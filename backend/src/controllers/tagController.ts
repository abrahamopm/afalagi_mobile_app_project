import { Response, NextFunction } from 'express';
import Tag from '../models/Tag';
import Property from '../models/Property';
import { AuthRequest } from '../middleware/authMiddleware';

// @desc    Get all tags for current agent, with active property count
// @route   GET /api/v1/tags
// @access  Private
export const getTags = async (req: AuthRequest, res: Response, next: NextFunction) => {
  try {
    const tags = await Tag.find({ user: req.user?._id }).sort({ name: 1 });

    // Aggregate counts for each tag dynamically
    const tagsWithCounts = await Promise.all(
      tags.map(async (tag) => {
        const propertyCount = await Property.countDocuments({
          user: req.user?._id,
          tags: tag.name,
        });

        return {
          _id: tag._id,
          name: tag.name,
          color: tag.color,
          propertyCount,
        };
      })
    );

    res.json({
      success: true,
      count: tagsWithCounts.length,
      data: tagsWithCounts,
    });
  } catch (err) {
    next(err);
  }
};

// @desc    Get tag by ID
// @route   GET /api/v1/tags/:id
// @access  Private
export const getTagById = async (req: AuthRequest, res: Response, next: NextFunction) => {
  try {
    const tag = await Tag.findOne({ _id: req.params.id, user: req.user?._id });

    if (!tag) {
      res.status(404).json({ success: false, error: 'Tag not found' });
      return;
    }

    const propertyCount = await Property.countDocuments({
      user: req.user?._id,
      tags: tag.name,
    });

    res.json({
      success: true,
      data: {
        _id: tag._id,
        name: tag.name,
        color: tag.color,
        propertyCount,
      },
    });
  } catch (err) {
    next(err);
  }
};

// @desc    Create new tag
// @route   POST /api/v1/tags
// @access  Private
export const createTag = async (req: AuthRequest, res: Response, next: NextFunction) => {
  try {
    req.body.user = req.user?._id;

    // Check if tag name already exists for this user
    const existingTag = await Tag.findOne({ user: req.user?._id, name: req.body.name });
    if (existingTag) {
      res.status(400).json({ success: false, error: 'Tag with this name already exists' });
      return;
    }

    const tag = await Tag.create(req.body);

    res.status(201).json({
      success: true,
      data: {
        _id: tag._id,
        name: tag.name,
        color: tag.color,
        propertyCount: 0,
      },
    });
  } catch (err) {
    next(err);
  }
};

// @desc    Update tag
// @route   PUT /api/v1/tags/:id
// @access  Private
export const updateTag = async (req: AuthRequest, res: Response, next: NextFunction) => {
  try {
    const tag = await Tag.findOne({ _id: req.params.id, user: req.user?._id });

    if (!tag) {
      res.status(404).json({ success: false, error: 'Tag not found' });
      return;
    }

    // If changing name, ensure uniqueness
    if (req.body.name && req.body.name !== tag.name) {
      const nameExists = await Tag.findOne({ user: req.user?._id, name: req.body.name });
      if (nameExists) {
        res.status(400).json({ success: false, error: 'Tag with this name already exists' });
        return;
      }
    }

    const updatedTag = await Tag.findByIdAndUpdate(req.params.id, req.body, {
      new: true,
      runValidators: true,
    });

    const propertyCount = await Property.countDocuments({
      user: req.user?._id,
      tags: updatedTag?.name,
    });

    res.json({
      success: true,
      data: {
        _id: updatedTag?._id,
        name: updatedTag?.name,
        color: updatedTag?.color,
        propertyCount,
      },
    });
  } catch (err) {
    next(err);
  }
};

// @desc    Delete tag
// @route   DELETE /api/v1/tags/:id
// @access  Private
export const deleteTag = async (req: AuthRequest, res: Response, next: NextFunction) => {
  try {
    const tag = await Tag.findOne({ _id: req.params.id, user: req.user?._id });

    if (!tag) {
      res.status(404).json({ success: false, error: 'Tag not found' });
      return;
    }

    // Pull tag name from any property's tags list
    await Property.updateMany(
      { user: req.user?._id, tags: tag.name },
      { $pull: { tags: tag.name } }
    );

    await Tag.findByIdAndDelete(req.params.id);

    res.json({
      success: true,
      message: 'Tag deleted successfully and properties updated',
    });
  } catch (err) {
    next(err);
  }
};
