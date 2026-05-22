import { Response, NextFunction } from 'express';
import Viewing from '../models/Viewing';
import { AuthRequest } from '../middleware/authMiddleware';

// @desc    Get all viewings for current agent
// @route   GET /api/v1/viewings
// @access  Private
export const getViewings = async (req: AuthRequest, res: Response, next: NextFunction) => {
  try {
    const viewings = await Viewing.find({ user: req.user?._id })
      .populate('property')
      .populate('client')
      .sort({ createdAt: -1 });

    res.json({
      success: true,
      count: viewings.length,
      data: viewings,
    });
  } catch (err) {
    next(err);
  }
};

// @desc    Get viewing by ID
// @route   GET /api/v1/viewings/:id
// @access  Private
export const getViewingById = async (req: AuthRequest, res: Response, next: NextFunction) => {
  try {
    const viewing = await Viewing.findOne({ _id: req.params.id, user: req.user?._id })
      .populate('property')
      .populate('client');

    if (!viewing) {
      res.status(404).json({ success: false, error: 'Viewing not found' });
      return;
    }

    res.json({
      success: true,
      data: viewing,
    });
  } catch (err) {
    next(err);
  }
};

// @desc    Create new viewing log
// @route   POST /api/v1/viewings
// @access  Private
export const createViewing = async (req: AuthRequest, res: Response, next: NextFunction) => {
  try {
    req.body.user = req.user?._id;

    let viewing = await Viewing.create(req.body);
    
    // Populate before sending response
    viewing = await viewing.populate('property');
    viewing = await viewing.populate('client');

    res.status(201).json({
      success: true,
      data: viewing,
    });
  } catch (err) {
    next(err);
  }
};

// @desc    Update viewing log
// @route   PUT /api/v1/viewings/:id
// @access  Private
export const updateViewing = async (req: AuthRequest, res: Response, next: NextFunction) => {
  try {
    let viewing = await Viewing.findOne({ _id: req.params.id, user: req.user?._id });

    if (!viewing) {
      res.status(404).json({ success: false, error: 'Viewing not found' });
      return;
    }

    viewing = await Viewing.findByIdAndUpdate(req.params.id, req.body, {
      new: true,
      runValidators: true,
    })
    .populate('property')
    .populate('client');

    res.json({
      success: true,
      data: viewing,
    });
  } catch (err) {
    next(err);
  }
};

// @desc    Delete viewing log
// @route   DELETE /api/v1/viewings/:id
// @access  Private
export const deleteViewing = async (req: AuthRequest, res: Response, next: NextFunction) => {
  try {
    const viewing = await Viewing.findOne({ _id: req.params.id, user: req.user?._id });

    if (!viewing) {
      res.status(404).json({ success: false, error: 'Viewing not found' });
      return;
    }

    await Viewing.findByIdAndDelete(req.params.id);

    res.json({
      success: true,
      message: 'Viewing log deleted successfully',
    });
  } catch (err) {
    next(err);
  }
};
