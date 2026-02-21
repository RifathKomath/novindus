import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/extensions/margin_extension.dart';
import '../../core/style/app_text_style.dart';
import '../../core/style/colors.dart';

class AppTextField extends StatelessWidget {
  final String? label;
  final String labelText;
  final TextEditingController controller;
  final TextInputType textInputType;
  final String? Function(String?)? validator;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final bool readOnly;
  final ValueChanged<String>? onChanged;
  final int? maxLength;
  final int? minLines;
  final int? max;
  final bool useHintInsteadOfLabel;
  final bool isRequired;
  final List<TextInputFormatter>? inputFormatters;
  final TextCapitalization textCapitalization;
  final bool obscureText;

  const AppTextField({
    super.key,
    this.label,
    this.obscureText = false,
    required this.controller,
    required this.textInputType,
    this.validator,
    this.prefixIcon,
    this.suffixIcon,
    this.minLines,
    this.readOnly = false,
    required this.labelText,
    this.onChanged,
    this.maxLength,
    this.max,
    this.textCapitalization = TextCapitalization.none,
    this.useHintInsteadOfLabel = false,
    this.isRequired = false,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) customTitle(label!, isRequired),
        8.hBox,
        TextFormField(
          maxLength: maxLength,
          minLines: minLines,
          style: AppTextStyles.textStyle_500_14.copyWith(color: whiteClr),
          maxLines: max,
          readOnly: readOnly,
          obscureText: obscureText,
          textCapitalization: textCapitalization,
          controller: controller,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          onChanged: onChanged,
          inputFormatters: inputFormatters,

          decoration: InputDecoration(
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 17,
            ),
            counterText: '',
            suffixIcon: suffixIcon,
            prefixIcon: prefixIcon,
            hintText: useHintInsteadOfLabel ? labelText : null,
            labelText: useHintInsteadOfLabel ? null : labelText,
            hintStyle: AppTextStyles.textStyle_400_14.copyWith(
              color: darkGrey,
              fontSize: 12,
            ),
            labelStyle: AppTextStyles.textStyle_400_14.copyWith(
              color: darkGrey,
              fontSize: 12,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: borderColor, width: 1),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: borderColor, width: 1),
            ),
          ),
          keyboardType: textInputType,
          validator: validator,
        ),
      ],
    );
  }
}

Widget customTitle(final String label, bool isRequired) {
  return RichText(
    text: TextSpan(
      text: label,
      style: AppTextStyles.textStyle_400_14.copyWith(
        color: Colors.black,
        fontSize: 16,
      ),
      children: isRequired
          ? const [
              TextSpan(
                text: ' *',
                style: TextStyle(color: Colors.red),
              ),
            ]
          : [],
    ),
  );
}
