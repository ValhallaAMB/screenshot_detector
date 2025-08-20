package com.example.screenshot_detector

import android.content.Context
//import android.content.ContextWrapper
//import android.content.IntentFilter
import android.os.BatteryManager
//import android.os.Build
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity(){
    private val BATTERY_CHANNEL = "com.example.screenshot_detector/battery"
    private lateinit var channel: MethodChannel

    override fun configureFlutterEngine(flutterEngine: FlutterEngine){
        super.configureFlutterEngine(flutterEngine)
        channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, BATTERY_CHANNEL)
        channel.setMethodCallHandler { call, result ->
            if (call.method == "getBatteryLevel") {
                val args = call.arguments as Map<*, *>
                val title = args["title"]

                val batteryLevel = getBatteryLevel()

                result.success("$title: $batteryLevel")
            }else {
                result.error("Bad", "Did not complete", "Big error")
            }
        }
    }

    private fun getBatteryLevel(): Int {
        val batteryLevel: Int
        val batteryManager = getSystemService(Context.BATTERY_SERVICE) as BatteryManager
        batteryLevel = batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY)


//        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
//
//            val batteryManager = getSystemService(BATTERY_SERVICE) as BatteryManager
//            batteryLevel = batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY)
//        } else {
//            val intent = ContextWrapper(applicationContext).registerReceiver(null, IntentFilter())
//            batteryLevel = intent!!.getIntExtra(BatteryManager.EXTRA_LEVEL, -1) * 100
//        }


        return batteryLevel
    }
}

