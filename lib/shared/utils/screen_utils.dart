import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/style/colors.dart';
import '../widgets/app_lottie.dart';
bool isShowingLoader = false;

class Screen {
  static Future? open(Widget page) => Get.to(page);

  static Future? openClosingCurrent(Widget page) => Get.off(page);

  static Future? openAsNewPage(Widget page) => Get.offAll(() => page);

  static close({Object? result}) => Get.back(result: result);

  static closeDialog({Object? result}) => Get.back(result: result);
}

Future<void> showLoader() async {
  isShowingLoader = true;
  await Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Container(
            alignment: Alignment.center,
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.all(Radius.circular(20))),
            child: Container(
                decoration:  BoxDecoration(
                    color: primaryColor.withOpacity(0.5),
                    borderRadius: const BorderRadius.all(Radius.circular(12))),
                child: Transform.scale(
                    scale: 1.8,
                    child: const AppLottie(
                        assetName: "loader", width: 80, height: 80)))),
      ),
      barrierDismissible: false);
}

hideLoader({bool closeOverlays = false}) {
  if (isShowingLoader) Get.back(closeOverlays: closeOverlays);
}