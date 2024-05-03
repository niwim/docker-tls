#!/bin/bash

# Set the directory where certificates are supposed to be found
CERT_DIR="${PWD}/cert/server"
CA_CERT_DIR="${PWD}/cert/ca"

# Set the paths to the certificate and key files for CA
CA_KEY_FILE="$CA_CERT_DIR/ca.key"
CA_CERT_FILE="$CA_CERT_DIR/ca.pem"

# Set the paths to the certificate and key files
CERT_FILE="$CERT_DIR/cert.pem"
KEY_FILE="$CERT_DIR/key.pem"

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

    # Generate a new private key and certificate
    openssl req -x509 -newkey rsa:4096 -keyout "$KEY_FILE" -out "$CERT_FILE" -days 365 -nodes -subj "/C=SE/ST=Stockholm/L=Stockholm/O=NIWIM/OU=IT Department/CN=www.na.com"

    echo "New SSL certificate and key have been generated."
fi

# Check if both the certificate and key files exist
if [[ -f "$CERT_FILE" && -f "$KEY_FILE" ]]; then
    echo "Certificate and key files found. No need to generate new ones."
else
    echo "Certificate or key file not found. Generating new ones..."
    
    # Ensure the certificate directory exists
    mkdir -p "$CERT_DIR"

    # Generate a new private key and certificate
    openssl req -x509 -newkey rsa:4096 -keyout "$KEY_FILE" -out "$CERT_FILE" -days 365 -nodes -subj "/C=SE/ST=Stockholm/L=Stockholm/O=NIWIM/OU=IT Department/CN=www.na.com"

    echo "New SSL certificate and key have been generated."
fi
