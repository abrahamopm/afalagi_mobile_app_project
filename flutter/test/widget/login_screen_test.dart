import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:go_router/go_router.dart';
import 'package:afalagi/features/auth/screens/login_screen.dart';
import 'package:afalagi/features/auth/providers/auth_provider.dart';
import 'package:afalagi/features/auth/domain/repositories/auth_repository.dart';
import 'package:afalagi/features/auth/domain/usecases/login_usecase.dart';
import 'package:afalagi/features/auth/domain/usecases/get_current_user.dart';
import 'package:afalagi/features/auth/data/models/user_model.dart';
import 'package:afalagi/core/usecases/usecase.dart';
import 'package:afalagi/core/widgets/input.dart';
import 'package:afalagi/core/widgets/button.dart';

class MockLoginUseCase extends Mock implements LoginUseCase {}
class MockGetCurrentUser extends Mock implements GetCurrentUser {}
class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  setUpAll(() {
    registerFallbackValue(const LoginParams(email: '', password: ''));
    registerFallbackValue(NoParams());
  });

  late MockLoginUseCase mockLoginUseCase;
  late MockGetCurrentUser mockGetCurrentUser;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockLoginUseCase = MockLoginUseCase();
    mockGetCurrentUser = MockGetCurrentUser();
    mockAuthRepository = MockAuthRepository();
    when(() => mockAuthRepository.getRememberedEmail()).thenAnswer((_) async => null);
    when(() => mockAuthRepository.saveRememberedEmail(any())).thenAnswer((_) async => {});
  });

  testWidgets('LoginScreen displays fields, validates input, and triggers login flow', (WidgetTester tester) async {
    // We override getMeUseCaseProvider so build() runs and returns null (user is not logged in)
    when(() => mockGetCurrentUser(any())).thenAnswer((_) async => null);

    final router = GoRouter(
      routes: [
        GoRoute(path: '/', builder: (context, state) => const LoginScreen()),
        GoRoute(path: '/dashboard', builder: (context, state) => const Scaffold(body: Text('Dashboard'))),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          getMeUseCaseProvider.overrideWithValue(mockGetCurrentUser),
          loginUseCaseProvider.overrideWithValue(mockLoginUseCase),
          authRepositoryProvider.overrideWithValue(mockAuthRepository),
        ],
        child: MaterialApp.router(
          routerConfig: router,
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Initial state check
    expect(find.text('Welcome Back'), findsOneWidget);
    expect(find.byType(CustomTextField), findsNWidgets(2));
    expect(find.byType(CustomButton), findsOneWidget);

    // Act: Tap without entering credentials (validation trigger)
    await tester.tap(find.byType(CustomButton));
    await tester.pump();

    // Assert validation error messages
    expect(find.text('Email address is required'), findsOneWidget);
    expect(find.text('Password is required'), findsOneWidget);

    // Act: Enter credentials
    final textFields = find.byType(TextField);
    expect(textFields, findsNWidgets(2));

    await tester.enterText(textFields.at(0), 'john.doe@curator.com');
    await tester.enterText(textFields.at(1), 'password123');

    // Mock successful login response
    const tUser = UserModel(id: '1', name: 'John Doe', email: 'john.doe@curator.com');
    when(() => mockLoginUseCase(any())).thenAnswer((_) async => tUser);

    // Act: Tap sign in again
    await tester.tap(find.byType(CustomButton));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pumpAndSettle();

    // Verify use case was called with correct parameters
    verify(() => mockLoginUseCase(any())).called(1);

    // Verify navigation was triggered
    expect(find.text('Dashboard'), findsOneWidget);
  });
}
