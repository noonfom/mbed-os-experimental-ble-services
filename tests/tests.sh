#!/bin/bash
set -e

usage() {
  cat <<HELP_USAGE

  $0 -s <service> -t <toolchain> -m <target>

  -s Service test suite
  -t Compile toolchain
  -m Compile target
HELP_USAGE
}

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

# Parse options
while getopts "s:t:m:h" opt
do
  case "$opt" in
   s)
     service="$OPTARG"
     ;;
   t)
     toolchain="$OPTARG"
     ;;
   m)
     target="$OPTARG"
     ;;
   h)
     usage
     exit 1
     ;;
  \?)
    echo "Invalid option: -$OPTARG" 1>&2
    exit 1
    ;;
  : )
    echo "Invalid option: -$OPTARG requires an argument" 1>&2
    exit 1
    ;;
  esac
done

# Verify that all arguments exist
if [[ (-z "$toolchain") ||  (-z "$target") || (-z "$service") ]]
then
  echo "No arguments supplied." 1>&2
  exit 1
fi

# Enter device folder for specified service
cd TESTS/"$service"/device

# Build Mbed BLE app
mbed compile -t "$toolchain" -m "$target"
# TODO: support new tools
# mbed-tools compile -t GCC_ARM -m $target

exit 0
