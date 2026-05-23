import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'features/auth/screens/splash_screen.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/auth/screens/signup_screen.dart';
import 'features/property/screens/property_list_screen.dart';
import 'features/property/screens/add_property_screen.dart';
import 'features/property/screens/property_detail_screen.dart';
import 'features/property/domain/entities/property_entity.dart';
import 'features/client/screens/client_list_screen.dart';
import 'features/client/screens/client_detail_screen.dart';
import 'features/client/domain/entities/client_entity.dart';
import 'features/viewing/routes/viewing_routes.dart';
import 'features/dashboard/screens/home_dashboard.dart';
import 'features/profile/screens/profile_screen.dart';
import 'features/profile/screens/delete_account_screen.dart';
import 'features/profile/screens/personal_info_screen.dart';
import 'features/profile/screens/agency_details_screen.dart';
import 'features/tags/screens/tag_management_screen.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:afalagi/features/auth/providers/auth_provider.dart';

import 'core/widgets/shell_scaffold.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);
  
  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      // If authState is still loading or hasn't finished initial build, don't redirect yet
      if (authState.isLoading) return null;

      final isAuth = authState.value != null;
      
      final isSplash = state.uri.path == '/';
      final isLoggingIn = state.uri.path == '/login';
      final isSigningUp = state.uri.path == '/signup';

      if (!isAuth) {
        if (!isLoggingIn && !isSigningUp && !isSplash) {
          return '/login';
        }
      } else {
        if (isLoggingIn || isSigningUp || isSplash) {
          return '/dashboard';
        }
      }
      return null;
    },
    routes: [
      GoRoute(path: '/', builder: (context, state) => const SplashScreen()),
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(
        path: '/signup',
        builder: (context, state) => const SignupScreen(),
      ),

      ShellRoute(
        builder: (context, state, child) => ShellScaffold(child: child),
        routes: [
          GoRoute(
            path: '/dashboard',
            builder: (context, state) => const DashboardScreen(),
          ),
          GoRoute(
            path: '/properties',
            builder: (context, state) => const PropertyListScreen(),
          ),
          GoRoute(
            path: '/property-detail',
            builder: (context, state) =>
                PropertyDetailScreen(property: state.extra as PropertyEntity),
          ),
          GoRoute(
            path: '/add-property',
            builder: (context, state) => const AddPropertyScreen(),
          ),
          GoRoute(
            path: '/edit-property',
            builder: (context, state) =>
                AddPropertyScreen(property: state.extra as PropertyEntity),
          ),
          GoRoute(
            path: '/clients',
            builder: (context, state) => const ClientListScreen(),
          ),
          GoRoute(
            path: '/client-detail',
            builder: (context, state) =>
                ClientDetailScreen(client: state.extra as ClientEntity),
          ),
          ...ViewingRoutes.routes,
          GoRoute(
            path: '/profile',
            builder: (context, state) => const ProfileScreen(),
          ),
          GoRoute(
            path: '/delete-account',
            builder: (context, state) => const DeleteAccountScreen(),
          ),
          GoRoute(
            path: '/personal-info',
            builder: (context, state) => const PersonalInfoScreen(),
          ),
          GoRoute(
            path: '/agency-details',
            builder: (context, state) => const AgencyDetailsScreen(),
          ),
          GoRoute(
            path: '/tag-management',
            builder: (context, state) => const TagManagementScreen(),
          ),
        ],
      ),
    ],
  );
});
