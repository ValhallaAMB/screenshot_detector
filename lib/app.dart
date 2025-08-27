import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:screenshot_detector/services/foreground_services.dart';
import 'package:system_alert_window/system_alert_window.dart';

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  bool isListening = false;

  // Handle incoming data from the foreground service
  void _onReceiveTaskData(Object data) {
    if (data is Map<String, dynamic>) {
      debugPrint("Data from Foreground: $data");
    }
  }

  @override
  void initState() {
    super.initState();
    FlutterForegroundTask.addTaskDataCallback(_onReceiveTaskData);

    // Request permissions and initialize service
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _requestPermissions();
      await _initService();
    });
  }

  @override
  void dispose() {
    FlutterForegroundTask.removeTaskDataCallback(_onReceiveTaskData);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Screenshot Detector')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Click the button to start listening for screenshots",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  setState(() => isListening = !isListening);
                  if (isListening) {
                    _startForegroundTask();
                  } else {
                    _stopForegroundTask();
                  }
                },
                child: Text(isListening ? 'Stop Listening' : 'Start Listening'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Request necessary permissions
  Future<void> _requestPermissions() async {
    // Notifications (Android 13+ runtime)
    final np = await FlutterForegroundTask.checkNotificationPermission();
    if (np != NotificationPermission.granted) {
      await FlutterForegroundTask.requestNotificationPermission();
    }

    // Optional but recommended for long-running FG services on Android 12+:
    if (Platform.isAndroid &&
        !await FlutterForegroundTask.isIgnoringBatteryOptimizations) {
      await FlutterForegroundTask.requestIgnoreBatteryOptimization();
    }

    // Media (screenshots) – PhotoManager handles runtime prompts.
    await PhotoManager.requestPermissionExtend();

    // Overlay permission (for your floating bar)
    // if (!await FlutterOverlayWindow.isPermissionGranted()) {
    //   await FlutterOverlayWindow.requestPermission();
    // }

    SystemAlertWindow.requestPermissions;
  }

  // Initialize foreground service
  Future<void> _initService() async {
    FlutterForegroundTask.init(
      androidNotificationOptions: AndroidNotificationOptions(
        channelId: 'foreground_service',
        channelName: 'Screenshot Detector',
        channelDescription: 'Detecting screenshots in background.',
        onlyAlertOnce: true,
      ),
      iosNotificationOptions: const IOSNotificationOptions(
        showNotification: false,
        playSound: false,
      ),
      foregroundTaskOptions: ForegroundTaskOptions(
        eventAction: ForegroundTaskEventAction.repeat(
          3000, // Check every 3 seconds
        ),
      ),
    );
  }

  // Start foreground task
  Future<ServiceRequestResult> _startForegroundTask() async {
    if (await FlutterForegroundTask.isRunningService) {
      return FlutterForegroundTask.restartService();
    }
    return FlutterForegroundTask.startService(
      serviceId: 256,
      notificationTitle: 'Screenshot Detector Running',
      notificationText: 'Listening for screenshots…',
      callback: startCallback,
    );
  }

  // Stop foreground task
  Future<ServiceRequestResult> _stopForegroundTask() async {
    return FlutterForegroundTask.stopService();
  }
}
