# Supply Chain Dependency Chart - Setup Instructions

This document provides instructions to set up and run the Supply Chain Dependency Chart application on your local machine. The application consists of a React frontend and a Node.js backend that connects to a MySQL database.

## Quick Setup with Docker (Recommended)

If you have Docker and Docker Compose installed, you can get the entire application running with just a few commands:

```bash
# Clone the repository (assuming you've created one)
git clone <your-repository-url>
cd supply-chain-app

# Start all services (MySQL, backend, frontend)
docker-compose up -d

# The application will be available at:
# - Frontend: http://localhost:3000
# - Backend API: http://localhost:5000/api
# - MySQL: localhost:3306
```

This will set up everything automatically, including the database with sample data.

## Manual Setup

## Prerequisites

Make sure you have the following installed on your machine:

- Node.js (v14 or higher)
- npm (v6 or higher)
- MySQL (v5.7 or higher)

## Step 1: Database Setup

1. Start your MySQL server
2. Log in to MySQL using your credentials
3. Run the SQL commands from the `database-setup.sql` file to create the database and tables:

```bash
mysql -u your_username -p < database-setup.sql
```

Alternatively, you can copy and paste the SQL commands directly into your MySQL client.

## Step 2: Backend Setup

1. Create a new directory for your project:

```bash
mkdir supply-chain-app
cd supply-chain-app
mkdir backend
cd backend
```

2. Initialize a new Node.js project:

```bash
npm init -y
```

3. Install the required dependencies:

```bash
npm install express mysql2 cors dotenv
```

4. Create a `.env` file in the backend directory with your MySQL configuration:

```
PORT=5000
DB_HOST=localhost
DB_USER=your_username
DB_PASSWORD=your_password
DB_NAME=supply_chain_db
```

5. Create a `server.js` file and copy the code from the provided backend API file.

6. Start the backend server:

```bash
node server.js
```

You should see a message that the server is running on port 5000.

## Step 3: Frontend Setup

1. In a new terminal window, navigate back to your project root directory and create a React app:

```bash
cd ..
npx create-react-app frontend
cd frontend
```

2. Install the required dependencies:

```bash
npm install axios lucide-react
```

3. Create a file called `.env` in the frontend directory with the following content:

```
REACT_APP_API_URL=http://localhost:5000/api
```

4. Configure the proxy in `package.json` by adding:

```json
"proxy": "http://localhost:5000",
```

5. Replace the content of `src/App.js` with the code from the Supply Chain Dependency Chart component.

6. Start the React development server:

```bash
npm start
```

The application should open in your browser at http://localhost:3000.

## Project Structure

Your project should have the following structure:

```
supply-chain-app/
├── backend/
│   ├── node_modules/
│   ├── .env
│   ├── package.json
│   └── server.js
├── frontend/
│   ├── node_modules/
│   ├── public/
│   ├── src/
│   │   ├── App.js
│   │   ├── index.js
│   │   └── ...
│   ├── .env
│   └── package.json
└── database-setup.sql
```

## Advanced Features and Customization

### Re-enabling Filters

The filter functionality has been temporarily disabled as requested. To re-enable it:

1. Update the `SupplyChainDependencyChart` component to include the filter UI elements
2. Add state management for filters
3. Implement filter logic in your API or frontend

### Adding Real-time Updates

To implement real-time updates of node statuses:

1. Add WebSocket support to the backend using Socket.io:
   ```bash
   cd backend
   npm install socket.io
   ```

2. Configure the server to emit events when data changes:
   ```javascript
   // In server.js
   const http = require('http');
   const server = http.createServer(app);
   const io = require('socket.io')(server, {
     cors: {
       origin: '*',
     }
   });

   io.on('connection', (socket) => {
     console.log('Client connected');
   });

   // Emit events when data changes
   function emitDataChange() {
     io.emit('data-change');
   }
   
   server.listen(port, () => {
     console.log(`Server running on port ${port}`);
   });
   ```

3. Update the frontend to listen for these events:
   ```javascript
   // In SupplyChainDependencyChart.js
   import io from 'socket.io-client';

   useEffect(() => {
     const socket = io('http://localhost:5000');
     
     socket.on('data-change', () => {
       fetchData(); // Re-fetch data when changes occur
     });
     
     return () => {
       socket.disconnect();
     };
   }, []);
   ```

## Troubleshooting

### Database Connection Issues

- Ensure your MySQL server is running
- Verify the credentials in the `.env` file
- Check that the database `supply_chain_db` exists
- Ensure the MySQL user has appropriate permissions
- For Docker setup, check logs: `docker-compose logs mysql`

### API Connection Issues

- Confirm that the backend server is running on port 5000
- Check the browser console for any CORS errors
- Verify that the proxy is correctly set in `package.json`
- For Docker setup, check logs: `docker-compose logs backend`

### Data Not Displaying

- Check the browser console for any errors
- Verify the API response using a tool like Postman or curl:
  ```bash
  curl http://localhost:5000/api/nodedata
  ```
- Ensure the database contains data (run the sample inserts)
- Check that the tree building logic is working correctly

## Production Deployment

For production deployment:

1. Build the React app:
   ```bash
   cd frontend
   npm run build
   ```

2. Configure your backend to serve the static files from the build directory:
   ```javascript
   // In server.js
   app.use(express.static(path.join(__dirname, '../frontend/build')));
   
   app.get('*', (req, res) => {
     res.sendFile(path.join(__dirname, '../frontend/build', 'index.html'));
   });
   ```

3. Set up proper security measures:
   - Use HTTPS
   - Implement authentication/authorization
   - Add rate limiting
   - Use environment variables for sensitive data

4. Deploy using Docker:
   ```bash
   docker-compose -f docker-compose.prod.yml up -d
   ```

5. Use a process manager like PM2 to keep the Node.js server running:
   ```bash
   npm install -g pm2
   pm2 start server.js
   ```

## Scaling the Application

As your data grows, consider these scaling strategies:

1. **Database Optimization**:
   - Add indexes for frequently queried columns
   - Use connection pooling (already implemented)
   - Consider database sharding for very large datasets

2. **API Optimization**:
   - Implement pagination for large datasets
   - Add caching with Redis
   - Create specialized endpoints for different view types

3. **Frontend Performance**:
   - Implement virtualization for large trees
   - Add lazy loading for nodes
   - Consider using WebWorkers for complex tree calculations
