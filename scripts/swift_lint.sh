#!/usr/bin/env sh

if which mint >/dev/null; then
  mint run SwiftLint swiftlint
else
  /opt/homebrew/bin/mint run SwiftLint swiftlint
fi
