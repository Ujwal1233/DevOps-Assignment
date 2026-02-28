const express = require("express");
const app = express();

app.get("/api/health", (req, res) => {
  res.json({ status: "healthy", message: "Backend running successfully" });
});

app.listen(3000, () => {
  console.log("Server running on port 3000");
});
