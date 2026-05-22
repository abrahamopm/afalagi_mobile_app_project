import express from 'express';
import { getDashboardStats } from '../controllers/dashboardController';
import { protect } from '../middleware/authMiddleware';

const router = express.Router();

router.get('/stats', protect as any, getDashboardStats as any);

export default router;
