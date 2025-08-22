import 'package:flutter/material.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot_detector/app.dart';
import 'package:screenshot_detector/overlay.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

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

  // if (!await FlutterOverlayWindow.isPermissionGranted()) {
  //   await FlutterOverlayWindow.requestPermission();
  // }

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
