#!/bin/sh

if test -d "/opt/homebrew/bin/"; then
  PATH="/opt/homebrew/bin/:${PATH}"
elif test -d "/usr/local/bin/"; then
  PATH="/usr/local/bin/:${PATH}"
fi

# Please install SwiftFormat before executing this script
swiftformat . --config .swiftformat --exclude Carthage
