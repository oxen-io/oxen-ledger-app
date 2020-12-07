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

#include <stdbool.h>
#include "os.h"
#include "cx.h"
#include "loki_types.h"
#include "loki_api.h"
#include "loki_vars.h"

/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
static unsigned char const WIDE C_ED25519_G[] = {
    // uncompressed
    0x04,
    // x
    0x21, 0x69, 0x36, 0xd3, 0xcd, 0x6e, 0x53, 0xfe, 0xc0, 0xa4, 0xe2, 0x31, 0xfd, 0xd6, 0xdc, 0x5c,
    0x69, 0x2c, 0xc7, 0x60, 0x95, 0x25, 0xa7, 0xb2, 0xc9, 0x56, 0x2d, 0x60, 0x8f, 0x25, 0xd5, 0x1a,
    // y
    0x66, 0x66, 0x66, 0x66, 0x66, 0x66, 0x66, 0x66, 0x66, 0x66, 0x66, 0x66, 0x66, 0x66, 0x66, 0x66,
    0x66, 0x66, 0x66, 0x66, 0x66, 0x66, 0x66, 0x66, 0x66, 0x66, 0x66, 0x66, 0x66, 0x66, 0x66, 0x58};

static unsigned char const WIDE C_ED25519_Hy[] = {
    0x8b, 0x65, 0x59, 0x70, 0x15, 0x37, 0x99, 0xaf, 0x2a, 0xea, 0xdc, 0x9f, 0xf1, 0xad, 0xd0, 0xea,
    0x6c, 0x72, 0x51, 0xd5, 0x41, 0x54, 0xcf, 0xa9, 0x2c, 0x17, 0x3a, 0x0d, 0xd3, 0x9c, 0x1f, 0x94};

unsigned char const C_ED25519_ORDER[32] = {
    // l: 0x1000000000000000000000000000000014def9dea2f79cd65812631a5cf5d3ed
    0x10, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    0x14, 0xDE, 0xF9, 0xDE, 0xA2, 0xF7, 0x9C, 0xD6, 0x58, 0x12, 0x63, 0x1A, 0x5C, 0xF5, 0xD3, 0xED};

unsigned char const C_ED25519_FIELD[32] = {
    // q:  0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffed
    0x7f, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
    0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xed};

unsigned char const C_EIGHT[32] = {0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
                                   0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
                                   0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x08};

/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
void monero_aes_derive(cx_aes_key_t *sk, unsigned char *seed32, unsigned char *a,
                       unsigned char *b) {
    unsigned char h1[32];

    cx_keccak_init(&G_loki_state.keccak_alt, 256);
    loki_hash_update(&G_loki_state.keccak_alt, seed32, 32);
    loki_hash_update(&G_loki_state.keccak_alt, a, 32);
    loki_hash_update(&G_loki_state.keccak_alt, b, 32);
    loki_hash_final(&G_loki_state.keccak_alt, h1);

    loki_keccak_256(&G_loki_state.keccak_alt, h1, 32, h1);

    cx_aes_init_key(h1, 16, sk);
}

/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
void monero_aes_generate(cx_aes_key_t *sk) {
    unsigned char h1[16];
    cx_rng(h1, 16);
    cx_aes_init_key(h1, 16, sk);
}

/* ----------------------------------------------------------------------- */
/* --- assert: max_len>0                                               --- */
/* ----------------------------------------------------------------------- */
unsigned int monero_encode_varint(unsigned char *varint, const unsigned int max_len, uint64_t value) {
    unsigned int len;
    len = 0;
    while (value >= 0x80) {
        if (len == (max_len - 1)) {
            THROW(SW_WRONG_DATA_RANGE);
        }
        varint[len] = (value & 0x7F) | 0x80;
        value = value >> 7;
        len++;
    }
    varint[len] = value;
    return len + 1;
}

