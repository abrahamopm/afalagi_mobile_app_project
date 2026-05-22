import { Request, Response, NextFunction } from 'express';
import User from '../models/User';

// @desc    Get all users
// @route   GET /api/v1/users
// @access  Public
export const getUsers = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const users = await User.find();
    res.status(200).json({
      success: true,
      count: users.length,
      data: users
    });
  } catch (err) {
    next(err);
  }
};

// @desc    Create new user
// @route   POST /api/v1/users
// @access  Public
export const createUser = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const { name, email, password } = req.body;
    const user = await User.create({
      name,
      email,
      password
    });

    // Convert to object to remove select: false fields if they were included by create()
    const userResponse = user.toObject();
    delete userResponse.password;

    res.status(201).json({
      success: true,
      data: userResponse
    });
  } catch (err) {
    next(err);
  }
};