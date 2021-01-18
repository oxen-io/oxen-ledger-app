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
static void monero_payment_id_to_str(const unsigned char *payment_id, char *str) {
    for (int i = 0; i < 8; i++)
        snprintf(str + i * 2, 3, "%02x", payment_id[i]);
}

int monero_apdu_display_address(void) {
    unsigned int major;
    unsigned int minor;
    unsigned char index[8];
    unsigned char payment_id[8];
    unsigned char C[32];
    unsigned char D[32];

    // fetch
    monero_io_fetch(index, 8);
    monero_io_fetch(payment_id, 8);
    monero_io_discard(0);

    major = (index[0] << 0) | (index[1] << 8) | (index[2] << 16) | (index[3] << 24);
    minor = (index[4] << 0) | (index[5] << 8) | (index[6] << 16) | (index[7] << 24);
    if ((minor | major) && (G_oxen_state.io_p1 == 1)) {
        THROW(SW_WRONG_DATA);
    }

    // retrieve pub keys
    if (minor | major) {
        monero_get_subaddress(C, D, index);
    } else {
        os_memmove(C, G_oxen_state.view_pub, 32);
        os_memmove(D, G_oxen_state.spend_pub, 32);
    }

    // prepare UI
    if (minor | major) {
        G_oxen_state.disp_addr_M = major;
        G_oxen_state.disp_addr_m = minor;
        G_oxen_state.disp_addr_mode = DISP_SUB;
    } else {
        if (G_oxen_state.io_p1 == 1) {
            monero_payment_id_to_str(payment_id, G_oxen_state.payment_id);
            G_oxen_state.disp_addr_mode = DISP_INTEGRATED;
        } else {
            G_oxen_state.disp_addr_mode = DISP_MAIN;
        }
    }

    ui_menu_any_pubaddr_display(C, D, (minor | major) ? 1 : 0,
                                (G_oxen_state.io_p1 == 1) ? payment_id : NULL);
    return 0;
}

/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
int is_fake_view_key(const unsigned char *s) { return os_memcmp(s, C_FAKE_SEC_VIEW_KEY, 32) == 0; }

int is_fake_spend_key(const unsigned char *s) { return os_memcmp(s, C_FAKE_SEC_SPEND_KEY, 32) == 0; }

/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
int monero_apdu_put_key(void) {
    unsigned char raw[32];
    unsigned char pub[32];
    unsigned char sec[32];

    // option + priv/pub view key + priv/pub spend key + base58 address
    if (G_oxen_state.io_length != (1 + 32 * 2 + 32 * 2 + 95)) {
        THROW(SW_WRONG_LENGTH);
        return SW_WRONG_LENGTH;
    }

    // view key
    monero_io_fetch(sec, 32);
    monero_io_fetch(pub, 32);
    monero_ecmul_G(raw, sec);
    if (os_memcmp(pub, raw, 32)) {
        THROW(SW_WRONG_DATA);
        return SW_WRONG_DATA;
    }
    nvm_write((void *)N_oxen_state->view_priv, sec, 32);

    // spend key
    monero_io_fetch(sec, 32);
    monero_io_fetch(pub, 32);
    monero_ecmul_G(raw, sec);
    if (os_memcmp(pub, raw, 32)) {
        THROW(SW_WRONG_DATA);
        return SW_WRONG_DATA;
    }
    nvm_write((void *)N_oxen_state->spend_priv, sec, 32);

    // change mode
    unsigned char key_mode = KEY_MODE_EXTERNAL;
    nvm_write((void *)&N_oxen_state->key_mode, &key_mode, 1);

    monero_io_discard(1);

    return SW_OK;
}

int monero_apdu_get_network(void) {
    // We sent back "OXEN" followed by the network type byte
    monero_io_discard(1);
    uint8_t nettype;
    switch (N_oxen_state->network_id) {
        case MAINNET: nettype = 0; break;
        case TESTNET: nettype = 1; break;
        case DEVNET: nettype = 2; break;
        case FAKECHAIN: nettype = 3; break;
        default: nettype = 255;
    }
    monero_io_insert((const unsigned char*) "OXEN", 4);
    monero_io_insert(&nettype, 1);
    return SW_OK;
}

