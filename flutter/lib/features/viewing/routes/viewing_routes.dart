import 'package:afalagi/features/viewing/domain/entities/viewing_entity.dart';
import 'package:afalagi/features/viewing/screens/viewing_history_screen.dart';
import 'package:afalagi/features/viewing/screens/log_viewing_screen.dart';
import 'package:go_router/go_router.dart';

class ViewingRoutes {
  static const String viewingHistory = '/viewings';
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
        if (state.extra is ViewingEntity) {
          return LogViewingScreen(viewing: state.extra as ViewingEntity);
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
