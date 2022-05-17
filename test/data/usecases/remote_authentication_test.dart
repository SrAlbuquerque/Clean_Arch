import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import 'remote_authentication_test.mocks.dart';

class RemoteAuthentication {
  final HttpClient httpClient;
  final String url;

  RemoteAuthentication({
    required this.httpClient,
    required this.url,
  });

  Future<void> auth() async {
    await httpClient.request(url: url);
  }
}

abstract class HttpClient {
  Future<void> request({
    required String url,
  });
}

//class HttpClientSpy extends Mock implements HttpClient {}

@GenerateMocks([HttpClient])
void main() {
  test(
    'Should call HttpClient with correct URL',
    () async {
      final httpClient = MockHttpClient();
      final url = faker.internet.httpUrl();
      final sut = RemoteAuthentication(httpClient: httpClient, url: url);

      await sut.auth();

      verify(httpClient.request(url: url));
    },
  );
}