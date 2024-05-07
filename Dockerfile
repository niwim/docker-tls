# Specify the base image
FROM node:alpine

# Set the working directory
WORKDIR /app

# Copy package.json and package-lock.json
COPY package*.json ./

# Update the package lists for upgrades and new packages
RUN apk update

# Install OpenSSL
RUN apk add --no-cache openssl

# Install dependencies
RUN yarn install

# Copy the rest of the application
COPY . .

# Copy the entrypoint script into the image
RUN chmod +x /app/entrypoint.sh

# COPY setup-ssl.sh /setup-ssl.sh
RUN chmod +x /app/setup-ssl.sh

# Build the application
RUN yarn build
# Expose the port your app runs on
EXPOSE 3000

# Specify the entrypoint script
ENTRYPOINT ["/app/entrypoint.sh"]