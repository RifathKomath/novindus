import 'dart:developer';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'api.dart';

class ApiResponse<T> {
  final bool success;
  final String msg;
  final T? data;
  final dynamic response;
  final String statusCode;

  ApiResponse({
    required this.success,
    required this.msg,
    required this.data,
    required this.response,
    required this.statusCode,
  });

  factory ApiResponse.fromJson(
    Uri url,
    Method method,
    Object? body,
    Map<String, dynamic> responseData, {
    String? fetchKeyName,
  }) {
    debugPrint("$url ($method)");
    if (body != null) log(jsonEncode(body));

    final String message =
        responseData["message"] ?? responseData["msg"] ?? "";

    final bool isSuccess = responseData["status"] == true;

    dynamic data;
    if (fetchKeyName != null) {
      data = responseData[fetchKeyName];
    } else {

      data = responseData["data"] ??
          responseData["user"] ??
          responseData;
    }

    return ApiResponse(
      success: isSuccess,
      msg: message,
      data: data,
      response: responseData,
      statusCode: "",
    );
  }
}
