package com.example.base_project

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.content.Context
import android.os.BatteryManager

class MainActivity : FlutterActivity() {

    private val CHANNEL = "com.example.base_project/method_channel"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->

            if (call.method == "getBatteryLevel") {
                val batteryLevel = getBatteryLevel()
                if (batteryLevel != -1) { // Changed to -1 for error checking
                    result.success(batteryLevel)
                } else {
                    result.error("UNAVAILABLE", "Failed to get battery level", null) // Corrected error type and code
                }
            } else {
                result.notImplemented()
            }
        }
    }

    private fun getBatteryLevel(): Int {
        val battery = getSystemService(Context.BATTERY_SERVICE) as BatteryManager
        return battery.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY)
    }
}
