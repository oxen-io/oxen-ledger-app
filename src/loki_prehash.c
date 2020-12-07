/*****************************************************************************
 *   Ledger Loki App.
 *   (c) 2017-2020 Cedric Mesnil <cslashm@gmail.com>, Ledger SAS.
 *   (c) 2020 Ledger SAS.
 *   (c) 2020 Loki Project
 *
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 *****************************************************************************/

/*
 * Client: rctSigs.cpp.c -> get_pre_clsag_hash
 */

#include "os.h"
#include "cx.h"
#include "loki_types.h"
#include "loki_api.h"
#include "loki_vars.h"

/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
int monero_apdu_clsag_prehash_init(void) {
    if (G_loki_state.tx_sig_mode == TRANSACTION_CREATE_REAL) {
        if (G_loki_state.io_p2 == 1) {
            monero_sha256_outkeys_final(G_loki_state.OUTK);
            monero_sha256_outkeys_init();
            monero_sha256_commitment_init();
            monero_keccak_init_H();
        }
    }
    // We always confirm fees for LNS because often this is the *only* confirmation for an LNS tx
    unsigned char confirm_fee_mode = G_loki_state.tx_type == TXTYPE_LNS
        ? CONFIRM_FEE_ALWAYS
        : N_loki_state->confirm_fee_mode;

    monero_keccak_update_H(G_loki_state.io_buffer + G_loki_state.io_offset,
                           G_loki_state.io_length - G_loki_state.io_offset);
    if ((G_loki_state.tx_sig_mode == TRANSACTION_CREATE_REAL) && (G_loki_state.io_p2 == 1)
            && confirm_fee_mode != CONFIRM_FEE_NEVER) {

        // skip type
        monero_io_fetch_u8();
        // fee str
        uint64_t amount;
        monero_decode_varint(G_loki_state.io_buffer + G_loki_state.io_offset, 10, &amount);
        monero_io_discard(1);

        switch (confirm_fee_mode) {
            case CONFIRM_FEE_ABOVE_0_05: if (amount <   50000000) amount = 0; break;
            case CONFIRM_FEE_ABOVE_0_2:  if (amount <  200000000) amount = 0; break;
            case CONFIRM_FEE_ABOVE_1:    if (amount < 1000000000) amount = 0; break;
            default: break;
        }
        if (amount > 0) {
            // ask user
            loki_currency_str(amount, G_loki_state.ux_amount);
            ui_menu_fee_validation_display();
            return 0;
        }
        return SW_OK;
    } else {
        monero_io_discard(1);
        return SW_OK;
    }
}

