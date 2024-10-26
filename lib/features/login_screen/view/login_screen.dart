import 'package:base_project/features/home/home.dart';
import 'package:base_project/features/voice_read/voice_read_screen.dart';
import 'package:base_project/utls/colors.dart';
import 'package:base_project/utls/styles.dart';
import 'package:base_project/widgets/app_button.dart';
import 'package:base_project/widgets/app_icon_button.dart';
import 'package:base_project/widgets/custom_appbar.dart';
import 'package:base_project/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  static const routeName = '/LoginScreen';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  int batteryLevel = -1;
  @override
  void initState() {
    getBatteryLevel();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorWhite,
      appBar: buildAppBar(title: ''),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.spMin, vertical: 20),
            child: Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Text(
                            'Log in to Chatbox',
                            style: tsS18W600,
                          ),
                          Text(
                            batteryLevel.toString(),
                            style: tsS18W600,
                          ),
                          SizedBox(
                            height: 16.spMin,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12.spMin),
                            child: Text(
                              '''Welcome back! Sign in using your social account or email to continue us''',
                              style:
                                  tsS14W400.copyWith(color: secondaryTextColor),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(
                            height: 30.spMin,
                          ),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AppIconButton(
                                icon: 'facebook',
                              ),
                              AppIconButton(
                                icon: 'google',
                              ),
                              AppIconButton(
                                icon: 'apple',
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 30.spMin,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Container(
                                  height: 1,
                                  color: colorDivider,
                                ),
                              ),
                              SizedBox(
                                width: 5.spMin,
                              ),
                              Text(
                                'OR',
                                style: tsS14W400.copyWith(
                                  color: secondaryTextColor,
                                ),
                              ),
                              SizedBox(
                                width: 5.spMin,
                              ),
                              Expanded(
                                child: Container(
                                  height: 1,
                                  color: colorDivider,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 30.spMin,
                          ),
                          const AppTextField(
                            lablel: 'Email',
                          ),
                          SizedBox(
                            height: 30.spMin,
                          ),
                          const AppTextField(
                            lablel: 'Password',
                          ),
                        ],
                      ),
                    ),
                  ),
                  AppButton(
                    text: 'Log in',
                    onTap: () {
                      Navigator.pushNamed(context, HomeScreen.routeName);
                    },
                  ),
                  SizedBox(
                    height: 16.spMin,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, Voice.routeName);
                    },
                    child: Text(
                      'Forgot Password?',
                      style: tsS16W500.copyWith(color: primaryButtonColor),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  static const platform =
      MethodChannel('com.example.base_project/method_channel');

  Future<void> getBatteryLevel() async {
    String battery = '';
    try {
      final result = await platform.invokeMethod('getBatteryLevel');
      battery = result.toString();
    } catch (e) {
      print('Error: $e');
      battery = '-1';
    }
    setState(() {
      batteryLevel = int.parse(battery);
    });
  }
}
