#!/usr/bin/env sh

if which mint >/dev/null; then
  mint run mono0926/LicensePlist license-plist --output-path ${PRODUCT_NAME}/Application/Resources/Settings/Settings.bundle
else
  /opt/homebrew/bin/mint run mono0926/LicensePlist license-plist --output-path ${PRODUCT_NAME}/Application/Resources/Settings/Settings.bundle
fi