/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
int monero_apdu_get_key(void) {
    monero_io_discard(1);
    switch (G_oxen_state.io_p1) {
        // get pub
        case 1:
            monero_io_insert(G_oxen_state.view_pub, 32);
            monero_io_insert(G_oxen_state.spend_pub, 32);
            // public base address
            unsigned char wallet_len = oxen_wallet_address(
                    (char *)G_oxen_state.io_buffer + G_oxen_state.io_offset,
                    G_oxen_state.view_pub, G_oxen_state.spend_pub, 0, NULL);
            monero_io_inserted(wallet_len);
            break;

        // get private
        case 2:
            // view key
            if (G_oxen_state.export_view_key) {
                monero_io_insert(G_oxen_state.view_priv, 32);
            } else {
                ui_export_viewkey_display();
                return 0;
            }
            break;

#if DEBUG_HWDEVICE
        // get info
        case 3: {
            unsigned int path[5];
            unsigned char seed[32];

            // m/44'/240'/0'/0/0
            path[0] = 0x8000002C;
            path[1] = 0x800000F0;
            path[2] = 0x80000000;
            path[3] = 0x00000000;
            path[4] = 0x00000000;

            os_perso_derive_node_bip32(CX_CURVE_SECP256K1, path, 5, seed, G_oxen_state.view_priv);
            monero_io_insert(seed, 32);

            monero_io_insert(G_oxen_state.spend_priv, 32);
            monero_io_insert(G_oxen_state.view_priv, 32);

            break;
        }

            // get info
        case 4:
            monero_io_insert(G_oxen_state.view_priv, 32);
            monero_io_insert(G_oxen_state.spend_priv, 32);
            break;
#endif

        default:
            THROW(SW_WRONG_P1P2);
    }
    return SW_OK;
}

/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
int monero_apdu_verify_key(void) {
    unsigned char pub[32];
    unsigned char priv[32];
    unsigned char computed_pub[32];
    unsigned int verified = 0;

    monero_io_fetch_decrypt_key(priv);
    monero_io_fetch(pub, 32);
    switch (G_oxen_state.io_p1) {
        case 0:
            monero_secret_key_to_public_key(computed_pub, priv);
            break;
        case 1:
            os_memmove(computed_pub, G_oxen_state.view_pub, 32);
            break;
        case 2:
            os_memmove(computed_pub, G_oxen_state.spend_pub, 32);
            break;
        default:
            THROW(SW_WRONG_P1P2);
    }
    if (os_memcmp(computed_pub, pub, 32) == 0) {
        verified = 1;
    }

    monero_io_discard(1);
    monero_io_insert_u32(verified);
    return SW_OK;
}

/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
#define CHACHA8_KEY_TAIL 0x8c
int monero_apdu_get_chacha8_prekey(/*char  *prekey*/) {
    unsigned char abt[65];
    unsigned char pre[32];

    monero_io_discard(0);
    os_memmove(abt, G_oxen_state.view_priv, 32);
    os_memmove(abt + 32, G_oxen_state.spend_priv, 32);
    abt[64] = CHACHA8_KEY_TAIL;
    oxen_keccak_256(&G_oxen_state.keccak, abt, 65, pre);
    monero_io_insert((unsigned char *)G_oxen_state.keccak.acc, 200);
    return SW_OK;
}
#undef CHACHA8_KEY_TAIL

/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
int monero_apdu_sc_add(/*unsigned char *r, unsigned char *s1, unsigned char *s2*/) {
    unsigned char s1[32];
    unsigned char s2[32];
    unsigned char r[32];
    // fetch
    monero_io_fetch_decrypt(s1, 32, TYPE_SCALAR);
    monero_io_fetch_decrypt(s2, 32, TYPE_SCALAR);
    monero_io_discard(0);
    if (G_oxen_state.tx_in_progress) {
        // During a transaction, only "last_derive_secret_key+last_get_subaddress_secret_key"
        // is allowed, in order to match the call at
        // https://github.com/monero-project/monero/blob/v0.15.0.5/src/cryptonote_basic/cryptonote_format_utils.cpp#L331
        //
        //      hwdev.sc_secret_add(scalar_step2, scalar_step1,subaddr_sk);
        if ((os_memcmp(s1, G_oxen_state.last_derive_secret_key, 32) != 0) ||
            (os_memcmp(s2, G_oxen_state.last_get_subaddress_secret_key, 32) != 0)) {
            monero_lock_and_throw(SW_WRONG_DATA);
        }
    }
    monero_addm(r, s1, s2);
    monero_io_insert_encrypt(r, 32, TYPE_SCALAR);
    return SW_OK;
}

