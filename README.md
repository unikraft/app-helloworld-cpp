# A "Hello, world!" C++ Application on Unikraft

This application starts a C++ Helloworld application with Unikraft.
Follow the instructions below to set up, configure, build and run Helloworld.

To get started immediately, you can use Unikraft's companion command-line companion tool, [`kraft`](https://github.com/unikraft/kraftkit).
Start by running the interactive installer:

```console
curl --proto '=https' --tlsv1.2 -sSf https://get.kraftkit.sh | sudo sh
```

Once installed, clone [this repository](https://github.com/unikraft/app-helloworld-cpp) and run `kraft build`:

```console
git clone https://github.com/unikraft/app-helloworld-cpp helloworld-cpp
cd helloworld-cpp/
kraft build
```

This will guide you through an interactive build process where you can select one of the available targets (architecture/platform combinations).
Otherwise, we recommend building for `qemu/x86_64` like so:

```console
kraft build --arch x86_64 --plat qemu
```

Once built, you can instantiate the unikernel via:

```console
kraft run
```

When left without any input flags, you'll be queried for the desired target architecture/platform.

## Work with the Basic Build & Run Toolchain (Advanced)

You can set up, configure, build and run the application from grounds up, without using the companion tool `kraft`.

### Quick Setup (aka TLDR)

For a quick setup, run the commands below.
Note that you still need to install the [requirements](#requirements).

For building and running everything for `x86_64`, follow the steps below:

```console
git clone https://github.com/unikraft/app-helloworld-cpp helloworld-cpp
cd helloworld-cpp/
git clone https://github.com/unikraft/unikraft .unikraft/unikraft
git clone https://github.com/unikraft/lib-libcxxabi .unikraft/libs/libcxxabi
git clone https://github.com/unikraft/lib-libcxx .unikraft/libs/libcxx
git clone https://github.com/unikraft/lib-compiler-rt .unikraft/libs/compiler-rt
git clone https://github.com/unikraft/lib-libunwind .unikraft/libs/libunwind
git clone https://github.com/unikraft/lib-musl .unikraft/libs/musl
UK_DEFCONFIG=$(pwd)/.config.helloworld-cpp-qemu-x86_64 make defconfig
make -j $(nproc)
/usr/bin/qemu-system-x86_64 -kernel build/helloworld-cpp_qemu-x86_64 -nographic
```

This will configure, build and run the `helloworld-cpp` application, resulting in a `Hello world!` message being printed, along with the Unikraft banner.

The same can be done for `AArch64`, by running the commands below:

```console
make properclean
UK_DEFCONFIG=$(pwd)/.config.helloworld-cpp-qemu-aarch64 make defconfig
make -j $(nproc)
/usr/bin/qemu-system-aarch64 -kernel build/helloworld-cpp_qemu-arm64 -nographic -machine virt -cpu cortex-a57
```

Similar to the `x86_64` build, this will result in a `Hello world!` message being printed.
Information about every step is detailed below.

### Requirements

In order to set up, configure, build and run helloworld C++ on Unikraft, the following packages are required:

* `build-essential` / `base-devel` / `@development-tools` (the meta-package that includes `make`, `gcc` and other development-related packages)
* `sudo`
* `flex`
* `bison`
* `git`
* `wget`
* `uuid-runtime`
* `qemu-system-x86`
* `qemu-system-arm`
* `qemu-kvm`
* `sgabios`
* `gcc-aarch64-linux-gnu`

GCC >= 8 is required to build helloworld C++ on Unikraft.

On Ubuntu/Debian or other `apt`-based distributions, run the following command to install the requirements:

```console
sudo apt install -y --no-install-recommends \
  build-essential \
  sudo \
  gcc-aarch64-linux-gnu \
  libncurses-dev \
  libyaml-dev \
  flex \
  bison \
  git \
  wget \
  uuid-runtime \
  qemu-kvm \
  qemu-system-x86 \
  qemu-system-arm \
  sgabios
```

### Set Up

The following repositories are required for helloworld C++:

* The application repository (this repository): [`app-helloworld-cpp`](https://github.com/unikraft/app-helloworld-cpp)
* The Unikraft core repository: [`unikraft`](https://github.com/unikraft/unikraft)
* Library repositories:
  * The C++ ABI library: [`lib-libcxxabi`](https://github.com/unikraft/lib-libcxxabi)
  * The C++ library: [`lib-libcxx`](https://github.com/unikraft/lib-libcxx)
  * The compiler runtime library: [`lib-libcxx`](https://github.com/unikraft/lib-compiler-rt)
  * The bunwind library: [`lib-libunwind`](https://github.com/unikraft/lib-libunwind)
  * The standard C library: [`lib-musl`](https://github.com/unikraft/lib-musl)

Follow the steps below for the setup:

  1. First clone the [`app-helloworld-cpp` repository](https://github.com/unikraft/app-helloworld-cpp) in the `helloworld-cpp/` directory:

     ```console
     git clone https://github.com/unikraft/app-helloworld-cpp helloworld-cpp
     ```

     Enter the `helloworld-cpp/` directory:

     ```console
     cd helloworld-cpp/

     ls -F
     ```

     You will see the contents of the repository:

     ```text
     .config.helloworld-cpp-fc-x86_64  .config.helloworld-cpp-qemu-aarch64  .config.helloworld-cpp-qemu-x86_64  helloworld-cpp-fc-x86_64.json  kraft.yaml  Makefile  Makefile.uk  README.md [...]
     ```

  1. While inside the `helloworld-cpp/` directory, create the `.unikraft/` directory:

     ```console
     mkdir .unikraft
     ```

     Enter the `.unikraft/` directory:

     ```console
     cd .unikraft/
     ```

  1. While inside the `.unikraft` directory, clone the [`unikraft` repository](https://github.com/unikraft/unikraft):

     ```console
     git clone https://github.com/unikraft/unikraft unikraft
     ```

  1. While inside the `.unikraft/` directory, clone the library repositories in the `libs/` directory:

     ```console
     git clone https://github.com/unikraft/lib-libcxxabi libs/libcxxabi

     git clone https://github.com/unikraft/lib-libcxx libs/libcxx

     git clone https://github.com/unikraft/lib-compiler-rt libs/compiler-rt

     git clone https://github.com/unikraft/lib-libunwind libs/libunwind

     git clone https://github.com/unikraft/lib-musl libs/musl
     ```

  1. Get back to the application directory:

     ```console
     cd ../
     ```

     Use the `tree` command to inspect the contents of the `.unikraft/` directory.
     It should print something like this:

     ```console
     tree -F -L 2 .unikraft/
     ```

     You should see the following layout:

     ```text
     .unikraft/
     |-- libs/
     |   |-- compiler-rt/
     |   |-- libcxx/
     |   |-- libcxxabi/
     |   |-- libunwind/
     |   `-- musl/
     `-- unikraft/
         |-- ADOPTERS.md
         |-- CONTRIBUTING.md
         |-- COPYING.md
         |-- Config.uk
         |-- Makefile
         |-- Makefile.uk
         |-- README.md
         |-- arch/
         |-- include/
         |-- lib/
         |-- plat/
         |-- support/
         `-- version.mk

     13 directories, 8 files
     ```

### Configure

Configuring, building and running a Unikraft application depends on our choice of platform and architecture.
Currently, supported platforms are QEMU (KVM), Firecaker (KVM), Xen and linuxu.
QEMU (KVM) is known to be working, so we focus on that.

Supported architectures are x86_64 and AArch64.

Use the corresponding the configuration files (`config-...`), according to your choice of platform and architecture.

#### QEMU x86_64

Use the `.config.helloworld-cpp-qemu-x86_64` configuration file together with `make defconfig` to create the configuration file:

```console
UK_DEFCONFIG=$(pwd)/.config.helloworld-cpp-qemu-x86_64 make defconfig
```

This results in the creation of the `.config` file:

```console
ls .config
.config
```

The `.config` file will be used in the build step.

#### QEMU AArch64

Use the `.config.helloworld-cpp-qemu-aarch64` configuration file together with `make defconfig` to create the configuration file:

```console
UK_DEFCONFIG=$(pwd)/.config.helloworld-cpp-qemu-aarch64 make defconfig
```

Similar to the x86_64 configuration, this results in the creation of the `.config` file that will be used in the build step.

### Build

Building uses as input the `.config` file from above, and results in a unikernel image as output.
The unikernel output image, together with intermediary build files, are stored in the `build/` directory.

#### Clean Up

Before starting a build on a different platform or architecture, you must clean up the build output.
This may also be required in case of a new configuration.

Cleaning up is done with 3 possible commands:

* `make clean`: cleans all actual build output files (binary files, including the unikernel image)
* `make properclean`: removes the entire `build/` directory
* `make distclean`: removes the entire `build/` directory **and** the `.config` file

Typically, you would use `make properclean` to remove all build artifacts, but keep the configuration file.

#### QEMU x86_64

Building for QEMU x86_64 assumes you did the QEMU x86_64 configuration step above.
Build the Unikraft helloworld C++ image for QEMU AArch64 by using the command below:

```console
make -j $(nproc)
```

You will see a list of all the files generated by the build system:

```text
[...]
  LD      helloworld-cpp_qemu-x86_64.dbg
  UKBI    helloworld-cpp_qemu-x86_64.dbg.bootinfo
  SCSTRIP helloworld-cpp_qemu-x86_64
  GZ      helloworld-cpp_qemu-x86_64.gz
make[1]: Leaving directory '/media/stefan/projects/unikraft/scripts/workdir/apps/app-helloworld-cpp/.unikraft/unikraft'
```

At the end of the build command, the `helloworld-cpp_qemu-x86_64` unikernel image is generated.
This image is to be used in the run step.

#### QEMU AArch64

If you had configured and build a unikernel image for another platform or architecture (such as x86_64) before, then:

1. Do a cleanup step with `make properclean`.

1. Configure for QEMU AAarch64, as shown above.

1. Follow the instructions below to build for QEMU AArch64.

Building for QEMU AArch64 assumes you did the QEMU AArch64 configuration step above.
Build the Unikraft helloworld C++ image for QEMU AArch64 by using the same command as for x86_64:

```console
make -j $(nproc)
```

Same as in the x86_64 setup, you will see a list of all the files generated by the build system:

```text
[...]
  LD      helloworld-cpp_qemu-arm64.dbg
  UKBI    helloworld-cpp_qemu-arm64.dbg.bootinfo
  SCSTRIP helloworld-cpp_qemu-arm64
  GZ      helloworld-cpp_qemu-arm64.gz
make[1]: Leaving directory '/media/stefan/projects/unikraft/scripts/workdir/apps/app-helloworld-cpp/.unikraft/unikraft'
```

Similarly to x86_64, at the end of the build command, the `helloworld-cpp_qemu-arm64` unikernel image is generated.
This image is to be used in the run step.

### Run

Run the resulting image using `qemu-system`.

#### QEMU x86_64

To run the QEMU x86_64 build, use:

```console
/usr/bin/qemu-system-x86_64 -kernel build/helloworld-cpp_qemu-x86_64 -nographic
```

You will be met by the Unikraft banner, along with the `Hello, world!` message:

```text
qemu-system-x86_64: warning: TCG doesn't support requested feature: CPUID.01H:ECX.vmx [bit 5]
Powered by
o.   .o       _ _               __ _
Oo   Oo  ___ (_) | __ __  __ _ ' _) :_
oO   oO ' _ `| | |/ /  _)' _` | |_|  _)
oOo oOO| | | | |   (| | | (_) |  _) :_
 OoOoO ._, ._:_:_,\_._,  .__,_:_, \___)
                  Atlas 0.13.1~5eb820bd
Hello world!
```

#### QEMU AArch64

To run the AArch64 build, use:

```console
/usr/bin/qemu-system-aarch64 -kernel build/helloworld-cpp_qemu-arm64 -nographic -machine virt -cpu cortex-a57
```

Same as running on x86_64, the application will start:

```
Powered by
o.   .o       _ _               __ _
Oo   Oo  ___ (_) | __ __  __ _ ' _) :_
oO   oO ' _ `| | |/ /  _)' _` | |_|  _)
oOo oOO| | | | |   (| | | (_) |  _) :_
 OoOoO ._, ._:_:_,\_._,  .__,_:_, \___)
                  Atlas 0.13.1~5eb820bd
Hello world!
```

### Building and Running with Firecracker

[Firecracker](https://firecracker-microvm.github.io/) is a lightweight VMM (*virtual machine manager*) that can be used as more efficient alternative to QEMU.

Configure and build commands are similar to a QEMU-based build with an initrd-based filesystem:

```console
make distclean
UK_DEFCONFIG=$(pwd)/.config.helloworld-cpp-fc-x86_64 make defconfig
make -j $(nproc)
```

To use Firecraker, you need to download a [Firecracker release](https://github.com/firecracker-microvm/firecracker/releases).
You can use the commands below to make the `firecracker-x86_64` executable from release v1.4.0 available globally in the command line:

```console
cd /tmp
wget https://github.com/firecracker-microvm/firecracker/releases/download/v1.4.0/firecracker-v1.4.0-x86_64.tgz
tar xzf firecracker-v1.4.0-x86_64.tgz
sudo cp release-v1.4.0-x86_64/firecracker-v1.4.0-x86_64 /usr/local/bin/firecracker-x86_64
```

To run a unikernel image, you need to configure a JSON file.
This is the `helloworld-cpp-fc-x86_64.json` file.
Pass this file to the `firecracker-x86_64` command to run the Unikernel instance:

```console
rm /tmp/firecracker.socket
firecracker-x86_64 --api-sock /tmp/firecracker.socket --config-file helloworld-cpp-fc-x86_64.json
```

Same as running with QEMU, the application will start:

```text
Powered by
o.   .o       _ _               __ _
Oo   Oo  ___ (_) | __ __  __ _ ' _) :_
oO   oO ' _ `| | |/ /  _)' _` | |_|  _)
oOo oOO| | | | |   (| | | (_) |  _) :_
 OoOoO ._, ._:_:_,\_._,  .__,_:_, \___)
                  Atlas 0.13.1~2f2ecc9f
Hello world!
```
