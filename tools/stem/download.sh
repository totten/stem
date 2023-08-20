#!/usr/bin/env bash

## download.sh -- Download CiviCRM core and configure it for standalone development

###############################################################################

mkdir -p "$WEB_ROOT" "$WEB_ROOT/web" "$WEB_ROOT/web/upload" "$WEB_ROOT/data"

pushd "$WEB_ROOT"
  if [ ! -d "web/core" ]; then
    git clone https://github.com/civicrm/civicrm-core.git      -b "$CIVI_VERSION" "web/core"
  fi

  if [ ! -d "$WEB_ROOT/web/core/packages" ]; then
    git clone https://github.com/civicrm/civicrm-packages.git  -b "$CIVI_VERSION" "web/core/packages"
  fi
popd

pushd "$WEB_ROOT/web/core"
  composer install
popd
