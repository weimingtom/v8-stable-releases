#!/bin/sh

V8VER=4.4.63.25;
V8DIR=v8-dev-$V8VER-`uname -s`-x64;
CC=clang;
CXX=clang++;
LINK=clang++;
make x64.release library=shared soname_version=$V8VER i18nsupport=off &&
mkdir -p $V8DIR/lib;
mkdir -p $V8DIR/include;
cp out/x64.release/lib.target/libv8.so.$V8VER $V8DIR/lib/;
cp include/v8*.h $V8DIR/include/;
cp -r include/libplatform $V8DIR/include/;
tar -jvcf $V8DIR.tbz $V8DIR;
rm -rf $V8DIR;
