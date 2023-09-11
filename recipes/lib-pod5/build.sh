#!/bin/bash
set -ex

$PYTHON -m setuptools_scm
$PYTHON -m pod5_make_version

mkdir build
cd build

# conan apparently requires actual binary names like gcc, which is really unfortunate
ln -s $CC $PREFIX/bin/gcc
ln -s $CXX $PREFIX/bin/g++
export CC=$PREFIX/bin/gcc
export CXX=$PREFIX/bin/g++

conan install --build=missing -s build_type=Release -s compiler=$PREFIX/bin/gxx .. 
cmake -DENABLE_CONAN=ON -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=${PREFIX} ..
make -j

unlink $PREFIX/bin/gcc
unlink $PREFIX/bin/g++
