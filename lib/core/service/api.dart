import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../config.dart';
import '../../shared/utils/screen_utils.dart';
import '../../shared/widgets/app_toast.dart';
import 'shared_pref.dart';
import 'urls.dart';
import 'api_response.dart';
import 'package:http_parser/http_parser.dart';

enum Method { get, post, put, patch, delete, upload }

class Api {
  static Future<ApiResponse> call({
    required String endPoint,
    Method method = Method.get,
    Object? body,
    bool isFormData = false,
    bool isShowLoader = false,
    bool isShowToast = true,
    String? fetchKeyName,
    bool isImageDownload = false,
  }) async {
    try {
      final headers = {
        'Content-Type': isFormData ? 'multipart/form-data' : 'application/json',
        'platform': 'app',
        if (accessToken != null && accessToken!.isNotEmpty)
          'Authorization': 'Bearer $accessToken',
      };
      if (isShowLoader) {
        isShowingLoader = true;
        showLoader();
      }

      final http.Response response;
      Uri url = Uri.parse("$baseUrl$endPoint");
      debugPrint('$headers');
      debugPrint('$url');
      debugPrint('$body');

      if (body != null && method == Method.get) {
        method = Method.post;
      }

      switch (method) {
        case Method.get:
          response = await http.get(url, headers: headers);
          break;

        case Method.post:
          if (isFormData && body is Map<String, dynamic>) {
            var request = http.MultipartRequest('POST', url);
            request.headers.addAll(headers);
            body.forEach((key, value) async {
              if (value is File) {
                request.files.add(
                  await http.MultipartFile.fromPath(key, value.path),
                );
              } else {
                request.fields[key] = value.toString();
              }
            });
            var streamed = await request.send();
            response = await http.Response.fromStream(streamed);
          } else {
            response = await http.post(
              url,
              body: json.encode(body),
              headers: headers,
            );
          }
          break;

        case Method.patch:
          response = await http.patch(
            url,
            body: json.encode(body),
            headers: headers,
          );
          break;

        case Method.put:
          response = await http.put(
            url,
            body: json.encode(body),
            headers: headers,
          );
          break;

        case Method.delete:
          response = await http.delete(
            url,
            body: body != null ? json.encode(body) : null,
            headers: headers,
          );
          break;

        default:
          throw ("Invalid request type");
      }

      print(response.body);

      if (isShowLoader) hideLoader();
      if ((response.statusCode == 401) ||
          (response.statusCode == 500) ||
          (response.statusCode == 403)) {
        return ApiResponse(
          success: false,
          msg: "Server under maintanance",
          data: null,
          statusCode: response.statusCode.toString(),
          response: response,
        );
      }

      if (isImageDownload) {
        if (response.statusCode == 200) {
          return ApiResponse(
            success: true,
            msg: "Image downloaded successfully",
            data: response.bodyBytes,
            statusCode: response.statusCode.toString(),
            response: response,
          );
        } else {
          return ApiResponse(
            success: false,
            msg: "Failed to download image",
            data: null,
            statusCode: response.statusCode.toString(),
            response: response,
          );
        }
      }

      final Map<String, dynamic> responseData = json.decode(response.body);
      return ApiResponse.fromJson(
        url,
        method,
        body,
        responseData,
        fetchKeyName: fetchKeyName,
      );
    } on SocketException {
      if (isShowLoader) hideLoader();
      showToast("Network seems to be offline");
      return ApiResponse(
        success: false,
        msg: "Network seems to be offline",
        data: null,
        statusCode: "",
        response: null,
      );
    } catch (e) {
      debugPrint(e.toString());
      if (isShowLoader) hideLoader();
      return ApiResponse(
        success: false,
        msg: "An Error Occured",
        data: null,
        statusCode: "",
        response: null,
      );
    }
  }

  static Future<ApiResponse> uploadFile({
    required String endPoint,
    File? file,
    List<File>? files,
    Map<String, String>? fields,
    Map<String, String>? queryParams,
    bool isShowLoader = false,
    bool isShowToast = true,
    String? fetchKeyName,
    String fileFieldName = 'file',
  }) async {
    try {
      if (isShowLoader) {
        isShowingLoader = true;
        showLoader();
      }

      Uri url = Uri.parse("$baseUrl$endPoint");
      if (queryParams != null && queryParams.isNotEmpty) {
        url = url.replace(
          queryParameters: {...url.queryParameters, ...queryParams},
        );
      }

      var request = http.MultipartRequest('POST', url);

      request.headers.addAll({
        "platform": "app",
        if (accessToken != null && accessToken!.isNotEmpty)
          "Authorization": "Bearer $accessToken",
      });

      if (files != null && files.isNotEmpty) {
        for (var f in files) {
          String fileName = f.path.split('/').last;
          var multipartFile = await http.MultipartFile.fromPath(
            fileFieldName,
            f.path,
            filename: fileName,
          );
          request.files.add(multipartFile);
        }
      } else if (file != null) {
        String fileName = file.path.split('/').last;
        var multipartFile = await http.MultipartFile.fromPath(
          fileFieldName,
          file.path,
          filename: fileName,
          contentType: MediaType('image', _getImageExtension(fileName)),
        );
        request.files.add(multipartFile);
      }

      if (fields != null) {
        request.fields.addAll(fields);
      }

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);
      print("response eeeee ${response.body}");

      if (isShowLoader) hideLoader();

      if (response.statusCode == 401) {
        if (accessToken != null) {
          await SharedPref().logout();
        }
        return ApiResponse(
          success: false,
          msg: "Session expired. Please login again.",
          data: null,
          statusCode: response.statusCode.toString(),
          response: response,
        );
      }
      if (response.statusCode == 500) {
        return ApiResponse(
          success: false,
          msg: "Server under maintenance",
          data: null,
          statusCode: response.statusCode.toString(),
          response: response,
        );
      }

      final Map<String, dynamic> responseData = json.decode(response.body);
      return ApiResponse.fromJson(
        url,
        Method.upload,
        null,
        responseData,
        fetchKeyName: fetchKeyName,
      );
    } on SocketException {
      if (isShowLoader) hideLoader();
      return ApiResponse(
        success: false,
        msg: "Network seems to be offline",
        data: null,
        statusCode: "",
        response: null,
      );
    } catch (e) {
      debugPrint('Upload error: ${e.toString()}');
      if (isShowLoader) hideLoader();
      if (isShowToast) showToast("Upload failed");
      return ApiResponse(
        success: false,
        msg: "Upload failed: ${e.toString()}",
        data: null,
        statusCode: "",
        response: null,
      );
    }
  }
}

String _getImageExtension(String fileName) {
  final ext = fileName.split('.').last.toLowerCase();
  switch (ext) {
    case 'jpg':
    case 'jpeg':
      return 'jpeg';
    case 'png':
      return 'png';
    default:
      return 'jpeg';
  }
}
