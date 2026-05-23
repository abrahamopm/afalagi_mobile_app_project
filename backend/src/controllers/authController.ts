import { Response, NextFunction } from 'express';
import User from '../models/User';
import Property from '../models/Property';
import Client from '../models/Client';
import Viewing from '../models/Viewing';
import Tag from '../models/Tag';
import generateToken from '../utils/generateToken';
import { AuthRequest } from '../middleware/authMiddleware';

// @desc    Register a new user (agent)
// @route   POST /api/v1/auth/register
// @access  Public
export const registerUser = async (req: AuthRequest, res: Response, next: NextFunction) => {
  try {
    const { name, email, password, phone, agencyName, agencyLicense } = req.body;

    const userExists = await User.findOne({ email });

    if (userExists) {
      res.status(400).json({ success: false, error: 'User already exists' });
      return;
    }

    const user = await User.create({
      name,
      email,
      password,
      phone: phone || '',
      agencyName: agencyName || '',
      agencyLicense: agencyLicense || '',
    });

    if (user) {
      res.status(201).json({
        success: true,
        token: generateToken(user._id.toString()),
        data: {
          id: user._id,
          name: user.name,
          email: user.email,
          phone: user.phone,
          agencyName: user.agencyName,
          agencyLicense: user.agencyLicense,
        },
      });
    } else {
      res.status(400).json({ success: false, error: 'Invalid user data' });
    }
  } catch (err) {
    next(err);
  }
};

// @desc    Authenticate user & get token
// @route   POST /api/v1/auth/login
// @access  Public
export const loginUser = async (req: AuthRequest, res: Response, next: NextFunction) => {
  try {
    const { email, password } = req.body;

    // Get user and select password specifically
    const user = await User.findOne({ email }).select('+password');

    if (user && (await user.matchPassword(password))) {
      res.json({
        success: true,
        token: generateToken(user._id.toString()),
        data: {
          id: user._id,
          name: user.name,
          email: user.email,
          phone: user.phone,
          agencyName: user.agencyName,
          agencyLicense: user.agencyLicense,
        },
      });
    } else {
      res.status(401).json({ success: false, error: 'Invalid email or password' });
    }
  } catch (err) {
    next(err);
  }
};

// @desc    Get logged in user details
// @route   GET /api/v1/auth/me
// @access  Private
export const getMe = async (req: AuthRequest, res: Response, next: NextFunction) => {
  try {
    if (!req.user) {
      res.status(404).json({ success: false, error: 'User not found' });
      return;
    }

    res.json({
      success: true,
      data: {
        id: req.user._id,
        name: req.user.name,
        email: req.user.email,
        phone: req.user.phone,
        agencyName: req.user.agencyName,
        agencyLicense: req.user.agencyLicense,
      },
    });
  } catch (err) {
    next(err);
  }
};

// @desc    Update current user profile
// @route   PUT /api/v1/auth/me
// @access  Private
export const updateProfile = async (req: AuthRequest, res: Response, next: NextFunction) => {
  try {
    const user = await User.findById(req.user?._id);

    if (!user) {
      res.status(404).json({ success: false, error: 'User not found' });
      return;
    }

    user.name = req.body.name || user.name;
    user.phone = req.body.phone !== undefined ? req.body.phone : user.phone;
    user.agencyName = req.body.agencyName !== undefined ? req.body.agencyName : user.agencyName;
    user.agencyLicense = req.body.agencyLicense !== undefined ? req.body.agencyLicense : user.agencyLicense;

    if (req.body.password) {
      user.password = req.body.password;
    }

    const updatedUser = await user.save();

    res.json({
      success: true,
      data: {
        id: updatedUser._id,
        name: updatedUser.name,
        email: updatedUser.email,
        phone: updatedUser.phone,
        agencyName: updatedUser.agencyName,
        agencyLicense: updatedUser.agencyLicense,
      },
    });
  } catch (err) {
    next(err);
  }
};

// @desc    Delete current user account & cascade all owned resources
// @route   DELETE /api/v1/auth/me
// @access  Private
export const deleteAccount = async (req: AuthRequest, res: Response, next: NextFunction) => {
  try {
    const userId = req.user?._id;

    if (!userId) {
      res.status(404).json({ success: false, error: 'User not found' });
      return;
    }

    // Cascade deletions of all user records
    await Property.deleteMany({ user: userId });
    await Client.deleteMany({ user: userId });
    await Viewing.deleteMany({ user: userId });
    await Tag.deleteMany({ user: userId });
    await User.findByIdAndDelete(userId);

    res.json({
      success: true,
      message: 'Account and all associated portfolios deleted successfully',
    });
  } catch (err) {
    next(err);
  }
};

// @desc    Logout user / clear session
// @route   POST /api/v1/auth/logout
// @access  Private
export const logoutUser = async (req: AuthRequest, res: Response, next: NextFunction) => {
  try {
    // In a stateless JWT setup, logout is primarily handled by the client dropping the token.
    // Here we just return a success response.
    res.json({
      success: true,
      message: 'Logged out successfully',
    });
  } catch (err) {
    next(err);
  }
};
