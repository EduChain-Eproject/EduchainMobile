import 'dart:convert';
import 'package:http/http.dart' as http;
import 'types/api_response.dart';
import 'types/page.dart';

abstract class ApiService {
  final String apiUrl = 'https://292c-118-69-183-66.ngrok-free.app';

  ApiResponse<T> get<T>(
    String endpoint,
    T Function(Map<String, dynamic>)? fromJson,
  ) async {
    try {
      final response = await http.get(Uri.parse('$apiUrl/$endpoint'));

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (fromJson != null) {
          if (responseData is Map<String, dynamic>) {
            return Response(data: fromJson(responseData));
          } else {
            return Response(error: {'message': 'Unexpected response format'});
          }
        } else {
          return Response(data: response.body as T);
        }
      } else {
        return Response(error: {
          'message': 'Failed to fetch data',
          'statusCode': response.statusCode
        });
      }
    } catch (e) {
      return Response(error: {'message': e.toString()});
    }
  }

  ApiResponse<List<T>> getList<T>(
    String endpoint,
    T Function(Map<String, dynamic>)? fromJson,
  ) async {
    try {
      final response = await http.get(Uri.parse('$apiUrl/$endpoint'));

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (fromJson != null) {
          if (responseData is List<dynamic>) {
            return Response(
                data: responseData
                    .map((item) => fromJson(item as Map<String, dynamic>))
                    .toList());
          } else {
            return Response(error: {'message': 'Unexpected response format'});
          }
        } else {
          return Response(data: responseData as List<T>);
        }
      } else {
        return Response(error: {
          'message': 'Failed to fetch data',
          'statusCode': response.statusCode
        });
      }
    } catch (e) {
      return Response(error: {'message': e.toString()});
    }
  }

  ApiResponse<Page<T>> getPageableList<T>(
    String endpoint,
    int page,
    int limit,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    try {
      final response = await http.get(
        Uri.parse('$apiUrl/$endpoint?page=$page&limit=$limit'),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
        return Response(data: Page.fromJson(jsonResponse['data'], fromJson));
      } else {
        return Response(error: {
          'message': 'Failed to fetch data',
          'statusCode': response.statusCode
        });
      }
    } catch (e) {
      return Response(error: {'message': e.toString()});
    }
  }

  ApiResponse<T> post<T>(
    String endpoint,
    T Function(Map<String, dynamic>)? fromJson,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$apiUrl/$endpoint'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        if (fromJson != null) {
          if (responseData is Map<String, dynamic>) {
            return Response(data: fromJson(responseData));
          } else {
            return Response(error: {'message': 'Unexpected response format'});
          }
        } else {
          return Response(data: response.body as T);
        }
      } else {
        return Response(error: {
          'message': 'Failed to call API',
          'statusCode': response.statusCode
        });
      }
    } catch (e) {
      return Response(error: {'message': e.toString()});
    }
  }

  ApiResponse<T> put<T>(
    String endpoint,
    T Function(Map<String, dynamic>) fromJson,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await http.put(
        Uri.parse('$apiUrl/$endpoint'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body) as Map<String, dynamic>;
        return Response(data: fromJson(responseData));
      } else {
        return Response(error: {
          'message': 'Failed to update',
          'statusCode': response.statusCode
        });
      }
    } catch (e) {
      return Response(error: {'message': e.toString()});
    }
  }

  ApiResponse<void> delete(String endpoint) async {
    try {
      final response = await http.delete(Uri.parse('$apiUrl/$endpoint'));

      if (response.statusCode == 204) {
        return Response();
      } else {
        return Response(error: {
          'message': 'Failed to delete',
          'statusCode': response.statusCode
        });
      }
    } catch (e) {
      return Response(error: {'message': e.toString()});
    }
  }
}
