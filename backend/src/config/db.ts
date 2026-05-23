import mongoose from 'mongoose';

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
  } catch (err: any) {
    console.error(`Error: ${err.message}`);
    process.exit(1);
  }
};

export default connectDB;