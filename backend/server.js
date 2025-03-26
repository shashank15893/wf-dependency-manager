// server.js
const express = require('express');
const mysql = require('mysql2/promise');
const cors = require('cors');
require('dotenv').config();

const app = express();
const port = process.env.PORT || 5000;

app.use(cors());
app.use(express.json());

// Create MySQL connection pool
const pool = mysql.createPool({
  host: process.env.DB_HOST || 'localhost',
  user: process.env.DB_USER || 'root',
  password: process.env.DB_PASSWORD || '',
  database: process.env.DB_NAME || 'supply_chain_dashboard',
  waitForConnections: true,
  connectionLimit: 10,
  queueLimit: 0
});

// Test database connection
app.get('/api/test', async (req, res) => {
  try {
    const connection = await pool.getConnection();
    connection.release();
    res.json({ message: 'Database connection successful' });
  } catch (error) {
    console.error('Database connection error:', error);
    res.status(500).json({ error: 'Failed to connect to database' });
  }
});

// API endpoint to get all nodes
app.get('/api/nodes', async (req, res) => {
  try {
    const [rows] = await pool.query(`
      SELECT 
        NODE_ID, 
        PARENT_ID, 
        NODE_NM, 
        STATUS, 
        SLA, 
        EXECUTION_DT, 
        NODE_DESCRIPTION 
      FROM dependency
    `);
    res.json(rows);
  } catch (error) {
    console.error('Error fetching nodes:', error);
    res.status(500).json({ error: 'Failed to fetch nodes' });
  }
});

// API endpoint to get nodes with filters
app.get('/api/nodes/filtered', async (req, res) => {
  try {
    const { organization, domain, product, instance } = req.query;
    
    // Start with base query
    let query = `
      SELECT 
        NODE_ID, 
        PARENT_ID, 
        NODE_NM, 
        STATUS, 
        SLA, 
        EXECUTION_DT, 
        NODE_DESCRIPTION 
      FROM dependency
    `;
    
    const whereConditions = [];
    const params = [];
    
    // Add filter conditions if provided
    if (organization) {
      whereConditions.push('NODE_NM = ? AND NODE_DESCRIPTION = "Organisation"');
      params.push(organization);
    }
    
    if (domain) {
      whereConditions.push('NODE_NM = ? AND NODE_DESCRIPTION = "Domain"');
      params.push(domain);
    }
    
    if (product) {
      whereConditions.push('NODE_NM = ? AND NODE_DESCRIPTION = "Product"');
      params.push(product);
    }
    
    if (instance) {
      whereConditions.push('NODE_NM = ? AND NODE_DESCRIPTION = "Instance"');
      params.push(instance);
    }
    
    // Append WHERE clause if filters exist
    if (whereConditions.length > 0) {
      query += ' WHERE ' + whereConditions.join(' OR ');
    }
    
    const [rows] = await pool.query(query, params);
    res.json(rows);
  } catch (error) {
    console.error('Error fetching filtered nodes:', error);
    res.status(500).json({ error: 'Failed to fetch filtered nodes' });
  }
});

// Start the server
app.listen(port, () => {
  console.log(`Server running on port ${port}`);
});