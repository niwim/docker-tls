# Docker-TLS

This project sets up a Docker environment with TLS. The application is a simple Node.js server that serves a static HTML page. The server is configured to use TLS.

Certificates can either be provided in the cert/server folder or will be generated automatically.

Generated certificates are self-signed by a CA that is also generated. The CA certificate is stored in the cert/ca folder. And can be added as a trusted CA to the client.

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes.

### Prerequisites

- Docker
- Node.js

### Installation

1. Clone the repository
2. Install dependencies with `yarn install`
3. Build the project with `yarn build`

## Running the Docker Environment

Build the Docker image with `yarn docker:build`.
Start the Docker environment with `yarn docker:start`.
