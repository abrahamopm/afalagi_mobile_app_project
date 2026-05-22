import express from 'express';
import {
  getClients,
  getClientById,
  createClient,
  updateClient,
  deleteClient,
} from '../controllers/clientController';
import { protect } from '../middleware/authMiddleware';

const router = express.Router();

router.use(protect as any);

router.route('/')
  .get(getClients as any)
  .post(createClient as any);

router.route('/:id')
  .get(getClientById as any)
  .put(updateClient as any)
  .delete(deleteClient as any);

export default router;
