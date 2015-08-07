#!/bin/sh

export V8VER=4.4.63.25;
export V8DIR=v8-dev-$V8VER-`uname -s`-x64;
export CC=clang;
if [ `uname -s` != "Darwin" ]
then
  export CXX=clang++;
else
  export CXX="clang++ -stdlib=libc++";
fi
export LINK=$CXX;
export GYP_DEFINES="mac_deployment_target=10.7";

make -j4 x64.release library=shared soname_version=$V8VER i18nsupport=off &&
rm -rf $V8DIR;
mkdir -p $V8DIR/bin;
mkdir -p $V8DIR/lib;
mkdir -p $V8DIR/include;

## copy libraries
for filename in libv8_base.a libv8_libplatform.a libv8_nosnapshot.a libv8_snapshot.a libv8_libbase.a
do
  if [ -f "out/x64.release/obj.target/tools/gyp/$filename" ]
  then
    cp out/x64.release/obj.target/tools/gyp/$filename $V8DIR/lib/;
  elif [ -f "out/x64.release/$filename" ]
  then
    cp out/x64.release/$filename $V8DIR/lib/;
  else
    echo "The v8 static libraries are not found!!!";
    exit 1;
  fi
done

## copy libv8.so.VERSION
if [ -f "out/x64.release/lib.target/libv8.so.$V8VER" ]
then
  cp out/x64.release/lib.target/libv8.so.$V8VER $V8DIR/lib/;
elif [ -f "out/x64.release/libv8.so.$V8VER" ]
then
  cp out/x64.release/libv8.so.$V8VER $V8DIR/lib/;
else
  echo "The v8 shared library is not found!!!";
  exit 1;
fi
cd $V8DIR/lib && ln -sf libv8.so.$V8VER libv8.so && cd -;

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
