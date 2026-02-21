import 'package:flutter/material.dart';
import '../../../../core/style/app_text_style.dart';
import '../../../../core/style/colors.dart';
import '../../../../shared/widgets/app_svg.dart';

class CategoryChip extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;
  final bool showIcon;

  const CategoryChip({
    super.key,
    required this.title,
    required this.isSelected,
    required this.onTap,
    this.showIcon = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15),
        decoration: BoxDecoration(
          color: isSelected
              ? redClr2.withOpacity(0.10)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: isSelected
                ? redClr2.withOpacity(0.40)
                : textClr2.withOpacity(0.3),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showIcon)
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: AppSvg(assetName: "ankr-(ankr)"),
              ),
            Text(
              title,
              style: AppTextStyles.textStyle_400_14.copyWith(
                color: whiteClr,
                fontSize: 12
              ),
            ),
          ],
        ),
      ),
    );
  }
}
