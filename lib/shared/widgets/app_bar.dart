import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:noviindus_round_2/app/view/my_feed/my_feed_view.dart';
import 'package:noviindus_round_2/shared/utils/screen_utils.dart';

import '../../core/extensions/margin_extension.dart';
import '../../core/style/app_text_style.dart';
import '../../core/style/colors.dart';

Widget commonAppBar() {
  return Padding(
    padding: const EdgeInsets.only(left: 18, right: 18, top: 60),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Hello Rifath",
              style: AppTextStyles.textStyle_600_14.copyWith(
                fontSize: 16,
                color: whiteClr,
              ),
            ),
            5.h.hBox,
            Text(
              "Welcome back to Section",
              style: AppTextStyles.textStyle_400_14.copyWith(
                fontSize: 12,
                color: textClr2,
              ),
            ),
          ],
        ),
        GestureDetector(
          onTap: () {
            Screen.open(MyFeedView());
          },
          child: CircleAvatar(
            radius: 25,
            backgroundImage: AssetImage("assets/images/User-Profile.png"),
          ),
        ),
      ],
    ),
  );
}
