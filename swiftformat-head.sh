#!/bin/bash
# This script will swift format all files changed in the commit pointed to by HEAD

if test -d "/opt/homebrew/bin/"; then
  PATH="/opt/homebrew/bin/:${PATH}"
elif test -d "/usr/local/bin/"; then
  PATH="/usr/local/bin/:${PATH}"
fi

SwiftFormatFilePath="~/code/iOS/RMessage/.swiftformat"

git diff-tree --no-commit-id --name-only -r HEAD | grep -e '\(.*\).swift$' | while read line; do
  swiftformat --config $SwiftFormatFilePath $line "${line}";
  git add "$line";
done
