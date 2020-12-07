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
 * Client: rctSigs.cpp.c -> get_pre_mlsag_hash
 */

#include "os.h"
#include "cx.h"
#include "loki_types.h"
#include "loki_api.h"
#include "loki_vars.h"

/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
// str must be size >= 21
static void monero_uint642str(uint64_t val, char *str) {
    unsigned char len, i, j;
    char tmp;

    len = 0;

    // Write it out in reverse, then swap it (because until we write it out we won't know the
    // length)
    do {
        str[len++] = '0' + val % 10;
        val /= 10;
    } while (val);

    // Reverse it
    for (i = 0, j = len - 1; i < j; ++i, --j) {
        tmp = str[i];
        str[i] = str[j];
        str[j] = tmp;
    }

    // Terminate it
    str[len] = 0;
}


/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
int monero_apdu_prefix_hash_init(void) {
    monero_keccak_init_H();
    if (G_loki_state.tx_sig_mode == TRANSACTION_CREATE_REAL) {
        if (monero_io_fetch_varint16() != 4) // tx version; we only support v4 txes
            THROW(SW_WRONG_DATA_RANGE);

        uint16_t txtype = monero_io_fetch_varint16();
        uint64_t timelock = monero_io_fetch_varint();

        if (G_loki_state.tx_type != txtype)
            THROW(SW_WRONG_DATA_RANGE);

        if (timelock != 0 && txtype != TXTYPE_STANDARD)
            THROW(SW_WRONG_DATA_RANGE);

        if (monero_io_fetch_available())
            THROW(SW_WRONG_DATA);

        monero_io_discard(1);

        // At this stage we only want to check for a timelock and prompt if necessary (to prevent
        // accidental timelocked transactions).
        if (timelock != 0) {
            monero_uint642str(timelock, G_loki_state.ux_amount);
            ui_menu_timelock_validation_display();
            return 0;
        } else {
            return SW_OK;
        }
    } else {
        monero_io_discard(1);
        return SW_OK;
    }
}

/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
int monero_apdu_prefix_hash_update(void) {
    monero_keccak_update_H(G_loki_state.io_buffer + G_loki_state.io_offset,
                           G_loki_state.io_length - G_loki_state.io_offset);
    monero_io_discard(0);
    if (G_loki_state.io_p2 == 0) {
        monero_keccak_final_H(G_loki_state.prefixH);
        monero_io_insert(G_loki_state.prefixH, 32);
    }

    return SW_OK;
}
