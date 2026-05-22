import { Request, Response, NextFunction } from 'express';
import jwt from 'jsonwebtoken';
import User, { IUser } from '../models/User';

export interface AuthRequest extends Request {
  user?: IUser;
}

export const protect = async (req: AuthRequest, res: Response, next: NextFunction) => {
  let token;

  if (
    req.headers.authorization &&
    req.headers.authorization.startsWith('Bearer')
  ) {
    try {
      token = req.headers.authorization.split(' ')[1];
      const jwtSecret = process.env.JWT_SECRET || 'fallback_secret_key_for_afalagi_app_2026';
      const decoded: any = jwt.verify(token, jwtSecret);

      const user = await User.findById(decoded.id);
      if (!user) {
        res.status(401).json({ success: false, error: 'Not authorized, user not found' });
        return;
      }

      req.user = user;
      next();
    } catch (error) {
      console.error(error);
      res.status(401).json({ success: false, error: 'Not authorized, token failed' });
    }
  } else {
    res.status(401).json({ success: false, error: 'Not authorized, no token' });
  }
};
