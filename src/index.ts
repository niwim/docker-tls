import path from "path";
import https from "https";
import fs from "fs";
import express from "express";

// Resolve paths to certificate and key files
const keyPath = path.resolve(__dirname, "../cert/server/key.pem");
const certPath = path.resolve(__dirname, "../cert/server/cert.pem");

// Read certificate and key files
const options = {
  key: fs.readFileSync(keyPath),
  cert: fs.readFileSync(certPath),
};

// Initialize the Express application
const app = express();

// Define a route handler for the GET method on the path '/'
app.get("/", (req, res) => {
  res.send("Hello World!");
});

// Get the port from the environment variables or use 443 as a default
const port = process.env.PORT || 443;

https.createServer(options, app).listen(port, () => {
  console.log(`Server is running on https://localhost:${port}`);
});
