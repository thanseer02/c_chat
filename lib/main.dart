import 'package:base_project/config/app_config.dart';
import 'package:base_project/features/splash_screen/view/splash_screen.dart';
import 'package:base_project/utls/routes.dart';
import 'package:base_project/utls/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:overlay_support/overlay_support.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (context, child) {
        return OverlaySupport(
          child: MaterialApp(
            title: 'C chat',
            theme: appLightTheme,
            initialRoute: SplashScreen.routeName,
            onGenerateRoute: onAppGenerateRoute(),
            routes: appRoutes(),
            navigatorKey: AppConfig.navKey,
          ),
        );
      },
    );
}
}
