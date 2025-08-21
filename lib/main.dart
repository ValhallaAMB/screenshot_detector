import 'package:flutter/material.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot_detector/app.dart';
import 'package:screenshot_detector/overlay.dart';
import 'package:workmanager/workmanager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Workmanager().initialize(callbackDispatcher, isInDebugMode: true);

  if (!await _requestPermissions()) {
    openAppSettings();
  }

  runApp(const MainApp());
}

Future<bool> _requestPermissions() async {
  Map<Permission, PermissionStatus> statuses = await [
    Permission.photos,
    // Permission.storage,
    Permission.manageExternalStorage,
    Permission.systemAlertWindow,
  ].request();

  if (!await FlutterOverlayWindow.isPermissionGranted()) {
    await FlutterOverlayWindow.requestPermission();
  }

  // statuses.forEach((permission, status) {
  //   debugPrint('$permission: $status');
  // });

  return statuses.values.every((status) => status.isGranted);
}

// overlay entry point
@pragma("vm:entry-point")
void overlayMain() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const OverlayMain());
}

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    switch (task) {
      case "printInfo":
        await funTask();
        break;
      default:
        // Handle unknown task types
        break;
    }

    return Future.value(true);
  });
}

Future<void> funTask() async {
  // This function can be used to perform background tasks
  // For example, you can check for new screenshots here
  debugPrint("Background task executed");
}
