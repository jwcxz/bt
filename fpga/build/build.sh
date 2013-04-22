#!/bin/bash

set -o pipefail

basedir="`realpath $(dirname \"$0\")/..`"
echo "basedir: $basedir"

cd $basedir/bsc
source bluespec-setup
make full_clean compile link || exit 1

cd $basedir
./build/build-xilinx.sh
