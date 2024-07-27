import 'dart:convert';
import 'package:http/http.dart' as http;
import 'types/api_response.dart';
import 'types/page.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class ApiService {
  final String apiUrl =
      'https://fbb2-2402-800-63f0-8566-1cfa-ce08-1e8e-8c17.ngrok-free.app';

  Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken');
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  ApiResponse<T> get<T>(
    String endpoint,
    T Function(Map<String, dynamic>)? fromJson,
  ) async {
    try {
      final headers = await _getHeaders();
      final response =
          await http.get(Uri.parse('$apiUrl/$endpoint'), headers: headers);

      if (response.statusCode == 200) {
        if (fromJson != null) {
          final responseData = jsonDecode(response.body);
          return Response(data: fromJson(responseData));
        } else {
          return Response(data: jsonDecode(response.body) as T);
        }
      } else {
        return Response(error: {
          'message': 'Failed to fetch data',
          'status': response.statusCode.toString()
        });
      }
    } catch (e) {
      return Response(error: {'message': 'Error: $e'});
    }
  }

  ApiResponse<List<T>> getList<T>(
    String endpoint,
    T Function(Map<String, dynamic>)? fromJson,
  ) async {
    try {
      final headers = await _getHeaders();
      final response =
          await http.get(Uri.parse('$apiUrl/$endpoint'), headers: headers);
      if (response.statusCode == 200) {
        if (fromJson != null) {
          final data = jsonDecode(response.body);
          return Response(
              data: List<T>.from(data.map((item) => fromJson(item))));
        } else {
          return Response(data: jsonDecode(response.body) as List<T>);
        }
      } else {
        return Response(error: {
          'message': 'Failed to fetch data',
          'status': response.statusCode.toString()
        });
      }
    } catch (e) {
      return Response(error: {'message': 'Error: $e'});
    }
  }

  ApiResponse<Page<T>> getPageableList<T>(
    String endpoint,
    int page,
    int limit,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('$apiUrl/$endpoint?page=$page&limit=$limit'),
        headers: headers,
      );
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
        return Response(data: Page.fromJson(jsonResponse['data'], fromJson));
      } else {
        return Response(error: {
          'message': 'Failed to fetch data',
          'status': response.statusCode.toString()
        });
      }
    } catch (e) {
      return Response(error: {'message': 'Error: $e'});
    }
  }

  ApiResponse<T> post<T>(
    String endpoint,
    T Function(Map<String, dynamic>)? fromJson,
    Map<String, dynamic>? data,
  ) async {
    try {
      final headers = await _getHeaders();
      final response = await http.post(
        Uri.parse('$apiUrl/$endpoint'),
        headers: headers,
        body: jsonEncode(data),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (fromJson != null) {
          final responseData = jsonDecode(response.body);
          return Response(data: fromJson(responseData['object']));
        } else {
          return Response(data: response.body as T);
        }
      } else {
        return Response(error: {
          'message': 'Failed to call api',
          'status': response.statusCode.toString()
        });
      }
    } catch (e) {
      return Response(error: {'message': 'Error: $e'});
    }
  }

  ApiResponse<T> put<T>(
    String endpoint,
    T Function(Map<String, dynamic>) fromJson,
    Map<String, dynamic> data,
  ) async {
    try {
      final headers = await _getHeaders();
      final response = await http.put(
        Uri.parse('$apiUrl/$endpoint'),
        headers: headers,
        body: jsonEncode(data),
      );
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body) as Map<String, dynamic>;
        return Response(data: fromJson(responseData));
      } else {
        return Response(error: {
          'message': 'Failed to update',
          'status': response.statusCode.toString()
        });
      }
    } catch (e) {
      return Response(error: {'message': 'Error: $e'});
    }
  }

  ApiResponse<void> delete(String endpoint) async {
    try {
      final headers = await _getHeaders();
      final response =
          await http.delete(Uri.parse('$apiUrl/$endpoint'), headers: headers);
      if (response.statusCode != 204) {
        return Response(error: {
          'message': 'Failed to delete',
          'status': response.statusCode.toString()
        });
      }
      return Response();
    } catch (e) {
      return Response(error: {'message': 'Error: $e'});
    }
  }
}
