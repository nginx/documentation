#!/bin/bash

# Prefix for agent certificates and keys
nginx=agent

make_ca() {
    echo "Creating CA certificate and key"
    openssl req \
      -new \
      -newkey rsa:4096 \
      -days 365 \
      -sha256 \
      -nodes \
      -x509 \
      -keyout ca.key \
      -out ca.crt \
      -config ca.cnf \
      -extensions v3_req
    #openssl x509 -in ca.crt -noout -text
}

make_int() {
    echo "Creating Intermediate CA certificate and key"
    openssl req \
      -new \
      -newkey rsa:4096 \
      -nodes \
      -keyout ca_int.key \
      -out ca_int.csr \
      -config ca-intermediate.cnf \
      -extensions v3_req
    openssl req -in ca_int.csr -noout -verify
    openssl x509 \
      -req \
      -sha256 \
      -days 365 \
      -CA ca.crt \
      -CAkey ca.key \
      -CAcreateserial \
      -in ca_int.csr \
      -out ca_int.crt \
      -extfile ca-intermediate.cnf \
      -extensions v3_req
    openssl verify -CAfile ca.crt ca_int.crt
    echo "Creating CA chain"
    cat ca_int.crt ca.crt > ca.pem
}

make_server() {
    echo "Creating nginx-manger certificate and key"
    openssl req \
      -new \
      -nodes \
      -keyout server.key \
      -out server.csr \
      -config server.cnf \
      -extensions v3_req
    openssl req -in server.csr -noout -verify
    openssl x509 \
      -req \
      -days 365 \
      -sha256 \
      -CA ca_int.crt \
      -CAkey ca_int.key \
      -CAcreateserial \
      -in server.csr \
      -out server.crt \
      -extfile server.cnf \
      -extensions v3_req
    openssl verify -CAfile ca.pem server.crt
}

make_agent() {
    echo "Creating Agent certificate and key"
    openssl req \
        -new \
        -newkey rsa:2048 \
        -nodes \
        -keyout agent.key \
        -out agent.csr \
        -config agent.cnf \
        -extensions v3_req
    openssl req -in agent.csr -noout -verify
    openssl x509 \
        -req \
        -days 365 \
        -CA ca_int.crt \
        -CAkey ca_int.key \
        -CAcreateserial \
        -in agent.csr \
        -out agent.crt \
        -extfile agent.cnf \
        -extensions v3_req
    openssl verify -CAfile ca.pem agent.crt
    for os in {1..10}
    do
      openssl req \
        -new \
        -newkey rsa:2048 \
        -nodes \
        -keyout $nginx-"$os".key \
        -out $nginx-"$os".csr \
        -config agent.cnf \
        -extensions v3_req
      openssl req -in $nginx-"$os".csr -noout -verify
      openssl x509 \
        -req \
        -days 365 \
        -sha256 \
        -CA ca_int.crt \
        -CAkey ca_int.key \
        -CAcreateserial \
        -in $nginx-"$os".csr \
        -out $nginx-"$os".crt \
        -extfile agent.cnf \
        -extensions v3_req
      openssl verify -CAfile ca.pem $nginx-"$os".crt
    done
}

# MAIN
make_ca
make_int
make_server
make_agent