/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
int monero_apdu_scal_mul_key(/*const rct::key &pub, const rct::key &sec, rct::key mulkey*/) {
    unsigned char pub[32];
    unsigned char sec[32];
    unsigned char r[32];
    // fetch
    monero_io_fetch(pub, 32);
    monero_io_fetch_decrypt_key(sec);
    monero_io_discard(0);

    monero_ecmul_k(r, pub, sec);
    monero_io_insert(r, 32);
    return SW_OK;
}

/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
int monero_apdu_scal_mul_base(/*const rct::key &sec, rct::key mulkey*/) {
    unsigned char sec[32];
    unsigned char r[32];
    // fetch
    monero_io_fetch_decrypt(sec, 32, TYPE_SCALAR);
    monero_io_discard(0);

    monero_ecmul_G(r, sec);
    monero_io_insert(r, 32);
    return SW_OK;
}

/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
int monero_apdu_generate_keypair(/*crypto::public_key &pub, crypto::secret_key &sec*/) {
    unsigned char sec[32];
    unsigned char pub[32];

    monero_io_discard(0);
    monero_generate_keypair(pub, sec);
    monero_io_insert(pub, 32);
    monero_io_insert_encrypt(sec, 32, TYPE_SCALAR);
    return SW_OK;
}

/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
int monero_apdu_secret_key_to_public_key(
    /*const crypto::secret_key &sec, crypto::public_key &pub*/) {
    unsigned char sec[32];
    unsigned char pub[32];
    // fetch
    monero_io_fetch_decrypt(sec, 32, TYPE_SCALAR);
    monero_io_discard(0);
    // pub
    monero_ecmul_G(pub, sec);
    // pub key
    monero_io_insert(pub, 32);
    return SW_OK;
}

/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
int monero_apdu_generate_key_derivation(/*const crypto::public_key &pub, const crypto::secret_key &sec, crypto::key_derivation &derivation*/) {
    unsigned char pub[32];
    unsigned char sec[32];
    unsigned char drv[32];
    // fetch
    monero_io_fetch(pub, 32);
    monero_io_fetch_decrypt_key(sec);

    monero_io_discard(0);

    // Derive  and keep
    monero_generate_key_derivation(drv, pub, sec);

    monero_io_insert_encrypt(drv, 32, TYPE_DERIVATION);
    return SW_OK;
}

/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
int monero_apdu_derivation_to_scalar(
    /*const crypto::key_derivation &derivation, const size_t output_index, ec_scalar &res*/) {
    unsigned char derivation[32];
    unsigned int output_index;
    unsigned char res[32];

    // fetch
    monero_io_fetch_decrypt(derivation, 32, TYPE_DERIVATION);
    output_index = monero_io_fetch_u32();
    monero_io_discard(0);

    // pub
    monero_derivation_to_scalar(res, derivation, output_index);

    // pub key
    monero_io_insert_encrypt(res, 32, TYPE_SCALAR);
    return SW_OK;
}

/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
int monero_apdu_derive_public_key(/*const crypto::key_derivation &derivation, const std::size_t output_index, const crypto::public_key &pub, public_key &derived_pub*/) {
    unsigned char derivation[32];
    unsigned int output_index;
    unsigned char pub[32];
    unsigned char drvpub[32];

    // fetch
    monero_io_fetch_decrypt(derivation, 32, TYPE_DERIVATION);
    output_index = monero_io_fetch_u32();
    monero_io_fetch(pub, 32);
    monero_io_discard(0);

    // pub
    monero_derive_public_key(drvpub, derivation, output_index, pub);

    // pub key
    monero_io_insert(drvpub, 32);
    return SW_OK;
}

/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
int monero_apdu_derive_secret_key(/*const crypto::key_derivation &derivation, const std::size_t output_index, const crypto::secret_key &sec, secret_key &derived_sec*/){
    unsigned char derivation[32];
    unsigned int output_index;
    unsigned char sec[32];
    unsigned char drvsec[32];

    // fetch
    monero_io_fetch_decrypt(derivation, 32, TYPE_DERIVATION);
    output_index = monero_io_fetch_u32();
    monero_io_fetch_decrypt_key(sec);
    monero_io_discard(0);

    // pub
    monero_derive_secret_key(drvsec, derivation, output_index, sec);

    // sec key
    os_memmove(G_oxen_state.last_derive_secret_key, drvsec, 32);
    monero_io_insert_encrypt(drvsec, 32, TYPE_SCALAR);
    return SW_OK;
}

