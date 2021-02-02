# Oxen Ledger App

Oxen wallet application for Ledger Nano S and Nano X.

Unlike Ledger apps such as Bitcoin, the Oxen wallet requires considerably more data storage for
transactions and, as such, cannot be stored on the Ledger device itself because of its limited
storage.  Instead the Oxen Ledger app works in conjunction with an Oxen wallet by offloading all
encryption to the Ledger.  This allows keeping all wallet keys on the Ledger itself, thus ensuring
that your wallet data files are useless without also having the Ledger device.

## Installation via Ledger Manager

Unfortunately, the only way to securely use the Ledger wallet with Oxen is by installing it through
the Ledger Manager.  While it *is* possible to load a self-compiled version of the wallet app, it
cannot properly encrypt values that are sent to the companion app (i.e. the Oxen Wallet) because
Ledger refuses to allow on-device encryption for externally compiled applications (c.f.
https://github.com/LedgerHQ/app-monero/issues/53).

Compiling it yourself thus requires that you build both the ledger oxen app and the oxen wallet in
debug mode: for the ledger app by using `make DEBUG=1`, and for the oxen wallet by invoke cmake with
the `-DHWDEVICE_DEBUG=ON` option.  Be aware that this mode should only be used for testing and
should be considered insecure as programs (such as the Oxen wallet) running on the host system are
able to access some unencrypted private keys.

## Prerequisites

### Device Firmware

For a Nano S, we also require that the device is running firmware version 1.6 (or newer).  For a
Nano X there is no hard version requirement, but be advised that we will generally only explicitly
support the latest firmware version.

### Compilers

Building this requires a reasonably recent linux distribution; the instructions below should work on
Debian 10+ or Ubuntu 20.04+.  (Some additional instructions below for making it work on other
systems).

The build requires clang and arm cross-compiling tools and headers.  On recent Debian/Ubuntu:

    sudo apt install clang gcc-arm-none-eabi libnewlib-arm-none-eabi

> Note that this must install clang 7 or higher.  If you are installing on an older distribution,
> such as Ubuntu 18.04, you can instead install one of the newer clang packages such as `clang-10`,
> and then run `export CC=clang-10` before you compile, below.  If you are compiling on something
> much older or not debian based see [Getting
> Started](https://ledger.readthedocs.io/en/latest/userspace/getting_started.html) from the Ledger
> documentation.

### Python libs

You'll also need some Python libraries: pil to convert the icons into embedded source code, and
ledgerblue for dealing with some Ledger-specific code and device interaction.  You can install with:

    sudo apt install python3-pil python3-hid python3-protobuf python3-pycryptodome python3-future python3-pip 
    pip3 install ledgerblue

(The first line installs some of the dependencies already available in Debian/Ubuntu repositories;
the second line will install ledgerblue plus some other unpackaged Python dependencies).

Note that actual device loading may require some additional one-time setup: see
[ledgerblue](https://pypi.org/project/ledgerblue/) for details.  Generally this one-time setup seems
to be the same as that required by Ledger Live, so if you have that working on the Linux system you
are probably already set up.

To test that things are working, plug in your Ledger, enter your PIN, and then run one of the
following from a terminal:

    # Nano S:
    python -m ledgerblue.checkGenuineRemote --targetId 0x31100004
    # Nano X:
    python -m ledgerblue.checkGenuineRemote --targetId 0x33000004

Your Ledger will prompt you to "Allow Ledger Manager" to allow the request; when you accept you
should see (back in the terminal):

    Product is genuine

If you get an error instead then check the above ledgerblue link for details on getting the Python
module properly set up.

### Ledger Nano S SDK

The Ledger Nano SDK is included in this repository as a submodule; make sure you have it cloned and
updated using:

    git submodule update --init --recursive

If you don't want to use the submodule for some reason, you can download the SDK somewhat and set
the `BOLOS_SDK` environment variable to the path to the SDK:

    export BOLOS_SDK=/path/to/extracted/sdk

## Compilation

Compile the code using:

    make

## Loading the app onto your Ledger Nano S

Assuming the compilation above finished without error, you can now install onto your Ledger.  Note
that installing this way is obviously not signed by Ledger, and so will be considered "not
genuine".  It still works, but presents a nag screen when you start it.

First make sure your Nano S is unlocked and at the main menu (where apps are listed).  Now run:

    make load

The Ledger will prompt you about this "unsafe manager" trying to load an app, since this is not an
officially Ledger-signed app or manager.  Select "Allow" and let it continue.

If you already have the Oxen app installed, you'll first be prompted to remove the existing one;
select "Perform deletion" to continue.  (This will not affect your funds).

Next you'll be prompted to "Install app Oxen".  Choose "Perform installation", and then enter your
code.  Once this completes you have the custom built Oxen wallet app installed!

To remove the app from your Ledger:

    make delete

## Useful links

* Oxen client CLI - https://github.com/oxen-io/oxen-core/releases

* Ledger's developer documentation - [https://ledger.readthedocs.io](https://ledger.readthedocs.io)
