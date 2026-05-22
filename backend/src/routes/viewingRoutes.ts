import express from 'express';
import {
  getViewings,
  getViewingById,
  createViewing,
  updateViewing,
  deleteViewing,
} from '../controllers/viewingController';
import { protect } from '../middleware/authMiddleware';

const router = express.Router();

router.use(protect as any);

router.route('/')
  .get(getViewings as any)
  .post(createViewing as any);

router.route('/:id')
  .get(getViewingById as any)
  .put(updateViewing as any)
  .delete(deleteViewing as any);

export default router;
