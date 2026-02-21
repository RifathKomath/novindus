import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:noviindus_round_2/core/extensions/margin_extension.dart';
import 'package:noviindus_round_2/core/style/app_text_style.dart';
import 'package:noviindus_round_2/core/style/colors.dart';
import 'package:noviindus_round_2/shared/widgets/app_svg.dart';

class DottedVideoUploadBox extends StatelessWidget {
  final String text;
  final String icon;

  const DottedVideoUploadBox({super.key, required this.text, required this.icon});

  @override
  Widget build(BuildContext context) {
    return DottedBorder(
      options: RoundedRectDottedBorderOptions(
        color: Colors.white30,
        strokeWidth: 1,
        dashPattern: [15, 7],
        radius: Radius.circular(8),
      ),
      child: Container(
        height: 240,
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFF1C1C1C),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
           AppSvg(assetName: icon),
            14.h.hBox,
            Text(
              text,
              style: AppTextStyles.textStyle_400_14.copyWith(fontSize: 15,color: whiteClr),
            ),
          ],
        ),
      ),
    );
  }
}


class DottedThumnailUploadBox extends StatelessWidget {
  final String text;
  final String icon;

  const DottedThumnailUploadBox({super.key, required this.text, required this.icon});

  @override
  Widget build(BuildContext context) {
    return DottedBorder(
      options: RoundedRectDottedBorderOptions(
        color: Colors.white30,
        strokeWidth: 1,
        dashPattern: [15, 7],
        radius: Radius.circular(8),
      ),
      child: Container(
        height: 130,
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFF1C1C1C),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 20,
          children: [
           AppSvg(assetName: icon),
            14.h.hBox,
            Text(
              text,
              style: AppTextStyles.textStyle_400_14.copyWith(fontSize: 15,color: textClr2),
            ),
          ],
        ),
      ),
    );
  }
}