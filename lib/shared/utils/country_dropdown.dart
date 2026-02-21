import 'package:flutter/material.dart';
import 'package:noviindus_round_2/core/style/app_text_style.dart';
import '../../core/style/colors.dart';

class CountryCodeDropdown extends StatelessWidget {
  final String value;
  final ValueChanged<String> onChanged;

  const CountryCodeDropdown({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: SizedBox(
        height: 70,
        child: DropdownButtonFormField<String>(
          dropdownColor: const Color.fromARGB(255, 52, 55, 58),
          borderRadius: BorderRadius.circular(8),
          iconDisabledColor: whiteClr,
          iconEnabledColor: whiteClr,
          style: AppTextStyles.textStyle_500_14.copyWith(
            color: whiteClr,
            fontSize: 16,
          ),
          value: value,
          isDense: true,
          items: const [
            DropdownMenuItem(value: "+91", child: Text("+91")),
            DropdownMenuItem(value: "+1", child: Text("+1")),
            DropdownMenuItem(value: "+44", child: Text("+44")),
          ],
          onChanged: (val) => onChanged(val!),
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 15,
            ),

            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: borderColor, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: borderColor, width: 1),
            ),
          ),
        ),
      ),
    );
  }
}
