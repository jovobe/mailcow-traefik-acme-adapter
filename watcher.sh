#!/bin/bash

sleep 10s

while true; do
    inotifywait -e modify /traefik/acme.json
    bash /dumpcerts.sh /traefik/acme.json /dump-target
    cp "/dump-target/private/${DOMAIN}.key" /ssl-share/key.pem
    cp "/dump-target/certs/${DOMAIN}.crt" /ssl-share/cert.pem
    rm -rf /dump-target/*
    postfix_c=$(docker ps -qaf name=postfix-mailcow)
    dovecot_c=$(docker ps -qaf name=dovecot-mailcow)
    nginx_c=$(docker ps -qaf name=nginx-mailcow)
    docker restart ${postfix_c} ${dovecot_c} ${nginx_c}
done
