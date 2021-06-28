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

BOLOS_SDK := $(shell pwd)/nanox-secure-sdk
ifeq ($(BOLOS_SDK),)
$(error Environment variable BOLOS_SDK is not set)
endif

# Respect a user-provided SYSROOT, but don't respect the SDK Makefile.defines one which does the
# wrong thing with the debian package arm-none-eabi compiler (appending -I/usr/include, which is
# completely wrong)
ifneq ($(SYSROOT),)
else ifneq ("","$(wildcard /usr/lib/arm-none-eabi)")
	override SYSROOT := /usr/lib/arm-none-eabi
endif
$(info SYSROOT=$(SYSROOT))

SCRIPT_LD := script.ld

include $(BOLOS_SDK)/Makefile.defines

include ../Makefile.oxen

CFLAGS += -Oz
LDFLAGS += -Oz

################
# Default rule #
################

all: default

############
# Platform #
############

DEFINES += IO_SEPROXYHAL_BUFFER_SIZE_B=300
DEFINES += BAGL_WIDTH=128 BAGL_HEIGHT=64
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
