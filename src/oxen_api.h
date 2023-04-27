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

#ifndef OXEN_API_H
#define OXEN_API_H

#include <stdint.h>

int monero_apdu_reset(void);
int monero_apdu_lock(void);
void monero_lock_and_throw(int sw);

void oxen_install(unsigned char netId);
void monero_init(void);
void monero_init_private_key(void);
void monero_wipe_private_key(void);

void monero_init_ux(void);
int monero_dispatch(void);
void clear_protocol(void);

int monero_apdu_get_network(void);
int monero_apdu_reset_network(void);  // Only allowed in a debug build
int monero_apdu_put_key(void);
int monero_apdu_get_key(void);
int monero_apdu_display_address(void);
int monero_apdu_verify_key(void);
int monero_apdu_get_chacha8_prekey(void);
int monero_apdu_sc_add(void);
int monero_apdu_scal_mul_key(void);
int monero_apdu_scal_mul_base(void);
int monero_apdu_generate_keypair(void);
int monero_apdu_secret_key_to_public_key(void);
int monero_apdu_generate_key_derivation(void);
int monero_apdu_derivation_to_scalar(void);
int monero_apdu_derive_public_key(void);
int monero_apdu_derive_secret_key(void);
int oxen_apdu_get_tx_secret_key(void);
int monero_apdu_generate_key_image(void);
int oxen_apdu_generate_key_image_signature(void);
int oxen_apdu_generate_unlock_signature(void);
int oxen_apdu_generate_lns_hash(void);
int oxen_apdu_generate_lns_signature(void);
int monero_apdu_derive_subaddress_public_key(void);
int monero_apdu_get_subaddress(void);
int monero_apdu_get_subaddress_spend_public_key(void);
int monero_apdu_get_subaddress_secret_key(void);

int monero_apdu_get_tx_proof(void);

int monero_apdu_open_tx(void);
int monero_apdu_open_tx_cont(void);
void monero_reset_tx(int reset_tx_cnt);
int monero_apdu_open_subtx(void);
int monero_apdu_set_signature_mode(void);
int monero_apdu_encrypt_payment_id(void);
int monero_apdu_blind(void);
int monero_apdu_unblind(void);
int monero_apdu_gen_commitment_mask(void);

int monero_apdu_clsag_prehash_init(void);
int monero_apdu_clsag_prehash_update(void);
int monero_apdu_clsag_prehash_finalize(void);

int monero_apdu_clsag_prepare(void);
int monero_apdu_clsag_hash(void);
int monero_apdu_clsag_hash_set(void);
int monero_apdu_clsag_sign(void);

int monero_apu_generate_txout_keys(void);

int monero_apdu_prefix_hash_init(void);
int monero_apdu_prefix_hash_update(void);

int monero_apdu_close_tx(void);

void ui_menu_lock_display(void);
void ui_menu_main_display(void);
void ui_menu_info_display(void);
void ui_menu_info_display2(const char *line1, const char *line2);
void ui_export_viewkey_display(void);
void ui_menu_any_pubaddr_display(unsigned char *pub_view,
                                 unsigned char *pub_spend,
                                 unsigned char is_subbadress,
                                 unsigned char *paymentID);
void ui_menu_pubaddr_display(void);

/* ----------------------------------------------------------------------- */
/* ---                               MISC                             ---- */
/* ----------------------------------------------------------------------- */
#define OFFSETOF(type, field) ((unsigned int) &(((type *) NULL)->field))

// Obtains the monero-base58-encoded wallet address from the view and spend keys, subaddress flag,
// and payment id (for integrated address).  Returns the number of chars written to str_b58.
// Note: does *not* null-terminate the string.
unsigned char oxen_wallet_address(char *str_b58,
                                  unsigned char *view,
                                  unsigned char *spend,
                                  unsigned char is_subbadress,
                                  unsigned char *paymentID);

/** binary little endian unsigned int amount to uint64 */
uint64_t monero_bamount2uint64(unsigned char *binary);

/** uint64 atomic currency amount to human-readable currency amount string. `str` must be at least
 * 22 chars long. */
void oxen_currency_str(uint64_t atomic_oxen, char *str);

int monero_abort_tx(void);
int monero_unblind(unsigned char *v,
                   unsigned char *k,
                   unsigned char *AKout,
                   unsigned int short_amount);
