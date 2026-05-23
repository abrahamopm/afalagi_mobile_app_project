import { Response, NextFunction } from 'express';
import User from '../models/User';
import Property from '../models/Property';
import Client from '../models/Client';
import Viewing from '../models/Viewing';
import { AuthRequest } from '../middleware/authMiddleware';

const formatTime = (date: Date) => {
  const diffMs = Date.now() - date.getTime();
  const mins = Math.floor(diffMs / 60000);
  if (mins < 60) return `${Math.max(mins, 1)}m ago`;
  const hours = Math.floor(mins / 60);
  if (hours < 24) return `${hours}h ago`;
  const days = Math.floor(hours / 24);
  if (days < 7) return `${days}d ago`;
  return date.toLocaleDateString();
};

const serializeUser = (user: any) => ({
  id: user._id,
  name: user.name,
  email: user.email,
  role: user.role,
  phone: user.phone ?? '',
  agencyName: user.agencyName ?? '',
  profileImage: user.profileImage ?? 'assets/images/generic_avatar.png',
  isVerified: user.isVerified ?? false,
  isActive: user.isActive ?? true,
  managedUnits: user.managedUnits ?? 0,
  closingsCount: user.closingsCount ?? 0,
  createdAt: user.createdAt,
});

// @desc    Platform-wide admin stats
// @route   GET /api/v1/admin/stats
// @access  Admin
export const getAdminStats = async (req: AuthRequest, res: Response, next: NextFunction) => {
  try {
    const [
      userCount,
      propertyCount,
      viewingCount,
      pendingUsers,
      hiddenProperties,
      recentUsers,
      recentProperties,
      recentViewings,
    ] = await Promise.all([
      User.countDocuments(),
      Property.countDocuments(),
      Viewing.countDocuments(),
      User.countDocuments({ $or: [{ isVerified: false }, { isActive: false }] }),
      Property.countDocuments({ isAvailable: false }),
      User.find().sort({ createdAt: -1 }).limit(3),
      Property.find().sort({ createdAt: -1 }).limit(3).populate('user', 'name'),
      Viewing.find().sort({ createdAt: -1 }).limit(3).populate('property').populate('client'),
    ]);

    const activityFeed: any[] = [];

    recentUsers.forEach((u) => {
      activityFeed.push({
        id: u._id,
        type: 'user',
        title: 'New user registered',
        description: `${u.name} (${u.email}) joined as ${u.role}`,
        time: formatTime(u.createdAt),
      });
    });

    recentProperties.forEach((p: any) => {
      activityFeed.push({
        id: p._id,
        type: 'property',
        title: 'Property listed',
        description: `"${p.title}" by ${p.user?.name ?? 'Agent'}`,
        time: formatTime(p.createdAt),
      });
    });

    recentViewings.forEach((v: any) => {
      activityFeed.push({
        id: v._id,
        type: 'viewing',
        title: 'Viewing logged',
        description: `${v.client?.name ?? 'Client'} viewed "${v.property?.title ?? 'Property'}"`,
        time: formatTime(v.createdAt),
      });
    });

    res.json({
      success: true,
      data: {
        userCount,
        propertyCount,
        viewingCount,
        pendingUsers,
        hiddenProperties,
        recentActivity: activityFeed.slice(0, 5),
      },
    });
  } catch (err) {
    next(err);
  }
};

// @desc    List all users (admin)
// @route   GET /api/v1/admin/users
// @access  Admin
export const getAdminUsers = async (req: AuthRequest, res: Response, next: NextFunction) => {
  try {
    const users = await User.find().select('-password').sort({ createdAt: -1 });
    res.json({
      success: true,
      count: users.length,
      data: users.map(serializeUser),
    });
  } catch (err) {
    next(err);
  }
};

// @desc    Update user status (admin)
// @route   PUT /api/v1/admin/users/:id
// @access  Admin
export const updateAdminUser = async (req: AuthRequest, res: Response, next: NextFunction) => {
  try {
    const user = await User.findById(req.params.id);
    if (!user) {
      res.status(404).json({ success: false, error: 'User not found' });
      return;
    }

    if (user._id.toString() === req.user?._id.toString()) {
      res.status(400).json({ success: false, error: 'Cannot modify your own admin account here' });
      return;
    }

    if (req.body.isActive !== undefined) user.isActive = req.body.isActive;
    if (req.body.isVerified !== undefined) user.isVerified = req.body.isVerified;

    await user.save();

    res.json({ success: true, data: serializeUser(user) });
  } catch (err) {
    next(err);
  }
};

// @desc    List all properties (admin)
// @route   GET /api/v1/admin/properties
// @access  Admin
export const getAdminProperties = async (req: AuthRequest, res: Response, next: NextFunction) => {
  try {
    const properties = await Property.find()
      .sort({ createdAt: -1 })
      .populate('user', 'name email');

    res.json({
      success: true,
      count: properties.length,
      data: properties.map((p: any) => ({
        id: p._id,
        title: p.title,
        description: p.description,
        location: p.location,
        imageUrl: p.imageUrl,
        price: p.price,
        beds: p.beds,
        baths: p.baths,
        sqft: p.sqft,
        isAvailable: p.isAvailable,
        tags: p.tags,
        agentName: p.user?.name ?? 'Unknown Agent',
        agentEmail: p.user?.email ?? '',
        createdAt: p.createdAt,
      })),
    });
  } catch (err) {
    next(err);
  }
};

// @desc    Update property availability (admin moderation)
// @route   PUT /api/v1/admin/properties/:id
// @access  Admin
export const updateAdminProperty = async (req: AuthRequest, res: Response, next: NextFunction) => {
  try {
    const property = await Property.findById(req.params.id).populate('user', 'name email');
    if (!property) {
      res.status(404).json({ success: false, error: 'Property not found' });
      return;
    }

    if (req.body.isAvailable !== undefined) {
      property.isAvailable = req.body.isAvailable;
    }

    await property.save();

    const p: any = property;
    res.json({
      success: true,
      data: {
        id: p._id,
        title: p.title,
        description: p.description,
        location: p.location,
        imageUrl: p.imageUrl,
        price: p.price,
        beds: p.beds,
        baths: p.baths,
        sqft: p.sqft,
        isAvailable: p.isAvailable,
        tags: p.tags,
        agentName: p.user?.name ?? 'Unknown Agent',
        agentEmail: p.user?.email ?? '',
        createdAt: p.createdAt,
      },
    });
  } catch (err) {
    next(err);
  }
};

// @desc    Delete property (admin)
// @route   DELETE /api/v1/admin/properties/:id
// @access  Admin
export const deleteAdminProperty = async (req: AuthRequest, res: Response, next: NextFunction) => {
  try {
    const property = await Property.findById(req.params.id);
    if (!property) {
      res.status(404).json({ success: false, error: 'Property not found' });
      return;
    }

    await property.deleteOne();
    await Viewing.deleteMany({ property: property._id });

    res.json({ success: true, message: 'Property removed' });
  } catch (err) {
    next(err);
  }
};
