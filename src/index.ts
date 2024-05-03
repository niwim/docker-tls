import express from "express";

// Initialize the Express application
const app = express();

// Define a route handler for the GET method on the path '/'
app.get("/", (req, res) => {
  res.send("Hello World!");
});

// Get the port from the environment variables or use 3000 as a default
const port = process.env.PORT || 3000;

// Start the server on the specified port
app.listen(port, () => {
  console.log(`Server is running on port ${port}`);
});
