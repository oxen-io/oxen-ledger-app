ifeq ($(BOLOS_SDK),)
$(error Environment variable BOLOS_SDK is not set)
endif

include $(BOLOS_SDK)/Makefile.defines

ICONNAME = glyphs/nanox_app_oxen.gif
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
GLYPH_SRC_DIR=../src
include $(BOLOS_SDK)/Makefile.glyphs

### variables processed by the common makefile.rules of the SDK to grab source files and include dirs
APP_SOURCE_PATH  += ../src
SDK_SOURCE_PATH  += lib_stusb lib_stusb_impl lib_u2f lib_ux lib_blewbxx lib_blewbxx_impl

load: all
	python3 -m ledgerblue.loadApp $(APP_LOAD_PARAMS)

delete:
	python3 -m ledgerblue.deleteApp $(COMMON_DELETE_PARAMS)

listvariants:
	@echo VARIANTS COIN oxen

# import generic rules from the user and SDK
-include Makefile.rules

CC := $(CLANGPATH)clang
AS := $(CC)
LD := $(CC)

include $(BOLOS_SDK)/Makefile.rules

#add dependency on custom makefile filename
dep/%.d: %.c Makefile


LDLIBS += -lc -lgcc
