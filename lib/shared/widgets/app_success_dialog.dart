import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../core/style/app_text_style.dart';
import '../../core/style/colors.dart';
import 'app_lottie.dart';

class SuccessDialog extends StatelessWidget {
  const SuccessDialog({
    super.key,
    required this.message,
    this.onComplete,
    this.duration = const Duration(milliseconds: 2000),
  });

  final String message;
  final VoidCallback? onComplete;
  final Duration duration;

  static void show(
    BuildContext context, {
    required String message,
    VoidCallback? onComplete,
    Duration duration = const Duration(milliseconds: 2000),
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (_) => SuccessDialog(
            message: message,
            onComplete: onComplete,
            duration: duration,
          ),
    );

    Future.delayed(duration, () {
      if (Navigator.of(context, rootNavigator: true).canPop()) {
        Navigator.of(context, rootNavigator: true).pop();
        onComplete?.call();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.all(55),
      backgroundColor: whiteClr,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
               
                const AppLottie(assetName: "success",height: 130,),
                Text(
                  message,
                  style: AppTextStyles.textStyle_400_14.copyWith(
                    fontSize: 16,
                    color: blackText,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          Positioned(
            top: -35,
            right: 100,
            child: SvgPicture.asset(
              "assets/images/app_Icon.svg",
              height: 80,
              width: 25,
            ),
          ),
        ],
      ),
    );
  }
}
