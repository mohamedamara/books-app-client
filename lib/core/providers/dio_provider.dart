import 'package:books_app_client/core/providers/jwt_state_provider.dart';
import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../constants/env.dart';

final dioProvider = Provider<Dio>((ref) {
  final jwt = ref.watch(jwtStateProvider);
  final options = BaseOptions(
    baseUrl: Env.baseUrl,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
    headers: {if (jwt.isNotEmpty) 'Authorization': 'Bearer $jwt'},
  );
  return Dio(options);
});
