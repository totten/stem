[global]
pid = {{LOCO_SVC_VAR}}/php-fpm.pid
error_log = {{LOCO_SVC_VAR}}/php-fpm.log
; include=/etc/php5/fpm/pool.d/*.conf
daemonize = no

[www]
; user = www-data
; group = www-data
listen = {{LOCALHOST}}:{{PHPFPM_PORT}}
; listen.owner = www-data
; listen.group = www-data
pm = dynamic
pm.max_children = 5
pm.start_servers = 2
pm.min_spare_servers = 1
pm.max_spare_servers = 3
chdir = /
env[MAIL_SMTP_PORT] = $MAIL_SMTP_PORT
env[NIX_SSL_CERT_FILE] = $NIX_SSL_CERT_FILE
env[XDEBUG_MODE] = $XDEBUG_MODE
env[XDEBUG_PORT] = $XDEBUG_PORT
env[XDEBUG_CONFIG] = $XDEBUG_CONFIG