/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
int monero_apdu_clsag_prehash_update(void) {
    unsigned char is_subaddress;
    unsigned char *Aout;
    unsigned char *Bout;
    unsigned char is_change;
    unsigned char aH[32];
    unsigned char C[32];
    unsigned char v[32];
    unsigned char k[32];

    unsigned char kG[32];

    // fetch destination
    is_subaddress = monero_io_fetch_u8();
    is_change = monero_io_fetch_u8();
    Aout = G_loki_state.io_buffer + G_loki_state.io_offset;
    monero_io_fetch(NULL, 32);
    Bout = G_loki_state.io_buffer + G_loki_state.io_offset;
    monero_io_fetch(NULL, 32);
    monero_io_fetch_decrypt(aH, 32, TYPE_AMOUNT_KEY);
    monero_io_fetch(C, 32);
    monero_io_fetch(k, 32);
    monero_io_fetch(v, 32);

    monero_io_discard(0);

    // update CLSAG prehash
    if ((G_loki_state.options & 0x03) == 0x02) {
        monero_keccak_update_H(v, 8);
    } else {
        monero_keccak_update_H(k, 32);
        monero_keccak_update_H(v, 32);
    }

    if (G_loki_state.tx_sig_mode == TRANSACTION_CREATE_REAL) {
        if (!is_change && G_loki_state.tx_type != TXTYPE_STAKE && G_loki_state.tx_type != TXTYPE_LNS) {
            // encode dest adress
            unsigned char pos = loki_wallet_address(G_loki_state.ux_address, Aout, Bout, is_subaddress, NULL);
            if (N_loki_state->truncate_addrs_mode == CONFIRM_ADDRESS_SHORT) {
                // First 23, "..", last 23 (so total is 48 = 3 pages on Nano S)
                G_loki_state.ux_address[23] = '.';
                G_loki_state.ux_address[24] = '.';
                os_memmove(&G_loki_state.ux_address[25], &G_loki_state.ux_address[pos-23], 23);
                pos = 48;
            } else if (N_loki_state->truncate_addrs_mode == CONFIRM_ADDRESS_SHORTER) {
                // 16..14 so that first page gets first [16], last page gets last [..14]
                G_loki_state.ux_address[16] = '.';
                G_loki_state.ux_address[17] = '.';
                os_memmove(&G_loki_state.ux_address[18], &G_loki_state.ux_address[pos-14], 14);
                pos = 32;
            }
            G_loki_state.ux_address[pos] = 0; // null terminate
        }
        // update destination hash control
        monero_sha256_outkeys_update(Aout, 32);
        monero_sha256_outkeys_update(Bout, 32);
        monero_sha256_outkeys_update(&is_change, 1);
        monero_sha256_outkeys_update(aH, 32);

        // check C = aH+kG
        monero_unblind(v, k, aH, G_loki_state.options & 0x03);
        monero_ecmul_G(kG, k);
        if (!cx_math_is_zero(v, 32)) {
            monero_ecmul_H(aH, v);
            monero_ecadd(aH, kG, aH);
        } else {
            os_memmove(aH, kG, 32);
        }
        if (os_memcmp(C, aH, 32)) {
            monero_lock_and_throw(SW_SECURITY_COMMITMENT_CONTROL);
        }
        // update commitment hash control
        monero_sha256_commitment_update(C, 32);

        if ((G_loki_state.options & IN_OPTION_MORE_COMMAND) == 0) {
            // finalize and check destination hash_control
            monero_sha256_outkeys_final(k);
            if (os_memcmp(k, G_loki_state.OUTK, 32)) {
                monero_lock_and_throw(SW_SECURITY_OUTKEYS_CHAIN_CONTROL);
            }
            // finalize commitment hash control
            monero_sha256_commitment_final(G_loki_state.commitment_hash);
            monero_sha256_commitment_init();
        }

        // ask user
        uint64_t amount;
        amount = monero_bamount2uint64(v);
        if (amount) {
            loki_currency_str(amount, G_loki_state.ux_amount);
            if (!is_change) {
                if (G_loki_state.tx_type == TXTYPE_STAKE || G_loki_state.tx_type == TXTYPE_LNS) {
                    // If this is a stake or LNS tx then the non-change recipient must be ourself.
                    if (os_memcmp(Aout, G_loki_state.view_pub, 32) || os_memcmp(Bout, G_loki_state.spend_pub, 32))
                        monero_lock_and_throw(SW_SECURITY_INTERNAL);

                    ui_menu_stake_validation_display();
                }
                else
                    ui_menu_validation_display();
            }
            else if (N_loki_state->confirm_change_mode == CONFIRM_CHANGE_DISABLED)
                return SW_OK;
            else
                ui_menu_change_validation_display();
            return 0;
        }
    }
    return SW_OK;
}

/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
int monero_apdu_clsag_prehash_finalize(void) {
    unsigned char message[32];
    unsigned char proof[32];
    unsigned char H[32];

    if (G_loki_state.options & IN_OPTION_MORE_COMMAND) {
        // accumulate
        monero_io_fetch(H, 32);
        monero_io_discard(1);
        monero_keccak_update_H(H, 32);
        monero_sha256_commitment_update(H, 32);
    } else {
        // Finalize and check commitment hash control
        if (G_loki_state.tx_sig_mode == TRANSACTION_CREATE_REAL) {
            monero_sha256_commitment_final(H);
            if (os_memcmp(H, G_loki_state.commitment_hash, 32)) {
                monero_lock_and_throw(SW_SECURITY_COMMITMENT_CHAIN_CONTROL);
            }
        }
        // compute last H
        monero_keccak_final_H(H);
        // compute last prehash
        monero_io_fetch(message, 32);
        monero_io_fetch(proof, 32);
        monero_io_discard(1);
        monero_keccak_init_H();
        if (os_memcmp(message, G_loki_state.prefixH, 32) != 0) {
            monero_lock_and_throw(SW_SECURITY_PREFIX_HASH);
        }
        monero_keccak_update_H(message, 32);
        monero_keccak_update_H(H, 32);
        monero_keccak_update_H(proof, 32);
        monero_keccak_final_H(H);

        monero_io_insert(H, 32);
    }

    return SW_OK;
}
