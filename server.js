const express = require('express');
const axios = require('axios');
const cors = require('cors');

const app = express();
const PORT = 3000;

const API_BASE_URL = 'https://api.football-data.org/v4';
const API_KEY = '5a488af03d0a46a8b516c8807861dde2';

// Enable CORS for all routes
app.use(cors());

// Proxy endpoint for matches
app.get('/api/matches', async (req, res) => {
  try {
    const response = await axios.get(`${API_BASE_URL}/matches`, {
      params: req.query,
      headers: {
        'X-Auth-Token': API_KEY,
      },
    });
    res.json(response.data);
  } catch (error) {
    console.error('API Error:', error.message);
    res.status(error.response?.status || 500).json({
      error: error.message,
      details: error.response?.data || null,
    });
  }
});

// Proxy endpoint for standings
app.get('/api/competitions/:id/standings', async (req, res) => {
  try {
    const response = await axios.get(
      `${API_BASE_URL}/competitions/${req.params.id}/standings`,
      {
        headers: {
          'X-Auth-Token': API_KEY,
        },
      }
    );
    res.json(response.data);
  } catch (error) {
    console.error('API Error:', error.message);
    res.status(error.response?.status || 500).json({
      error: error.message,
      details: error.response?.data || null,
    });
  }
});

// Health check
app.get('/health', (req, res) => {
  res.json({ status: 'Server is running', timestamp: new Date() });
});

app.listen(PORT, () => {
  console.log(`🚀 Proxy server running at http://localhost:${PORT}`);
  console.log(`📡 Football API Base: ${API_BASE_URL}`);
  console.log(`✅ CORS enabled - ready to serve web requests`);
});
