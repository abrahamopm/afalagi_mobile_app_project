import jwt from 'jsonwebtoken';

const generateToken = (id: string): string => {
  const jwtSecret = process.env.JWT_SECRET || 'fallback_secret_key_for_afalagi_app_2026';
  return jwt.sign({ id }, jwtSecret, {
    expiresIn: '30d',
  });
};

export default generateToken;
