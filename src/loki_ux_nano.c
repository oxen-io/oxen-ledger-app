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

#include "loki_ux_msg.h"
#include "os_io_seproxyhal.h"
#include "glyphs.h"

/* ----------------------------------------------------------------------- */
/* ---                     Nano S and X UI layout                      --- */
/* ----------------------------------------------------------------------- */

#define ACCEPT 0xACCE
#define REJECT ~ACCEPT

/* -------------------------------------- LOCK--------------------------------------- */

void ui_menu_pinlock_display(void) {
    struct {
        bolos_ux_t ux_id;
        // length of parameters in the u union to be copied during the syscall
        unsigned int len;
        union {
            struct {
                unsigned int cancellable;
            } validate_pin;
        } u;

    } ux_params;

    os_global_pin_invalidate();
    G_monero_vstate.protocol_barrier = PROTOCOL_LOCKED_UNLOCKABLE;
    ux_params.ux_id = BOLOS_UX_VALIDATE_PIN;
    ux_params.len = sizeof(ux_params.u.validate_pin);
    ux_params.u.validate_pin.cancellable = 0;
    os_ux((bolos_ux_params_t*)&ux_params);
    ui_menu_main_display();
}

/* -------------------------------------- 25 WORDS --------------------------------------- */
void ui_menu_words_display(void);
void ui_menu_words_clear(void);

UX_STEP_NOCB(ux_menu_words_1_step,
             paging,
             {
                 .title = "Electrum Seed",
                 .text = "NOTSET",
             });

UX_STEP_CB(ux_menu_words_2_step, bn, ui_menu_words_clear(),
           {"CLEAR WORDS", "(Does not wipe wallet)"});

UX_STEP_CB(ux_menu_words_3_step, pb, ui_menu_main_display(), {&C_icon_back, "back"});

UX_FLOW(ux_flow_words, &ux_menu_words_1_step, &ux_menu_words_2_step, &ux_menu_words_3_step);

void ui_menu_words_clear(void) {
    monero_clear_words();
    ui_menu_main_display();
}

void ui_menu_words_display(void) { ux_flow_init(0, ux_flow_words, NULL); }

void settings_show_25_words(void) { ui_menu_words_display(); }
/* -------------------------------- INFO UX --------------------------------- */
unsigned int ui_menu_info_action(void);

UX_STEP_CB(ux_menu_info_1_step, nn, ui_menu_info_action(),
           {
               G_monero_vstate.ux_info1,
               G_monero_vstate.ux_info2,
           });

UX_FLOW(ux_flow_info, &ux_menu_info_1_step);

unsigned int ui_menu_info_action(void) {
    if (G_monero_vstate.protocol_barrier == PROTOCOL_LOCKED) {
        ui_menu_pinlock_display();
    } else {
        ui_menu_main_display();
    }
    return 0;
}

void ui_menu_info_display2(char* line1, char* line2) {
    snprintf(G_monero_vstate.ux_info1, sizeof(G_monero_vstate.ux_info1), "%s", line1);
    snprintf(G_monero_vstate.ux_info2, sizeof(G_monero_vstate.ux_info2), "%s", line2);
    ux_flow_init(0, ux_flow_info, NULL);
}

void ui_menu_info_display(void) { ux_flow_init(0, ux_flow_info, NULL); }

/* -------------------------------- OPEN TX UX --------------------------------- */
unsigned int ui_menu_opentx_action(unsigned int value);

UX_STEP_NOCB(ux_menu_opentx_1_step, nn, {"Process", "new TX ?"});

UX_STEP_CB(ux_menu_opentx_2_step, pb, ui_menu_opentx_action(ACCEPT), {&C_icon_validate_14, "Yes"});

UX_STEP_CB(ux_menu_opentx_3_step, pb, ui_menu_opentx_action(REJECT), {&C_icon_crossmark, "No!"});

UX_FLOW(ux_flow_opentx, &ux_menu_opentx_1_step, &ux_menu_opentx_2_step, &ux_menu_opentx_3_step);

unsigned int ui_menu_opentx_action(unsigned int value) {
    unsigned int sw;
    unsigned char x[32];

    monero_io_discard(0);
    os_memset(x, 0, 32);
    sw = SW_OK;

    if (value == ACCEPT) {
        sw = monero_apdu_open_tx_cont();
        ui_menu_info_display2("Processing TX", "...");
    } else {
        monero_abort_tx();
        sw = SW_DENY;
        ui_menu_info_display2("Tansaction", "aborted");
    }
    monero_io_insert_u16(sw);
    monero_io_do(IO_RETURN_AFTER_TX);
    return 0;
}

