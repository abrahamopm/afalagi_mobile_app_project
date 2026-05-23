import mongoose from 'mongoose';
import User from '../models/User';

const seedAdmin = async () => {
  const email = process.env.ADMIN_EMAIL || 'admin@afalagi.com';
  const password = process.env.ADMIN_PASSWORD || 'Admin123!';
  const name = process.env.ADMIN_NAME || 'Afalagi Admin';

  try {
    const adminExists = await User.findOne({ email });
    if (!adminExists) {
      await User.create({
        name,
        email,
        password,
        role: 'admin',
        isVerified: true,
        isActive: true,
      });
      console.log(`Default admin created: ${email}`);
    }
  } catch (error) {
    console.error('Error seeding admin:', error);
  }
};

const connectDB = async () => {
  try {
    let mongoUri = process.env.MONGODB_URI;
    if (!mongoUri) {
      console.log('MONGODB_URI is not defined. Initializing mongodb-memory-server...');
      try {
        // Dynamically import/require mongodb-memory-server
        const { MongoMemoryServer } = require('mongodb-memory-server');
        const mongoServer = await MongoMemoryServer.create();
        mongoUri = mongoServer.getUri();
        console.log(`In-memory MongoDB Server running at: ${mongoUri}`);
      } catch (memErr: any) {
        throw new Error(`MONGODB_URI is missing, and failed to start MongoMemoryServer: ${memErr.message}`);
      }
    }
    const conn = await mongoose.connect(mongoUri!);
    console.log(`MongoDB Connected: ${conn.connection.host}`);

    // Seed admin for development
    if (process.env.NODE_ENV === 'development') {
      await seedAdmin();
    }
  } catch (err: any) {
    console.error(`Error: ${err.message}`);
    process.exit(1);
  }
};

export default connectDB;