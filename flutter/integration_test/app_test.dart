import 'package:integration_test/integration_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:afalagi/main.dart';
import 'package:afalagi/features/auth/screens/splash_screen.dart';
import 'package:afalagi/features/auth/screens/login_screen.dart';
import 'package:afalagi/features/auth/screens/signup_screen.dart';
import 'package:afalagi/features/auth/providers/auth_provider.dart';
import 'package:afalagi/features/auth/domain/repositories/auth_repository.dart';
import 'package:afalagi/features/auth/domain/usecases/get_current_user.dart';
import 'package:afalagi/features/auth/domain/usecases/login_usecase.dart';
import 'package:afalagi/core/usecases/usecase.dart';
import 'package:afalagi/features/property/screens/property_list_screen.dart';
import 'package:afalagi/features/client/screens/client_list_screen.dart';
import 'package:afalagi/features/admin/screens/admin_dashboard_screen.dart';
import 'package:afalagi/features/property/providers/property_provider.dart';
import 'package:afalagi/features/client/providers/client_provider.dart';
import 'package:afalagi/features/admin/providers/admin_provider.dart';
import 'package:afalagi/features/property/domain/repositories/property_repository.dart';
import 'package:afalagi/features/client/domain/repositories/client_repository.dart';
import 'package:afalagi/features/admin/domain/repositories/admin_repository.dart';
import 'package:afalagi/features/property/domain/entities/property_entity.dart';
import 'package:afalagi/features/client/domain/entities/client_entity.dart';
import 'package:afalagi/features/admin/domain/entities/admin_stats.dart';
import 'package:afalagi/features/tags/screens/tag_management_screen.dart';
import 'package:afalagi/features/tags/providers/tag_provider.dart';
import 'package:afalagi/features/tags/domain/repositories/tag_repository.dart';
import 'package:afalagi/features/tags/domain/entities/tag_entity.dart';

class MockAuthRepository extends Mock implements AuthRepository {}
class MockGetCurrentUser extends Mock implements GetCurrentUser {}
class MockLoginUseCase extends Mock implements LoginUseCase {}
class MockPropertyRepository extends Mock implements PropertyRepository {}
class MockClientRepository extends Mock implements ClientRepository {}
class MockAdminRepository extends Mock implements AdminRepository {}
class MockTagRepository extends Mock implements TagRepository {}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    registerFallbackValue(const LoginParams(email: '', password: ''));
    registerFallbackValue(NoParams());
    registerFallbackValue(const PropertyEntity(
      id: '', title: '', description: '', location: '',
      imageUrl: '', price: 0, beds: 0, baths: 0, sqft: 0,
    ));
    registerFallbackValue(const ClientEntity(id: '', name: '', phone: ''));
  });

  testWidgets('splash screen redirects to login when unauthenticated',
      (tester) async {
    final mockGetMe = MockGetCurrentUser();
    when(() => mockGetMe(any())).thenAnswer((_) async => null);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [getMeUseCaseProvider.overrideWithValue(mockGetMe)],
        child: const AfalagiApp(),
      ),
    );

    expect(find.byType(SplashScreen), findsOneWidget);
    await tester.pumpAndSettle(const Duration(seconds: 4));
    expect(find.byType(LoginScreen), findsOneWidget);
    expect(find.text('Welcome Back'), findsOneWidget);
  });

  testWidgets('login screen navigates to signup', (tester) async {
    final mockAuthRepo = MockAuthRepository();
    when(() => mockAuthRepo.getRememberedEmail()).thenAnswer((_) async => null);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [authRepositoryProvider.overrideWithValue(mockAuthRepo)],
        child: const MaterialApp(home: LoginScreen()),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Sign Up'));
    await tester.pumpAndSettle();
    expect(find.byType(SignupScreen), findsOneWidget);
    expect(find.text('Create Account'), findsOneWidget);
  });

  testWidgets('authenticated agent sees property and client screens',
      (tester) async {
    final mockPropertyRepo = MockPropertyRepository();
    final mockClientRepo = MockClientRepository();

    when(() => mockPropertyRepo.getAll()).thenAnswer((_) async => [
      const PropertyEntity(
        id: '1', title: 'Test Villa', description: 'Nice',
        location: 'Addis', imageUrl: '', price: 500000,
        beds: 3, baths: 2, sqft: 1500,
      ),
    ]);
    when(() => mockClientRepo.getAll()).thenAnswer((_) async => [
      const ClientEntity(id: '1', name: 'Jane Doe', phone: '+251911111111'),
    ]);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          propertyRepositoryProvider.overrideWithValue(mockPropertyRepo),
          clientRepositoryProvider.overrideWithValue(mockClientRepo),
        ],
        child: const MaterialApp(home: PropertyListScreen()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Test Villa'), findsOneWidget);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          propertyRepositoryProvider.overrideWithValue(mockPropertyRepo),
          clientRepositoryProvider.overrideWithValue(mockClientRepo),
        ],
        child: const MaterialApp(home: ClientListScreen()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Jane Doe'), findsOneWidget);
  });

  testWidgets('admin dashboard displays stats', (tester) async {
    final mockAdminRepo = MockAdminRepository();
    when(() => mockAdminRepo.getStats()).thenAnswer((_) async => const AdminStats(
      userCount: 10,
      propertyCount: 25,
      viewingCount: 50,
      pendingUsers: 2,
      hiddenProperties: 3,
      recentActivity: [],
    ));

    await tester.pumpWidget(
      ProviderScope(
        overrides: [adminRepositoryProvider.overrideWithValue(mockAdminRepo)],
        child: const MaterialApp(home: AdminDashboardScreen()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(AdminDashboardScreen), findsOneWidget);
  });

  testWidgets('tag management screen displays tags', (tester) async {
    final mockTagRepo = MockTagRepository();
    when(() => mockTagRepo.getAll()).thenAnswer((_) async => [
      const TagEntity(id: '1', name: 'Luxury', color: '#1B385E'),
    ]);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [tagRepositoryProvider.overrideWithValue(mockTagRepo)],
        child: const MaterialApp(home: TagManagementScreen()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Luxury'), findsOneWidget);
    expect(find.text('Create New Tag'), findsOneWidget);
  });
}