/* ----------------------------------------------------------------------- */
/* --- assert: max_len>0                                               --- */
/* ----------------------------------------------------------------------- */
unsigned int monero_decode_varint(const unsigned char *varint, const unsigned int max_len, uint64_t *value) {
    const unsigned int bits = max_len < 10 ? max_len*7 : 64;

    bool more = true;
    unsigned int read = 0;
    *value = 0;
    for (unsigned int shift = 0; more && read < max_len; shift += 7, ++read, ++varint) {

        // if all 0 bits *and* shifting we have something invalid: we have a final, most-significant
        // byte of all 0s, but that isn't allowed (the previous byte should not have had a
        // continuation bit set).
        if (*varint == 0 && shift)
            THROW(SW_WRONG_DATA);

        // If we have <= 7 bits of space remaining then the value must fit and must not have a continuation bit
        const unsigned int bits_avail = bits - shift;
        if (bits_avail <= 7 && *varint >= 1 << bits_avail)
            break; // more is still set, so will throw below

        more = *varint & 0x80;
        *value |= (uint64_t)(*varint & 0x7f) << shift; // 7-bit value
    }
    if (more)
        THROW(SW_WRONG_DATA_RANGE);

    return read;
}

/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
void monero_reverse32(unsigned char *rscal, unsigned char *scal) {
    unsigned char x;
    unsigned int i;
    for (i = 0; i < 16; i++) {
        x = scal[i];
        rscal[i] = scal[31 - i];
        rscal[31 - i] = x;
    }
}

/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */

// Does a one-shot Keccak-256 hash.  (Note that this is not *quite* the same as SHA-3: SHA-3
// appends two bits (01) to the end of the message).
int loki_keccak_256(cx_sha3_t *hasher, unsigned char *buf, unsigned int len, unsigned char *out) {
    cx_keccak_init(hasher, 256);
    return cx_hash((cx_hash_t *) hasher, CX_LAST, buf, len, out, 32);
}

/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
/* thanks to knaccc and moneromoo help on IRC #monero-research-lab */
/* From Monero code
 *
 *  fe_sq2(v, u);            // 2 * u^2
 *  fe_1(w);
 *  fe_add(w, v, w);         // w = 2 * u^2 + 1
 *  fe_sq(x, w);             // w^2
 *  fe_mul(y, fe_ma2, v);    // -2 * A^2 * u^2
 *  fe_add(x, x, y);         // x = w^2 - 2 * A^2 * u^2
 *  fe_divpowm1(r->X, w, x); // (w / x)^(m + 1)
 *  fe_sq(y, r->X);
 *  fe_mul(x, y, x);
 *  fe_sub(y, w, x);
 *  fe_copy(z, fe_ma);
 *  if (fe_isnonzero(y)) {
 *    fe_add(y, w, x);
 *    if (fe_isnonzero(y)) {
 *      goto negative;
 *    } else {
 *      fe_mul(r->X, r->X, fe_fffb1);
 *    }
 *  } else {
 *    fe_mul(r->X, r->X, fe_fffb2);
 *  }
 *  fe_mul(r->X, r->X, u);  // u * sqrt(2 * A * (A + 2) * w / x)
 *  fe_mul(z, z, v);        // -2 * A * u^2
 *  sign = 0;
 *  goto setsign;
 *negative:
 *  fe_mul(x, x, fe_sqrtm1);
 *  fe_sub(y, w, x);
 *  if (fe_isnonzero(y)) {
 *    assert((fe_add(y, w, x), !fe_isnonzero(y)));
 *    fe_mul(r->X, r->X, fe_fffb3);
 *  } else {
 *    fe_mul(r->X, r->X, fe_fffb4);
 *  }
 *  // r->X = sqrt(A * (A + 2) * w / x)
 *  // z = -A
 *  sign = 1;
 *setsign:
 *  if (fe_isnegative(r->X) != sign) {
 *    assert(fe_isnonzero(r->X));
 *    fe_neg(r->X, r->X);
 *  }
 *  fe_add(r->Z, z, w);
 *  fe_sub(r->Y, z, w);
 *  fe_mul(r->X, r->X, r->Z);
 */

// A = 486662
const unsigned char C_fe_ma2[] = {
    /* -A^2
     *  0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffc8db3de3c9
     */
    0x7f, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
    0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xc8, 0xdb, 0x3d, 0xe3, 0xc9};

const unsigned char C_fe_ma[] = {
    /* -A
     *  0x7ffffffffffffffffffffffffffffffffffffffffffffffffffffffffff892e7
     */
    0x7f, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
    0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xf8, 0x92, 0xe7};
