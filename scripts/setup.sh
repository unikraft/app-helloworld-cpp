#!/bin/bash

test ! -d "workdir" && echo "Cloning unikraft..." || true
test ! -d "workdir/unikraft" && git clone https://github.com/unikraft/unikraft workdir/unikraft || true
test ! -d "workdir/libs/libcxxabi" && git clone https://github.com/unikraft/lib-libcxxabi workdir/libs/libcxxabi || true
test ! -d "workdir/libs/libcxx" && git clone https://github.com/unikraft/lib-libcxx workdir/libs/libcxx || true
test ! -d "workdir/libs/compiler-rt" && git clone https://github.com/unikraft/lib-compiler-rt workdir/libs/compiler-rt || true
test ! -d "workdir/libs/libunwind" && git clone https://github.com/unikraft/lib-libunwind workdir/libs/libunwind || true
test ! -d "workdir/libs/musl" && git clone https://github.com/unikraft/lib-musl workdir/libs/musl || true
