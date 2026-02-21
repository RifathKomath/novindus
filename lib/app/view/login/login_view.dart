import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:noviindus_round_2/app/controller/login/login_controller.dart';
import 'package:noviindus_round_2/core/extensions/margin_extension.dart';
import 'package:noviindus_round_2/core/style/app_text_style.dart';
import 'package:noviindus_round_2/core/style/colors.dart';
import 'package:noviindus_round_2/shared/widgets/app_svg.dart';

import '../../../shared/utils/country_dropdown.dart';
import '../../../shared/utils/validators.dart';
import '../../../shared/widgets/app_text_field.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final LoginController controller = Get.put(LoginController());
    return Scaffold(
      body: Form(
        key: controller.formKey,
        child: Padding(
          padding: EdgeInsets.only(top: 80, left: 18, right: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Enter Your\nMobile Number",
                style: AppTextStyles.textStyle_500_14.copyWith(
                  fontSize: 23,
                  color: whiteClr,
                ),
              ),
              12.h.hBox,
              Text(
                "Lorem ipsum dolor sit amet consectetur. Porta at id hac vitae. Et tortor at vehicula euismod mi viverra.",
                style: AppTextStyles.textStyle_400_14.copyWith(
                  fontSize: 12,
                  color: whiteClr,
                ),
              ),
              36.h.hBox,
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(
                    () => SizedBox(
                      width: 90.w,
                      child: CountryCodeDropdown(
                        value: controller.countryCode.value,
                        onChanged: (val) {
                          controller.countryCode.value = val;
                        },
                      ),
                    ),
                  ),

                  8.wBox,
                  Expanded(
                    child: AppTextField(
                      controller: controller.phoneNoCntrl,
                      textInputType: TextInputType.number,
                      labelText: "Enter your Phone Number",
                      useHintInsteadOfLabel: true,
                      isRequired: true,
                      maxLength: 10,
                      validator: AppValidators.required,
                    ),
                  ),
                ],
              ),
              Spacer(),
              Align(
                alignment: Alignment.center,
                child: Obx(
                  () => continueButton(
                    isLoading: controller.isLoading.value,
                    onTap: () {
                      if (controller.formKey.currentState!.validate()) {
                        controller.login(context: context);
                      }
                    },
                  ),
                ),
              ),
              120.h.hBox,
            ],
          ),
        ),
      ),
    );
  }
}

Widget continueButton({VoidCallback? onTap, bool isLoading = false}) {
  return InkWell(
    borderRadius: BorderRadius.circular(35),
    onTap: isLoading ? null : onTap,
    child: Container(
      decoration: BoxDecoration(
        border: Border.all(color: whiteClr.withOpacity(0.28), width: 2),
        borderRadius: BorderRadius.circular(35),
        color: playButtonClr.withOpacity(0.09),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Continue",
              style: AppTextStyles.textStyle_400_14.copyWith(color: whiteClr),
            ),
            15.w.wBox,
            isLoading
                ? Container(
                    height: 34,
                    width: 34,
                    decoration: const BoxDecoration(
                      color: redClr2,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: CupertinoActivityIndicator(
                        color: Colors.black,
                        radius: 10,
                      ),
                    ),
                  )
                : AppSvg(assetName: "red_play_button"),
          ],
        ),
      ),
    ),
  );
}
