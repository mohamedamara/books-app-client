import 'package:books_app_client/core/network/network_configs.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authenticationRepositoryProvider = Provider<AuthenticationRepository>(
  (ref) {
    final dio = ref.watch(dioProvider);
    return AuthenticationRepositoryImpl(dio: dio);
  },
);

abstract class AuthenticationRepository {
  Future<String> signUp({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  });
  Future<String> signIn({
    required String email,
    required String password,
  });
}

class AuthenticationRepositoryImpl implements AuthenticationRepository {
  AuthenticationRepositoryImpl({required this.dio});
  final Dio dio;

  @override
  Future<String> signUp({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) async {
    throw UnimplementedError();
  }

  @override
  Future<String> signIn({
    required String email,
    required String password,
  }) async {
    final response = await dio.get(
      'users',
      data: {
        'email': email,
        'password': password,
      },
    );
    String jwt = response.data['jwt'];
    return jwt;
  }
}
