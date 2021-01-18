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

-include Makefile.env
BOLOS_SDK := $(shell pwd)/nanos-secure-sdk
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

APPNAME = Oxen
#Loki /44'/240'
APP_LOAD_PARAMS=  --path "44'/240'" --curve secp256k1 $(COMMON_LOAD_PARAMS) --appFlags 0x40

ICONNAME = glyphs/icon_oxen.gif

APPVERSION_M=0
APPVERSION_N=9
APPVERSION_P=0

APPVERSION=$(APPVERSION_M).$(APPVERSION_N).$(APPVERSION_P)

CFLAGS += -Oz
LDFLAGS += -Oz

DEFINES   += OXEN_VERSION_MAJOR=$(APPVERSION_M) OXEN_VERSION_MINOR=$(APPVERSION_N) OXEN_VERSION_MICRO=$(APPVERSION_P)
DEFINES   += OXEN_VERSION_STRING=\"$(APPVERSION)\"

################
# Default rule #
################

all: default

############
# Platform #
############

DEFINES += OS_IO_SEPROXYHAL IO_SEPROXYHAL_BUFFER_SIZE_B=128
DEFINES += HAVE_BAGL HAVE_SPRINTF
DEFINES += HAVE_IO_USB HAVE_L4_USBLIB IO_USB_MAX_ENDPOINTS=4 IO_HID_EP_LENGTH=64 HAVE_USB_APDU
DEFINES += HAVE_LEGACY_PID

DEFINES += U2F_PROXY_MAGIC=\"OXEN\"
DEFINES += HAVE_IO_U2F HAVE_U2F
DEFINES += HAVE_UX_FLOW

# Enabling debug PRINTF
DEBUG = 0
ifneq ($(DEBUG),0)

  DEFINES += HAVE_PRINTF PRINTF=screen_printf
  DEFINES += PLINE="PRINTF(\"FILE:%s..LINE:%d\n\",__FILE__,__LINE__)"

  # Debug options
  DEFINES += DEBUG_HWDEVICE
  DEFINES += IODUMMYCRYPT  # or IONOCRYPT
  # testnet network by default:
  DEFINES += OXEN_BETA
else

  DEFINES += PRINTF\(...\)=
  DEFINES += PLINE\(...\)=

endif


CC := $(CLANGPATH)clang

AS := $(GCCPATH)arm-none-eabi-gcc
LD := $(GCCPATH)arm-none-eabi-gcc

LDLIBS   += -lm -lgcc -lc

# import rules to compile glyphs(/pone)
include $(BOLOS_SDK)/Makefile.glyphs

### variables processed by the common makefile.rules of the SDK to grab source files and include dirs
APP_SOURCE_PATH  += src
SDK_SOURCE_PATH  += lib_stusb lib_stusb_impl lib_u2f lib_ux

load: all
	python3 -m ledgerblue.loadApp $(APP_LOAD_PARAMS)

delete:
	python3 -m ledgerblue.deleteApp $(COMMON_DELETE_PARAMS)

# import generic rules from the user and SDK
-include Makefile.rules
include $(BOLOS_SDK)/Makefile.rules

#add dependency on custom makefile filename
dep/%.d: %.c Makefile

# Rewrite the bolos sdk script to increase the stack size slightly
script.ld: $(BOLOS_SDK)/script.ld Makefile
	sed -e 's/^STACK_SIZE\s*=\s*[0-9]\+;/STACK_SIZE = 712;/' $< >$@

listvariants:
	@echo VARIANTS COIN oxen 