// Accesses the (decrypted) tx secret key.  Normally you don't want to do this (because having it
// unmasks the transaction details), but that is explicitly required for stake transactions so we
// allow this *only if* we have an open transaction and it is a stake transaction (which also
// changes how the is displayed so the user will confirm it as a stake rather than a regular TX),
// and only while constructing the transaction from our local r (so that you can't misuse this to
// decrypt an arbitrary value), which is only ever set randomly.
int oxen_apdu_get_tx_secret_key(void) {
    monero_io_discard(0);
    if (G_oxen_state.tx_in_progress && G_oxen_state.tx_type == TXTYPE_STAKE) {
        monero_io_insert(G_oxen_state.r, 32);
        return SW_OK;
    }
    THROW(SW_COMMAND_NOT_ALLOWED);
}

/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
int monero_apdu_generate_key_image(
    /*const crypto::public_key &pub, const crypto::secret_key &sec, crypto::key_image &image*/) {
    unsigned char pub[32];
    unsigned char sec[32];
    unsigned char image[32];

    // fetch
    monero_io_fetch(pub, 32);
    monero_io_fetch_decrypt(sec, 32, TYPE_SCALAR);
    monero_io_discard(0);

    // pub
    monero_generate_key_image(image, pub, sec);

    // pub key
    monero_io_insert(image, 32);
    return SW_OK;
}

/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
int oxen_apdu_generate_key_image_signature(
    /*const crypto::key_image& image, const crypto::public_key& pub, const crypto::secret_key& sec, crypto::signature& sig*/) {
    unsigned char signature[64];
    unsigned char image[32];
    unsigned char pub[32];
    unsigned char sec[32];

    // fetch
    monero_io_fetch(image, 32);
    monero_io_fetch(pub, 32);
    monero_io_fetch_decrypt(sec, 32, TYPE_SCALAR);
    monero_io_discard(0);

    // sign
    oxen_generate_key_image_signature(signature, image, pub, sec);

    // return
    monero_io_insert(signature, 64);
    return SW_OK;
}

static const unsigned char STAKE_UNLOCK_HASH[32] = {
    'U','N','L','K','U','N','L','K','U','N','L','K','U','N','L','K',
    'U','N','L','K','U','N','L','K','U','N','L','K','U','N','L','K'};

// Generate an unlock signature.  There are two steps here: the first (p1=0) asks for confirmation,
// and if given, we store that and then allow the second (p1=1) to produce the signature.  We
// require that that a transaction be open, and be an UNLOCK type.
int oxen_apdu_generate_unlock_signature(void) {
    unsigned char signature[64];
    unsigned char sec[32];
    unsigned char *pub;

    if (G_oxen_state.io_p1 == 0) {
        // Confirm the unlock with the user
        monero_io_discard(1);
        ui_menu_unlock_validation_display();
        return 0;
    } else if (G_oxen_state.io_p1 != 1 || !G_oxen_state.tx_special_confirmed) {
        monero_lock_and_throw(SW_WRONG_DATA);
    }

    // fetch
    pub = G_oxen_state.io_buffer + G_oxen_state.io_offset;
    monero_io_fetch(NULL, 32);
    monero_io_fetch_decrypt(sec, 32, TYPE_SCALAR);
    monero_io_discard(0);

    // sign
    oxen_generate_signature(signature, (unsigned char*) STAKE_UNLOCK_HASH, pub, sec);

    // return
    monero_io_insert(signature, 64);
    return SW_OK;
}