#if 0
void ui_menu_opentx_display(void) {
  if (G_monero_vstate.tx_sig_mode == TRANSACTION_CREATE_REAL) {
    ux_flow_init(0, ux_flow_opentx,NULL);
  } else {
    snprintf(G_monero_vstate.ux_info1, sizeof(G_monero_vstate.ux_info1), "Prepare new");
    snprintf(G_monero_vstate.ux_info2, sizeof(G_monero_vstate.ux_info2), "TX / %d", G_monero_vstate.tx_cnt);
    ui_menu_info_display();
  }
}
#else
void ui_menu_opentx_display(void) {
    uint8_t i;
    if (G_monero_vstate.tx_sig_mode == TRANSACTION_CREATE_REAL) {
        snprintf(G_monero_vstate.ux_info1, sizeof(G_monero_vstate.ux_info1), "Processing TX");
    } else {
        snprintf(G_monero_vstate.ux_info1, sizeof(G_monero_vstate.ux_info1), "Preparing TX");
    }
    for (i = 0; (i < G_monero_vstate.tx_cnt) && (i < 12); i++) {
        G_monero_vstate.ux_info2[i] = '.';
    }
    G_monero_vstate.ux_info2[i] = 0;
    ui_menu_info_display();
}
#endif

/* ----------------- FEE/CHANGE/TIMELOCK VALIDATION ----------------- */

void ui_menu_amount_validation_action(unsigned int value);

UX_STEP_NOCB(ux_menu_validation_fee_1_step, bn,
             {
                 "Fee",
                 G_monero_vstate.ux_amount,
             });

UX_STEP_NOCB(ux_menu_validation_change_1_step, bn,
             {
                 "Change",
                 G_monero_vstate.ux_amount,
             });

UX_STEP_NOCB(ux_menu_validation_timelock_1_step, bn,
             {
                 "Timelock",
                 G_monero_vstate.ux_amount,
             });

UX_STEP_CB(ux_menu_validation_cf_2_step, pb, ui_menu_amount_validation_action(ACCEPT),
           {
               &C_icon_validate_14,
               "Accept",
           });

UX_STEP_CB(ux_menu_validation_cf_3_step, pb, ui_menu_amount_validation_action(REJECT),
           {
               &C_icon_crossmark,
               "Reject",
           });

UX_FLOW(ux_flow_fee, &ux_menu_validation_fee_1_step, &ux_menu_validation_cf_2_step,
        &ux_menu_validation_cf_3_step);

UX_FLOW(ux_flow_change, &ux_menu_validation_change_1_step, &ux_menu_validation_cf_2_step,
        &ux_menu_validation_cf_3_step);

UX_FLOW(ux_flow_timelock, &ux_menu_validation_timelock_1_step, &ux_menu_validation_cf_2_step,
        &ux_menu_validation_cf_3_step);

void ui_menu_amount_validation_action(unsigned int value) {
    unsigned short sw;
    if (value == ACCEPT) {
        sw = SW_OK;
    } else {
        monero_abort_tx();
        sw = SW_DENY;
    }
    monero_io_insert_u16(sw);
    monero_io_do(IO_RETURN_AFTER_TX);
    ui_menu_info_display2("Processing TX", "...");
}

void ui_menu_fee_validation_display(void) { ux_flow_init(0, ux_flow_fee, NULL); }

void ui_menu_change_validation_display(void) {
    ux_flow_init(0, ux_flow_change, NULL);
}

void ui_menu_timelock_validation_display(void) {
    ux_flow_init(0, ux_flow_timelock, NULL);
}
/* ----------------------------- USER DEST/AMOUNT VALIDATION ----------------------------- */
void ui_menu_validation_action(unsigned int value);

UX_STEP_NOCB(ux_menu_validation_1_step, bn, {"Amount", G_monero_vstate.ux_amount});

UX_STEP_NOCB(ux_menu_validation_2_step, paging,
             {"Destination", G_monero_vstate.ux_address});

UX_STEP_CB(ux_menu_validation_3_step, pb, ui_menu_validation_action(ACCEPT),
           {&C_icon_validate_14, "Accept"});

UX_STEP_CB(ux_menu_validation_4_step, pb, ui_menu_validation_action(REJECT),
           {&C_icon_crossmark, "Reject"});

UX_FLOW(ux_flow_validation,
        &ux_menu_validation_1_step,
        &ux_menu_validation_2_step,
        &ux_menu_validation_3_step,
        &ux_menu_validation_4_step);

