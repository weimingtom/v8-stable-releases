#!/bin/sh

export V8VER=4.4.63.25;
export V8DIR=v8-dev-$V8VER-`uname -s`-x64;
export CC=clang;
export CXX=clang++;
export LINK=clang++;

make -j4 x64.release library=shared soname_version=$V8VER i18nsupport=off &&
rm -rf $V8DIR;
mkdir -p $V8DIR/bin;
mkdir -p $V8DIR/lib;
mkdir -p $V8DIR/include;

## copy platform library
if [ -f "out/x64.release/obj.target/tools/gyp/libv8_libplatform.a" ]
then
  cp out/x64.release/obj.target/tools/gyp/libv8_libplatform.a $V8DIR/lib/;
elif [ -f "out/x64.release/libv8_libplatform.a" ]
then
  cp out/x64.release/libv8_libplatform.a $V8DIR/lib/;
else
  echo "The v8 platform static library not found!!!";
  exit 1;
fi

## copy libv8.so.VERSION
if [ -f "out/x64.release/lib.target/libv8.so.$V8VER" ]
then
  cp out/x64.release/lib.target/libv8.so.$V8VER $V8DIR/lib/;
elif [ -f "out/x64.release/libv8.so.$V8VER" ]
then
  cp out/x64.release/libv8.so.$V8VER $V8DIR/lib/;
else
  echo "The v8 shared library not found!!!";
  exit 1;
fi
ln -sr $V8DIR/lib/libv8.so.$V8VER $V8DIR/lib/libv8.so;

## others
cp out/x64.release/d8 $V8DIR/bin/;
cp out/x64.release/mksnapshot $V8DIR/bin/;
cp out/x64.release/process $V8DIR/bin/;
cp out/x64.release/shell $V8DIR/bin/;
cp include/v8*.h $V8DIR/include/;
cp -r include/libplatform $V8DIR/include/;
rm -f $V8DIR.tbz;
tar --exclude=.* -jvcf $V8DIR.tbz $V8DIR;
rm -rf $V8DIR;