const unsigned char C_fe_fffb1[] = {

    /* sqrt(-2 * A * (A + 2))
     * 0x7e71fbefdad61b1720a9c53741fb19e3d19404a8b92a738d22a76975321c41ee
     */
    0x7e, 0x71, 0xfb, 0xef, 0xda, 0xd6, 0x1b, 0x17, 0x20, 0xa9, 0xc5, 0x37, 0x41, 0xfb, 0x19, 0xe3,
    0xd1, 0x94, 0x04, 0xa8, 0xb9, 0x2a, 0x73, 0x8d, 0x22, 0xa7, 0x69, 0x75, 0x32, 0x1c, 0x41, 0xee};
const unsigned char C_fe_fffb2[] = {
    /* sqrt(2 * A * (A + 2))
     * 0x4d061e0a045a2cf691d451b7c0165fbe51de03460456f7dfd2de6483607c9ae0
     */
    0x4d, 0x06, 0x1e, 0x0a, 0x04, 0x5a, 0x2c, 0xf6, 0x91, 0xd4, 0x51, 0xb7, 0xc0, 0x16, 0x5f, 0xbe,
    0x51, 0xde, 0x03, 0x46, 0x04, 0x56, 0xf7, 0xdf, 0xd2, 0xde, 0x64, 0x83, 0x60, 0x7c, 0x9a, 0xe0};
const unsigned char C_fe_fffb3[] = {
    /* sqrt(-sqrt(-1) * A * (A + 2))
     * 674a110d14c208efb89546403f0da2ed4024ff4ea5964229581b7d8717302c66
     */
    0x67, 0x4a, 0x11, 0x0d, 0x14, 0xc2, 0x08, 0xef, 0xb8, 0x95, 0x46,
    0x40, 0x3f, 0x0d, 0xa2, 0xed, 0x40, 0x24, 0xff, 0x4e, 0xa5, 0x96,
    0x42, 0x29, 0x58, 0x1b, 0x7d, 0x87, 0x17, 0x30, 0x2c, 0x66

};
const unsigned char C_fe_fffb4[] = {
    /* sqrt(sqrt(-1) * A * (A + 2))
     * 1a43f3031067dbf926c0f4887ef7432eee46fc08a13f4a49853d1903b6b39186
     */
    0x1a, 0x43, 0xf3, 0x03, 0x10, 0x67, 0xdb, 0xf9, 0x26, 0xc0, 0xf4,
    0x88, 0x7e, 0xf7, 0x43, 0x2e, 0xee, 0x46, 0xfc, 0x08, 0xa1, 0x3f,
    0x4a, 0x49, 0x85, 0x3d, 0x19, 0x03, 0xb6, 0xb3, 0x91, 0x86

};
const unsigned char C_fe_sqrtm1[] = {
    /* sqrt(2 * A * (A + 2))
     * 0x2b8324804fc1df0b2b4d00993dfbd7a72f431806ad2fe478c4ee1b274a0ea0b0
     */
    0x2b, 0x83, 0x24, 0x80, 0x4f, 0xc1, 0xdf, 0x0b, 0x2b, 0x4d, 0x00, 0x99, 0x3d, 0xfb, 0xd7, 0xa7,
    0x2f, 0x43, 0x18, 0x06, 0xad, 0x2f, 0xe4, 0x78, 0xc4, 0xee, 0x1b, 0x27, 0x4a, 0x0e, 0xa0, 0xb0};
const unsigned char C_fe_qm5div8[] = {
    0x0f, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
    0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xfd};

