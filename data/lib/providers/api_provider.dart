import 'dart:convert';

import 'package:data/http/http_client.dart';
import 'package:http/http.dart';

class ApiProvider {
  final HttpAppClient _client;
  ApiProvider({
    required HttpAppClient client,
  }) : _client = client;

  Future<List<String>> getCarsByParams(String url) async {
    final Response res = await _client.post(
      '/getCarsByParams',
      <String, dynamic>{'url': url},
    );
    if (res.statusCode != 200) {
      return <String>[];
    }
    final Map<String, dynamic> resAsJson =
        json.decode(res.body) as Map<String, dynamic>;
    return resAsJson['urls'] as List<String>;
  }

  Future<Map<String, dynamic>> getCardByUrl(String url) async {
    final Response res = await _client.post(
      '/getCardByUrl',
      <String, dynamic>{'url': url},
    );
    if (res.statusCode != 200) {
      return <String, dynamic>{};
    }
    return json.decode(res.body) as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getCarByUrl(String url) async {
    final Response res = await _client.post(
      '/getCarByUrl',
      <String, dynamic>{'url': url},
    );
    if (res.statusCode != 200) {
      return <String, dynamic>{};
    }
    return json.decode(res.body) as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getCharsByUrl(String url) async {
    final Response res = await _client.post(
      '/getCharsByUrl',
      <String, dynamic>{'url': url},
    );
    if (res.statusCode != 200) {
      return <String, dynamic>{};
    }
    return json.decode(res.body) as Map<String, dynamic>;
  }

  Future<String> getNotificationUpdates(String url) async {
    return (await _client.post(
      '/getNotUpdate',
      <String, dynamic>{'url': url},
    ))
        .body;
  }
}
