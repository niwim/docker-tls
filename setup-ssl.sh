#!/bin/bash

# Set the directory where certificates are supposed to be found
CERT_DIR="${PWD}/cert/server"
CA_CERT_DIR="${PWD}/cert/ca"

# Config file for openssl
OPENSSL_CONFIG_FILE="${PWD}/openssl.cnf"

# Set the paths to the certificate and key files for CA
CA_KEY_FILE="$CA_CERT_DIR/ca.key"
CA_CERT_FILE="$CA_CERT_DIR/ca.pem"

# Set the paths to the certificate and key files
CERT_FILE="$CERT_DIR/cert.pem"
KEY_FILE="$CERT_DIR/key.pem"
CSR_FILE="$CERT_DIR/server.csr"

# Check if both the certificate and key files exist for CA
if [[ -f "$CA_CERT_FILE" && -f "$CA_KEY_FILE" ]]; then
    echo "Certificate and key files for CA found. No need to generate new ones."
else
    echo "Certificate or key file for CA not found. Generating new ones..."
    
    # Ensure the certificate directory exists
    mkdir -p "$CA_CERT_DIR"

    # Generate a private key for your CA
    openssl genpkey -algorithm RSA -out $CA_KEY_FILE

    # Use the private key to create a new CA certificate
    openssl req -x509 -new -nodes -key $CA_KEY_FILE -sha256 -days 1825 -out $CA_CERT_FILE -subj "/C=SE/ST=Stockholm/L=Stockholm/O=NIWIM/OU=IT Department/CN=My CA"

    echo "New CA certificate and key have been generated."
fi

# Check if both the certificate and key files exist
if [[ -f "$CERT_FILE" && -f "$KEY_FILE" ]]; then
    echo "Certificate and key files found. No need to generate new ones."
else
    echo "Certificate or key file not found. Generating new ones..."
    
    # Ensure the certificate directory exists
    mkdir -p "$CERT_DIR"

    # Generate a private key for your server
    openssl genpkey -algorithm RSA -out $KEY_FILE   

    # Create a configuration file for the certificate
    CONFIG_FILE="$CERT_DIR/certificate.cnf"
    echo "[req]" > $CONFIG_FILE
    echo "distinguished_name = req_distinguished_name" >> $CONFIG_FILE
    echo "req_extensions = v3_req" >> $CONFIG_FILE
    echo "prompt = no" >> $CONFIG_FILE
    echo "" >> $CONFIG_FILE
    echo "[req_distinguished_name]" >> $CONFIG_FILE
    echo "C = SE" >> $CONFIG_FILE
    echo "ST = Stockholm" >> $CONFIG_FILE
    echo "L = Stockholm" >> $CONFIG_FILE
    echo "O = NIWIM" >> $CONFIG_FILE
    echo "OU = IT" >> $CONFIG_FILE
    echo "CN = localhost" >> $CONFIG_FILE
    echo "" >> $CONFIG_FILE
    echo "[v3_req]" >> $CONFIG_FILE
    echo "subjectAltName = @alt_names" >> $CONFIG_FILE
    echo "" >> $CONFIG_FILE
    echo "[alt_names]" >> $CONFIG_FILE
    echo "DNS.1 = localhost" >> $CONFIG_FILE

     # Create a certificate signing request (CSR) for your server
    openssl req -new -key $KEY_FILE -out $CSR_FILE -config $CONFIG_FILE

    # Use your CA's private key to sign the server's CSR and create a server certificate
    openssl x509 -req -in $CSR_FILE -CA $CA_CERT_FILE -CAkey $CA_KEY_FILE -CAcreateserial -out $CERT_FILE -days 825 -sha256 -extensions v3_req -extfile $CONFIG_FILE

    echo "New SSL certificate and key have been generated."
fi
