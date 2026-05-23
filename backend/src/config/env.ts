import fs from 'fs';
import path from 'path';
import dotenv from 'dotenv';

/** Backend package root (`/backend`), works from `src/` and compiled `dist/`. */
export const backendRoot = path.resolve(__dirname, '../..');

const envPath = path.join(backendRoot, '.env');
const envLocalPath = path.join(backendRoot, '.env.local');

// `.env.local` overrides `.env` (optional, gitignored).
if (fs.existsSync(envPath)) {
  dotenv.config({ path: envPath });
}
if (fs.existsSync(envLocalPath)) {
  dotenv.config({ path: envLocalPath, override: true });
}

if (!fs.existsSync(envPath) && !fs.existsSync(envLocalPath) && process.env.NODE_ENV !== 'production') {
  console.warn(
    `[env] No .env file at ${envPath}. Copy .env.example to .env or set variables in your shell / Render dashboard.`,
  );
}
