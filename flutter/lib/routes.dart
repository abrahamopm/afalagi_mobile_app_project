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
import 'features/viewing/routes/viewing_routes.dart';
import 'features/dashboard/screens/home_dashboard.dart';
import 'features/profile management/screens/profile_screen.dart';
import 'features/profile management/screens/delete_account_screen.dart';
import 'features/profile management/screens/personal_info_screen.dart';
import 'features/profile management/screens/agency_details_screen.dart';
import 'features/tags/screens/tag_management_screen.dart';

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
}
