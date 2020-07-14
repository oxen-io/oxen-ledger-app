/*****************************************************************************
 *   Ledger Monero App.
 *   (c) 2017-2020 Cedric Mesnil <cslashm@gmail.com>, Ledger SAS.
 *   (c) 2020 Ledger SAS.
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
#include "loki_types.h"
#include "loki_api.h"
#include "loki_vars.h"

/* ----------------------*/
/* -- A Kind of Magic -- */
/* ----------------------*/
const unsigned char C_MAGIC[8] = {'L', 'O', 'K', 'I', '0', '0', '0', '0'};

const unsigned char C_FAKE_SEC_VIEW_KEY[32] = {
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00};
const unsigned char C_FAKE_SEC_SPEND_KEY[32] = {
    0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
    0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF};

/* ----------------------------------------------------------------------- */
/* --- Boot                                                            --- */
/* ----------------------------------------------------------------------- */
void monero_init(void) {
    os_memset(&G_monero_vstate, 0, sizeof(monero_v_state_t));

    // first init ?
    if (os_memcmp((void*)N_monero_pstate->magic, (void*)C_MAGIC, sizeof(C_MAGIC)) != 0) {
#if defined(LOKI_ALPHA) || defined(LOKI_BETA)
        loki_install(TESTNET);
#else
        loki_install(MAINNET);
#endif
    }

    G_monero_vstate.protocol = 0xff;
    G_monero_vstate.protocol_barrier = PROTOCOL_UNLOCKED;

    // load key
    monero_init_private_key();
    // ux conf
    monero_init_ux();
    // Let's go!
    G_monero_vstate.state = STATE_IDLE;
}

/* ----------------------------------------------------------------------- */
/* --- init private keys                                               --- */
/* ----------------------------------------------------------------------- */
void monero_wipe_private_key(void) {
    os_memset(G_monero_vstate.keys, 0, sizeof(G_monero_vstate.keys));
    os_memset(&G_monero_vstate.spk, 0, sizeof(G_monero_vstate.spk));
    G_monero_vstate.key_set = 0;
}

void monero_init_private_key(void) {
    unsigned int path[5];
    unsigned char seed[32];
    unsigned char chain[32];

    // generate account keys

    // m / purpose' / coin_type' / account' / change / address_index
    // m / 44'      / 240'       / 0'       / 0      / 0
    path[0] = 0x8000002C;
    path[1] = 0x800000F0;
    path[2] = 0x80000000 | N_monero_pstate->account_id;
    path[3] = 0x00000000;
    path[4] = 0x00000000;
    os_perso_derive_node_bip32(CX_CURVE_SECP256K1, path, 5, seed, chain);

    switch (N_monero_pstate->key_mode) {
        case KEY_MODE_SEED:

            monero_keccak_F(seed, 32, G_monero_vstate.spend_priv);
            monero_reduce(G_monero_vstate.spend_priv, G_monero_vstate.spend_priv);
            monero_keccak_F(G_monero_vstate.spend_priv, 32, G_monero_vstate.view_priv);
            monero_reduce(G_monero_vstate.view_priv, G_monero_vstate.view_priv);
            break;

        case KEY_MODE_EXTERNAL:
            os_memmove(G_monero_vstate.view_priv, (void*)N_monero_pstate->view_priv, 32);
            os_memmove(G_monero_vstate.spend_priv, (void*)N_monero_pstate->spend_priv, 32);
            break;

        default:
            THROW(SW_SECURITY_LOAD_KEY);
            return;
    }
    monero_ecmul_G(G_monero_vstate.view_pub, G_monero_vstate.view_priv);
    monero_ecmul_G(G_monero_vstate.spend_pub, G_monero_vstate.spend_priv);

    // generate key protection
    monero_aes_derive(&G_monero_vstate.spk, chain, G_monero_vstate.view_priv, G_monero_vstate.spend_priv);

    G_monero_vstate.key_set = 1;
}