void ui_menu_validation_display(void) { ux_flow_init(0, ux_flow_validation, NULL); }

void ui_menu_validation_action(unsigned int value) {
    unsigned short sw;
    if (value == ACCEPT) {
        sw = SW_OK;
    } else {
        monero_abort_tx();
        sw = SW_DENY;
    }
    monero_io_insert_u16(sw);
    monero_io_do(IO_RETURN_AFTER_TX);
    ui_menu_info_display2("Processing TX", "...");
}

/* -------------------------------- EXPORT VIEW KEY UX --------------------------------- */
unsigned int ui_menu_export_viewkey_action(unsigned int value);

UX_STEP_CB(ux_menu_export_viewkey_1_step, pb, ui_menu_export_viewkey_action(ACCEPT),
           {&C_icon_validate_14, "Export view key?"});

UX_STEP_CB(ux_menu_export_viewkey_2_step, pb, ui_menu_export_viewkey_action(ACCEPT | 0x10000),
           {&C_icon_validate_14, "Always export"});

UX_STEP_CB(ux_menu_export_viewkey_3_step, pb, ui_menu_export_viewkey_action(REJECT),
           {&C_icon_crossmark, "Reject"});

UX_STEP_CB(ux_menu_export_viewkey_4_step, pb, ui_menu_export_viewkey_action(REJECT | 0x10000),
           {&C_icon_crossmark, "Always reject"});

UX_FLOW(ux_flow_export_viewkey,
        &ux_menu_export_viewkey_1_step,
        &ux_menu_export_viewkey_2_step,
        &ux_menu_export_viewkey_3_step,
        &ux_menu_export_viewkey_4_step,
        FLOW_LOOP
        );

void ui_export_viewkey_display(void) {
    switch (N_monero_pstate->viewkey_export_mode) {
        case VIEWKEY_EXPORT_ALWAYS_ALLOW:
            ui_menu_export_viewkey_action(ACCEPT);
            break;
        case VIEWKEY_EXPORT_ALWAYS_DENY:
            ui_menu_export_viewkey_action(REJECT);
            break;
        default:
            ux_flow_init(0, ux_flow_export_viewkey, NULL);
            break;
    }
}

unsigned int ui_menu_export_viewkey_action(unsigned int value) {
    unsigned int sw;
    unsigned char x[32];

    monero_io_discard(0);
    os_memset(x, 0, 32);
    sw = SW_OK;
    if (value & 0x10000) { // remember
        value &= ~0x10000;
        unsigned char val = value == ACCEPT ? VIEWKEY_EXPORT_ALWAYS_ALLOW : VIEWKEY_EXPORT_ALWAYS_DENY;
        monero_nvm_write((void*)&N_monero_pstate->viewkey_export_mode, &val, sizeof(unsigned char));
    }

    if (value == ACCEPT) {
        monero_io_insert(G_monero_vstate.view_priv, 32);
        G_monero_vstate.export_view_key = 1;
    } else {
        monero_io_insert(x, 32);
        G_monero_vstate.export_view_key = 0;
    }
    monero_io_insert_u16(sw);
    monero_io_do(IO_RETURN_AFTER_TX);
    ui_menu_main_display();
    return 0;
}


const char* const viewkey_export_submenu_values[] = {
    "Always prompt",
    "Always allow",
    "Always deny",
    "Cancel"};
const char* const viewkey_export_submenu_values_selected[] = {
    "Always prompt *",
    "Always allow *",
    "Always deny *",
    "Cancel"};

const char* viewkey_export_submenu_getter(unsigned int idx) {
    if (idx >= ARRAYLEN(viewkey_export_submenu_values)) {
        return NULL;
    } else if (N_monero_pstate->viewkey_export_mode == idx) {
        return viewkey_export_submenu_values_selected[idx];
    } else {
        return viewkey_export_submenu_values[idx];
    }
}

void viewkey_export_submenu_selector(unsigned int idx) {
    if (idx < ARRAYLEN(viewkey_export_submenu_values) - 1) {
        unsigned char val =
            idx == 1 ? VIEWKEY_EXPORT_ALWAYS_ALLOW :
            idx == 2 ? VIEWKEY_EXPORT_ALWAYS_DENY :
            VIEWKEY_EXPORT_ALWAYS_PROMPT;
        monero_nvm_write((void*)&N_monero_pstate->viewkey_export_mode, &val, sizeof(unsigned char));
        monero_init();
    }
    ui_menu_main_display();
}

