#!/bin/bash
set -e

# Set pwd to script location
cd "$( dirname "$0" )"

# Bootstrap of the environment
if [ ! -f "../.bootstrap" ]
then
  ../bootstrap.sh
  touch ../.bootstrap
fi

# TODO: preserve state after calling bootstrap.sh
# Workaround: activate virtual environment here
source ../activate.sh

# Enter device folder of specified test suite
cd TESTS/"$1"/device; shift

# Build Mbed BLE app for all targets
for target in "$@"
do
  mbed compile -t GCC_ARM -m "$target"
  # TODO: support new tools
  # mbed-tools compile -t GCC_ARM -m $target
done
