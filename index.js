const express = require("express");
const app = express();

app.get("/api/health", (req, res) => {
  res.json({ status: "healthy", message: "Backend running successfully" });
});

const PORT = process.env.PORT || 3000;

app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
