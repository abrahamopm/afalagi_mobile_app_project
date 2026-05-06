const express = require('express');
const cors = require('cors');
const morgan = require('morgan');
const helmet = require('helmet');
const errorHandler = require('./middleware/errorMiddleware');

const app = express();

// Middleware
app.use(helmet());
app.use(cors());
app.use(express.json());

// Dev logging middleware
if (process.env.NODE_ENV === 'development') {
  app.use(morgan('dev'));
}

// Routes
app.use('/api/v1/users', require('./routes/userRoutes'));

// Root route
app.get('/', (req, res) => {
  res.json({ message: 'Welcome to Afalagi API' });
});

// Error handling middleware
app.use(errorHandler);

module.exports = app;
