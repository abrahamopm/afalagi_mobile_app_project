import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:afalagi/core/usecases/usecase.dart';
import 'package:afalagi/core/widgets/button.dart';
import 'package:afalagi/core/widgets/input.dart';
import 'package:afalagi/features/auth/data/models/user_model.dart';
import 'package:afalagi/features/auth/domain/usecases/get_current_user.dart';
import 'package:afalagi/features/auth/domain/usecases/signup_usecase.dart';
import 'package:afalagi/features/auth/providers/auth_provider.dart';
import 'package:afalagi/features/auth/screens/signup_screen.dart';

class MockSignupUseCase extends Mock implements SignupUseCase {}

class MockGetCurrentUser extends Mock implements GetCurrentUser {}

void main() {
  setUpAll(() {
    registerFallbackValue(const SignupParams(
      name: '',
      email: '',
      password: '',
    ));
    registerFallbackValue(const NoParams());
  });

  late MockSignupUseCase mockSignupUseCase;
  late MockGetCurrentUser mockGetCurrentUser;

  setUp(() {
    mockSignupUseCase = MockSignupUseCase();
    mockGetCurrentUser = MockGetCurrentUser();
  });

  testWidgets('SignupScreen displays fields, validates input, and triggers signup flow',
      (WidgetTester tester) async {
    when(() => mockGetCurrentUser(any())).thenAnswer((_) async => null);

    final router = GoRouter(
      routes: [
        GoRoute(path: '/', builder: (context, state) => const SignupScreen()),
        GoRoute(
          path: '/dashboard',
          builder: (context, state) => const Scaffold(body: Text('Dashboard')),
        ),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          getMeUseCaseProvider.overrideWithValue(mockGetCurrentUser),
          signupUseCaseProvider.overrideWithValue(mockSignupUseCase),
        ],
        child: MaterialApp.router(routerConfig: router),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Create Account'), findsOneWidget);
    expect(find.byType(CustomTextField), findsNWidgets(6));
    expect(find.byType(CustomButton), findsOneWidget);

    final signUpButton = find.byType(CustomButton);
    await tester.ensureVisible(signUpButton);
    await tester.tap(signUpButton);
    await tester.pumpAndSettle();

    expect(find.text('Full name is required'), findsOneWidget);
    expect(find.text('Email address is required'), findsOneWidget);
    expect(find.text('Password is required'), findsOneWidget);

    final textFields = find.byType(TextFormField);
    await tester.enterText(textFields.at(0), 'Kaleab Mulugeta');
    await tester.enterText(textFields.at(1), 'kalili@gmail.com');
    await tester.enterText(textFields.at(2), 'password123');

    await tester.ensureVisible(signUpButton);
    await tester.tap(signUpButton);
    await tester.pumpAndSettle();

    expect(
      find.text('Please agree to the Terms of Service'),
      findsOneWidget,
    );

    await tester.tap(find.byType(Checkbox));
    await tester.pump();

    const tUser = UserModel(
      id: '1',
      name: 'Kaleab Mulugeta',
      email: 'kalili@gmail.com',
    );
    when(() => mockSignupUseCase(any())).thenAnswer((_) async => tUser);

    await tester.ensureVisible(signUpButton);
    await tester.tap(signUpButton);
    await tester.pumpAndSettle();

    verify(() => mockSignupUseCase(any())).called(1);
    expect(find.text('Dashboard'), findsOneWidget);
  });
}