// Generates an LNS hash
int oxen_apdu_generate_lns_hash(void) {

    if (G_oxen_state.io_p1 == 0) {
        // Confirm the LNS initialization with the user
        monero_io_discard(1);
        ui_menu_lns_validation_display();
        return 0;
    } else if (G_oxen_state.io_p1 != 1 || !G_oxen_state.tx_special_confirmed) {
        monero_lock_and_throw(SW_WRONG_DATA);
    }

    // We init hash if we just came off [0] (in which case current cmd must be [1,1] or [1,0], i.e.
    // the first of multipart, or single-part.
    if (G_oxen_state.tx_state_p1 == 0) {
        if (G_oxen_state.io_p2 > 1)
            THROW(SW_SUBCOMMAND_NOT_ALLOWED);
        cx_blake2b_init(&G_oxen_state.blake2b, 256);
    // Otherwise we are in the hashing step so make sure the piece we receive properly follows
    } else if (!(
                G_oxen_state.io_p2 == 0 || // this chunk is last, *or*:
                G_oxen_state.io_p2 == (G_oxen_state.tx_state_p2 == 255 ? 1 : G_oxen_state.tx_state_p2 + 1) // this chunk properly follows the previous
                )) {
        THROW(SW_SUBCOMMAND_NOT_ALLOWED);
    }

    oxen_hash_update(&G_oxen_state.blake2b,
            G_oxen_state.io_buffer + G_oxen_state.io_offset,
            G_oxen_state.io_length - G_oxen_state.io_offset);
    monero_io_discard(1);

    if (G_oxen_state.io_p2 == 0) // This was the last data piece
        oxen_hash_final(&G_oxen_state.blake2b, G_oxen_state.lns_hash);

    return SW_OK;
}

int oxen_apdu_generate_lns_signature(void) {
    unsigned char subaddr_index[8];
#define SKEY &G_oxen_state.tmp[0]
#define PKEY &G_oxen_state.tmp[32]
#define STMP &G_oxen_state.tmp[64]
#define SIGNATURE &G_oxen_state.tmp[64]

    monero_io_fetch(subaddr_index, 8);
    monero_io_discard(1);

    if (os_memcmp(subaddr_index, "\0\0\0\0\0\0\0\0", 8) == 0) {
        os_memmove(SKEY, G_oxen_state.spend_priv, 32);
        os_memmove(PKEY, G_oxen_state.spend_pub, 32);
    } else {
        monero_get_subaddress_secret_key(STMP, G_oxen_state.view_priv, subaddr_index);
        monero_addm(SKEY, STMP, G_oxen_state.spend_priv);
        monero_ecmul_G(PKEY, SKEY);
    }

    oxen_generate_signature(SIGNATURE, G_oxen_state.lns_hash, PKEY, SKEY);
    monero_io_insert(SIGNATURE, 64);
    os_memset(G_oxen_state.tmp, 0, 128);
    os_memset(G_oxen_state.lns_hash, 0, 32);

    return SW_OK;
}

/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
int monero_apdu_derive_subaddress_public_key(/*const crypto::public_key &pub, const crypto::key_derivation &derivation, const std::size_t output_index, public_key &derived_pub*/) {
    unsigned char pub[32];
    unsigned char derivation[32];
    unsigned int output_index;
    unsigned char sub_pub[32];

    // fetch
    monero_io_fetch(pub, 32);
    monero_io_fetch_decrypt(derivation, 32, TYPE_DERIVATION);
    output_index = monero_io_fetch_u32();
    monero_io_discard(0);

    // pub
    monero_derive_subaddress_public_key(sub_pub, pub, derivation, output_index);
    // pub key
    monero_io_insert(sub_pub, 32);
    return SW_OK;
}

/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
int monero_apdu_get_subaddress(
    /*const cryptonote::subaddress_index& index, cryptonote::account_public_address &address*/) {
    unsigned char index[8];
    unsigned char C[32];
    unsigned char D[32];

    // fetch
    monero_io_fetch(index, 8);
    monero_io_discard(0);

    // pub
    monero_get_subaddress(C, D, index);

    // pub key
    monero_io_insert(C, 32);
    monero_io_insert(D, 32);
    return SW_OK;
}

/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
int monero_apdu_get_subaddress_spend_public_key(
    /*const cryptonote::subaddress_index& index, crypto::public_key D*/) {
    unsigned char index[8];
    unsigned char D[32];

    // fetch
    monero_io_fetch(index, 8);
    monero_io_discard(1);

    // pub
    monero_get_subaddress_spend_public_key(D, index);

    // pub key
    monero_io_insert(D, 32);

    return SW_OK;
}

/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
int monero_apdu_get_subaddress_secret_key(/*const crypto::secret_key& sec, const cryptonote::subaddress_index& index, crypto::secret_key &sub_sec*/) {
    unsigned char sec[32];
    unsigned char index[8];
    unsigned char sub_sec[32];

    monero_io_fetch_decrypt_key(sec);
    monero_io_fetch(index, 8);
    monero_io_discard(0);

    monero_get_subaddress_secret_key(sub_sec, sec, index);

    os_memmove(G_oxen_state.last_get_subaddress_secret_key, sub_sec, 32);
    monero_io_insert_encrypt(sub_sec, 32, TYPE_SCALAR);
    return SW_OK;
}

