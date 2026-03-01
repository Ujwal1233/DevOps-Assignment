# Simple Node.js Backend for Cloud Run
FROM node:18-alpine

WORKDIR /app

# Create a simple Express.js backend
RUN echo 'const express = require("express"); \
const app = express(); \
const port = process.env.PORT || 8080; \
\
app.get("/", (req, res) => { \
  res.json({ message: "Backend API is running!", environment: "GCP Cloud Run" }); \
}); \
\
app.get("/api/health", (req, res) => { \
  res.json({ status: "healthy", message: "Backend is running successfully" }); \
}); \
\
app.listen(port, "0.0.0.0", () => { \
  console.log("Server listening on port " + port); \
});' > server.js

# Install express
RUN npm init -y && npm install express

EXPOSE 8080

CMD ["node", "server.js"]
