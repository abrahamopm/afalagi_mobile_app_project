import express, { Request, Response } from 'express';
import cors from 'cors';
import userRoutes from './routes/userRoutes';
import authRoutes from './routes/authRoutes';
import propertyRoutes from './routes/propertyRoutes';
import clientRoutes from './routes/clientRoutes';
import viewingRoutes from './routes/viewingRoutes';
import tagRoutes from './routes/tagRoutes';
import dashboardRoutes from './routes/dashboardRoutes';
import adminRoutes from './routes/adminRoutes';
import errorHandler from './middleware/errorMiddleware';

const app = express();

app.use(cors());
app.use(express.json({ limit: '10mb' }));
app.use(express.urlencoded({ limit: '10mb', extended: true }));

// Routes
app.use('/api/v1/users', userRoutes);
app.use('/api/v1/auth', authRoutes);
app.use('/api/v1/properties', propertyRoutes);
app.use('/api/v1/clients', clientRoutes);
app.use('/api/v1/viewings', viewingRoutes);
app.use('/api/v1/tags', tagRoutes);
app.use('/api/v1/dashboard', dashboardRoutes);
app.use('/api/v1/admin', adminRoutes);

app.get('/', (req: Request, res: Response) => {
  res.send('Afalagi Backend is running!');
});

// Error middleware
app.use(errorHandler);

export default app;
