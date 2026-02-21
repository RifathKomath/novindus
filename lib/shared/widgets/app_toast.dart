import 'package:flutter/material.dart';
import 'package:get/get.dart';

showToast(String message, {bool isError = true}) =>
    Get.snackbar("Message", message,
        backgroundColor: isError ? Colors.red : Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 3));
