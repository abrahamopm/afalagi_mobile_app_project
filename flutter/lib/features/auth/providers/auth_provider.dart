import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:afalagi/core/usecases/usecase.dart';
import '../../../core/providers/core_providers.dart';
import '../data/datasources/auth_local_ds.dart';
import '../data/datasources/auth_remote_ds.dart';
import '../data/models/user_model.dart';
import '../data/repositories/auth_repository_impl.dart';
import '../domain/repositories/auth_repository.dart';
import '../domain/usecases/delete_account.dart';
import '../domain/usecases/get_current_user.dart';
import '../domain/usecases/login_usecase.dart';
import '../domain/usecases/logout_usecase.dart';
import '../domain/usecases/signup_usecase.dart';
import '../domain/usecases/update_profile.dart';

final authRemoteDSProvider = Provider<AuthRemoteDS>((ref) {
  return AuthRemoteDS(ref.watch(dioProvider));
});

final authLocalDSProvider = Provider<AuthLocalDS>((ref) {
  return AuthLocalDS(ref.watch(secureStorageProvider));
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    ref.watch(authRemoteDSProvider),
    ref.watch(authLocalDSProvider),
    ref.watch(databaseProvider),
  );
});

final getMeUseCaseProvider = Provider<GetCurrentUser>((ref) {
  return GetCurrentUser(ref.watch(authRepositoryProvider));
});

final loginUseCaseProvider = Provider<LoginUseCase>((ref) {
  return LoginUseCase(ref.watch(authRepositoryProvider));
});

final signupUseCaseProvider = Provider<SignupUseCase>((ref) {
  return SignupUseCase(ref.watch(authRepositoryProvider));
});

final updateProfileUseCaseProvider = Provider<UpdateProfile>((ref) {
  return UpdateProfile(ref.watch(authRepositoryProvider));
});

final deleteAccountUseCaseProvider = Provider<DeleteAccount>((ref) {
  return DeleteAccount(ref.watch(authRepositoryProvider));
});

final logoutUseCaseProvider = Provider<LogoutUseCase>((ref) {
  return LogoutUseCase(ref.watch(authRepositoryProvider));
});

final rememberedEmailProvider = FutureProvider<String?>((ref) async {
  return ref.watch(authRepositoryProvider).getRememberedEmail();
});

class AuthNotifier extends AsyncNotifier<UserModel?> {
  @override
  Future<UserModel?> build() async {
    final getMe = ref.watch(getMeUseCaseProvider);
    final user = await getMe(NoParams());
    return user != null ? UserModel.fromEntity(user) : null;
  }

  Future<void> login(String email, String password, {bool rememberMe = false}) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final login = ref.read(loginUseCaseProvider);
      final user = await login(LoginParams(email: email, password: password));
      await ref.read(authRepositoryProvider).saveRememberedEmail(
        rememberMe ? email : null,
      );
      return UserModel.fromEntity(user);
    });
  }

  Future<void> signup({
    required String name,
    required String email,
    required String password,
    String phone = '',
    String agencyName = '',
    String agencyLicense = '',
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final signup = ref.read(signupUseCaseProvider);
      final user = await signup(SignupParams(
        name: name,
        email: email,
        password: password,
        phone: phone,
        agencyName: agencyName,
        agencyLicense: agencyLicense,
      ));
      return UserModel.fromEntity(user);
    });
  }

  Future<void> updateProfile(Map<String, dynamic> updateData) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final updateProfile = ref.read(updateProfileUseCaseProvider);
      final user = await updateProfile(updateData);
      return UserModel.fromEntity(user);
    });
  }

  Future<void> deleteAccount() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final deleteAccount = ref.read(deleteAccountUseCaseProvider);
      await deleteAccount(NoParams());
      return null;
    });
  }

  Future<void> logout() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final logout = ref.read(logoutUseCaseProvider);
      await logout(NoParams());
      return null;
    });
  }
}

final authStateProvider = AsyncNotifierProvider<AuthNotifier, UserModel?>(() {
  return AuthNotifier();
});

final isAuthenticatedProvider = Provider<bool>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.value != null;
});
