import express from 'express';
import {
  registerUser,
  loginUser,
  getMe,
  updateProfile,
  deleteAccount,
  logoutUser,
} from '../controllers/authController';
import { protect } from '../middleware/authMiddleware';

const router = express.Router();

router.post('/register', registerUser);
router.post('/login', loginUser);
router.post('/logout', protect as any, logoutUser as any);

router.route('/me')
  .get(protect as any, getMe as any)
  .put(protect as any, updateProfile as any)
  .delete(protect as any, deleteAccount as any);

export default router;
