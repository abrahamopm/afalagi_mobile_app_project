import express from 'express';
import {
  registerUser,
  loginUser,
  getMe,
  updateProfile,
  deleteAccount,
} from '../controllers/authController';
import { protect } from '../middleware/authMiddleware';

const router = express.Router();

router.post('/register', registerUser);
router.post('/login', loginUser);

router.route('/me')
  .get(protect as any, getMe as any)
  .put(protect as any, updateProfile as any)
  .delete(protect as any, deleteAccount as any);

export default router;
