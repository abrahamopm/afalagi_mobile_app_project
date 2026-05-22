import express from 'express';
import {
  getProperties,
  getPropertyById,
  createProperty,
  updateProperty,
  deleteProperty,
} from '../controllers/propertyController';
import { protect } from '../middleware/authMiddleware';

const router = express.Router();

router.use(protect as any);

router.route('/')
  .get(getProperties as any)
  .post(createProperty as any);

router.route('/:id')
  .get(getPropertyById as any)
  .put(updateProperty as any)
  .delete(deleteProperty as any);

export default router;
