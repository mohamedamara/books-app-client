import 'package:books_app_client/core/constants/secure_storage_constants.dart';
import 'package:books_app_client/core/exceptions/failure.dart';
import 'package:books_app_client/features/authentication/data/repositories/authentication_repository.dart';
import 'package:books_app_client/features/authentication/data/repositories/secure_storage_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/providers/jwt_state_provider.dart';

final authenticationServiceProvider = Provider<AuthenticationService>((ref) {
  final authenticationRepository = ref.watch(authenticationRepositoryProvider);
  final secureStorageRepository = ref.watch(secureStorageRepositoryProvider);
  return AuthenticationServiceImpl(
    authenticationRepository: authenticationRepository,
    secureStorageRepository: secureStorageRepository,
    ref: ref,
  );
});

abstract class AuthenticationService {
  Future<void> signUp({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  });
  Future<void> signIn({
    required String email,
    required String password,
    required bool isStayLoggedInChecked,
  });
}

class AuthenticationServiceImpl implements AuthenticationService {
  AuthenticationServiceImpl({
    required this.authenticationRepository,
    required this.secureStorageRepository,
    required this.ref,
  });
  final AuthenticationRepository authenticationRepository;
  final SecureStorageRepository secureStorageRepository;
  final Ref ref;

  @override
  Future<void> signUp({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) async {
    try {
      final jwt = await authenticationRepository.signUp(
        firstName: firstName,
        lastName: lastName,
        email: email,
        password: password,
      );
      saveJwtInSecureStorage(jwt);
      updateJwtStateValue(jwt);
    } on Failure catch (_) {
      rethrow;
    }
  }

  @override
  Future<void> signIn({
    required String email,
    required String password,
    required bool isStayLoggedInChecked,
  }) async {
    try {
      final jwt = await authenticationRepository.signIn(
        email: email,
        password: password,
      );
      if (isStayLoggedInChecked) {
        saveJwtInSecureStorage(jwt);
      }
      updateJwtStateValue(jwt);
    } on Failure catch (_) {
      rethrow;
    }
  }

  void saveJwtInSecureStorage(String jwt) {
    secureStorageRepository.addData(SecureStorageConstants.jwt, jwt);
  }

  void updateJwtStateValue(String jwt) {
    ref.read(jwtStateProvider.notifier).state = jwt;
  }
}
