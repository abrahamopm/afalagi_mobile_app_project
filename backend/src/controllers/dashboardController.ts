import { Response, NextFunction } from 'express';
import Property from '../models/Property';
import Client from '../models/Client';
import Viewing from '../models/Viewing';
import { AuthRequest } from '../middleware/authMiddleware';

// @desc    Get dashboard metrics & activity feed
// @route   GET /api/v1/dashboard/stats
// @access  Private
export const getDashboardStats = async (req: AuthRequest, res: Response, next: NextFunction) => {
  try {
    const userId = req.user?._id;

    // Get simple counts
    const propertyCount = await Property.countDocuments({ user: userId });
    const clientCount = await Client.countDocuments({ user: userId });
    const viewingCount = await Viewing.countDocuments({ user: userId });

    // Count viewings scheduled for today (matches the viewing date field, not createdAt)
    const today = new Date();
    const todayStr = today.toISOString().split('T')[0];
    const todayViewingCount = await Viewing.countDocuments({
      user: userId,
      date: { $regex: `^${todayStr}` },
    });

    // Generate recent activity list dynamically by combining recent items
    const [recentProperties, recentClients, recentViewings] = await Promise.all([
      Property.find({ user: userId }).sort({ createdAt: -1 }).limit(3),
      Client.find({ user: userId }).sort({ createdAt: -1 }).limit(3),
      Viewing.find({ user: userId }).sort({ createdAt: -1 }).populate('property').populate('client').limit(3),
    ]);

    const activityFeed: any[] = [];

    recentProperties.forEach((p) => {
      activityFeed.push({
        id: p._id,
        type: 'property',
        title: 'New property listed',
        description: `Listed "${p.title}" for $${p.price.toLocaleString()}`,
        time: p.createdAt,
      });
    });

    recentClients.forEach((c) => {
      activityFeed.push({
        id: c._id,
        type: 'client',
        title: 'Lead added',
        description: `Added client "${c.name}" with priority ${c.priority}`,
        time: c.createdAt,
      });
    });

    recentViewings.forEach((v: any) => {
      activityFeed.push({
        id: v._id,
        type: 'viewing',
        title: 'Viewing logged',
        description: `Logged viewing for "${v.client?.name || 'Client'}" showing "${v.property?.title || 'Property'}"`,
        time: v.createdAt,
      });
    });

    // Sort combined activities by date descending
    activityFeed.sort((a, b) => new Date(b.time).getTime() - new Date(a.time).getTime());

    // Limit to top 5 recent activities
    const finalActivityFeed = activityFeed.slice(0, 5);

    res.json({
      success: true,
      data: {
        propertyCount,
        clientCount,
        viewingCount,
        todayViewingCount,
        recentActivity: finalActivityFeed,
      },
    });
  } catch (err) {
    next(err);
  }
};
