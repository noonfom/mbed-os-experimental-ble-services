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

# Activate virtual environment
source ../activate.sh

cmake -S . -B cmake_build -GNinja -DCMAKE_BUILD_TYPE=Debug -DCOVERAGE:STRING=xml
cmake --build cmake_build

# Normal test
(cd cmake_build; ctest -V)
# valgrind
(cd cmake_build; ctest -D ExperimentalMemCheck)
# gcov (only show coverage of services)
gcovr --html=coverage.html  -f ".*cmake_build/services.*"