/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */

int monero_apu_generate_txout_keys(/*size_t tx_version, crypto::secret_key tx_sec, crypto::public_key Aout, crypto::public_key Bout, size_t output_index, bool is_change, bool is_subaddress, bool need_additional_key*/) {
    // IN
    unsigned int tx_version;
    unsigned char tx_key[32];
    unsigned char *txkey_pub;
    unsigned char *Aout;
    unsigned char *Bout;
    unsigned int output_index;
    unsigned char is_change;
    unsigned char is_subaddress;
    unsigned char need_additional_txkeys;
    unsigned char additional_txkey_sec[32];
    // OUT
    unsigned char additional_txkey_pub[32];
#define amount_key         tx_key
#define out_eph_public_key additional_txkey_sec
    // TMP
    unsigned char derivation[32];

    tx_version = monero_io_fetch_u32();
    monero_io_fetch_decrypt_key(tx_key);
    txkey_pub = G_oxen_state.io_buffer + G_oxen_state.io_offset;
    monero_io_fetch(NULL, 32);
    Aout = G_oxen_state.io_buffer + G_oxen_state.io_offset;
    monero_io_fetch(NULL, 32);
    Bout = G_oxen_state.io_buffer + G_oxen_state.io_offset;
    monero_io_fetch(NULL, 32);
    output_index = monero_io_fetch_u32();
    is_change = monero_io_fetch_u8();
    is_subaddress = monero_io_fetch_u8();
    need_additional_txkeys = monero_io_fetch_u8();
    if (need_additional_txkeys) {
        monero_io_fetch_decrypt_key(additional_txkey_sec);
    }

    // update outkeys hash control
    if (G_oxen_state.tx_sig_mode == TRANSACTION_CREATE_REAL) {
        oxen_hash_update(&G_oxen_state.sha256, Aout, 32);
        oxen_hash_update(&G_oxen_state.sha256, Bout, 32);
        oxen_hash_update(&G_oxen_state.sha256, &is_change, 1);
    }

    // make additional tx pubkey if necessary
    if (need_additional_txkeys) {
        if (is_subaddress) {
            monero_ecmul_k(additional_txkey_pub, Bout, additional_txkey_sec);
        } else {
            monero_ecmul_G(additional_txkey_pub, additional_txkey_sec);
        }
    } else {
        os_memset(additional_txkey_pub, 0, 32);
    }

    // derivation
    if (is_change) {
        monero_generate_key_derivation(derivation, txkey_pub, G_oxen_state.view_priv);
    } else {
        monero_generate_key_derivation(
            derivation, Aout,
            (is_subaddress && need_additional_txkeys) ? additional_txkey_sec : tx_key);
    }

    // compute amount key AKout (scalar1), version is always greater than 1
    monero_derivation_to_scalar(amount_key, derivation, output_index);
    if (G_oxen_state.tx_sig_mode == TRANSACTION_CREATE_REAL) {
        oxen_hash_update(&G_oxen_state.sha256, amount_key, 32);
    }

    // compute ephemeral output key
    monero_derive_public_key(out_eph_public_key, derivation, output_index, Bout);

    // send all
    monero_io_discard(0);
    monero_io_insert_encrypt(amount_key, 32, TYPE_AMOUNT_KEY);
    monero_io_insert(out_eph_public_key, 32);
    if (need_additional_txkeys) {
        monero_io_insert(additional_txkey_pub, 32);
    }
    G_oxen_state.tx_output_cnt++;
    return SW_OK;
}

int monero_apdu_encrypt_payment_id(void) {
    int i;
    unsigned char pub[32];
    unsigned char sec[32];
    unsigned char drv[33];
    unsigned char payID[8];

    // fetch pub
    monero_io_fetch(pub, 32);
    // fetch sec
    monero_io_fetch_decrypt_key(sec);
    // fetch paymentID
    monero_io_fetch(payID, 8);

    monero_io_discard(0);

    // Compute Dout
    monero_generate_key_derivation(drv, pub, sec);

    // compute mask
    drv[32] = ENCRYPTED_PAYMENT_ID_TAIL;
    oxen_keccak_256(&G_oxen_state.keccak, drv, 33, sec);

    // encrypt
    for (i = 0; i < 8; i++) {
        payID[i] = payID[i] ^ sec[i];
    }

    monero_io_insert(payID, 8);

    return SW_OK;
}
