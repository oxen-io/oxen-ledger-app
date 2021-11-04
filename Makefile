

.PHONY: all
# Set up the 'all' target to build both targets using the submoduled SDKs if not specifying an SDK,
# otherwise to build S/X based on which SDK was provided.
ifeq ($(BOLOS_SDK),)

all: nanox nanos

else ifneq ($(shell grep "TARGET_NANOS" "$(BOLOS_SDK)/include/bolos_target.h"),)

all: nanos

else ifneq ($(shell grep "TARGET_NANOX" "$(BOLOS_SDK)/include/bolos_target.h"),)

all: nanox

endif

.PHONY: nanos load_nanos delete_nanos docker-build docker-start
nanos:
	$(MAKE) -C nanos
	rm -rf bin
	cp -r nanos/bin .

load_nanos: nanos
	$(MAKE) -C nanos load

delete_nanos: nanos
	$(MAKE) -C nanos delete

.PHONY: nanox
nanox:
	$(MAKE) -C nanox
	rm -rf bin
	cp -r nanox/bin .

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
