import express from 'express';
import {
  getTags,
  getTagById,
  createTag,
  updateTag,
  deleteTag,
} from '../controllers/tagController';
import { protect } from '../middleware/authMiddleware';

const router = express.Router();

router.use(protect as any);

router.route('/')
  .get(getTags as any)
  .post(createTag as any);

router.route('/:id')
  .get(getTagById as any)
  .put(updateTag as any)
  .delete(deleteTag as any);

export default router;
