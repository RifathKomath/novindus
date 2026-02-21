import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:noviindus_round_2/app/view/dash_board/dash_board_view.dart';
import 'package:noviindus_round_2/core/service/api.dart';
import 'package:noviindus_round_2/core/service/urls.dart';
import 'package:noviindus_round_2/shared/utils/screen_utils.dart';
import 'package:noviindus_round_2/shared/widgets/app_success_dialog.dart';
import 'package:noviindus_round_2/shared/widgets/app_toast.dart';
import 'package:video_player/video_player.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/service/api.dart';
import '../../model/dash_board/dash_board_data_response.dart';
import '../../model/feed/category_response.dart';
import '../../model/feed/my_feed_response.dart';

class DashBoardController extends GetxController {
  @override
  void onInit() async {
    super.onInit();
    await dataFetching();
    await myDataFetching();
    await categoryFetching();
  }

  RxBool isLoading = false.obs;
  RxString selectedCategoryId = "".obs;

  void selectCategory(String id) {
    selectedCategoryId.value = id;
  }

  final TextEditingController descripController = TextEditingController();

  RxInt selectedProjectCategoryIndex = (-1).obs;
  void selectProjectCategory(int index) {
    selectedProjectCategoryIndex.value = index;
  }

  RxList<CategoryDict> categoryList = <CategoryDict>[].obs;
  RxList<Result> resultList = <Result>[].obs;
  Future<void> dataFetching() async {
    try {
      isLoading.value = true;

      final response = await Api.call(endPoint: dataFetchingUrl);
      if (response.success) {
        final result = HomeDataResponse.fromJson(response.response);
        categoryList.value = result.categoryDict ?? [];
        resultList.value = result.results ?? [];
        if (categoryList.isNotEmpty) {
          selectedCategoryId.value = categoryList.last.id ?? "";
        }
      } else {
        showToast("Error while fetching datas");
      }
    } catch (e) {
      print("Error while fetching datas $e");
    } finally {
      isLoading.value = false;
    }
  }

  RxList<MyFeedResult> myFeedResultList = <MyFeedResult>[].obs;
  RxBool isMoreLoading = false.obs;
  String? nextPageUrl;

  Future<void> myDataFetching({bool isRefresh = false}) async {
    try {
      if (isRefresh) {
        nextPageUrl = null;
      }
      if (!isRefresh) {
        isLoading.value = true;
      } else {
        isMoreLoading.value = true;
      }
      final urlToFetch = nextPageUrl ?? myFeedGetUrl;
      final response = await Api.call(endPoint: urlToFetch);
      if (response.response != null) {
        final Map<String, dynamic> jsonMap = response.response is String
            ? json.decode(response.response)
            : response.response;
        final MyFeedResponse result = MyFeedResponse.fromJson(jsonMap);
        if (isRefresh || nextPageUrl == null) {
          myFeedResultList.value = result.results ?? [];
        } else {
          myFeedResultList.addAll(result.results ?? []);
        }
        nextPageUrl = result.next;
        if (result.next == null) {
          isMoreLoading.value = false;
        }
      } else {
        if (myFeedResultList.isEmpty) {
          showToast("No response from API");
        }
      }
    } catch (e) {
      print("Error fetching my feed: $e");
      if (myFeedResultList.isEmpty) {
        showToast("Error fetching my feed");
      }
    } finally {
      isLoading.value = false;
      isMoreLoading.value = false;
    }
  }

  RxList<CategoryList> getCategoryList = <CategoryList>[].obs;
  Future<void> categoryFetching() async {
    try {
      final response = await Api.call(endPoint: categoryFetchingUrl);
      if (response.success) {
        final result = CategoryResponse.fromJson(response.response);
        getCategoryList.value = result.categories ?? [];
      } else {
        showToast("Error while fetching category");
      }
    } catch (e) {
      print("Error while fetching category $e");
    }
  }

  RxList<int> selectedProjectCategoryIndexes = <int>[].obs;
  RxList<int> selectedProjectCategoryIds = <int>[].obs;

  void toggleProjectCategory(int index, int? id) {
    if (selectedProjectCategoryIndexes.contains(index)) {
      selectedProjectCategoryIndexes.remove(index);
      if (id != null) selectedProjectCategoryIds.remove(id);
    } else {
      selectedProjectCategoryIndexes.add(index);
      if (id != null) selectedProjectCategoryIds.add(id);
    }
  }

  Rxn<File> selectedVideo = Rxn<File>();
  Rxn<File> selectedThumbnail = Rxn<File>();
  Rxn<VideoPlayerController> videoController = Rxn<VideoPlayerController>();
  RxDouble uploadProgress = 0.0.obs;

  final ImagePicker picker = ImagePicker();

  Future<void> pickVideo() async {
    final XFile? file = await picker.pickVideo(
      source: ImageSource.gallery,
      maxDuration: const Duration(minutes: 5),
    );

    if (file != null) {
      selectedVideo.value = File(file.path);
      videoController.value = VideoPlayerController.file(selectedVideo.value!)
        ..initialize().then((_) {
          videoController.value!.setLooping(true);
          videoController.value!.play();
          update();
        });
    }
  }

  Future<void> pickThumbnail() async {
    final XFile? file = await picker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      selectedThumbnail.value = File(file.path);
    }
  }

  Future<void> uploadFeed({required BuildContext context}) async {
    if (selectedVideo.value == null ||
        selectedThumbnail.value == null ||
        descripController.text.isEmpty ||
        selectedProjectCategoryIds.isEmpty) {
      showToast("Please fill all fields and select video + thumbnail");
      return;
    }

    try {
      isLoading.value = true;
      Map<String, String> fields = {
        "desc": descripController.text,
        "category": jsonEncode(selectedProjectCategoryIds),
      };
      final response = await Api.uploadFilesMap(
        endPoint: uploadFeedUrl,
        filesMap: {
          "video": selectedVideo.value!,
          "image": selectedThumbnail.value!,
        },
        fields: fields,
      );

      if (response.success) {
        SuccessDialog.show(
          context,
          message: "Video Uploaded Successfully",
          onComplete: () {
            selectedVideo.value = null;
            selectedThumbnail.value = null;
            if (videoController.value != null) {
              videoController.value!.pause();
              videoController.value!.dispose();
              videoController.value = null;
            }
            descripController.clear();
            selectedProjectCategoryIndexes.clear();
            selectedProjectCategoryIds.clear();
            Screen.openAsNewPage(DashBoardView());
          },
        );
      } else {
        showToast("Upload failed: ${response.msg}");
      }
    } catch (e) {
      showToast("Upload failed: $e");
    }finally{
      isLoading.value = false;
    }
  }
}