void ui_menu_viewkey_export_display() {
    ux_menulist_init(G_ux.stack_count - 1, viewkey_export_submenu_getter, viewkey_export_submenu_selector);
}

/* -------------------------------- NETWORK UX --------------------------------- */

const char* const network_submenu_getter_values[] = {
#ifdef LOKI_ALPHA
    "Unvailable",
#else
    "Main Network",
#endif
    "Test Network", "Cancel"};
const char* const network_submenu_getter_values_selected[] = {
#ifdef LOKI_ALPHA
    "Unvailable",
#else
    "Main Network *",
#endif
    "Test Network *", "Cancel"};

const char* network_submenu_getter(unsigned int idx) {
    if (idx >= ARRAYLEN(network_submenu_getter_values)) {
        return NULL;
    }
    int net;
    switch (idx) {
        case 0:
#ifdef LOKI_ALPHA
            net = -1;
#else
            net = MAINNET;
#endif
            break;
        case 1:
            net = TESTNET;
            break;
        default:
            net = -1;
            break;
    }
    if (N_monero_pstate->network_id == net) {
        return network_submenu_getter_values_selected[idx];
    } else {
        return network_submenu_getter_values[idx];
    }
}

static void network_set_net(unsigned int network) {
    loki_install(network);
    monero_init();
}

void network_submenu_selector(unsigned int idx) {
    switch (idx) {
        case 0:
#ifndef LOKI_ALPHA
            network_set_net(MAINNET);
#endif
            break;
        case 1:
            network_set_net(TESTNET);
            break;
        default:
            break;
    }
    ui_menu_main_display();
}

void ui_menu_network_display(void) {
    ux_menulist_init(G_ux.stack_count - 1, network_submenu_getter, network_submenu_selector);
}

/* -------------------------------- RESET UX --------------------------------- */
void ui_menu_reset_display(void);
void ui_menu_reset_action(unsigned int value);

UX_STEP_NOCB(ux_menu_reset_1_step, nn,
             {
                 "",
                 "Really Reset?",
             });

UX_STEP_CB(ux_menu_reset_2_step, pb, ui_menu_reset_action(REJECT),
           {
               &C_icon_crossmark,
               "No",
           });

UX_STEP_CB(ux_menu_reset_3_step, pb, ui_menu_reset_action(ACCEPT),
           {
               &C_icon_validate_14,
               "Yes",
           });

UX_FLOW(ux_flow_reset, &ux_menu_reset_1_step, &ux_menu_reset_2_step, &ux_menu_reset_3_step);

void ui_menu_reset_display(void) { ux_flow_init(0, ux_flow_reset, 0); }

void ui_menu_reset_action(unsigned int value) {
    if (value == ACCEPT) {
        unsigned char magic[4] = {0};
        monero_nvm_write((void*)N_monero_pstate->magic, magic, 4);
        monero_init();
    }
    ui_menu_main_display();
}
/* ------------------------------- SETTINGS UX ------------------------------- */

const char* const settings_submenu_getter_values[] = {
    "Select Network", "View key export", "Show 25 words", "Reset", "Back",
};

const char* settings_submenu_getter(unsigned int idx) {
    if (idx < ARRAYLEN(settings_submenu_getter_values)) {
        return settings_submenu_getter_values[idx];
    }
    return NULL;
}

void settings_submenu_selector(unsigned int idx) {
    switch (idx) {
        case 0: ui_menu_network_display(); break;
        case 1: ui_menu_viewkey_export_display(); break;
        case 2: ui_menu_words_display(); break;
        case 3: ui_menu_reset_display(); break;
        default: ui_menu_main_display();
    }
}

/* ---------------------------- PUBLIC ADDRESS UX ---------------------------- */
void ui_menu_pubaddr_action(void);

UX_STEP_NOCB(ux_menu_pubaddr_1_step, nn,
         {
             .line1 = G_monero_vstate.ux_addr_type,
             .line2 = G_monero_vstate.ux_addr_info
         });

UX_STEP_NOCB(ux_menu_pubaddr_2_step, paging,
        {
            .title = "Address",
            .text = G_monero_vstate.ux_address
        });

UX_STEP_CB(ux_menu_pubaddr_3_step, pb, ui_menu_pubaddr_action(),
        {
            .icon = &C_icon_back,
            .line1 = "Back"
        });

UX_FLOW(ux_flow_pubaddr,
        &ux_menu_pubaddr_1_step,
        &ux_menu_pubaddr_2_step,
        &ux_menu_pubaddr_3_step,
        FLOW_LOOP
        );

