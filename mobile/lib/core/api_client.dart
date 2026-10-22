import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/endpoints.dart';
import 'session.dart';

class ApiClient {
  final String baseUrl;

  ApiClient({this.baseUrl = AppEndpoints.defaultBaseUrl});

  Future<Map<String, String>> _getHeaders() async {
    final token = await SessionManager.getToken();
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  Future<dynamic> get(String path, {Map<String, String>? queryParams}) async {
    final uri = Uri.parse('$baseUrl$path').replace(queryParameters: queryParams);
    final headers = await _getHeaders();
    final response = await http.get(uri, headers: headers);
    return _handleResponse(response);
  }

  Future<dynamic> post(String path, {Map<String, dynamic>? body}) async {
    final uri = Uri.parse('$baseUrl$path');
    final headers = await _getHeaders();
    final response = await http.post(
      uri,
      headers: headers,
      body: body != null ? jsonEncode(body) : null,
    );
    return _handleResponse(response);
  }

  dynamic _handleResponse(http.Response response) {
    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    final isSuccess = decoded['success'] as bool? ?? false;

    if (response.statusCode >= 200 && response.statusCode < 300 && isSuccess) {
      return decoded['data'];
    }

    final errorMessage = decoded['message'] as String? ?? 'Terjadi kesalahan sistem';
    throw Exception(errorMessage);
  }
}

final apiClient = ApiClient();