void monero_ge_fromfe_frombytes(unsigned char *ge, unsigned char *bytes) {
#define MOD              (unsigned char *)C_ED25519_FIELD, 32
#define fe_isnegative(f) (f[31] & 1)
#if 0
    unsigned char u[32], v[32], w[32], x[32], y[32], z[32];
    unsigned char rX[32], rY[32], rZ[32];
    union {
        struct {
            unsigned char _uv7[32];
            unsigned char  _v3[32];
        };
        unsigned char _Pxy[65];

    } uv;

#define uv7 uv._uv7
#define v3  uv._v3

#define Pxy uv._Pxy
#else
#define u  (G_loki_state.io_buffer + 0 * 32)
#define v  (G_loki_state.io_buffer + 1 * 32)
#define w  (G_loki_state.io_buffer + 2 * 32)
#define x  (G_loki_state.io_buffer + 3 * 32)
#define y  (G_loki_state.io_buffer + 4 * 32)
#define z  (G_loki_state.io_buffer + 5 * 32)
#define rX (G_loki_state.io_buffer + 6 * 32)
#define rY (G_loki_state.io_buffer + 7 * 32)
#define rZ (G_loki_state.io_buffer + 8 * 32)

    //#define uv7 (G_loki_state.io_buffer+9*32)
    //#define v3  (G_loki_state.io_buffer+10*32)
    union {
        unsigned char _Pxy[65];
        struct {
            unsigned char _uv7[32];
            unsigned char _v3[32];
        };

    } uv;

#define uv7 uv._uv7
#define v3  uv._v3

#define Pxy uv._Pxy

#if MONERO_IO_BUFFER_LENGTH < (9 * 32)
#error MONERO_IO_BUFFER_LENGTH is too small
#endif
#endif

    unsigned char sign;

    // cx works in BE
    monero_reverse32(u, bytes);
    cx_math_modm(u, 32, (unsigned char *)C_ED25519_FIELD, 32);

    // go on
    cx_math_multm(v, u, u, MOD); /* 2 * u^2 */
    cx_math_addm(v, v, v, MOD);

    os_memset(w, 0, 32);
    w[31] = 1;                                           /* w = 1 */
    cx_math_addm(w, v, w, MOD);                          /* w = 2 * u^2 + 1 */
    cx_math_multm(x, w, w, MOD);                         /* w^2 */
    cx_math_multm(y, (unsigned char *)C_fe_ma2, v, MOD); /* -2 * A^2 * u^2 */
    cx_math_addm(x, x, y, MOD);                          /* x = w^2 - 2 * A^2 * u^2 */

// inline fe_divpowm1(r->X, w, x);     // (w / x)^(m + 1) => fe_divpowm1(r,u,v)
#define _u w
#define _v x
    cx_math_multm(v3, _v, _v, MOD);
    cx_math_multm(v3, v3, _v, MOD); /* v3 = v^3 */
    cx_math_multm(uv7, v3, v3, MOD);
    cx_math_multm(uv7, uv7, _v, MOD);
    cx_math_multm(uv7, uv7, _u, MOD);                               /* uv7 = uv^7 */
    cx_math_powm(uv7, uv7, (unsigned char *)C_fe_qm5div8, 32, MOD); /* (uv^7)^((q-5)/8)*/
    cx_math_multm(uv7, uv7, v3, MOD);
    cx_math_multm(rX, uv7, w, MOD); /* u^(m+1)v^(-(m+1)) */
#undef _u
#undef _v

    cx_math_multm(y, rX, rX, MOD);
    cx_math_multm(x, y, x, MOD);
    cx_math_subm(y, w, x, MOD);
    os_memmove(z, C_fe_ma, 32);

    if (!cx_math_is_zero(y, 32)) {
        cx_math_addm(y, w, x, MOD);
        if (!cx_math_is_zero(y, 32)) {
            goto negative;
        } else {
            cx_math_multm(rX, rX, (unsigned char *)C_fe_fffb1, MOD);
        }
    } else {
        cx_math_multm(rX, rX, (unsigned char *)C_fe_fffb2, MOD);
    }
    cx_math_multm(rX, rX, u, MOD);  // u * sqrt(2 * A * (A + 2) * w / x)
    cx_math_multm(z, z, v, MOD);    // -2 * A * u^2
    sign = 0;

    goto setsign;

negative:
    cx_math_multm(x, x, (unsigned char *)C_fe_sqrtm1, MOD);
    cx_math_subm(y, w, x, MOD);
    if (!cx_math_is_zero(y, 32)) {
        cx_math_addm(y, w, x, MOD);
        cx_math_multm(rX, rX, (unsigned char *)C_fe_fffb3, MOD);
    } else {
        cx_math_multm(rX, rX, (unsigned char *)C_fe_fffb4, MOD);
    }
    // r->X = sqrt(A * (A + 2) * w / x)
    // z = -A
    sign = 1;

setsign:
    if (fe_isnegative(rX) != sign) {
        // fe_neg(r->X, r->X);
        cx_math_sub(rX, (unsigned char *)C_ED25519_FIELD, rX, 32);
    }
    cx_math_addm(rZ, z, w, MOD);
    cx_math_subm(rY, z, w, MOD);
    cx_math_multm(rX, rX, rZ, MOD);

    // back to monero y-affine
    cx_math_invprimem(u, rZ, MOD);
    Pxy[0] = 0x04;
    cx_math_multm(&Pxy[1], rX, u, MOD);
    cx_math_multm(&Pxy[1 + 32], rY, u, MOD);
    cx_edward_compress_point(CX_CURVE_Ed25519, Pxy, sizeof(Pxy));
    os_memmove(ge, &Pxy[1], 32);

#undef u
#undef v
#undef w
#undef x
#undef y
#undef z
#undef rX
#undef rY
#undef rZ

#undef uv7
#undef v3

#undef Pxy
}

