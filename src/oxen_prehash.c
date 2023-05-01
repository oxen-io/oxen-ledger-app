/*****************************************************************************
 *   Ledger Oxen App.
 *   (c) 2017-2020 Cedric Mesnil <cslashm@gmail.com>, Ledger SAS.
 *   (c) 2020 Ledger SAS.
 *   (c) 2020 Oxen Project
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
#include "oxen_types.h"
#include "oxen_api.h"
#include "oxen_vars.h"

/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
int monero_apdu_clsag_prehash_init(void) {
    if (G_oxen_state.tx_sig_mode == TRANSACTION_CREATE_REAL) {
        if (G_oxen_state.io_p2 == 1) {
            oxen_hash_final(&G_oxen_state.sha256, G_oxen_state.OUTK);
            cx_sha256_init(&G_oxen_state.sha256);
            cx_sha256_init(&G_oxen_state.sha256_alt);
            cx_keccak_init(&G_oxen_state.keccak_alt, 256);
        }
    }
    // We always confirm fees for ONS because often this is the *only* confirmation for an ONS tx
    unsigned char confirm_fee_mode =
        G_oxen_state.tx_type == TXTYPE_ONS ? CONFIRM_FEE_ALWAYS : N_oxen_state->confirm_fee_mode;

    oxen_hash_update(&G_oxen_state.keccak_alt,
                     G_oxen_state.io_buffer + G_oxen_state.io_offset,
                     G_oxen_state.io_length - G_oxen_state.io_offset);
    if ((G_oxen_state.tx_sig_mode == TRANSACTION_CREATE_REAL) && (G_oxen_state.io_p2 == 1) &&
        confirm_fee_mode != CONFIRM_FEE_NEVER) {
        // skip type
        monero_io_fetch_u8();
        // fee str
        uint64_t amount;
        monero_decode_varint(G_oxen_state.io_buffer + G_oxen_state.io_offset, 10, &amount);
        monero_io_discard(1);

        switch (confirm_fee_mode) {
            case CONFIRM_FEE_ABOVE_0_05:
                if (amount < 50000000) amount = 0;
                break;
            case CONFIRM_FEE_ABOVE_0_2:
                if (amount < 200000000) amount = 0;
                break;
            case CONFIRM_FEE_ABOVE_1:
                if (amount < 1000000000) amount = 0;
                break;
            default:
                break;
        }
        if (amount > 0) {
            // ask user
            oxen_currency_str(amount, G_oxen_state.ux_amount);
            if (G_oxen_state.tx_type == TXTYPE_ONS)
                ui_menu_lns_fee_validation_display();
            else
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
    Aout = G_oxen_state.io_buffer + G_oxen_state.io_offset;
    monero_io_fetch(NULL, 32);
    Bout = G_oxen_state.io_buffer + G_oxen_state.io_offset;
    monero_io_fetch(NULL, 32);
    monero_io_fetch_decrypt(aH, 32, TYPE_AMOUNT_KEY);
    monero_io_fetch(C, 32);
    monero_io_fetch(k, 32);
    monero_io_fetch(v, 32);

    monero_io_discard(0);

    // update CLSAG prehash
    if ((G_oxen_state.options & 0x03) == 0x02) {
        oxen_hash_update(&G_oxen_state.keccak_alt, v, 8);
    } else {
        oxen_hash_update(&G_oxen_state.keccak_alt, k, 32);
        oxen_hash_update(&G_oxen_state.keccak_alt, v, 32);
    }

    if (G_oxen_state.tx_sig_mode == TRANSACTION_CREATE_REAL) {
        if (!is_change && G_oxen_state.tx_type != TXTYPE_STAKE &&
            G_oxen_state.tx_type != TXTYPE_ONS) {
            // encode dest adress
            unsigned char pos =
                oxen_wallet_address(G_oxen_state.ux_address, Aout, Bout, is_subaddress, NULL);
            if (N_oxen_state->truncate_addrs_mode == CONFIRM_ADDRESS_SHORT) {
                // First 23, "..", last 23 (so total is 48 = 3 pages on Nano S)
                G_oxen_state.ux_address[23] = '.';
                G_oxen_state.ux_address[24] = '.';
                memmove(&G_oxen_state.ux_address[25], &G_oxen_state.ux_address[pos - 23], 23);
                pos = 48;
            } else if (N_oxen_state->truncate_addrs_mode == CONFIRM_ADDRESS_SHORTER) {
                // 16..14 so that first page gets first [16], last page gets last [..14]
                G_oxen_state.ux_address[16] = '.';
                G_oxen_state.ux_address[17] = '.';
                memmove(&G_oxen_state.ux_address[18], &G_oxen_state.ux_address[pos - 14], 14);
                pos = 32;
            }
            G_oxen_state.ux_address[pos] = 0;  // null terminate
        }
        // update destination hash control
        oxen_hash_update(&G_oxen_state.sha256, Aout, 32);
        oxen_hash_update(&G_oxen_state.sha256, Bout, 32);
        oxen_hash_update(&G_oxen_state.sha256, &is_change, 1);
        oxen_hash_update(&G_oxen_state.sha256, aH, 32);

        // check C = aH+kG
        monero_unblind(v, k, aH, G_oxen_state.options & 0x03);
        monero_ecmul_G(kG, k);
        if (!cx_math_is_zero(v, 32)) {
            monero_ecmul_H(aH, v);
            monero_ecadd(aH, kG, aH);
        } else {
            memmove(aH, kG, 32);
        }
        if (memcmp(C, aH, 32)) {
            monero_lock_and_throw(SW_SECURITY_COMMITMENT_CONTROL);
        }
        // update commitment hash control
        oxen_hash_update(&G_oxen_state.sha256_alt, C, 32);

        if ((G_oxen_state.options & IN_OPTION_MORE_COMMAND) == 0) {
            // finalize and check destination hash_control
            oxen_hash_final(&G_oxen_state.sha256, k);
            if (memcmp(k, G_oxen_state.OUTK, 32)) {
                monero_lock_and_throw(SW_SECURITY_OUTKEYS_CHAIN_CONTROL);
            }
            // finalize commitment hash control
            oxen_hash_final(&G_oxen_state.sha256_alt, G_oxen_state.commitment_hash);
            cx_sha256_init(&G_oxen_state.sha256_alt);
        }

        // ask user
        uint64_t amount;
        amount = monero_bamount2uint64(v);
        if (amount) {
            oxen_currency_str(amount, G_oxen_state.ux_amount);
            if (!is_change) {
                if (G_oxen_state.tx_type == TXTYPE_STAKE || G_oxen_state.tx_type == TXTYPE_ONS) {
                    // If this is a stake or ONS tx then the non-change recipient must be ourself.
                    if (memcmp(Aout, G_oxen_state.view_pub, 32) ||
                        memcmp(Bout, G_oxen_state.spend_pub, 32))
                        monero_lock_and_throw(SW_SECURITY_INTERNAL);

                    ui_menu_stake_validation_display();
                } else
                    ui_menu_validation_display();
            } else if (N_oxen_state->confirm_change_mode == CONFIRM_CHANGE_DISABLED)
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

    if (G_oxen_state.options & IN_OPTION_MORE_COMMAND) {
        // accumulate
        monero_io_fetch(H, 32);
        monero_io_discard(1);
        oxen_hash_update(&G_oxen_state.keccak_alt, H, 32);
        oxen_hash_update(&G_oxen_state.sha256_alt, H, 32);
    } else {
        // Finalize and check commitment hash control
        if (G_oxen_state.tx_sig_mode == TRANSACTION_CREATE_REAL) {
            oxen_hash_final(&G_oxen_state.sha256_alt, H);
            if (memcmp(H, G_oxen_state.commitment_hash, 32)) {
                monero_lock_and_throw(SW_SECURITY_COMMITMENT_CHAIN_CONTROL);
            }
        }
        // compute last H
        oxen_hash_final(&G_oxen_state.keccak_alt, H);
        // compute last prehash
        monero_io_fetch(message, 32);
        monero_io_fetch(proof, 32);
        monero_io_discard(1);
        cx_keccak_init(&G_oxen_state.keccak_alt, 256);
        if (memcmp(message, G_oxen_state.prefixH, 32) != 0) {
            monero_lock_and_throw(SW_SECURITY_PREFIX_HASH);
        }
        oxen_hash_update(&G_oxen_state.keccak_alt, message, 32);
        oxen_hash_update(&G_oxen_state.keccak_alt, H, 32);
        oxen_hash_update(&G_oxen_state.keccak_alt, proof, 32);
        oxen_hash_final(&G_oxen_state.keccak_alt, H);

        monero_io_insert(H, 32);
    }

    return SW_OK;
}
