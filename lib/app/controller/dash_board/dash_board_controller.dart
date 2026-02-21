import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:noviindus_round_2/core/service/api.dart';
import 'package:noviindus_round_2/core/service/urls.dart';
import 'package:noviindus_round_2/shared/widgets/app_toast.dart';

import '../../model/dash_board/dash_board_data_response.dart';
import '../../model/feed/my_feed_response.dart';

class DashBoardController extends GetxController {
  @override
  void onInit() async {
    super.onInit();
    await dataFetching();
    await myDataFetching();
  }

  RxBool isLoading = false.obs;
  RxString selectedCategoryId = "".obs;

  void selectCategory(String id) {
    selectedCategoryId.value = id;
  }

  final TextEditingController descripController = TextEditingController();

  final List<String> projectCategories = [
    "Physics",
    "Artificial Intelligence",
    "Mathematics",
    "Chemistry",
    "Micro Biology",
    "Lorem ipsum dolor sit gre",
  ];

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
}
