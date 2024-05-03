import express from "express";

// Initialize the Express application
const app = express();

// Define a route handler for the GET method on the path '/'
app.get("/", (req, res) => {
  res.send("Hello World!");
});

// Start the server on port 3000
app.listen(3000, () => {
  console.log("Server is running on port 3000");
});