/* ======================================================================= */
/*                            DERIVATION & KEY                             */
/* ======================================================================= */

/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
void monero_hash_to_scalar(unsigned char *scalar, unsigned char *raw, unsigned int raw_len) {
    loki_keccak_256(&G_loki_state.keccak, raw, raw_len, scalar);
    monero_reduce(scalar, scalar);
}

/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
void monero_hash_to_ec(unsigned char *ec, unsigned char *ec_pub) {
    loki_keccak_256(&G_loki_state.keccak, ec_pub, 32, ec);
    monero_ge_fromfe_frombytes(ec, ec);
    monero_ecmul_8(ec, ec);
}

/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
void monero_generate_keypair(unsigned char *ec_pub, unsigned char *ec_priv) {
    monero_rng_mod_order(ec_priv);
    monero_ecmul_G(ec_pub, ec_priv);
}

/* ----------------------------------------------------------------------- */
/* --- ok                                                              --- */
/* ----------------------------------------------------------------------- */
void monero_generate_key_derivation(unsigned char *drv_data, unsigned char *P,
                                    unsigned char *scalar) {
    monero_ecmul_8k(drv_data, P, scalar);
}

/* ----------------------------------------------------------------------- */
/* ---  ok                                                             --- */
/* ----------------------------------------------------------------------- */
void monero_derivation_to_scalar(unsigned char *scalar, unsigned char *drv_data,
                                 unsigned int out_idx) {
    unsigned char varint[32 + 8];
    unsigned int len_varint;

    os_memmove(varint, drv_data, 32);
    len_varint = monero_encode_varint(varint + 32, 8, out_idx);
    len_varint += 32;
    loki_keccak_256(&G_loki_state.keccak, varint, len_varint, varint);
    monero_reduce(scalar, varint);
}

/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
void monero_derive_secret_key(unsigned char *x, unsigned char *drv_data, unsigned int out_idx,
                              unsigned char *ec_priv) {
    unsigned char tmp[32];

    // derivation to scalar
    monero_derivation_to_scalar(tmp, drv_data, out_idx);

    // generate
    monero_addm(x, tmp, ec_priv);
}

/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
void monero_derive_public_key(unsigned char *x, unsigned char *drv_data, unsigned int out_idx,
                              unsigned char *ec_pub) {
    unsigned char tmp[32];

    // derivation to scalar
    monero_derivation_to_scalar(tmp, drv_data, out_idx);
    // generate
    monero_ecmul_G(tmp, tmp);
    monero_ecadd(x, tmp, ec_pub);
}

/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
void monero_secret_key_to_public_key(unsigned char *ec_pub, unsigned char *ec_priv) {
    monero_ecmul_G(ec_pub, ec_priv);
}

/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
void monero_generate_key_image(unsigned char *img, unsigned char *P, unsigned char *x) {
    unsigned char I[32];
    monero_hash_to_ec(I, P);
    monero_ecmul_k(img, I, x);
}

