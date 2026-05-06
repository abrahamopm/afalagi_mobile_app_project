import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'features/auth/screens/splash_screen.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/auth/screens/signup_screen.dart';
import 'features/property/screens/property_list_screen.dart';
import 'features/property/screens/add_property_screen.dart';
import 'features/property/screens/edit_property_screen.dart';
import 'features/property/screens/property_detail_screen.dart';
import 'features/property/models/property_model.dart';
import 'features/client/screens/client_list_screen.dart';
import 'features/client/screens/client_detail_screen.dart';
import 'features/client/models/client_model.dart';
import 'features/viewing/screens/log_viewing_screen.dart';
import 'features/viewing/screens/viewing_history_screen.dart';
import 'features/appointment/screens/dashboard_screen.dart';
import 'features/appointment/screens/appointment_screen.dart';
import 'features/appointment/screens/profile_screen.dart';
import 'features/appointment/screens/settings_screen.dart';
import 'features/appointment/screens/activity_log_screen.dart';
import 'core/widgets/shell_scaffold.dart';

class AppRoutes {
  static final GlobalKey<NavigatorState> _rootNavigatorKey =
      GlobalKey<NavigatorState>();
  static final GlobalKey<NavigatorState> _shellNavigatorKey =
      GlobalKey<NavigatorState>();

  static final router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (context, state) => const SplashScreen()),
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(
        path: '/signup',
        builder: (context, state) => const SignupScreen(),
      ),

      ShellRoute(
        navigatorKey: _shellNavigatorKey,
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
                PropertyDetailScreen(property: state.extra as Property),
          ),
          GoRoute(
            path: '/add-property',
            builder: (context, state) => const AddPropertyScreen(),
          ),
          GoRoute(
            path: '/edit-property',
            builder: (context, state) =>
                EditPropertyScreen(property: state.extra as Property),
          ),
          GoRoute(
            path: '/clients',
            builder: (context, state) => const ClientListScreen(),
          ),
          GoRoute(
            path: '/client-detail',
            builder: (context, state) =>
                ClientDetailScreen(client: state.extra as Client),
          ),
          GoRoute(
            path: '/log-viewing',
            builder: (context, state) {
              final args = state.extra as Map<String, dynamic>?;
              return LogViewingScreen(
                propertyId: args?['propertyId'],
                clientId: args?['clientId'],
              );
            },
          ),
          GoRoute(
            path: '/viewing-history',
            builder: (context, state) => const ViewingHistoryScreen(),
          ),
          GoRoute(
            path: '/appointments',
            builder: (context, state) => const AppointmentScreen(),
          ),
          GoRoute(
            path: '/profile',
            builder: (context, state) => const ProfileScreen(),
          ),
          GoRoute(
            path: '/settings',
            builder: (context, state) => const SettingsScreen(),
          ),
          GoRoute(
            path: '/activity-log',
            builder: (context, state) => const ActivityLogScreen(),
          ),
        ],
      ),
    ],
  );
}
