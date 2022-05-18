import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import 'remote_authentication_test.mocks.dart';

import 'package:clean_arch/domain/helpers/helpers.dart';
import 'package:clean_arch/domain/usecases/usecases.dart';

import 'package:clean_arch/data/usecases/usecases.dart';
import 'package:clean_arch/data/http/http.dart';

@GenerateMocks([HttpClient])
void main() {
  late RemoteAuthentication sut;
  late String url;
  late MockHttpClient httpClient;

  setUp(() {
    httpClient = MockHttpClient();
    url = faker.internet.httpUrl();
    sut = RemoteAuthentication(httpClient: httpClient, url: url);
  });
  test(
    'Should call HttpClient with correct values',
    () async {
      final params = AuthenticationParams(
          email: faker.internet.email(), password: faker.internet.password());
      await sut.auth(params);

      verify(
        httpClient.request(
          url: url,
          method: 'post',
          body: {'email': params.email, 'password': params.password},
        ),
      );
    },
  );
  test(
    'Should throw UnexperctedError if HttpClient returns 400',
    () async {
      when(
        httpClient.request(
          url: anyNamed('url'),
          method: anyNamed('method'),
          body: anyNamed('body'),
        ),
      ).thenThrow(HttpError.badRequest);

      final params = AuthenticationParams(
          email: faker.internet.email(), password: faker.internet.password());
      final future = sut.auth(params);

      expect(future, throwsA(DomainError.unexpected));
    },
  );
}