/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
void loki_generate_key_image_signature(unsigned char *sig, unsigned char *img, unsigned char *P, unsigned char *x) {
    unsigned char k[32];
    unsigned char tmp[32];

    cx_keccak_init(&G_loki_state.keccak_alt, 256); // Need to calculate H(I || L || R)
    loki_hash_update(&G_loki_state.keccak_alt, img, 32); // H(I ||...

    monero_rng_mod_order(k); // k = random ]0..L[
    monero_ecmul_G(tmp, k); // L0 = kG
    loki_hash_update(&G_loki_state.keccak_alt, tmp, 32); // H(...|| L ||...)

    monero_hash_to_ec(tmp, P); // H(P)
    monero_ecmul_k(tmp, tmp, k); // R = kH(P)
    loki_hash_update(&G_loki_state.keccak_alt, tmp, 32); // H(...|| R)

    // sig = [c,r]
    // c = H(I || L || R) mod L
    loki_hash_final(&G_loki_state.keccak_alt, sig);
    monero_reduce(sig, sig);

    monero_multm(tmp, x, sig); // xc
    monero_subm(sig+32, k, tmp); // r = k - xc
}

/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
void loki_generate_signature(unsigned char *sig, unsigned char *hash, unsigned char *A, unsigned char *a) {
    unsigned char r[32];
    unsigned char tmp[32];

    monero_rng_mod_order(r); // r = random ]0..L[
    monero_ecmul_G(tmp, r); // R = rG

    cx_keccak_init(&G_loki_state.keccak_alt, 256); // Need to calculate H(M || A || R)
    loki_hash_update(&G_loki_state.keccak_alt, hash, 32); // H(M
    loki_hash_update(&G_loki_state.keccak_alt, A, 32);    //     || A
    loki_hash_update(&G_loki_state.keccak_alt, tmp, 32);  //          || R)
    // sig = [c,s]
    // c = H(M||A||R) mod L:
    loki_hash_final(&G_loki_state.keccak_alt, sig);
    monero_reduce(sig, sig);

    monero_multm(tmp, sig, a); // ac
    monero_subm(sig+32, r, tmp); // s = r - ac
}

/* ======================================================================= */
/*                               SUB ADDRESS                               */
/* ======================================================================= */

/* ----------------------------------------------------------------------- */
/* --- ok                                                              --- */
/* ----------------------------------------------------------------------- */
void monero_derive_subaddress_public_key(unsigned char *x, unsigned char *pub,
                                         unsigned char *drv_data, unsigned int index) {
    unsigned char scalarG[32];

    monero_derivation_to_scalar(scalarG, drv_data, index);
    monero_ecmul_G(scalarG, scalarG);
    monero_ecsub(x, pub, scalarG);
}

/* ----------------------------------------------------------------------- */
/* --- ok                                                              --- */
/* ----------------------------------------------------------------------- */
void monero_get_subaddress_spend_public_key(unsigned char *x, unsigned char *index) {
    // m = Hs(a || index_major || index_minor)
    monero_get_subaddress_secret_key(x, G_loki_state.view_priv, index);
    // M = m*G
    monero_secret_key_to_public_key(x, x);
    // D = B + M
    monero_ecadd(x, x, G_loki_state.spend_pub);
}

/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
void monero_get_subaddress(unsigned char *C, unsigned char *D, unsigned char *index) {
    // retrieve D
    monero_get_subaddress_spend_public_key(D, index);
    // C = a*D
    monero_ecmul_k(C, D, G_loki_state.view_priv);
}

/* ----------------------------------------------------------------------- */
/* --- ok                                                              --- */
/* ----------------------------------------------------------------------- */
static const char C_sub_address_prefix[] = {'S', 'u', 'b', 'A', 'd', 'd', 'r', 0};

void monero_get_subaddress_secret_key(unsigned char *sub_s, unsigned char *s,
                                      unsigned char *index) {
    cx_keccak_init(&G_loki_state.keccak, 256);

    loki_hash_update(&G_loki_state.keccak, C_sub_address_prefix, sizeof(C_sub_address_prefix));
    loki_hash_update(&G_loki_state.keccak, s, 32);
    loki_hash_update(&G_loki_state.keccak, index, 8);
    loki_hash_final(&G_loki_state.keccak, sub_s);
    monero_reduce(sub_s, sub_s);
}

/* ======================================================================= */
/*                                  MATH                                   */
/* ======================================================================= */

