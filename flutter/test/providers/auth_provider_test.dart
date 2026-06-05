import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:afalagi/features/auth/providers/auth_provider.dart';
import 'package:afalagi/features/auth/domain/usecases/login_usecase.dart';
import 'package:afalagi/features/auth/domain/usecases/get_current_user.dart';
import 'package:afalagi/features/auth/data/models/user_model.dart';
import 'package:afalagi/core/usecases/usecase.dart';

class MockLoginUseCase extends Mock implements LoginUseCase {}
class MockGetCurrentUser extends Mock implements GetCurrentUser {}

void main() {
  setUpAll(() {
    registerFallbackValue(const LoginParams(email: '', password: ''));
    registerFallbackValue(NoParams());
  });

  late MockLoginUseCase mockLoginUseCase;
  late MockGetCurrentUser mockGetCurrentUser;

  setUp(() {
    mockLoginUseCase = MockLoginUseCase();
    mockGetCurrentUser = MockGetCurrentUser();
  });

  test('AuthNotifier transitions state from loading to AsyncData(null) on initialization when not logged in', () async {
    // arrange
    when(() => mockGetCurrentUser(any())).thenAnswer((_) async => null);

    // Create a new ProviderContainer for the test. Disposing it cleans up any running providers.
    final container = ProviderContainer(
      overrides: [
        getMeUseCaseProvider.overrideWithValue(mockGetCurrentUser),
      ],
    );
    addTearDown(container.dispose);

    // Collect states in a list
    final states = <AsyncValue<UserModel?>>[];
    container.listen(
      authStateProvider,
      (previous, next) => states.add(next),
      fireImmediately: true,
    );

    // Assert: Initially, it should start in AsyncLoading state
    expect(states[0], isA<AsyncLoading<UserModel?>>());

    // Wait for the asynchronous build() to finish
    await container.read(authStateProvider.future);

    // Assert: After loading, it transitions to AsyncData(null)
    expect(states.length, equals(2));
    expect(states[1], const AsyncValue<UserModel?>.data(null));
  });

  test('AuthNotifier transitions state on successful login', () async {
    const tUser = UserModel(id: '1', name: 'John Doe', email: 'john@example.com');
    when(() => mockGetCurrentUser(any())).thenAnswer((_) async => null);
    when(() => mockLoginUseCase(any())).thenAnswer((_) async => tUser);

    final container = ProviderContainer(
      overrides: [
        getMeUseCaseProvider.overrideWithValue(mockGetCurrentUser),
        loginUseCaseProvider.overrideWithValue(mockLoginUseCase),
      ],
    );
    addTearDown(container.dispose);

    // Wait for initial build to complete
    await container.read(authStateProvider.future);

    final states = <AsyncValue<UserModel?>>[];
    container.listen(
      authStateProvider,
      (previous, next) => states.add(next),
      fireImmediately: true,
    );

    // Initial state is now AsyncData(null)
    expect(states[0], const AsyncValue<UserModel?>.data(null));

    // Trigger login
    final notifier = container.read(authStateProvider.notifier);
    final loginFuture = notifier.login('john@example.com', 'password123');

    // Wait for the login logic to execute
    await loginFuture;

    // Assert transitions:
    // 1. From AsyncData(null) to AsyncLoading
    // 2. From AsyncLoading to AsyncData(tUser)
    expect(states.length, equals(3));
    expect(states[1], isA<AsyncLoading<UserModel?>>());
    expect(states[2], const AsyncValue<UserModel?>.data(tUser));
  });
}
