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

#ifndef OXEN_VARS_H
#define OXEN_VARS_H

#include "os.h"
#include "ux.h"
#include "cx.h"
#include "os_io_seproxyhal.h"
#include "oxen_types.h"
#include "oxen_api.h"

extern oxen_v_state_t G_oxen_state;

#define OXEN_IO_P_EQUALS(p1, p2) (G_oxen_state.io_p1 == (p1) && G_oxen_state.io_p2 == (p2))
#define OXEN_TX_STATE_P_EQUALS(p1, p2) (G_oxen_state.tx_state_p1 == (p1) && G_oxen_state.tx_state_p2 == (p2))

#define OXEN_IO_INS_P_EQUALS(ins, p1, p2) (G_oxen_state.io_ins == (ins) && OXEN_IO_P_EQUALS(p1, p2))
#define OXEN_TX_STATE_INS_P_EQUALS(ins, p1, p2) (G_oxen_state.tx_state_ins == (ins) && OXEN_TX_STATE_P_EQUALS(p1, p2))

#ifdef TARGET_NANOX
extern const oxen_nv_state_t N_state_pic;
#define N_oxen_state ((volatile oxen_nv_state_t *)PIC(&N_state_pic))
#else
extern oxen_nv_state_t N_state_pic;
#define N_oxen_state ((WIDE oxen_nv_state_t *)PIC(&N_state_pic))
#endif

extern ux_state_t ux;
#endif
