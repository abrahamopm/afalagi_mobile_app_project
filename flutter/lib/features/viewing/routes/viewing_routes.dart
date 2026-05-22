import 'package:afalagi/features/viewing/models/viewing_model.dart';
import 'package:afalagi/features/viewing/screens/viewing_history_screen.dart';
import 'package:afalagi/features/viewing/screens/log_viewing_screen.dart';
import 'package:go_router/go_router.dart';

class ViewingRoutes {
  static const String viewingHistory = '/viewing-history';
  static const String logViewing = '/log-viewing';

  static List<RouteBase> routes = [
    GoRoute(
      path: viewingHistory,
      builder: (context, state) {
        final args = state.extra as Map<String, dynamic>?;
        return ViewingHistoryScreen(
          propertyId: args?['propertyId'],
          clientId: args?['clientId'],
        );
      },
    ),
    GoRoute(
      path: logViewing,
      builder: (context, state) {
        if (state.extra is Viewing) {
          return LogViewingScreen(viewing: state.extra as Viewing);
        }
        final args = state.extra as Map<String, dynamic>?;
        return LogViewingScreen(
          propertyId: args?['propertyId'],
          clientId: args?['clientId'],
        );
      },
    ),
  ];
}
