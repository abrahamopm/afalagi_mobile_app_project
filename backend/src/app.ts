import express, { Request, Response } from 'express';
import cors from 'cors';
import userRoutes from './routes/userRoutes';
import errorHandler from './middleware/errorMiddleware';

const app = express();

app.use(cors());
app.use(express.json());

// Routes
app.use('/api/v1/users', userRoutes);

app.get('/', (req: Request, res: Response) => {
  res.send('Afalagi Backend is running!');
});

// Error middleware
app.use(errorHandler);

export default app;
