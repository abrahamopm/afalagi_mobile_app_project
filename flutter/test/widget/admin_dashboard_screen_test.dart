import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:afalagi/core/usecases/usecase.dart';
import 'package:afalagi/features/admin/data/models/admin_stats_model.dart';
import 'package:afalagi/features/admin/domain/usecases/get_admin_stats.dart';
import 'package:afalagi/features/admin/domain/entities/admin_property_item.dart';
import 'package:afalagi/features/admin/domain/entities/admin_stats.dart';
import 'package:afalagi/features/admin/domain/entities/admin_user_summary.dart';
import 'package:afalagi/features/admin/domain/repositories/admin_repository.dart';
import 'package:afalagi/features/admin/providers/admin_provider.dart';
import 'package:afalagi/features/admin/screens/admin_dashboard_screen.dart';
import 'package:afalagi/features/auth/data/models/user_model.dart';
import 'package:afalagi/features/auth/domain/usecases/get_current_user.dart';
import 'package:afalagi/features/auth/providers/auth_provider.dart';

class DummyAdminRepository implements AdminRepository {
  final AdminStats stats;

  DummyAdminRepository(this.stats);

  @override
  Future<AdminStats> getStats() async => stats;

  @override
  Future<List<AdminUserSummary>> getUsers() async => throw UnimplementedError();

  @override
  Future<AdminUserSummary> updateUser(
    String id, {
    bool? isActive,
    bool? isVerified,
  }) async =>
      throw UnimplementedError();

  @override
  Future<List<AdminPropertyItem>> getProperties() async =>
      throw UnimplementedError();

  @override
  Future<AdminPropertyItem> updateProperty(String id, {bool? isAvailable}) async =>
      throw UnimplementedError();

  @override
  Future<void> deleteProperty(String id) async => throw UnimplementedError();
}

class MockGetCurrentUser extends Mock implements GetCurrentUser {}

void main() {
  setUpAll(() {
    registerFallbackValue(const NoParams());
  });

  late MockGetCurrentUser mockGetCurrentUser;

  final tStats = AdminStatsModel(
    userCount: 10,
    propertyCount: 25,
    viewingCount: 50,
    pendingUsers: 2,
    hiddenProperties: 1,
    recentActivity: const [
      AdminActivityModel(
        id: '1',
        type: 'user',
        title: 'New Agent',
        description: 'Agent joined platform',
        time: '1h ago',
      ),
    ],
  );

  setUp(() {
    mockGetCurrentUser = MockGetCurrentUser();
  });

  testWidgets('AdminDashboardScreen displays stats and welcome header', (
    WidgetTester tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(1200, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    const tAdmin = UserModel(
      id: 'admin_1',
      name: 'Admin User',
      email: 'admin@example.com',
      role: 'admin',
    );
    when(() => mockGetCurrentUser(any())).thenAnswer((_) async => tAdmin);

    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) =>
              const Scaffold(body: AdminDashboardScreen()),
        ),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          getAdminStatsUseCaseProvider.overrideWithValue(
            GetAdminStats(DummyAdminRepository(tStats)),
          ),
          getMeUseCaseProvider.overrideWithValue(mockGetCurrentUser),
        ],
        child: MaterialApp.router(routerConfig: router),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Hello, Admin User'), findsOneWidget);
    expect(find.text('TOTAL USERS'), findsOneWidget);
    expect(find.text('10'), findsOneWidget);
    expect(find.text('ACTIVE PROPERTIES'), findsOneWidget);
    expect(find.text('25'), findsOneWidget);
    expect(find.text('TOTAL VIEWINGS'), findsOneWidget);
    expect(find.text('50'), findsOneWidget);
    expect(find.text('Review Pending Users'), findsOneWidget);
    expect(find.text('New Agent'), findsOneWidget);
  });
}