/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
void monero_check_scalar_range_1N(unsigned char *s) {
    unsigned char x[32];
    monero_reverse32(x, s);
    if (cx_math_is_zero(x, 32) || cx_math_cmp(x, C_ED25519_ORDER, 32) >= 0) {
        THROW(SW_WRONG_DATA_RANGE);
    }
}

/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
void monero_check_scalar_not_null(unsigned char *s) {
    if (cx_math_is_zero(s, 32)) {
        THROW(SW_WRONG_DATA_RANGE);
    }
}
/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
void monero_ecmul_G(unsigned char *W, unsigned char *scalar32) {
    unsigned char Pxy[65];
    unsigned char s[32];
    monero_reverse32(s, scalar32);
    os_memmove(Pxy, C_ED25519_G, 65);
    cx_ecfp_scalar_mult(CX_CURVE_Ed25519, Pxy, sizeof(Pxy), s, 32);
    cx_edward_compress_point(CX_CURVE_Ed25519, Pxy, sizeof(Pxy));
    os_memmove(W, &Pxy[1], 32);
}

/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
void monero_ecmul_H(unsigned char *W, unsigned char *scalar32) {
    unsigned char Pxy[65];
    unsigned char s[32];

    monero_reverse32(s, scalar32);

    Pxy[0] = 0x02;
    os_memmove(&Pxy[1], C_ED25519_Hy, 32);
    cx_edward_decompress_point(CX_CURVE_Ed25519, Pxy, sizeof(Pxy));

    cx_ecfp_scalar_mult(CX_CURVE_Ed25519, Pxy, sizeof(Pxy), s, 32);
    cx_edward_compress_point(CX_CURVE_Ed25519, Pxy, sizeof(Pxy));

    os_memmove(W, &Pxy[1], 32);
}

/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
void monero_ecmul_k(unsigned char *W, unsigned char *P, unsigned char *scalar32) {
    unsigned char Pxy[65];
    unsigned char s[32];

    monero_reverse32(s, scalar32);

    Pxy[0] = 0x02;
    os_memmove(&Pxy[1], P, 32);
    cx_edward_decompress_point(CX_CURVE_Ed25519, Pxy, sizeof(Pxy));

    cx_ecfp_scalar_mult(CX_CURVE_Ed25519, Pxy, sizeof(Pxy), s, 32);
    cx_edward_compress_point(CX_CURVE_Ed25519, Pxy, sizeof(Pxy));

    os_memmove(W, &Pxy[1], 32);
}

/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
void monero_ecmul_8k(unsigned char *W, unsigned char *P, unsigned char *scalar32) {
    unsigned char s[32];
    monero_multm_8(s, scalar32);
    monero_ecmul_k(W, P, s);
}

/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
void monero_ecmul_8(unsigned char *W, unsigned char *P) {
    unsigned char Pxy[65];

    Pxy[0] = 0x02;
    os_memmove(&Pxy[1], P, 32);
    cx_edward_decompress_point(CX_CURVE_Ed25519, Pxy, sizeof(Pxy));
    cx_ecfp_add_point(CX_CURVE_Ed25519, Pxy, Pxy, Pxy, sizeof(Pxy));
    cx_ecfp_add_point(CX_CURVE_Ed25519, Pxy, Pxy, Pxy, sizeof(Pxy));
    cx_ecfp_add_point(CX_CURVE_Ed25519, Pxy, Pxy, Pxy, sizeof(Pxy));
    cx_edward_compress_point(CX_CURVE_Ed25519, Pxy, sizeof(Pxy));
    os_memmove(W, &Pxy[1], 32);
}

/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
void monero_ecadd(unsigned char *W, unsigned char *P, unsigned char *Q) {
    unsigned char Pxy[65];
    unsigned char Qxy[65];

    Pxy[0] = 0x02;
    os_memmove(&Pxy[1], P, 32);
    cx_edward_decompress_point(CX_CURVE_Ed25519, Pxy, sizeof(Pxy));

    Qxy[0] = 0x02;
    os_memmove(&Qxy[1], Q, 32);
    cx_edward_decompress_point(CX_CURVE_Ed25519, Qxy, sizeof(Qxy));

    cx_ecfp_add_point(CX_CURVE_Ed25519, Pxy, Pxy, Qxy, sizeof(Pxy));

    cx_edward_compress_point(CX_CURVE_Ed25519, Pxy, sizeof(Pxy));
    os_memmove(W, &Pxy[1], 32);
}

