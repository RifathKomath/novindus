import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:noviindus_round_2/core/style/app_text_style.dart';
import 'package:noviindus_round_2/core/style/colors.dart';
import 'package:noviindus_round_2/shared/utils/screen_utils.dart';
import 'package:noviindus_round_2/shared/widgets/app_svg.dart';

import '../../../core/extensions/margin_extension.dart';
import '../../controller/dash_board/dash_board_controller.dart';
import '../dash_board/widgets/video_container.dart';

class MyFeedView extends StatelessWidget {
  const MyFeedView({super.key});
  @override
  Widget build(BuildContext context) {
    final DashBoardController controller = Get.find<DashBoardController>();
    return Scaffold(
      body: Column(
        children: [
          customAppBar(title: "My Feed"),
          20.h.hBox,
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value &&
                  controller.myFeedResultList.isEmpty) {
                return const Center(
                  child: CupertinoActivityIndicator(color: redClr2, radius: 20),
                );
              }
              return NotificationListener<ScrollNotification>(
                onNotification: (scrollInfo) {
                  if (scrollInfo.metrics.pixels >=
                          scrollInfo.metrics.maxScrollExtent &&
                      controller.nextPageUrl != null &&
                      !controller.isMoreLoading.value) {
                    controller.myDataFetching();
                  }
                  return false;
                },
                child: ListView.separated(
                  padding: EdgeInsets.zero,
                  itemCount: controller.myFeedResultList.length + 1,
                  separatorBuilder: (context, index) => 10.h.hBox,
                  itemBuilder: (context, index) {
                    if (index < controller.myFeedResultList.length) {
                      final post = controller.myFeedResultList[index];
                      return VideoPostCard(
                        profileImage: post.user?.image ?? "",
                        name: post.user?.name ?? "",
                        time: post.createdAt?.toString() ?? "",
                        videoUrl: post.video ?? "",
                        description: post.description ?? "",
                      );
                    } else {
                      return Obx(
                        () => controller.isMoreLoading.value
                            ? const Padding(
                                padding: EdgeInsets.all(10),
                                child: Center(
                                  child: CupertinoActivityIndicator(
                                    color: redClr2,
                                  ),
                                ),
                              )
                            : const SizedBox.shrink(),
                      );
                    }
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

// Custom app bar
Widget customAppBar({
  required String title,
  bool showButton = false,
  VoidCallback? onTap,
}) {
  return Padding(
    padding: const EdgeInsets.only(left: 16, top: 45),
    child: Row(
      spacing: 15,
      children: [
        AppSvg.clickable(
          assetName: "arrow-circle-right",
          onPressed: () {
            Screen.close();
          },
        ),
        Text(
          title,
          style: AppTextStyles.textStyle_600_14.copyWith(color: whiteClr),
        ),
        if (showButton) ...[
          Spacer(),
          GestureDetector(
            onTap: onTap,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 7),
              decoration: BoxDecoration(
                color: redClr2.withOpacity(0.10),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: redClr2.withOpacity(0.40)),
              ),
              child: Center(
                child: Text(
                  "Share Post",
                  style: AppTextStyles.textStyle_400_14.copyWith(
                    color: whiteClr,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ).paddingSymmetricHorizontal(16),
        ],
      ],
    ),
  );
}
