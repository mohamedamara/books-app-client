import 'package:books_app_client/core/models/failure.dart';
import 'package:books_app_client/core/network/jwt_state_provider.dart';
import 'package:books_app_client/features/authentication/repositories/authentication_repository.dart';
import 'package:books_app_client/features/authentication/repositories/secure_storage_repository.dart';
import 'package:books_app_client/features/authentication/services/authentication_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';

import '../../../core/utils/test_utils.dart';

class MockAuthenticationRepository extends Mock
    implements AuthenticationRepository {}

class MockSecureStorageRepository extends Mock
    implements SecureStorageRepository {}

void main() {
  late AuthenticationRepository mockedAuthenticationRepository;
  late SecureStorageRepository mockedSecureStorageRepository;
  late ProviderContainer providerContainer;
  late AuthenticationService authenticationService;

  String email = "test@whatever.com";
  String password = "12345678";
  String jwt = "abcdefg";

  setUp(() {
    mockedAuthenticationRepository = MockAuthenticationRepository();
    mockedSecureStorageRepository = MockSecureStorageRepository();
    providerContainer = createContainer(
      overrides: [
        authenticationRepositoryProvider.overrideWithValue(
          mockedAuthenticationRepository,
        ),
        secureStorageRepositoryProvider.overrideWithValue(
          mockedSecureStorageRepository,
        ),
      ],
    );
    authenticationService = providerContainer.read(
      authenticationServiceProvider,
    );
  });

  group('Authentication service tests -', () {
    test(
        'Given successful API call When signin Then complete the function normally',
        () async {
      when(
        () => mockedAuthenticationRepository.signIn(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer(
        (_) async => Future.value(jwt),
      );

      when(
        () => mockedSecureStorageRepository.addData(any(), any()),
      ).thenAnswer(
        (_) async {},
      );

      expectLater(
        authenticationService.signIn(
          email: email,
          password: password,
        ),
        completes,
      );
    });

    test(
        'Given successful API call When signin Then call secure storage repository to store the jwt',
        () async {
      when(
        () => mockedAuthenticationRepository.signIn(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer(
        (_) async => Future.value(jwt),
      );

      when(
        () => mockedSecureStorageRepository.addData(any(), any()),
      ).thenAnswer(
        (_) async {},
      );

      await authenticationService.signIn(
        email: email,
        password: password,
      );

      verify(() => mockedSecureStorageRepository.addData(any(), any()))
          .called(1);
    });

    test(
        'Given successful API call When signin Then update jwt state with value gotten from API',
        () async {
      when(
        () => mockedAuthenticationRepository.signIn(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer(
        (_) async => Future.value(jwt),
      );

      when(
        () => mockedSecureStorageRepository.addData(any(), any()),
      ).thenAnswer(
        (_) async {},
      );

      final listener = Listener<String>();

      providerContainer.listen<String>(
        jwtStateProvider,
        listener,
        fireImmediately: true,
      );

      verify(() => listener(null, '')).called(1);

      verifyNoMoreInteractions(listener);

      await authenticationService.signIn(
        email: email,
        password: password,
      );

      verify(() => listener('', jwt)).called(1);

      verifyNoMoreInteractions(listener);
    });

    test('Given failed API call When signin Then throw failure exception',
        () async {
      when(
        () => mockedAuthenticationRepository.signIn(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenThrow(
        Failure(message: 'message', stackTrace: StackTrace.empty),
      );

      expect(
        () => authenticationService.signIn(
          email: email,
          password: password,
        ),
        throwsA(isA<Failure>()),
      );
    });
  });
}
