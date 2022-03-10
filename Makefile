.PHONY: all

ifeq ($(BOLOS_SDK),)
$(error Environment variable BOLOS_SDK is not set)
endif

include $(BOLOS_SDK)/Makefile.defines

ifeq ($(TARGET_NAME),TARGET_NANOS)
    SCRIPT_LD := script.ld
    ifneq ($(SYSROOT),)
    else ifneq ("","$(wildcard /usr/lib/arm-none-eabi)")
        override SYSROOT := /usr/lib/arm-none-eabi
    endif
    $(info SYSROOT=$(SYSROOT))
else
    # Work around buggy Makefile.defines not setting this:
    AFLAGS += --target=armv6m-none-eabi
endif

ifeq ($(TARGET_NAME),TARGET_NANOS)
    ICONNAME = glyphs/nanos_app_oxen.gif
else
    ICONNAME = glyphs/nanox_app_oxen.gif
endif

include Makefile.oxen

all: default

ifeq ($(TARGET_NAME),TARGET_NANOX)
    DEFINES += HAVE_BLE BLE_COMMAND_TIMEOUT_MS=2000 HAVE_BLE_APDU
endif

ifeq ($(TARGET_NAME),TARGET_NANOS)
    DEFINES += IO_SEPROXYHAL_BUFFER_SIZE_B=128
else
    DEFINES += IO_SEPROXYHAL_BUFFER_SIZE_B=300
    DEFINES += BAGL_WIDTH=128 BAGL_HEIGHT=64
    DEFINES += HAVE_BAGL_FONT_OPEN_SANS_REGULAR_11PX
    DEFINES += HAVE_BAGL_FONT_OPEN_SANS_EXTRABOLD_11PX
    DEFINES += HAVE_BAGL_FONT_OPEN_SANS_LIGHT_16PX
    DEFINES += HAVE_BLE BLE_COMMAND_TIMEOUT_MS=2000
    DEFINES += HAVE_BLE_APDU # basic ledger apdu transport over BLE
    DEFINES += UNUSED\(x\)=\(void\)x
endif

CC := $(CLANGPATH)clang
ifeq ($(TARGET_NAME),TARGET_NANOS)
    AS := $(GCCPATH)arm-none-eabi-gcc
    LD := $(GCCPATH)arm-none-eabi-gcc
else
    AS := $(CC)
    LD := $(CC)
endif
CFLAGS += -Oz -I$(shell pwd)/src
LDFLAGS += -Oz
LDLIBS  += -lgcc -lc

# import generic rules from the user and SDK
-include Makefile.rules

# import rules to compile glyphs(/pone)
GLYPH_SRC_DIR=src
include $(BOLOS_SDK)/Makefile.glyphs

### variables processed by the common makefile.rules of the SDK to grab source files and include dirs
APP_SOURCE_PATH += src
SDK_SOURCE_PATH += lib_stusb lib_stusb_impl lib_ux lib_u2f
ifeq ($(TARGET_NAME),TARGET_NANOX)
    SDK_SOURCE_PATH += lib_blewbxx lib_blewbxx_impl
endif

load: all
	python3 -m ledgerblue.loadApp $(APP_LOAD_PARAMS)

load-offline: all
	python3 -m ledgerblue.loadApp $(APP_LOAD_PARAMS) --offline

delete:
	python3 -m ledgerblue.deleteApp $(COMMON_DELETE_PARAMS)

include $(BOLOS_SDK)/Makefile.rules

dep/%.d: %.c Makefile

listvariants:
	@echo VARIANTS COIN oxen


ifeq ($(TARGET_NAME),TARGET_NANOS)
# Rewrite the bolos sdk script to increase the stack size slightly
script.ld: $(BOLOS_SDK)/script.ld Makefile
	sed -e 's/^STACK_SIZE\s*=\s*[0-9]\+;/STACK_SIZE = 712;/' $< >$@
endif

docker-build:
	sudo docker build -t ledger-app-builder:latest .

docker-start:
	sudo docker run --rm -ti -v "$(realpath .):/app" ledger-app-builder:latest
