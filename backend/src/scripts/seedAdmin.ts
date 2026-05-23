/**
 * Standalone admin seed (same logic as server startup).
 *
 * Usage (from /backend):
 *   npm run seed
 */
import '../config/env';
import mongoose from 'mongoose';
import { ensureAdminUser } from '../utils/ensureAdminUser';

async function main() {
  const mongoUri = process.env.MONGODB_URI;

  if (!mongoUri) {
    console.error(
      '\n[seed] MONGODB_URI is not set.\n' +
        '  1. Copy .env.example to .env\n' +
        '  2. Set MONGODB_URI (local: mongodb://127.0.0.1:27017/afalagi)\n' +
        '  3. Run: npm run seed\n',
    );
    process.exit(1);
  }

  try {
    await mongoose.connect(mongoUri, { connectTimeoutMS: 8000, serverSelectionTimeoutMS: 8000 } as any);
    console.log('[seed] Connected to MongoDB');

    const result = await ensureAdminUser({ forceUpdate: true });
    const password = process.env.ADMIN_PASSWORD || 'Admin123!';

    console.log(
      `[seed] Done. Login with:\n  Email:    ${result.email}\n  Password: ${password}\n`,
    );
  } catch (err: any) {
    if (err.name === 'MongooseServerSelectionError') {
      console.error(
        '\n[seed] Cannot reach MongoDB.\n' +
          '  • Start MongoDB locally, or\n' +
          '  • Use a cloud URI (Atlas / Render MongoDB) in MONGODB_URI\n',
      );
    } else {
      console.error('[seed] Error:', err.message ?? err);
    }
    process.exit(1);
  } finally {
    await mongoose.disconnect().catch(() => undefined);
  }
}

main();
