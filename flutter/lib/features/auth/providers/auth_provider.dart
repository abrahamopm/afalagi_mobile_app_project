import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:afalagi/core/usecases/usecase.dart';
import '../../../../core/providers/core_providers.dart';
import '../data/datasources/auth_local_ds.dart';
import '../data/datasources/auth_remote_ds.dart';
import '../data/models/user_model.dart';
import '../data/repositories/auth_repository_impl.dart';
import '../domain/repositories/auth_repository.dart';
import '../domain/usecases/delete_account.dart';
import '../domain/usecases/get_me.dart';
import '../domain/usecases/login_usecase.dart';
import '../domain/usecases/logout.dart';
import '../domain/usecases/signup_usecase.dart';
import '../domain/usecases/update_profile.dart';

final authLocalDSProvider = Provider<AuthLocalDS>((ref) {
  final secureStorage = ref.watch(secureStorageProvider);
  return AuthLocalDS(secureStorage);
});

final authRemoteDSProvider = Provider<AuthRemoteDS>((ref) {
  final dio = ref.watch(dioProvider);
  return AuthRemoteDS(dio);
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final remote = ref.watch(authRemoteDSProvider);
  final local = ref.watch(authLocalDSProvider);
  final networkInfo = ref.watch(networkInfoProvider);
  return AuthRepositoryImpl(
    remote: remote,
    local: local,
    networkInfo: networkInfo,
  );
});

final getMeUseCaseProvider = Provider<GetMe>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return GetMe(repository);
});

final loginUseCaseProvider = Provider<LoginUseCase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return LoginUseCase(repository);
});

final signupUseCaseProvider = Provider<SignupUseCase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return SignupUseCase(repository);
});

final updateProfileUseCaseProvider = Provider<UpdateProfile>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return UpdateProfile(repository);
});

final deleteAccountUseCaseProvider = Provider<DeleteAccount>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return DeleteAccount(repository);
});

final logoutUseCaseProvider = Provider<Logout>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return Logout(repository);
});

class AuthNotifier extends AsyncNotifier<UserModel?> {
  @override
  Future<UserModel?> build() async {
    final getMe = ref.watch(getMeUseCaseProvider);
    final user = await getMe(NoParams());
    return user != null ? UserModel.fromJson(user.toJson()) : null;
  }

  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final login = ref.read(loginUseCaseProvider);
      final user = await login(LoginParams(email: email, password: password));
      return UserModel.fromJson(user.toJson());
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
      return UserModel.fromJson(user.toJson());
    });
  }

  Future<void> updateProfile(Map<String, dynamic> updateData) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final updateProfile = ref.read(updateProfileUseCaseProvider);
      final user = await updateProfile(updateData);
      return UserModel.fromJson(user.toJson());
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
