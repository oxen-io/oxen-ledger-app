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

#include "os.h"
#include "cx.h"
#include "oxen_types.h"
#include "oxen_api.h"
#include "oxen_vars.h"

/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
void monero_reset_tx(int reset_tx_cnt) {
    memset(G_oxen_state.r, 0, 32);
    memset(G_oxen_state.R, 0, 32);
    cx_rng(G_oxen_state.hmac_key, 32);

    cx_keccak_init(&G_oxen_state.keccak_alt, 256);
    cx_sha256_init(&G_oxen_state.sha256_alt);
    cx_sha256_init(&G_oxen_state.sha256);
    G_oxen_state.tx_in_progress = 0;
    G_oxen_state.tx_output_cnt = 0;
    if (reset_tx_cnt) {
        G_oxen_state.tx_cnt = 0;
    }
}

/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
int monero_apdu_open_tx(void) {
    uint16_t txversion, txtype;

    txversion = monero_io_fetch_u16();
    txtype = monero_io_fetch_u16();

    if (txversion != 4)
        THROW(SW_WRONG_DATA_RANGE);
    if (!(txtype == TXTYPE_STANDARD || txtype == TXTYPE_UNLOCK || txtype == TXTYPE_STAKE || txtype == TXTYPE_LNS))
        THROW(SW_WRONG_DATA_RANGE);

    monero_io_discard(1);

    monero_reset_tx(0);
    G_oxen_state.tx_type = txtype;
    G_oxen_state.tx_cnt++;
    ui_menu_opentx_display(0);
    if (G_oxen_state.tx_sig_mode == TRANSACTION_CREATE_REAL) {
        // return 0;
    }
    return monero_apdu_open_tx_cont();
}

int monero_apdu_open_tx_cont(void) {
    G_oxen_state.tx_in_progress = 1;

#ifdef DEBUG_HWDEVICE
    memset(G_oxen_state.hmac_key, 0xab, 32);
#else
    cx_rng(G_oxen_state.hmac_key, 32);
#endif

    monero_rng_mod_order(G_oxen_state.r);
    monero_ecmul_G(G_oxen_state.R, G_oxen_state.r);

    monero_io_insert(G_oxen_state.R, 32);
    monero_io_insert_encrypt(G_oxen_state.r, 32, TYPE_SCALAR);
    monero_io_insert(C_FAKE_SEC_VIEW_KEY, 32);
    monero_io_insert_hmac_for((void*)C_FAKE_SEC_VIEW_KEY, 32, TYPE_SCALAR);
    monero_io_insert(C_FAKE_SEC_SPEND_KEY, 32);
    monero_io_insert_hmac_for((void*)C_FAKE_SEC_SPEND_KEY, 32, TYPE_SCALAR);
    return SW_OK;
}

/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
int monero_apdu_close_tx(void) {
    monero_io_discard(1);
    monero_reset_tx(G_oxen_state.tx_sig_mode == TRANSACTION_CREATE_REAL);
    ui_menu_main_display();
    return SW_OK;
}

/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
int monero_abort_tx(void) {
    monero_reset_tx(1);
    ui_menu_info_display2("TX", "Aborted");
    return 0;
}

/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
int monero_apdu_set_signature_mode(void) {
    unsigned int sig_mode;

    G_oxen_state.tx_sig_mode = TRANSACTION_CREATE_FAKE;

    sig_mode = monero_io_fetch_u8();
    monero_io_discard(0);
    switch (sig_mode) {
        case TRANSACTION_CREATE_REAL:
        case TRANSACTION_CREATE_FAKE:
            break;
        default:
            monero_lock_and_throw(SW_WRONG_DATA);
    }
    G_oxen_state.tx_sig_mode = sig_mode;

    monero_io_insert_u32(G_oxen_state.tx_sig_mode);
    return SW_OK;
}
