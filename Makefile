


ifeq ($(BOLOS_SDK),)
$(error Environment variable BOLOS_SDK is not set)
endif

# this extracts target name
include $(BOLOS_SDK)/Makefile.defines


ifeq ($(TARGET_NAME),)
$(error Environment variable TARGET_NAME is not set)
endif

#Oxen /44'/240'
APP_LOAD_PARAMS  =  --path "44'/240'" --curve secp256k1
# OR MAYBE ? APP_LOAD_PARAMS=  --path "44'" --curve secp256k1 # based on boilerplate
ifeq ($(TARGET_NAME), TARGET_NANOX)
APP_LOAD_PARAMS+=--appFlags 0x200  # APPLICATION_FLAG_BOLOS_SETTINGS
else
APP_LOAD_PARAMS+=--appFlags 0x40
endif
APP_LOAD_PARAMS += $(COMMON_LOAD_PARAMS)

APPNAME = "Oxen"
APPVERSION_M = 0
APPVERSION_N = 10
APPVERSION_P = 2
APPVERSION   = "$(APPVERSION_M).$(APPVERSION_N).$(APPVERSION_P)"

ifeq ($(TARGET_NAME),TARGET_NANOS)
    ICONNAME = glyphs/nanos_app_oxen.gif
else
    ICONNAME = glyphs/nanox_app_oxen.gif
endif



# DEFINES   += $(OXEN_CONFIG) # what could this be?
DEFINES += OXEN_VERSION_MAJOR=$(APPVERSION_M) OXEN_VERSION_MINOR=$(APPVERSION_N) OXEN_VERSION_MICRO=$(APPVERSION_P)
DEFINES += OXEN_VERSION_STRING=\"$(APPVERSION)\"


################
# Default rule #
################
.PHONY: all

all: default

############
# Platform #
############
DEFINES += $(DEFINES_LIB)
DEFINES += APPNAME=\"$(APPNAME)\"
DEFINES += APPVERSION=\"$(APPVERSION)\"
DEFINES += MAJOR_VERSION=$(APPVERSION_M) MINOR_VERSION=$(APPVERSION_N) PATCH_VERSION=$(APPVERSION_P)
DEFINES += OS_IO_SEPROXYHAL
DEFINES += HAVE_BAGL HAVE_UX_FLOW HAVE_SPRINTF
DEFINES += HAVE_IO_USB HAVE_L4_USBLIB IO_USB_MAX_ENDPOINTS=6 IO_HID_EP_LENGTH=64 HAVE_USB_APDU
DEFINES += USB_SEGMENT_SIZE=64
DEFINES += BLE_SEGMENT_SIZE=32
DEFINES += U2F_PROXY_MAGIC=\"OXEN\"
DEFINES += HAVE_IO_U2F
DEFINES += HAVE_WEBUSB WEBUSB_URL_SIZE_B=0 WEBUSB_URL=""
DEFINES   += UNUSED\(x\)=\(void\)x

ifeq ($(TARGET_NAME),TARGET_NANOX)
    DEFINES 	+= HAVE_BLE BLE_COMMAND_TIMEOUT_MS=2000 HAVE_BLE_APDU
endif


ifeq ($(TARGET_NAME),TARGET_NANOS)
	DEFINES		+= IO_SEPROXYHAL_BUFFER_SIZE_B=128
else
	DEFINES		+= IO_SEPROXYHAL_BUFFER_SIZE_B=300
    DEFINES 	+= HAVE_GLO096
	DEFINES     += BAGL_WIDTH=128 BAGL_HEIGHT=64
    DEFINES 	+= HAVE_BAGL_ELLIPSIS
	DEFINES 	+= HAVE_BAGL_FONT_OPEN_SANS_REGULAR_11PX
	DEFINES 	+= HAVE_BAGL_FONT_OPEN_SANS_EXTRABOLD_11PX
	DEFINES 	+= HAVE_BAGL_FONT_OPEN_SANS_LIGHT_16PX
endif


DEBUG := 0

ifneq ($(DEBUG),0)
$(info "DEBUG IS set")
    DEFINES 	+= HAVE_PRINTF
	ifeq ($(TARGET_NAME),TARGET_NANOS)
		DEFINES += PRINTF=screen_printf
	else
		DEFINES += PRINTF=mcu_usb_printf
	endif

  	# Oxen Debug options
	DEFINES 	+= DEBUG_HWDEVICE
	DEFINES 	+= IODUMMYCRYPT  # or IONOCRYPT

	# Testnet network by default

	DEFINES 	+= OXEN_BETA
else
$(info DEBUG is NOT set)
	DEFINES   	+= PRINTF\(...\)=
endif


ifneq ($(BOLOS_ENV),)
$(info BOLOS_ENV=$(BOLOS_ENV))
CLANGPATH := $(BOLOS_ENV)/clang-arm-fropi/bin/
GCCPATH   := $(BOLOS_ENV)/gcc-arm-none-eabi-5_3-2016q1/bin/
else
$(info BOLOS_ENV is not set: falling back to CLANGPATH and GCCPATH)
endif

ifeq ($(CLANGPATH),)
$(info CLANGPATH is not set: clang will be used from PATH)
endif

ifeq ($(GCCPATH),)
$(info GCCPATH is not set: arm-none-eabi-* will be used from PATH)
endif

CC := $(CLANGPATH)clang
AS := $(GCCPATH)arm-none-eabi-gcc
LD := $(GCCPATH)arm-none-eabi-gcc
CFLAGS += -O3 -Os -I$(shell pwd)/src # was  -Oz -I$(shell pwd)/src
LDFLAGS += -O3 -Os
LDLIBS   += -lm -lgcc -lc

# import rules to compile glyphs(/pone)
include $(BOLOS_SDK)/Makefile.glyphs

### variables processed by the common makefile.rules of the SDK to grab source files and include dirs
APP_SOURCE_PATH  += src
SDK_SOURCE_PATH += lib_stusb lib_stusb_impl lib_ux lib_u2f # lib_u2f was existing for oxen and lib_ux was not there

ifeq ($(TARGET_NAME),TARGET_NANOX)
SDK_SOURCE_PATH  += lib_blewbxx lib_blewbxx_impl
endif


load: all
	python3 -m ledgerblue.loadApp $(APP_LOAD_PARAMS)

load-offline: all
	python3 -m ledgerblue.loadApp $(APP_LOAD_PARAMS) --offline
delete:
	python3 -m ledgerblue.deleteApp $(COMMON_DELETE_PARAMS)


include $(BOLOS_SDK)/Makefile.rules

#add dependency on custom makefile filename
dep/%.d: %.c Makefile

listvariants:
	@echo VARIANTS COIN oxen


# We probably don't need this as the nanox default is 1500 and nanos default is 1024
# ifeq ($(TARGET_NAME),TARGET_NANOS)
# Rewrite the bolos sdk script to increase the stack size slightly

# script.ld: $(BOLOS_SDK)/script.ld Makefile
# 	sed -e 's/^STACK_SIZE\s*=\s*[0-9]\+;/STACK_SIZE = 712;/' $< >$@
# endif

