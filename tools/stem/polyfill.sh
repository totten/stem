#!/usr/bin/env bash

## Provide some of the important variables/functions from civibuild.*.sh

CIVI_VERSION=${CIVI_VERSION:-master}
WEB_ROOT="$STEM_HOME"
CMS_ROOT="$STEM_HOME/web"
CMS_URL="http://$HTTPD_DOMAIN:$HTTPD_PORT"
SITE_CONFIG_DIR="$STEM_HOME/tools/stem"

CIVI_DB_DSN="mysql://root:@${LOCALHOST}:${MYSQLD_PORT}/civicrm?new_link=true"
TEST_DB_DSN="mysql://root:@${LOCALHOST}:${MYSQLD_PORT}/test?new_link=true"

function amp_install() {
  echo 'DROP DATABASE IF EXISTS civicrm' | mysql
  echo 'DROP DATABASE IF EXISTS test' | mysql
  echo 'CREATE DATABASE civicrm' | mysql
  echo 'CREATE DATABASE test' | mysql
}

function amp_uninstall() {
  echo 'DROP DATABASE IF EXISTS civicrm' | mysql
  echo 'DROP DATABASE IF EXISTS test' | mysql
}

function civicrm_install_cv() {
  declare -a installOpts=()
  installOpts+=("-m" "extras.adminUser=$ADMIN_USER" "-m" "extras.adminPass=$ADMIN_PASS" -m "extras.adminEmail=$ADMIN_EMAIL")
  if [ -z "$NO_SAMPLE_DATA" ]; then
    installOpts+=("-m" "loadGenerated=1")
  fi
  cv core:install -vv -f --cms-base-url="$CMS_URL" --db="$CIVI_DB_DSN" "${installOpts[@]}"


#  civicrm_update_domain

  ## Enable development
#  civicrm_make_setup_conf
#  civicrm_make_test_settings_php

}
