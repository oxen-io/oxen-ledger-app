.PHONY: all

include Makefile.oxen

ifeq ($(BOLOS_SDK),)
.PHONY: nanos nanos_bin load_nanos delete_nanos docker-build docker-start
nanos:
	$(MAKE) -C nanos

nanos_bin: nanos
	rm -rf bin
	cp -r nanos/bin .

load_nanos: nanos
	$(MAKE) -C nanos load

delete_nanos: nanos
	$(MAKE) -C nanos delete

.PHONY: nanox nanox_bin
nanox:
	$(MAKE) -C nanox

nanox_bin: nanox
	rm -rf bin
	cp -r nanox/bin .
else

ifneq ($(shell grep "TARGET_NANOS" "$(BOLOS_SDK)/include/bolos_target.h"),)
TARGET_DIRECTORY:=nanos
else
TARGET_DIRECTORY:=nanox
endif

$(info $(TARGET_DIRECTORY))

default:
	$(MAKE) -C $(TARGET_DIRECTORY)
%:
	$(info "Calling app Makefile for target $@")
	COIN=$(COIN) $(MAKE) -C $(TARGET_DIRECTORY) $@
endif


.PHONY: clean
clean:
	$(MAKE) -C nanos clean
	$(MAKE) -C nanox clean
	rm -rf bin

listvariants:
	@echo VARIANTS COIN oxen

docker-build:
	sudo docker build -t ledger-app-builder:latest .

docker-start:
	sudo docker run --rm -ti -v "$(realpath .):/app" ledger-app-builder:latest
