const express = require("express");
const fs = require("fs");
const path = require("path");

const app = express();
const PORT = 3000;
const PUB_KEY_PATH = "/home/sshuser/.ssh/id_rsa";

app.get("/download-ssh-key", (req, res) => {
  if (!fs.existsSync(PUB_KEY_PATH)) {
    return res.status(404).json({ error: "Public key not found" });
  }
  try {
    res.download(PUB_KEY_PATH, "id_rsa");
  } catch (error) {
    console.log(error);
  }
});

app.listen(PORT, () => {
  console.log(`SSH Key Server running at http://localhost:${PORT}`);
});