/* ----------------------------------------------------------------------- */
/* ---  Set up ui/ux                                                   --- */
/* ----------------------------------------------------------------------- */
void monero_init_ux(void) {
    unsigned char wallet_len = loki_wallet_address(
            G_monero_vstate.ux_address, G_monero_vstate.view_pub, G_monero_vstate.spend_pub, 0, NULL);
    if (N_monero_pstate->account_id == 0)
        os_memmove(G_monero_vstate.ux_wallet_account_name, "LOKI wallet", 12);
    else
        snprintf(G_monero_vstate.ux_wallet_account_name, sizeof(G_monero_vstate.ux_wallet_account_name),
                "LOKI / %d", N_monero_pstate->account_id);

    os_memmove(G_monero_vstate.ux_wallet_public_short_address, G_monero_vstate.ux_address, 7);
    G_monero_vstate.ux_wallet_public_short_address[7] = '.';
    G_monero_vstate.ux_wallet_public_short_address[8] = '.';
    os_memmove(G_monero_vstate.ux_wallet_public_short_address + 9,
               G_monero_vstate.ux_address + wallet_len - 3, 3);
    G_monero_vstate.ux_wallet_public_short_address[12] = 0;
}

/* ----------------------------------------------------------------------- */
/* ---  Install/ReInstall Loki app                                   --- */
/* ----------------------------------------------------------------------- */
void loki_install(unsigned char netId) {
    unsigned char c;

    // full reset data
    monero_nvm_write((void*)N_monero_pstate, NULL, sizeof(monero_nv_state_t));

    // set mode key
    c = KEY_MODE_SEED;
    nvm_write((void*)&N_monero_pstate->key_mode, &c, 1);

    // set net id
    monero_nvm_write((void*)&N_monero_pstate->network_id, &netId, 1);

    // write magic
    monero_nvm_write((void*)N_monero_pstate->magic, (void*)C_MAGIC, sizeof(C_MAGIC));
}

/* ----------------------------------------------------------------------- */
/* --- Reset                                                           --- */
/* ----------------------------------------------------------------------- */
const char* const loki_supported_client[] = {
    "7.",
    "8.",
};
#define LOKI_SUPPORTED_CLIENT_SIZE (sizeof(loki_supported_client) / sizeof(char*))

int monero_apdu_reset(void) {
    unsigned short client_version_len;
    char client_version[16];
    client_version_len = G_monero_vstate.io_length - G_monero_vstate.io_offset;
    if (client_version_len > 14) {
        THROW(SW_CLIENT_NOT_SUPPORTED + 1);
    }
    monero_io_fetch((unsigned char*)&client_version[0], client_version_len);
    client_version[client_version_len++] = '.';
    client_version[client_version_len] = 0;
    uint8_t i;
    for (i = 0; i < LOKI_SUPPORTED_CLIENT_SIZE; i++) {
        size_t len = strlen((char*)PIC(loki_supported_client[i]));
        if (len <= client_version_len &&
                os_memcmp((char*)PIC(loki_supported_client[i]), client_version, len) == 0) {
            break;
        }
    }
    if (i == LOKI_SUPPORTED_CLIENT_SIZE) {
        THROW(SW_CLIENT_NOT_SUPPORTED);
    }

    monero_io_discard(0);
    monero_init();
    monero_io_insert_u8(LOKI_VERSION_MAJOR);
    monero_io_insert_u8(LOKI_VERSION_MINOR);
    monero_io_insert_u8(LOKI_VERSION_MICRO);
    return SW_OK;
}

/* ----------------------------------------------------------------------- */
/* --- LOCK                                                           --- */
/* ----------------------------------------------------------------------- */
int monero_apdu_lock(void) {
    monero_io_discard(0);
    monero_lock_and_throw(SW_SECURITY_LOCKED);
    return SW_SECURITY_LOCKED;
}

void monero_lock_and_throw(int sw) {
    G_monero_vstate.protocol_barrier = PROTOCOL_LOCKED;
    snprintf(G_monero_vstate.ux_info1, sizeof(G_monero_vstate.ux_info1), "Security Err");
    snprintf(G_monero_vstate.ux_info2, sizeof(G_monero_vstate.ux_info2), "%x", sw);
    ui_menu_info_display();
    THROW(sw);
}
