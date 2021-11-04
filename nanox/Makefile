#*******************************************************************************
#   Ledger Nano S
#   (c) 2016-2019 Ledger
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.
#*******************************************************************************

-include ../Makefile.env
-include Makefile.env

ifneq ($(NANOX_SDK),)
BOLOS_SDK := $(NANOX_SDK)
endif

ifeq ($(BOLOS_SDK),)
BOLOS_SDK := $(shell pwd)/nanox-secure-sdk
endif

ifeq ($(BOLOS_SDK),)
$(error Environment variable BOLOS_SDK is not set)
endif

include $(BOLOS_SDK)/Makefile.defines

include ../Makefile.oxen

CFLAGS += -Oz -I$(shell pwd)/src
LDFLAGS += -Oz

# Work around buggy Makefile.defines not setting this:
AFLAGS += --target=armv6m-none-eabi

################
# Default rule #
################

all: default

############
# Platform #
############

DEFINES += IO_SEPROXYHAL_BUFFER_SIZE_B=300
DEFINES += BAGL_WIDTH=128 BAGL_HEIGHT=64
DEFINES += HAVE_BAGL_FONT_OPEN_SANS_REGULAR_11PX
DEFINES += HAVE_BAGL_FONT_OPEN_SANS_EXTRABOLD_11PX
DEFINES += HAVE_BAGL_FONT_OPEN_SANS_LIGHT_16PX
DEFINES += HAVE_BLE BLE_COMMAND_TIMEOUT_MS=2000
DEFINES += HAVE_BLE_APDU # basic ledger apdu transport over BLE
DEFINES += UNUSED\(x\)=\(void\)x

# import rules to compile glyphs(/pone)
include $(BOLOS_SDK)/Makefile.glyphs

### variables processed by the common makefile.rules of the SDK to grab source files and include dirs
APP_SOURCE_PATH  += ../src
SDK_SOURCE_PATH  += lib_stusb lib_stusb_impl lib_u2f lib_ux lib_blewbxx lib_blewbxx_impl

load: all
	python3 -m ledgerblue.loadApp $(APP_LOAD_PARAMS)

delete:
	python3 -m ledgerblue.deleteApp $(COMMON_DELETE_PARAMS)

# import generic rules from the user and SDK
-include Makefile.rules

CC := $(CLANGPATH)clang
AS := $(CC)
LD := $(CC)

include $(BOLOS_SDK)/Makefile.rules

#add dependency on custom makefile filename
dep/%.d: %.c Makefile


LDLIBS += -lc -lgcc
