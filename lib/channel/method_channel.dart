import 'package:flutter/services.dart';

class PlatformService {
  static const platform =
      MethodChannel('com.example.base_project/method_channel');

  Future<String> getBatteryLevel() async {
    try {
      final batteryLevel = await platform.invokeMethod('getBatteryLevel');
      return 'batteryLevel $batteryLevel%';
    } on PlatformException catch (e) {
      return 'Failed to get battery level: ${e.message}';
    }
  }
}
