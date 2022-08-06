import 'dart:convert';
import 'package:http/http.dart';

class HttpAppClient {
  final Client _httpClient;

  static const String _BASE_URL = 'https://fpmiautoparser.herokuapp.com';

  Map<String, String> headers = <String, String>{
    'Content-type': 'application/json',
    'Accept': 'application/json; charset=UTF-8',
  };

  HttpAppClient({
    required Client httpClient,
  }) : _httpClient = httpClient;

  Future<Response> post(String method, Map<String, dynamic> parameters) async {
    final String body = json.encode(parameters);
    return _httpClient.post(
      Uri.parse(_BASE_URL + method),
      body: body,
      headers: headers,
    );
  }
}
