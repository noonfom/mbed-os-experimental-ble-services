#!/bin/bash
set -e

# Load symlink script and export path to ROOT variable
source "$(dirname "$0")"/symlink.sh

# Enter the test folder
cd "$ROOT"/tests

# We need stubs from mbed-os
if [ -d "mbed-os" ]
then
    echo "Using existing mbed-os"
else
    # git clone https://github.com/ARMmbed/mbed-os.git
    # until it's not merged we use my branch
    git clone --depth 1 https://github.com/ARMmbed/mbed-os.git -b feature-bluetooth-unit-test
fi

# Add symbolic links
cd "$ROOT"
symlink "tests/mbed-os" "tests/TESTS/LinkLoss/device/mbed-os"
symlink "services/LinkLoss" "tests/TESTS/LinkLoss/device/LinkLoss"

# Enter the integration testing folder
cd ./tests/TESTS

# Create virtual environment
if [ -d "venv" ]
then
  echo "Using existing virtual environment"
else
  mkdir venv
  # On Windows, the Python 3 executable is called 'python'
  if windows; then
    python  -m virtualenv venv
  else
    python3 -m virtualenv venv
  fi
fi

# Activate virtual environment
source ../../activate.sh

# Install mbed-os requirements
pip install -r ../mbed-os/requirements.txt

# Install testing requirements
pip install -r requirements.txt