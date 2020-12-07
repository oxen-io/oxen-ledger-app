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

#ifndef LOKI_VARS_H
#define LOKI_VARS_H

#include "os.h"
#include "cx.h"
#include "os_io_seproxyhal.h"
#include "loki_types.h"
#include "loki_api.h"

extern loki_v_state_t G_loki_state;

#define LOKI_IO_P_EQUALS(p1, p2) (G_loki_state.io_p1 == (p1) && G_loki_state.io_p2 == (p2))
#define LOKI_TX_STATE_P_EQUALS(p1, p2) (G_loki_state.tx_state_p1 == (p1) && G_loki_state.tx_state_p2 == (p2))

#define LOKI_IO_INS_P_EQUALS(ins, p1, p2) (G_loki_state.io_ins == (ins) && LOKI_IO_P_EQUALS(p1, p2))
#define LOKI_TX_STATE_INS_P_EQUALS(ins, p1, p2) (G_loki_state.tx_state_ins == (ins) && LOKI_TX_STATE_P_EQUALS(p1, p2))

extern loki_nv_state_t N_state_pic;
#define N_loki_state ((WIDE loki_nv_state_t *)PIC(&N_state_pic))

extern ux_state_t ux;
#endif
