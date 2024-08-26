import 'dart:convert';
import 'package:educhain/init_dependency.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'types/api_response.dart';
import 'types/page.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class ApiService {
  static const apiUrl =
      'https://0e89-2402-800-63f0-8566-e07d-76bf-92f5-9d6.ngrok-free.app';

  ApiResponse<T> get<T>(
    String endpoint,
    T Function(Map<String, dynamic>)? fromJson,
  ) async {
    return _performApiCall<T>(
      (headers) => http.get(Uri.parse('$apiUrl/$endpoint'), headers: headers),
      (data) {
        if (data is Map<String, dynamic> && fromJson != null) {
          return fromJson(data);
        } else {
          throw FormatException('Expected list but got ${data.runtimeType}');
        }
      },
    );
  }

  ApiResponse<List<T>> getList<T>(
    String endpoint,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    return _performApiCall<List<T>>(
      (headers) => http.get(Uri.parse('$apiUrl/$endpoint'), headers: headers),
      (data) {
        if (data is List) {
          return data
              .map((item) => fromJson(item as Map<String, dynamic>))
              .toList();
        } else {
          throw FormatException('Expected list but got ${data.runtimeType}');
        }
      },
    );
  }

  ApiResponse<Page<T>> getPageableList<T>(
    String endpoint,
    int page,
    int limit,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    return _performApiCall<Page<T>>(
      (headers) => http.get(
        Uri.parse('$apiUrl/$endpoint?page=$page&limit=$limit'),
        headers: headers,
      ),
      (data) => Page.fromJson(data, fromJson),
    );
  }

  ApiResponse<T> post<T>(
    String endpoint,
    T Function(Map<String, dynamic>)? fromJson,
    Map<String, dynamic>? data,
  ) async {
    return _performApiCall<T>(
      (headers) => http.post(
        Uri.parse('$apiUrl/$endpoint'),
        headers: headers,
        body: jsonEncode(data),
      ),
      fromJson != null
          ? (data) {
              if (data is Map<String, dynamic>) {
                return fromJson(data);
              } else {
                throw FormatException(
                    'Expected list but got ${data.runtimeType}');
              }
            }
          : null,
    );
  }

  ApiResponse<T> postMultipart<T>(
      String endpoint,
      T Function(Map<String, dynamic>)? fromJson,
      Map<String, String> fields,
      XFile? file,
      String? fileField,
      {String? method}) async {
    String? mimeType = file != null ? lookupMimeType(file.path) : null;
    final mediaType = mimeType != null
        ? MediaType.parse(mimeType)
        : MediaType('application', 'octet-stream');

    return _performApiCall<T>(
      setMediaType: false,
      (headers) async {
        final uri = Uri.parse('$apiUrl/$endpoint');
        final request = http.MultipartRequest(method ?? 'POST', uri);

        fields.forEach((key, value) {
          request.fields[key] = value;
        });

        if (file != null) {
          request.files.add(
            http.MultipartFile.fromBytes(
              fileField ?? 'file',
              await file.readAsBytes(),
              filename: file.name,
              contentType: mediaType,
            ),
          );
        }

        request.headers.addAll(headers);

        final streamedResponse = await request.send();
        final response = http.Response.fromStream(streamedResponse);
        return response;
      },
      (data) {
        if (data is Map<String, dynamic> && fromJson != null) {
          return fromJson(data);
        } else {
          throw FormatException('Expected list but got ${data.runtimeType}');
        }
      },
    );
  }

  ApiResponse<T> put<T>(
    String endpoint,
    T Function(Map<String, dynamic>) fromJson,
    Map<String, dynamic> data,
  ) async {
    return _performApiCall<T>(
      (headers) => http.put(
        Uri.parse('$apiUrl/$endpoint'),
        headers: headers,
        body: jsonEncode(data),
      ),
      (data) {
        if (data is Map<String, dynamic>) {
          return fromJson(data);
        } else {
          throw FormatException('Expected list but got ${data.runtimeType}');
        }
      },
    );
  }

  ApiResponse<T> delete<T>(
    String endpoint,
    T Function(Map<String, dynamic>)? fromJson,
    Map<String, dynamic>? data,
  ) async {
    return _performApiCall<T>(
      (headers) => http.delete(Uri.parse('$apiUrl/$endpoint'),
          headers: headers, body: data),
      fromJson != null
          ? (data) {
              if (data is Map<String, dynamic>) {
                return fromJson(data);
              } else {
                throw FormatException(
                    'Expected list but got ${data.runtimeType}');
              }
            }
          : null,
    );
  }

  ApiResponse<T> _performApiCall<T>(
      Future<http.Response> Function(Map<String, String> headers) apiCall,
      T Function(dynamic data)? fromJson,
      {bool? setMediaType}) async {
    try {
      final headers = await _getHeaders(setMediaType: setMediaType ?? true);
      var response = await apiCall(headers);

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (fromJson != null) {
          final responseData = jsonDecode(response.body);
          if (responseData is List) {
            return Response(data: fromJson(responseData));
          } else if (responseData is Map) {
            return Response(data: fromJson(responseData));
          } else {
            return Response(error: {'message': 'Unexpected data format'});
          }
        } else {
          return Response(data: parseResponseBody<T>(response.body));
        }
      } else if (response.statusCode == 403) {
        final newAccessToken = await _refreshToken();
        if (newAccessToken != null) {
          final retryHeaders = await _getHeaders();
          response = await apiCall(retryHeaders);
          if (response.statusCode == 200 || response.statusCode == 201) {
            final responseData = jsonDecode(response.body);
            if (fromJson != null) {
              if (responseData is List) {
                return Response(data: fromJson(responseData));
              } else if (responseData is Map) {
                return Response(data: fromJson(responseData));
              } else {
                return Response(error: {'message': 'Unexpected data format'});
              }
            } else {
              return Response(data: responseData as T);
            }
          } else {
            return _handleErrorResponse<T>(response);
          }
        } else {
          return _handleErrorResponse<T>(response);
        }
      } else {
        return _handleErrorResponse<T>(response);
      }
    } catch (e) {
      return Response(error: {'message': 'Error: $e'});
    }
  }

  Future<Map<String, String>> _getHeaders({bool setMediaType = true}) async {
    final prefs = getIt<SharedPreferences>();
    final token = prefs.getString('accessToken');

    final headers = <String, String>{};

    if (setMediaType) {
      headers['Content-Type'] = 'application/json';
    }

    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }

    return headers;
  }

  Response<T> _handleErrorResponse<T>(http.Response response) {
    final Map<String, dynamic> responseData =
        jsonDecode(response.body)['errors'];
    if (responseData.containsKey('message')) {
      return Response(
        error: {'message': responseData['message']},
      );
    } else {
      responseData['message'] = 'call api failed';
      return Response(
        error: responseData,
      );
    }
  }

  Future<String?> _refreshToken() async {
    final prefs = getIt<SharedPreferences>();
    final accessToken = prefs.getString('accessToken');
    final refreshToken = prefs.getString('refreshToken');
    if (accessToken != null && refreshToken != null) {
      final response = await http.post(
        Uri.parse('$apiUrl/Auth/reset-access-token'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'accessToken': accessToken,
          'refreshToken': refreshToken,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final newAccessToken = responseData['accessToken'];
        final newRefreshToken = responseData['refreshToken'];
        await prefs.setString('accessToken', newAccessToken);
        await prefs.setString('refreshToken', newRefreshToken);
        return newAccessToken;
      } else {
        await prefs.remove('accessToken');
        await prefs.remove('refreshToken');
        return null;
      }
    } else {
      return null;
    }
  }

  T parseResponseBody<T>(String responseBody) {
    if (T == int) {
      return int.tryParse(responseBody) as T;
    } else if (T == double) {
      return double.tryParse(responseBody) as T;
    } else if (T == bool) {
      if (responseBody.toLowerCase() == 'true') return true as T;
      if (responseBody.toLowerCase() == 'false') return false as T;
      throw FormatException('Cannot parse bool from $responseBody');
    } else if (T == String) {
      return responseBody as T;
    } else if (T == List) {
      return jsonDecode(responseBody) as T;
    } else if (T == Map) {
      return jsonDecode(responseBody) as T;
    } else {
      throw UnsupportedError('Type $T is not supported');
    }
  }
}
