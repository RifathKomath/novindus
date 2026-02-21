import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/instance_manager.dart';
import 'package:noviindus_round_2/app/controller/dash_board/dash_board_controller.dart';
import 'package:noviindus_round_2/app/view/my_feed/my_feed_view.dart';
import 'package:noviindus_round_2/core/extensions/margin_extension.dart';
import 'package:noviindus_round_2/core/style/app_text_style.dart';
import 'package:noviindus_round_2/core/style/colors.dart';
import 'package:noviindus_round_2/shared/widgets/app_svg.dart';
import 'package:noviindus_round_2/shared/widgets/app_text_field.dart';

import '../dash_board/widgets/dotted_container.dart';

class AddFeedView extends StatelessWidget {
  const AddFeedView({super.key});

  @override
  Widget build(BuildContext context) {
    final DashBoardController controller = Get.find<DashBoardController>();
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            customAppBar(title: "Add Feeds", showButton: true, onTap: () {}),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  25.h.hBox,
                  DottedVideoUploadBox(
                    text: "Select a video from Gallery",
                    icon: "upload (2)",
                  ),
                  20.h.hBox,
                  DottedThumnailUploadBox(
                    text: "Add a Thumbnail",
                    icon: "thumb",
                  ),
                  30.h.hBox,
                  Text(
                    "Add Description",
                    style: AppTextStyles.textStyle_500_14.copyWith(
                      color: textClr2,
                    ),
                  ),
                  10.h.hBox,
                  TextFormField(
                    controller: controller.descripController,
                    style: AppTextStyles.textStyle_400_14.copyWith(
                      color: whiteClr,
                    ),
                    decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: whiteClr.withOpacity(0.10),
                        ),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: whiteClr.withOpacity(0.35),
                        ),
                      ),
                    ),
                  ),

                  20.h.hBox,
                  customTextRow(title: "Categories This Project"),
                  20.h.hBox,

                  Obx(
                    () => Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: List.generate(
                        controller.projectCategories.length,
                        (index) {
                          final isSelected =
                              controller.selectedProjectCategoryIndex.value ==
                              index;

                          return GestureDetector(
                            onTap: () =>
                                controller.selectProjectCategory(index),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 18,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? playButtonClr.withOpacity(0.13)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(
                                  color: redClr2.withOpacity(0.40)
                                      
                                ),
                              ),
                              child: Text(
                                controller.projectCategories[index],
                                style: AppTextStyles.textStyle_400_14.copyWith(
                                  color: whiteClr,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget customTextRow({
  required String title,
  Widget? widget,
  VoidCallback? onTap,
}) {
  return Row(
    children: [
      Text(
        title,
        style: AppTextStyles.textStyle_500_14.copyWith(color: textClr2),
      ),
      Spacer(),
      GestureDetector(
        onTap: onTap,
        child: Text(
          "View All",
          style: AppTextStyles.textStyle_500_14.copyWith(
            color: textClr2,
            fontSize: 10,
          ),
        ),
      ),
      10.w.wBox,
      AppSvg.clickable(assetName: "arrow-circle", onPressed: onTap),
    ],
  );
}
