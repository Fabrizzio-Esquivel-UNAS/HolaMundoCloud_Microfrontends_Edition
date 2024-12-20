const express = require('express');
const cors = require('cors');
const app = express();
const PORT = 3030;

app.use(cors());

app.get('/message', (req, res) => {
  res.json({ message: 'Hello from the Backend!' });
});

app.listen(PORT, () => {
  console.log(`Backend server running on http://localhost:${PORT}`);
});