void ui_menu_validation_display(void);
void ui_menu_stake_validation_display(void);
void ui_menu_unlock_validation_display(void);
void ui_menu_lns_validation_display(void);
void ui_menu_fee_validation_display(void);
void ui_menu_lns_fee_validation_display(void);
void ui_menu_change_validation_display(void);
void ui_menu_timelock_validation_display(void);

void ui_menu_opentx_display(unsigned char final_step);
/* ----------------------------------------------------------------------- */
/* ---                          KEYS & ADDRESS                        ---- */
/* ----------------------------------------------------------------------- */
extern const unsigned char C_FAKE_SEC_VIEW_KEY[32];
extern const unsigned char C_FAKE_SEC_SPEND_KEY[32];

int is_fake_view_key(const unsigned char *s);
int is_fake_spend_key(const unsigned char *s);

void monero_ge_fromfe_frombytes(unsigned char *ge, const unsigned char *bytes);
void monero_sc_add(unsigned char *r, const unsigned char *s1, const unsigned char *s2);
void monero_hash_to_scalar(unsigned char *scalar, const unsigned char *raw, unsigned int len);
void monero_hash_to_ec(unsigned char *ec, const unsigned char *ec_pub);
void monero_generate_keypair(unsigned char *ec_pub, unsigned char *ec_priv);
/*
 *  compute s = 8 * (k*P)
 *
 * s [out] 32 bytes derivation value
 * P [in]  point in 02 y or 04 x y format
 * k [in]  32 bytes scalar
 */
void monero_generate_key_derivation(unsigned char *drv_data,
                                    const unsigned char *P,
                                    const unsigned char *scalar);
void monero_derivation_to_scalar(unsigned char *scalar,
                                 const unsigned char *drv_data,
                                 unsigned int out_idx);
/*
 *  compute x = Hps(drv_data,out_idx) + ec_pv
 *
 * x        [out] 32 bytes private key
 * drv_data [in]  32 bytes derivation data (point)
 * ec_pv    [in]  32 bytes private key
 */
void monero_derive_secret_key(unsigned char *x,
                              const unsigned char *drv_data,
                              unsigned int out_idx,
                              const unsigned char *ec_priv);
/*
 *  compute x = Hps(drv_data,out_idx)*G + ec_pub
 *
 * x        [out] 32 bytes public key
 * drv_data [in]  32 bytes derivation data (point)
 * ec_pub   [in]  32 bytes public key
 */
void monero_derive_public_key(unsigned char *x,
                              const unsigned char *drv_data,
                              unsigned int out_idx,
                              const unsigned char *ec_pub);
void monero_secret_key_to_public_key(unsigned char *ec_pub, const unsigned char *ec_priv);
void monero_generate_key_image(unsigned char *img, const unsigned char *P, const unsigned char *x);
void oxen_generate_key_image_signature(unsigned char *sig,
                                       const unsigned char *img,
                                       const unsigned char *P,
                                       const unsigned char *x);
void oxen_generate_signature(unsigned char *sig,
                             const unsigned char *hash,
                             const unsigned char *A,
                             const unsigned char *a);

void monero_derive_subaddress_public_key(unsigned char *x,
                                         const unsigned char *pub,
                                         const unsigned char *drv_data,
                                         unsigned int index);
void monero_get_subaddress_spend_public_key(unsigned char *x, const unsigned char *index);
void monero_get_subaddress(unsigned char *C, unsigned char *D, const unsigned char *index);
void monero_get_subaddress_secret_key(unsigned char *sub_s,
                                      const unsigned char *s,
                                      const unsigned char *index);

/* ----------------------------------------------------------------------- */
/* ---                              CRYPTO                            ---- */
/* ----------------------------------------------------------------------- */
extern const unsigned char C_ED25519_ORDER[];

void monero_aes_derive(cx_aes_key_t *sk,
                       const unsigned char *seed32,
                       const unsigned char *a,
                       const unsigned char *b);
void monero_aes_generate(cx_aes_key_t *sk);

int oxen_keccak_256(cx_sha3_t *hasher,
                    const unsigned char *buf,
                    unsigned int len,
                    unsigned char *out);

