import 'package:base_project/config/app_config.dart';
import 'package:base_project/utls/colors.dart';
import 'package:base_project/utls/extentions.dart';
import 'package:base_project/utls/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

AppBar buildAppBar({
  required String title,
  VoidCallback? onBackPress,
  TextStyle? titleStyle,
  Color? backgroundColor,
  bool? showActions,
  bool? showBack = true,
}) {
  return AppBar(
    flexibleSpace: SizedBox(
      width: 250.spMin,
      height: 250.spMin,
    ),
    title: Text(
      title,
      style: titleStyle ?? tsS16W600.copyWith(color: colorBlack),
      textAlign: TextAlign.start,
    ),
    leading: showBack!
        ? InkWell(
            onTap: () {
              if (onBackPress != null) {
                onBackPress();
              } else {
                Navigator.of(AppConfig.navKey.currentState!.context).pop();
              }
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.spMin),
              child: SvgPicture.asset('ic_arrow_left'.asAssetSvg()),
            ),
          )
        : null,
    actions: showActions == null ? [] : null,
    titleSpacing: showBack ? 0 : 10.spMin,
    elevation: 0,
    iconTheme: IconThemeData(color: colorBlack),
    backgroundColor: backgroundColor ?? colorWhite,
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: colorWhite,
      // <-- SEE HERE
      statusBarIconBrightness: Brightness.light,
      //<-- For Android SEE HERE (dark icons)
      statusBarBrightness: Brightness.light, //<-- For iOS SEE HERE (dark icons)
    ),
  );
}
