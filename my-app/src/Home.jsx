import { useState, useEffect } from "react";

const Home = () => {
  const [sshdConfig, setSshdConfig] = useState("");
  const [fail2banConfig, setFail2banConfig] = useState("");
  const [newSshdConfig, setNewSshdConfig] = useState("");
  const [newFail2banConfig, setNewFail2banConfig] = useState("");
  const [error, setError] = useState("");

  useEffect(() => {
    fetchCurrentConfigs();
  }, []);

  const fetchCurrentConfigs = async () => {
    try {
      const sshdResponse = await fetch(
        "http://localhost:3001/current-sshd-config"
      );
      const fail2banResponse = await fetch(
        "http://localhost:3001/current-fail2ban-config"
      );

      if (!sshdResponse.ok || !fail2banResponse.ok) {
        throw new Error("Failed to fetch configurations");
      }

      setSshdConfig(await sshdResponse.text());
      setFail2banConfig(await fail2banResponse.text());
    } catch (err) {
      setError(err.message);
    }
  };

  const handleSshdConfigChange = async () => {
    try {
      const response = await fetch("http://localhost:3001/modify-sshd-config", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ config: newSshdConfig }),
      });

      if (!response.ok) {
        throw new Error("Failed to update SSHD config");
      }

      fetchCurrentConfigs();
    } catch (err) {
      setError(err.message);
    }
  };

  const handleFail2banConfigChange = async () => {
    try {
      const response = await fetch(
        "http://localhost:3001/modify-fail2ban-config",
        {
          method: "POST",
          headers: { "Content-Type": "application/json" },
          body: JSON.stringify({ config: newFail2banConfig }),
        }
      );

      if (!response.ok) {
        throw new Error("Failed to update Fail2Ban config");
      }

      fetchCurrentConfigs();
    } catch (err) {
      setError(err.message);
    }
  };

  const downloadSshKey = () => {
    window.open("http://localhost:3001/download-ssh-key", "_blank");
  };
  return (
    <div className='container mx-auto p-4'>
      <h1 className='text-2xl font-bold mb-4'>
        Server Configuration Management
      </h1>
      {error && <p className='text-red-500'>{error}</p>}

      <div className='mb-6'>
        <h2 className='text-xl font-semibold'>Current SSHD Config</h2>
        <pre className='bg-gray-100 p-4 rounded'>{sshdConfig}</pre>
        <textarea
          className='w-full p-2 border rounded mt-2'
          rows='5'
          value={newSshdConfig}
          onChange={(e) => setNewSshdConfig(e.target.value)}
          placeholder='Enter new SSHD config'
        />
        <button
          className='bg-blue-500 text-white p-2 rounded mt-2'
          onClick={handleSshdConfigChange}
        >
          Update SSHD Config
        </button>
      </div>

      <div className='mb-6'>
        <h2 className='text-xl font-semibold'>Current Fail2Ban Config</h2>
        <pre className='bg-gray-100 p-4 rounded'>{fail2banConfig}</pre>
        <textarea
          className='w-full p-2 border rounded mt-2'
          rows='5'
          value={newFail2banConfig}
          onChange={(e) => setNewFail2banConfig(e.target.value)}
          placeholder='Enter new Fail2Ban config'
        />
        <button
          className='bg-blue-500 text-white p-2 rounded mt-2'
          onClick={handleFail2banConfigChange}
        >
          Update Fail2Ban Config
        </button>
      </div>

      <button
        className='bg-green-500 text-white p-2 rounded'
        onClick={downloadSshKey}
      >
        Download SSH Key
      </button>
    </div>
  );
};
export default Home;
