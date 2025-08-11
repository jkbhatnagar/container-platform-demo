const express = require('express');
const pool = require('./db');
require('dotenv').config();

// const cors = require('cors');
// const allowedOrigin = process.env.CORS_ORIGIN || '*';
// app.use(cors({ origin: allowedOrigin }));

const app = express();
app.use(express.json());

// Create a new complaint
app.post('/complaints', async (req, res) => {
  const { category, description, status } = req.body;
  try {
    const result = await pool.query(
      `INSERT INTO Complaints (category, description, status)
       VALUES ($1, $2, $3)
       RETURNING *`,
      [category, description, status || 'Open']
    );
    res.status(201).json(result.rows[0]);
  } catch (err) {
    console.error(err);
    res.status(500).send('Error creating complaint');
  }
});

// Get all complaints
app.get('/complaints', async (req, res) => {
  try {
    const result = await pool.query('SELECT * FROM Complaints ORDER BY created_at DESC');
    res.json(result.rows);
  } catch (err) {
    console.error(err);
    res.status(500).send('Error fetching complaints');
  }
});

// Get complaint by ID
app.get('/complaints/:id', async (req, res) => {
  try {
    const result = await pool.query('SELECT * FROM Complaints WHERE complaint_id = $1', [req.params.id]);
    if (result.rows.length === 0) {
      return res.status(404).send('Complaint not found');
    }
    res.json(result.rows[0]);
  } catch (err) {
    console.error(err);
    res.status(500).send('Error fetching complaint');
  }
});

// Update complaint
app.put('/complaints/:id', async (req, res) => {
  const { category, description, status } = req.body;
  try {
    const result = await pool.query(
      `UPDATE Complaints
       SET category = $1,
           description = $2,
           status = $3,
           updated_at = CURRENT_TIMESTAMP
       WHERE complaint_id = $4
       RETURNING *`,
      [category, description, status, req.params.id]
    );
    if (result.rows.length === 0) {
      return res.status(404).send('Complaint not found');
    }
    res.json(result.rows[0]);
  } catch (err) {
    console.error(err);
    res.status(500).send('Error updating complaint');
  }
});

// Delete complaint
app.delete('/complaints/:id', async (req, res) => {
  try {
    const result = await pool.query('DELETE FROM Complaints WHERE complaint_id = $1 RETURNING *', [req.params.id]);
    if (result.rows.length === 0) {
      return res.status(404).send('Complaint not found');
    }
    res.send(`Complaint ${req.params.id} deleted`);
  } catch (err) {
    console.error(err);
    res.status(500).send('Error deleting complaint');
  }
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Complaints service running on port ${PORT}`);
});
