import { Response, NextFunction } from 'express';
import Property from '../models/Property';
import Viewing from '../models/Viewing';
import { AuthRequest } from '../middleware/authMiddleware';

// @desc    Get all properties for current agent
// @route   GET /api/v1/properties
// @access  Private
export const getProperties = async (req: AuthRequest, res: Response, next: NextFunction) => {
  try {
    const properties = await Property.find({ user: req.user?._id }).sort({ createdAt: -1 });

    res.json({
      success: true,
      count: properties.length,
      data: properties,
    });
  } catch (err) {
    next(err);
  }
};

// @desc    Get property by ID
// @route   GET /api/v1/properties/:id
// @access  Private
export const getPropertyById = async (req: AuthRequest, res: Response, next: NextFunction) => {
  try {
    const property = await Property.findOne({ _id: req.params.id, user: req.user?._id });

    if (!property) {
      res.status(404).json({ success: false, error: 'Property not found' });
      return;
    }

    res.json({
      success: true,
      data: property,
    });
  } catch (err) {
    next(err);
  }
};

// @desc    Create new property
// @route   POST /api/v1/properties
// @access  Private
export const createProperty = async (req: AuthRequest, res: Response, next: NextFunction) => {
  try {
    req.body.user = req.user?._id;

    const property = await Property.create(req.body);

    res.status(201).json({
      success: true,
      data: property,
    });
  } catch (err) {
    next(err);
  }
};

// @desc    Update property
// @route   PUT /api/v1/properties/:id
// @access  Private
export const updateProperty = async (req: AuthRequest, res: Response, next: NextFunction) => {
  try {
    let property = await Property.findOne({ _id: req.params.id, user: req.user?._id });

    if (!property) {
      res.status(404).json({ success: false, error: 'Property not found' });
      return;
    }

    property = await Property.findByIdAndUpdate(req.params.id, req.body, {
      new: true,
      runValidators: true,
    });

    res.json({
      success: true,
      data: property,
    });
  } catch (err) {
    next(err);
  }
};

// @desc    Delete property & cascade viewings
// @route   DELETE /api/v1/properties/:id
// @access  Private
export const deleteProperty = async (req: AuthRequest, res: Response, next: NextFunction) => {
  try {
    const property = await Property.findOne({ _id: req.params.id, user: req.user?._id });

    if (!property) {
      res.status(404).json({ success: false, error: 'Property not found' });
      return;
    }

    // Delete associated viewings
    await Viewing.deleteMany({ property: req.params.id });

    await Property.findByIdAndDelete(req.params.id);

    res.json({
      success: true,
      message: 'Property and associated viewings deleted successfully',
    });
  } catch (err) {
    next(err);
  }
};
