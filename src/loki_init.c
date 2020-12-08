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
    os_memset(&G_loki_state, 0, sizeof(loki_v_state_t));

    // first init ?
    if (os_memcmp((void*)N_loki_state->magic, (void*)C_MAGIC, sizeof(C_MAGIC)) != 0) {
#if defined(LOKI_ALPHA) || defined(LOKI_BETA)
        loki_install(TESTNET);
#else
        loki_install(MAINNET);
#endif
    }

    G_loki_state.protocol = 0xff;
    G_loki_state.protocol_barrier = PROTOCOL_UNLOCKED;

    // load key
    monero_init_private_key();
    // ux conf
    monero_init_ux();
    // Let's go!
    G_loki_state.state = STATE_IDLE;
}

/* ----------------------------------------------------------------------- */
/* --- init private keys                                               --- */
/* ----------------------------------------------------------------------- */
void monero_wipe_private_key(void) {
    os_memset(G_loki_state.keys, 0, sizeof(G_loki_state.keys));
    os_memset(&G_loki_state.spk, 0, sizeof(G_loki_state.spk));
    G_loki_state.key_set = 0;
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
    path[2] = 0x80000000;
    path[3] = 0x00000000;
    path[4] = 0x00000000;
    os_perso_derive_node_bip32(CX_CURVE_SECP256K1, path, 5, seed, chain);

    switch (N_loki_state->key_mode) {
        case KEY_MODE_SEED:

            loki_keccak_256(&G_loki_state.keccak, seed, 32, G_loki_state.spend_priv);
            monero_reduce(G_loki_state.spend_priv);
            loki_keccak_256(&G_loki_state.keccak, G_loki_state.spend_priv, 32, G_loki_state.view_priv);
            monero_reduce(G_loki_state.view_priv);
            break;

        case KEY_MODE_EXTERNAL:
            os_memmove(G_loki_state.view_priv, (void*)N_loki_state->view_priv, 32);
            os_memmove(G_loki_state.spend_priv, (void*)N_loki_state->spend_priv, 32);
            break;

        default:
            THROW(SW_SECURITY_LOAD_KEY);
            return;
    }
    monero_ecmul_G(G_loki_state.view_pub, G_loki_state.view_priv);
    monero_ecmul_G(G_loki_state.spend_pub, G_loki_state.spend_priv);

    // generate key protection
    monero_aes_derive(&G_loki_state.spk, chain, G_loki_state.view_priv, G_loki_state.spend_priv);

    G_loki_state.key_set = 1;
}

/* ----------------------------------------------------------------------- */
/* ---  Set up ui/ux                                                   --- */
/* ----------------------------------------------------------------------- */
void monero_init_ux(void) {
    unsigned char wallet_len = loki_wallet_address(
            G_loki_state.ux_address, G_loki_state.view_pub, G_loki_state.spend_pub, 0, NULL);

    os_memmove(G_loki_state.ux_wallet_public_short_address, G_loki_state.ux_address, 7);
    G_loki_state.ux_wallet_public_short_address[7] = '.';
    G_loki_state.ux_wallet_public_short_address[8] = '.';
    os_memmove(G_loki_state.ux_wallet_public_short_address + 9,
               G_loki_state.ux_address + wallet_len - 3, 3);
    G_loki_state.ux_wallet_public_short_address[12] = 0;
}

/* ----------------------------------------------------------------------- */
/* ---  Install/ReInstall Loki app                                   --- */
/* ----------------------------------------------------------------------- */
void loki_install(unsigned char netId) {
    unsigned char c;

    // full reset data
    nvm_write(N_loki_state, NULL, sizeof(loki_nv_state_t));

    // set mode key
    c = KEY_MODE_SEED;
    nvm_write(&N_loki_state->key_mode, &c, 1);

    // set net id
    nvm_write(&N_loki_state->network_id, &netId, 1);

    // write magic
    nvm_write(N_loki_state->magic, (void *)C_MAGIC, sizeof(C_MAGIC));

#if DEBUG_HWDEVICE
    // Default into always-export-view-key mode when doing a debug build because it's annoying to
    // have to confirm the view key export every time when doing dev/debugging work.
    unsigned char always_export = VIEWKEY_EXPORT_ALWAYS_ALLOW;
    nvm_write(&N_loki_state->viewkey_export_mode, &always_export, 1);
#endif
}

/* ----------------------------------------------------------------------- */
/* --- Reset                                                           --- */
/* ----------------------------------------------------------------------- */
const char* const loki_supported_client[] = {
    "8.",
};
#define LOKI_SUPPORTED_CLIENT_SIZE (sizeof(loki_supported_client) / sizeof(char*))

int monero_apdu_reset(void) {
    unsigned short client_version_len;
    char client_version[16];
    client_version_len = G_loki_state.io_length - G_loki_state.io_offset;
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
    G_loki_state.protocol_barrier = PROTOCOL_LOCKED;
    snprintf(G_loki_state.ux_info1, sizeof(G_loki_state.ux_info1), "Security Err");
    snprintf(G_loki_state.ux_info2, sizeof(G_loki_state.ux_info2), "%x", sw);
    ui_menu_info_display();
    THROW(sw);
}
