import 'package:base_project/utls/colors.dart';
import 'package:base_project/utls/extentions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class AppIconButton extends StatelessWidget {
  const AppIconButton({
    required this.icon,
    super.key,
  });
  final String icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.spMin),
      child: Container(
        height: 48.spMin,
        padding: EdgeInsets.all(12.spMin),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: colorBlack,
          ),
        ),
        child: SvgPicture.asset(icon.asAssetSvg()),
      ),
    );
  }
}
