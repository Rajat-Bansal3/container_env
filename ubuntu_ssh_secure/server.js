const express = require("express");
const fs = require("fs");
const { exec } = require("child_process");
const cors = require("cors");
const path = require("path");

const app = express();
const PORT = 3000;
const PUB_KEY_PATH = "/home/sshuser/.ssh/id_rsa";

app.use(cors());
app.use(express.json({ limit: "1mb" }));

const restartServiceWithRollback = (
  serviceName,
  configPath,
  backupConfigPath,
  res
) => {
  exec(`service ${serviceName} restart`, (err) => {
    if (err) {
      fs.copyFileSync(backupConfigPath, configPath);
      exec(`service ${serviceName} restart`, (rollbackErr) => {
        if (rollbackErr) {
          return res
            .status(500)
            .send(`Failed to restart ${serviceName} service after rollback.`);
        }
        res.send(
          `${serviceName} configuration updated, but service restart failed. Rolled back to original config and restarted successfully.`
        );
      });
    } else {
      res.send(
        `${serviceName} configuration updated and service restarted successfully.`
      );
    }
  });
};

app.post("/modify-sshd-config", (req, res) => {
  const configPath = "/etc/ssh/sshd_config";
  const tempConfigPath = "/etc/ssh/sshd_config.tmp";
  const backupConfigPath = `${configPath}.old`;

  fs.copyFileSync(configPath, backupConfigPath);
  console.log(fs.readFileSync(configPath, "utf8"));
  let newConfig = req.body.config;
  fs.writeFileSync(tempConfigPath, newConfig);
  exec(`sshd -t -f ${tempConfigPath}`, (error) => {
    if (error) {
      fs.copyFileSync(backupConfigPath, configPath);
      return res
        .status(400)
        .send("Configuration validation failed. Rollback to original config.");
    }

    fs.copyFileSync(tempConfigPath, configPath);
    restartServiceWithRollback("ssh", configPath, backupConfigPath, res);
  });
});

app.post("/modify-fail2ban-config", (req, res) => {
  const configPath = "/etc/fail2ban/jail.local";
  const tempConfigPath = "/etc/fail2ban/jail.local.tmp";
  const backupConfigPath = `${configPath}.old`;

  fs.copyFileSync(configPath, backupConfigPath);

  let newConfig = req.body.config;
  fs.writeFileSync(tempConfigPath, newConfig);

  fs.copyFileSync(tempConfigPath, configPath);
  restartServiceWithRollback("fail2ban", configPath, backupConfigPath, res);
});

app.get("/current-sshd-config", (req, res) => {
  fs.readFile("/etc/ssh/sshd_config", "utf8", (err, data) => {
    if (err) {
      return res.status(500).send("Error reading sshd_config file.");
    }
    res.send(data);
  });
});

app.get("/current-fail2ban-config", (req, res) => {
  fs.readFile("/etc/fail2ban/jail.local", "utf8", (err, data) => {
    if (err) {
      return res.status(500).send("Error reading fail2ban config file.");
    }
    res.send(data);
  });
});

app.get("/download-ssh-key", (req, res) => {
  if (!fs.existsSync(PUB_KEY_PATH)) {
    return res.status(404).json({ error: "Public key not found" });
  }
  try {
    res.download(PUB_KEY_PATH, "id_rsa");
  } catch (error) {
    console.log(error);
    res.status(500).send("Error downloading the SSH key.");
  }
});
const services = [
  { name: "sshd" },
  { name: "fail2ban" },
  { name: "ufw" },
  { name: "openvswitch" },
];

app.get("/services", (req, res) => {
  res.json(services);
});

app.listen(PORT, () => {
  console.log(`Server running at http://localhost:${PORT}`);
});
