import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/core_providers.dart';
import '../data/models/user_model.dart';
import '../data/repositories/auth_repository.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final dio = ref.watch(dioProvider);
  final secureStorage = ref.watch(secureStorageProvider);
  return AuthRepository(dio, secureStorage);
});

class AuthNotifier extends AsyncNotifier<UserModel?> {
  late final AuthRepository _authRepository;

  @override
  Future<UserModel?> build() async {
    _authRepository = ref.watch(authRepositoryProvider);
    return _authRepository.getMe();
  }

  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      return await _authRepository.login(email, password);
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
      return await _authRepository.signup(
        name: name,
        email: email,
        password: password,
        phone: phone,
        agencyName: agencyName,
        agencyLicense: agencyLicense,
      );
    });
  }

  Future<void> updateProfile(Map<String, dynamic> updateData) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final updated = await _authRepository.updateProfile(updateData);
      return updated;
    });
  }

  Future<void> deleteAccount() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _authRepository.deleteAccount();
      return null;
    });
  }

  Future<void> logout() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _authRepository.logout();
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
