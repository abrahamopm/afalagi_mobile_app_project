import express from 'express';
import { protect } from '../middleware/authMiddleware';
import { requireAdmin } from '../middleware/adminMiddleware';
import {
  getAdminStats,
  getAdminUsers,
  updateAdminUser,
  getAdminProperties,
  updateAdminProperty,
  deleteAdminProperty,
} from '../controllers/adminController';

const router = express.Router();

router.use(protect, requireAdmin);

router.get('/stats', getAdminStats);
router.get('/users', getAdminUsers);
router.put('/users/:id', updateAdminUser);
router.get('/properties', getAdminProperties);
router.put('/properties/:id', updateAdminProperty);
router.delete('/properties/:id', deleteAdminProperty);

export default router;
