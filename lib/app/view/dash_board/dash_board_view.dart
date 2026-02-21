import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:noviindus_round_2/app/controller/dash_board/dash_board_controller.dart';
import 'package:noviindus_round_2/app/view/add_feed/add_feed_view.dart';
import 'package:noviindus_round_2/core/extensions/margin_extension.dart';
import 'package:noviindus_round_2/core/style/app_text_style.dart';
import 'package:noviindus_round_2/core/style/colors.dart';
import 'package:noviindus_round_2/shared/utils/screen_utils.dart';
import 'package:noviindus_round_2/shared/widgets/app_svg.dart';
import '../../../shared/widgets/app_bar.dart';
import 'widgets/category_chip.dart';
import 'widgets/video_container.dart';

class DashBoardView extends StatelessWidget {
  const DashBoardView({super.key});

  @override
  Widget build(BuildContext context) {
    final DashBoardController controller = Get.put(DashBoardController());
    return Scaffold(
      body: Column(
        children: [
          commonAppBar(),
          30.h.hBox,
          Obx(() {
            final reversedList = controller.categoryList.reversed.toList();

            return SizedBox(
              height: 40,
              child: ListView.separated(
                padding: const EdgeInsets.only(left: 18),
                scrollDirection: Axis.horizontal,
                itemCount: reversedList.length,
                separatorBuilder: (_, __) => 10.w.wBox,
                itemBuilder: (context, index) {
                  final item = reversedList[index];

                  return Obx(
                    () => CategoryChip(
                      title: item.title ?? "",
                      isSelected:
                          controller.selectedCategoryId.value == item.id,
                      onTap: () => controller.selectCategory(item.id ?? ""),
                      showIcon: item.id == "0",
                    ),
                  );
                },
              ),
            );
          }),

          20.h.hBox,
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                  child: CupertinoActivityIndicator(color: redClr2, radius: 20),
                );
              }
               if (controller.resultList.isEmpty) {
                return  Center(
                  child: Text("Videos not found",style: AppTextStyles.textStyle_500_14.copyWith(color: redClr2),),
                );
              }

              return ListView.separated(
                padding: EdgeInsets.zero,
                itemCount: controller.resultList.length,
                separatorBuilder: (context, index) => 10.h.hBox,
                itemBuilder: (context, index) {
                  final post = controller.resultList[index];
                  return VideoPostCard(
                    profileImage: post.user?.image ?? "",
                    name: post.user?.name ?? "",
                    time: post.createdAt?.toString() ?? "",
                    videoUrl: post.video ?? "",
                    description: post.description ?? "",
                  );
                },
              );
            }),
          ),
        ],
      ),
      floatingActionButton: AppSvg.clickable(
        assetName: "add_red_button",
        height: 80,
        onPressed: () {
          Screen.open(AddFeedView());
        },
      ),
    );
  }
}