#define oxen_hash_update(hasher, buf, len) cx_hash((cx_hash_t *) hasher, 0, buf, len, NULL, 0);
// Finalizes a 32-byte hash and copies it to `out`
#define oxen_hash_final(hasher, out) cx_hash((cx_hash_t *) hasher, CX_LAST, NULL, 0, out, 32);

/*
 *  check 1<s<N, else throw
 */
void monero_check_scalar_range_1N(const unsigned char *s);

/*
 *  check 1<s, else throw
 */
void monero_check_scalar_not_null(const unsigned char *s);

/**
 * LE-7-bits encoding. High bit set says more bytes to decode.  The maximum varint string length is
 * 10 (for a uint64_t with the MSB set).
 */
unsigned int monero_encode_varint(unsigned char *varint,
                                  const unsigned int max_len,
                                  const uint64_t v);

/**
 * LE-7-bits decoding. High bit set says more bytes to decode.  The maximum varint string length is
 * 10 (for a uint64_t with the MSB set).
 */
unsigned int monero_decode_varint(const unsigned char *varint,
                                  const unsigned int max_len,
                                  uint64_t *v);

/** */
void monero_reverse32(unsigned char *rscal, const unsigned char *scal);

/**
 * Hps: keccak(drv_data|varint(out_idx))
 */
void monero_derivation_to_scalar(unsigned char *scalar,
                                 const unsigned char *drv_data,
                                 unsigned int out_idx);

/*
 * W = k.P
 */
void monero_ecmul_k(unsigned char *W, const unsigned char *P, const unsigned char *scalar32);

/*
 * W = 8.P
 */
void monero_ecmul_8(unsigned char *W, const unsigned char *P);

/*
 * W = k.G
 */
void monero_ecmul_G(unsigned char *W, const unsigned char *scalar32);

/*
 * W = k.H
 */
void monero_ecmul_H(unsigned char *W, const unsigned char *scalar32);

/**
 *  keccak("amount"|sk)
 */
void monero_ecdhHash(unsigned char *x, const unsigned char *k);

/**
 * keccak("commitment_mask"|sk) %order
 */
void monero_genCommitmentMask(unsigned char *c, const unsigned char *sk);

/*
 * W = P+Q
 */
void monero_ecadd(unsigned char *W, const unsigned char *P, const unsigned char *Q);
/*
 * W = P-Q
 */
void monero_ecsub(unsigned char *W, const unsigned char *P, const unsigned char *Q);

/* r = (a+b) %order */
void monero_addm(unsigned char *r, const unsigned char *a, const unsigned char *b);

/* r = (a-b) %order */
void monero_subm(unsigned char *r, const unsigned char *a, const unsigned char *b);

/* r = (a*b) %order */
void monero_multm(unsigned char *r, const unsigned char *a, const unsigned char *b);

/* r %= order */
void monero_reduce(unsigned char *r);

void monero_rng_mod_order(unsigned char *r);
/* ----------------------------------------------------------------------- */
/* ---                                IO                              ---- */
/* ----------------------------------------------------------------------- */

void monero_io_discard(int clear);
void monero_io_clear(void);
void monero_io_set_offset(unsigned int offset);
void monero_io_hole(unsigned int sz);
void monero_io_inserted(unsigned int len);
void monero_io_insert(unsigned char const *buffer, unsigned int len);
void monero_io_insert_encrypt(unsigned char *buffer, int len, int type);
void monero_io_insert_hmac_for(unsigned char *buffer, int len, int type);

void monero_io_insert_u32(unsigned int v32);
void monero_io_insert_u24(unsigned int v24);
void monero_io_insert_u16(unsigned int v16);
void monero_io_insert_u8(unsigned int v8);

int monero_io_fetch_available();
void monero_io_fetch_buffer(unsigned char *buffer, unsigned int len);
uint64_t monero_io_fetch_varint(void);
uint32_t monero_io_fetch_varint32(void);
uint16_t monero_io_fetch_varint16(void);
unsigned int monero_io_fetch_u32(void);
unsigned int monero_io_fetch_u24(void);
unsigned int monero_io_fetch_u16(void);
unsigned int monero_io_fetch_u8(void);
int monero_io_fetch(unsigned char *buffer, int len);
int monero_io_fetch_decrypt(unsigned char *buffer, int len, int type);
int monero_io_fetch_decrypt_key(unsigned char *buffer);

int monero_io_do(unsigned int io_flags);

#endif