void ui_menu_pubaddr_action(void) {
    if (G_monero_vstate.disp_addr_mode) {
        monero_io_insert_u16(SW_OK);
        monero_io_do(IO_RETURN_AFTER_TX);
    }
    G_monero_vstate.disp_addr_mode = 0;
    ui_menu_main_display();
}

/**
 *
 */
void ui_menu_any_pubaddr_display(unsigned char* pub_view, unsigned char* pub_spend,
                                 unsigned char is_subbadress, unsigned char* paymentID) {
    os_memset(G_monero_vstate.ux_address, 0, sizeof(G_monero_vstate.ux_address));
    os_memset(G_monero_vstate.ux_addr_type, 0, sizeof(G_monero_vstate.ux_addr_type));
    os_memset(G_monero_vstate.ux_addr_info, 0, sizeof(G_monero_vstate.ux_addr_info));

    switch (G_monero_vstate.disp_addr_mode) {
        case 0:
        case DISP_MAIN:
            os_memmove(G_monero_vstate.ux_addr_type, "Regular address", 15);
            if (N_monero_pstate->network_id == MAINNET)
                os_memmove(G_monero_vstate.ux_addr_info, "(mainnet)", 9);
            else if (N_monero_pstate->network_id == TESTNET)
                os_memmove(G_monero_vstate.ux_addr_info, "(testnet)", 9);
            else if (N_monero_pstate->network_id == DEVNET)
                os_memmove(G_monero_vstate.ux_addr_info, "(devnet)", 8);
            break;

        case DISP_SUB:
            os_memmove(G_monero_vstate.ux_addr_type, "Subaddress", 10);
            // Copy these out because they are in a union with the ux_addr_info string
            unsigned int M = G_monero_vstate.disp_addr_M;
            unsigned int m = G_monero_vstate.disp_addr_m;
            snprintf(G_monero_vstate.ux_addr_info, 31, "Maj/min: %d/%d", M, m);
            break;

        case DISP_INTEGRATED:
            os_memmove(G_monero_vstate.ux_addr_type, "Integr. address", 15);
            // Copy the payment id into place *first*, before the label, because it overlaps with ux_addr_info
            os_memmove(G_monero_vstate.ux_addr_info + 9, G_monero_vstate.payment_id, 16);
            os_memmove(G_monero_vstate.ux_addr_info, "Pay. ID: ", 9);
            break;
    }

    loki_wallet_address(G_monero_vstate.ux_address, pub_view, pub_spend, is_subbadress, paymentID);
    ux_layout_paging_reset();
    ux_flow_init(0, ux_flow_pubaddr, NULL);
}

void ui_menu_pubaddr_display(void) {
    G_monero_vstate.disp_addr_mode = 0;
    G_monero_vstate.disp_addr_M = 0;
    G_monero_vstate.disp_addr_M = 0;
    ui_menu_any_pubaddr_display(G_monero_vstate.view_pub, G_monero_vstate.spend_pub, 0, NULL);
}

/* --------------------------------- MAIN UX --------------------------------- */

UX_STEP_CB(
    ux_menu_main_1_step,
    pnn,
    ui_menu_pubaddr_display(),
    {
        &C_icon_loki,
        "LOKI wallet",
        G_monero_vstate.ux_wallet_public_short_address
    });

UX_STEP_CB(
    ux_menu_main_2_step,
    pb,
    ux_menulist_init(G_ux.stack_count - 1, settings_submenu_getter, settings_submenu_selector),
    {&C_icon_coggle, "Settings"}
);

UX_STEP_NOCB(
    ux_menu_main_3_step,
    bn,
    {"Version", LOKI_VERSION_STRING}
);

UX_STEP_CB(
    ux_menu_main_4_step,
    pb,
    os_sched_exit(0),
    {&C_icon_dashboard_x, "Quit app"}
);

UX_FLOW(
    ux_flow_main,
    &ux_menu_main_1_step,
    &ux_menu_main_2_step,
    &ux_menu_main_3_step,
    &ux_menu_main_4_step,
    FLOW_LOOP
);

void ui_menu_main_display(void) {
    // reserve a display stack slot if none yet
    if (G_ux.stack_count == 0) {
        ux_stack_push();
    }
    ux_flow_init(0, ux_flow_main, NULL);
}
/* --- INIT --- */

void io_seproxyhal_display(const bagl_element_t* element) {
    io_seproxyhal_display_default((bagl_element_t*)element);
}
