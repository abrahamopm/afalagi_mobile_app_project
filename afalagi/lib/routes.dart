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

class AppRoutes {
  static const String initial = '/';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String dashboard = '/dashboard';
  static const String properties = '/properties';
  static const String propertyDetail = '/property-detail';
  static const String addProperty = '/add-property';
  static const String editProperty = '/edit-property';
  static const String clients = '/clients';
  static const String clientDetail = '/client-detail';
  static const String logViewing = '/log-viewing';
  static const String viewingHistory = '/viewing-history';
  static const String appointments = '/appointments';
  static const String profile = '/profile';
  static const String settings = '/settings';
  static const String activityLog = '/activity-log';

  static final router = GoRouter(
    initialLocation: properties,
    routes: [
      GoRoute(path: initial, builder: (context, state) => const SplashScreen()),
      GoRoute(path: login, builder: (context, state) => const LoginScreen()),
      GoRoute(path: signup, builder: (context, state) => const SignupScreen()),
      GoRoute(
        path: dashboard,
        builder: (context, state) => const DashboardScreen(),
      ),
      GoRoute(
        path: properties,
        builder: (context, state) => const PropertyListScreen(),
      ),
      GoRoute(
        path: propertyDetail,
        builder: (context, state) {
          final property = state.extra as Property;
          return PropertyDetailScreen(property: property);
        },
      ),
      GoRoute(
        path: addProperty,
        builder: (context, state) => const AddPropertyScreen(),
      ),
      GoRoute(
        path: editProperty,
        builder: (context, state) {
          final property = state.extra as Property;
          return EditPropertyScreen(property: property);
        },
      ),
      GoRoute(
        path: clients,
        builder: (context, state) => const ClientListScreen(),
      ),
      GoRoute(
        path: clientDetail,
        builder: (context, state) {
          final client = state.extra as Client;
          return ClientDetailScreen(client: client);
        },
      ),
      GoRoute(
        path: logViewing,
        builder: (context, state) {
          final args = state.extra as Map<String, dynamic>?;
          return LogViewingScreen(
            propertyId: args?['propertyId'],
            clientId: args?['clientId'],
          );
        },
      ),
      GoRoute(
        path: viewingHistory,
        builder: (context, state) => const ViewingHistoryScreen(),
      ),
      GoRoute(
        path: appointments,
        builder: (context, state) => const AppointmentScreen(),
      ),
      GoRoute(
        path: profile,
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: settings,
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: activityLog,
        builder: (context, state) => const ActivityLogScreen(),
      ),
    ],
  );
}
