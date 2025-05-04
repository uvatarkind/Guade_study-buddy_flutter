const express = require('express');
const cors = require('cors');
const { createServer } = require('http');
const { Server } = require('socket.io');
require('dotenv').config();

const app = express();
const httpServer = createServer(app);
const io = new Server(httpServer, {
  cors: {
    origin: "*",
    methods: ["GET", "POST"]
  }
});

// Middleware
app.use(cors());
app.use(express.json());

// Basic route for testing
app.get('/api/health', (req, res) => {
  res.json({ status: 'ok', message: 'Server is running' });
});

// Socket.IO connection handling
io.on('connection', (socket) => {
  console.log('A user connected');

  socket.on('join', (data) => {
    const { groupId } = data;
    socket.join(groupId);
    console.log(`User joined group: ${groupId}`);
  });

  socket.on('leave', (data) => {
    const { groupId } = data;
    socket.leave(groupId);
    console.log(`User left group: ${groupId}`);
  });

  socket.on('message', (data) => {
    const { groupId, message, timestamp } = data;
    io.to(groupId).emit('message', {
      ...data,
      senderId: socket.id
    });
  });

  socket.on('disconnect', () => {
    console.log('User disconnected');
  });
});

// Start server
const PORT = process.env.PORT || 5000;
httpServer.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
}); 