import request from 'supertest';
import mongoose from 'mongoose';
import { MongoMemoryServer } from 'mongodb-memory-server';
import app from '../src/app';
import User from '../src/models/User';

let mongoServer: MongoMemoryServer;

beforeAll(async () => {
  mongoServer = await MongoMemoryServer.create();
  const uri = mongoServer.getUri();
  await mongoose.connect(uri);
});

afterAll(async () => {
  await mongoose.disconnect();
  await mongoServer.stop();
});

beforeEach(async () => {
  await User.deleteMany({});
});

describe('User API', () => {
  describe('POST /api/v1/users', () => {
    it('should create a new user', async () => {
      const userData = {
        name: 'John Doe',
        email: 'john@example.com',
        password: 'password123'
      };

      const res = await request(app)
        .post('/api/v1/users')
        .send(userData);

      expect(res.status).toBe(201);
      expect(res.body.success).toBe(true);
      expect(res.body.data.name).toBe(userData.name);
      expect(res.body.data.email).toBe(userData.email);
      expect(res.body.data.password).toBeUndefined(); // Should be select: false

      // Verify hashed password in DB
      const user = await User.findOne({ email: userData.email }).select('+password');
      expect(user?.password).toBeDefined();
      expect(user?.password).not.toBe(userData.password);
    });

    it('should not create a user with duplicate email', async () => {
      const userData = {
        name: 'John Doe',
        email: 'john@example.com',
        password: 'password123'
      };

      await User.create(userData);

      const res = await request(app)
        .post('/api/v1/users')
        .send(userData);

      expect(res.status).toBe(400);
      expect(res.body.success).toBe(false);
      expect(res.body.error).toBe('Duplicate field value entered');
    });

    it('should not create a user with invalid email', async () => {
      const userData = {
        name: 'John Doe',
        email: 'invalid-email',
        password: 'password123'
      };

      const res = await request(app)
        .post('/api/v1/users')
        .send(userData);

      expect(res.status).toBe(400);
      expect(res.body.success).toBe(false);
      expect(res.body.error).toContain('Please add a valid email');
    });

    it('should NOT allow setting role to admin', async () => {
      const userData = {
        name: 'Admin User',
        email: 'admin@example.com',
        password: 'password123',
        role: 'admin'
      };

      const res = await request(app)
        .post('/api/v1/users')
        .send(userData);

      expect(res.status).toBe(201);
      expect(res.body.data.role).toBe('user'); // Should default to user
    });
  });

  describe('GET /api/v1/users', () => {
    it('should get all users', async () => {
      await User.create([
        { name: 'User 1', email: 'user1@example.com', password: 'password123' },
        { name: 'User 2', email: 'user2@example.com', password: 'password123' }
      ]);

      const res = await request(app).get('/api/v1/users');

      expect(res.status).toBe(200);
      expect(res.body.success).toBe(true);
      expect(res.body.count).toBe(2);
      expect(res.body.data).toHaveLength(2);
    });
  });
});
