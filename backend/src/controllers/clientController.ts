import { Response, NextFunction } from 'express';
import Client from '../models/Client';
import Viewing from '../models/Viewing';
import { AuthRequest } from '../middleware/authMiddleware';

// @desc    Get all clients for current agent
// @route   GET /api/v1/clients
// @access  Private
export const getClients = async (req: AuthRequest, res: Response, next: NextFunction) => {
  try {
    const clients = await Client.find({ user: req.user?._id }).sort({ createdAt: -1 });

    res.json({
      success: true,
      count: clients.length,
      data: clients,
    });
  } catch (err) {
    next(err);
  }
};

// @desc    Get client by ID
// @route   GET /api/v1/clients/:id
// @access  Private
export const getClientById = async (req: AuthRequest, res: Response, next: NextFunction) => {
  try {
    const client = await Client.findOne({ _id: req.params.id, user: req.user?._id });

    if (!client) {
      res.status(404).json({ success: false, error: 'Client not found' });
      return;
    }

    res.json({
      success: true,
      data: client,
    });
  } catch (err) {
    next(err);
  }
};

// @desc    Create new client
// @route   POST /api/v1/clients
// @access  Private
export const createClient = async (req: AuthRequest, res: Response, next: NextFunction) => {
  try {
    req.body.user = req.user?._id;

    const client = await Client.create(req.body);

    res.status(201).json({
      success: true,
      data: client,
    });
  } catch (err) {
    next(err);
  }
};

// @desc    Update client
// @route   PUT /api/v1/clients/:id
// @access  Private
export const updateClient = async (req: AuthRequest, res: Response, next: NextFunction) => {
  try {
    let client = await Client.findOne({ _id: req.params.id, user: req.user?._id });

    if (!client) {
      res.status(404).json({ success: false, error: 'Client not found' });
      return;
    }

    client = await Client.findByIdAndUpdate(req.params.id, req.body, {
      new: true,
      runValidators: true,
    });

    res.json({
      success: true,
      data: client,
    });
  } catch (err) {
    next(err);
  }
};

// @desc    Delete client & cascade viewings
// @route   DELETE /api/v1/clients/:id
// @access  Private
export const deleteClient = async (req: AuthRequest, res: Response, next: NextFunction) => {
  try {
    const client = await Client.findOne({ _id: req.params.id, user: req.user?._id });

    if (!client) {
      res.status(404).json({ success: false, error: 'Client not found' });
      return;
    }

    // Delete associated viewings
    await Viewing.deleteMany({ client: req.params.id });

    await Client.findByIdAndDelete(req.params.id);

    res.json({
      success: true,
      message: 'Client and associated viewings deleted successfully',
    });
  } catch (err) {
    next(err);
  }
};