/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
void monero_ecsub(unsigned char *W, unsigned char *P, unsigned char *Q) {
    unsigned char Pxy[65];
    unsigned char Qxy[65];

    Pxy[0] = 0x02;
    os_memmove(&Pxy[1], P, 32);
    cx_edward_decompress_point(CX_CURVE_Ed25519, Pxy, sizeof(Pxy));

    Qxy[0] = 0x02;
    os_memmove(&Qxy[1], Q, 32);
    cx_edward_decompress_point(CX_CURVE_Ed25519, Qxy, sizeof(Qxy));

    cx_math_sub(Qxy + 1, (unsigned char *)C_ED25519_FIELD, Qxy + 1, 32);
    cx_ecfp_add_point(CX_CURVE_Ed25519, Pxy, Pxy, Qxy, sizeof(Pxy));

    cx_edward_compress_point(CX_CURVE_Ed25519, Pxy, sizeof(Pxy));
    os_memmove(W, &Pxy[1], 32);
}

/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
void monero_ecdhHash(unsigned char *x, unsigned char *k) {
    cx_keccak_init(&G_loki_state.keccak, 256);
    loki_hash_update(&G_loki_state.keccak, "amount", 6);
    loki_hash_update(&G_loki_state.keccak, k, 32);
    loki_hash_final(&G_loki_state.keccak, x);
}

/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
void monero_genCommitmentMask(unsigned char *c, unsigned char *sk) {
    cx_keccak_init(&G_loki_state.keccak, 256);
    loki_hash_update(&G_loki_state.keccak, "commitment_mask", 15);
    loki_hash_update(&G_loki_state.keccak, sk, 32);
    loki_hash_final(&G_loki_state.keccak, c);
    monero_reduce(c, c);
}

/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
void monero_addm(unsigned char *r, unsigned char *a, unsigned char *b) {
    unsigned char ra[32];
    unsigned char rb[32];

    monero_reverse32(ra, a);
    monero_reverse32(rb, b);
    cx_math_addm(r, ra, rb, (unsigned char *)C_ED25519_ORDER, 32);
    monero_reverse32(r, r);
}

/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
void monero_subm(unsigned char *r, unsigned char *a, unsigned char *b) {
    unsigned char ra[32];
    unsigned char rb[32];

    monero_reverse32(ra, a);
    monero_reverse32(rb, b);
    cx_math_subm(r, ra, rb, (unsigned char *)C_ED25519_ORDER, 32);
    monero_reverse32(r, r);
}
/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
void monero_multm(unsigned char *r, unsigned char *a, unsigned char *b) {
    unsigned char ra[32];
    unsigned char rb[32];

    monero_reverse32(ra, a);
    monero_reverse32(rb, b);
    cx_math_multm(r, ra, rb, (unsigned char *)C_ED25519_ORDER, 32);
    monero_reverse32(r, r);
}

/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
void monero_multm_8(unsigned char *r, unsigned char *a) {
    unsigned char ra[32];
    unsigned char rb[32];

    monero_reverse32(ra, a);
    os_memset(rb, 0, 32);
    rb[31] = 8;
    cx_math_multm(r, ra, rb, (unsigned char *)C_ED25519_ORDER, 32);
    monero_reverse32(r, r);
}

/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
void monero_reduce(unsigned char *r, unsigned char *a) {
    unsigned char ra[32];
    monero_reverse32(ra, a);
    cx_math_modm(ra, 32, (unsigned char *)C_ED25519_ORDER, 32);
    monero_reverse32(r, ra);
}

/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
void monero_rng_mod_order(unsigned char *r) {
    unsigned char rnd[32 + 8];
    cx_rng(rnd, 32 + 8);
    cx_math_modm(rnd, 32 + 8, (unsigned char *)C_ED25519_ORDER, 32);
    monero_reverse32(r, rnd + 8);
}

/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
uint64_t monero_bamount2uint64(unsigned char *binary) {
    // Value is already little endian, so just copy it directly from the bytes:
    uint64_t xmr;
    os_memmove(&xmr, binary, 8);
    return xmr;
}
