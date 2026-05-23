import User from '../models/User';

export type EnsureAdminOptions = {
  /** When true, resets password from ADMIN_PASSWORD and refreshes admin flags. */
  forceUpdate?: boolean;
};

/**
 * Idempotent admin bootstrap.
 * - Creates admin if missing
 * - Promotes existing user to admin (role / active / verified)
 * - Optionally resets password when forceUpdate is true
 */
export const ensureAdminUser = async (options: EnsureAdminOptions = {}) => {
  const email = process.env.ADMIN_EMAIL || 'admin@afalagi.com';
  const password = process.env.ADMIN_PASSWORD || 'Admin123!';
  const name = process.env.ADMIN_NAME || 'Afalagi Admin';

  let user = await User.findOne({ email }).select('+password');

  if (!user) {
    await User.create({
      name,
      email,
      password,
      role: 'admin',
      isVerified: true,
      isActive: true,
    });
    console.log(`[seed] Admin account created: ${email}`);
    return { created: true, email };
  }

  let changed = false;

  if (user.role !== 'admin') {
    user.role = 'admin';
    changed = true;
  }
  if (!user.isActive) {
    user.isActive = true;
    changed = true;
  }
  if (!user.isVerified) {
    user.isVerified = true;
    changed = true;
  }
  if (user.name !== name) {
    user.name = name;
    changed = true;
  }

  if (options.forceUpdate) {
    user.password = password;
    changed = true;
  }

  if (changed) {
    await user.save();
    console.log(`[seed] Admin account updated: ${email}`);
  } else {
    console.log(`[seed] Admin account OK: ${email}`);
  }

  return { created: false, email };
};

/** Whether to run admin seed after DB connect. */
export const shouldSeedAdminOnStartup = (): boolean => {
  if (process.env.NODE_ENV === 'test') return false;
  if (process.env.SEED_ADMIN === 'false') return false;
  // Local dev always seeds; Render/production seeds unless explicitly disabled.
  if (process.env.NODE_ENV === 'development') return true;
  if (process.env.SEED_ADMIN === 'true') return true;
  // Convenient default for Render: seed on boot when Mongo is configured.
  if (process.env.NODE_ENV === 'production' && process.env.MONGODB_URI) return true;
  return false;
};

export const shouldForceAdminPasswordUpdate = (): boolean =>
  process.env.NODE_ENV === 'development' || process.env.SEED_ADMIN === 'true';
