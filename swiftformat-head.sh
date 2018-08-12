#!/bin/bash
# This script will swift format all files changed in the commit pointed to by HEAD

SwiftFormatFilePath="~/code/iOS/RMessage/.swiftformat"

git diff-tree --no-commit-id --name-only -r HEAD | grep -e '\(.*\).swift$' | while read line; do
  swiftformat --config $SwiftFormatFilePath $line "${line}";
  git add "$line";
done
