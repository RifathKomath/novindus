import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:noviindus_round_2/app/controller/dash_board/dash_board_controller.dart';
import 'package:noviindus_round_2/core/extensions/margin_extension.dart';
import 'package:noviindus_round_2/core/style/app_text_style.dart';
import 'package:noviindus_round_2/core/style/colors.dart';
import 'package:noviindus_round_2/shared/widgets/app_svg.dart';
import 'package:video_player/video_player.dart';
import '../dash_board/widgets/dotted_container.dart';
import '../my_feed/my_feed_view.dart';

class AddFeedView extends StatelessWidget {
  const AddFeedView({super.key});

  @override
  Widget build(BuildContext context) {
    final DashBoardController controller = Get.find<DashBoardController>();

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
             
                customAppBar(
                  title: "Add Feeds",
                  showButton: true,
                  isLoading: controller.isLoading,
                  onTap: () {
                    controller.uploadFeed(context: context);
                  },
                ),
            
              25.h.hBox,
              Obx(
                () => GestureDetector(
                  onTap: controller.pickVideo,
                  child: DottedVideoUploadBox(
                    text: controller.selectedVideo.value != null
                        ? "Video Selected"
                        : "Select a video from Gallery",
                    icon: "upload (2)",
                    child:
                        controller.selectedVideo.value != null &&
                            controller.videoController.value != null &&
                            controller
                                .videoController
                                .value!
                                .value
                                .isInitialized
                        ? AspectRatio(
                            aspectRatio: controller
                                .videoController
                                .value!
                                .value
                                .aspectRatio,
                            child: VideoPlayer(
                              controller.videoController.value!,
                            ),
                          )
                        : null,
                  ),
                ),
              ),
              20.h.hBox,
              Obx(
                () => GestureDetector(
                  onTap: controller.pickThumbnail,
                  child: DottedThumnailUploadBox(
                    text: controller.selectedThumbnail.value != null
                        ? "Thumbnail Selected"
                        : "Add a Thumbnail",
                    icon: "thumb",
                    child: controller.selectedThumbnail.value != null
                        ? Image.file(
                            controller.selectedThumbnail.value!,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: 130,
                          )
                        : null,
                  ),
                ),
              ),
              30.h.hBox,
              Text(
                "Add Description",
                style: AppTextStyles.textStyle_500_14.copyWith(color: textClr2),
              ),
              10.h.hBox,
              TextFormField(
                controller: controller.descripController,
                style: AppTextStyles.textStyle_400_14.copyWith(color: whiteClr),
                decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: whiteClr.withOpacity(0.10)),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: whiteClr.withOpacity(0.35)),
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
                  children: List.generate(controller.getCategoryList.length, (
                    index,
                  ) {
                    final category = controller.getCategoryList[index];
                    final isSelected = controller.selectedProjectCategoryIndexes
                        .contains(index);
                    return GestureDetector(
                      onTap: () {
                        controller.toggleProjectCategory(index, category.id);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? redClr2.withOpacity(0.13)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: redClr2.withOpacity(0.40)),
                        ),
                        child: Text(
                          category.title ?? "",
                          style: AppTextStyles.textStyle_400_14.copyWith(
                            color: whiteClr,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
              30.h.hBox,
              Obx(
                () => controller.uploadProgress.value > 0
                    ? Column(
                        children: [
                          LinearProgressIndicator(
                            value: controller.uploadProgress.value,
                            color: redClr2,
                            backgroundColor: Colors.white12,
                          ),
                          10.h.hBox,
                        ],
                      )
                    : SizedBox.shrink(),
              ),
            ],
          ),
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
