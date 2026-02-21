import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';

import '../../../core/service/api.dart';
import '../../../core/service/shared_pref.dart';
import '../../../core/service/urls.dart';
import '../../../shared/utils/screen_utils.dart';
import '../../../shared/widgets/app_success_dialog.dart';
import '../../../shared/widgets/app_toast.dart';
import '../../model/login/login_request.dart';
import '../../model/login/login_response.dart';
import '../../view/dash_board/dash_board_view.dart';

class LoginController extends GetxController {
  RxBool isLoading = false.obs;
  final formKey = GlobalKey<FormState>();
  RxString countryCode = "+91".obs;
  final TextEditingController phoneNoCntrl = TextEditingController();

  void login({required BuildContext context}) async {
    try {
      isLoading.value = true;
      final requestBody = LoginRequest(
        countryCode: countryCode.value,
        phone: phoneNoCntrl.text,
      );
      final response = await Api.call(
        endPoint: loginUrl,
        method: Method.post,
        body: requestBody.toJson(),
        isFormData: true,
      );
      if (response.success) {
        final result = LoginResponse.fromJson(response.response);

        await SharedPref().saveAccessToken(result.token?.access ?? "");
        await SharedPref().loadAccessToken();
        SuccessDialog.show(
          context,
          message: "Logged in successfully",
          onComplete: () {
            Screen.openAsNewPage(DashBoardView());
          },
        );
      } else {
        showToast(response.msg.isNotEmpty ? response.msg : "Error while login");
      }
    } catch (e) {
      print("Error while login $e");
    } finally {
      isLoading.value = false;
    }
  }
}
