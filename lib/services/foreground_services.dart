import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
// import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:system_alert_window/system_alert_window.dart';

// Foreground service entry point
@pragma('vm:entry-point')
void startCallback() {
  FlutterForegroundTask.setTaskHandler(MyTaskHandler());
}

class MyTaskHandler extends TaskHandler {
  String? lastSeenId;

  void _checkForNewScreenshot() async {
    // Get the list of albums
    final albums = await PhotoManager.getAssetPathList(type: RequestType.image);

    // Find the screenshots album
    final screenshotsAlbum = albums.firstWhere(
      (a) => a.name.toLowerCase().contains("screenshot"),
      orElse: () => AssetPathEntity(id: '', name: ''),
    );

    // Get the most recent screenshot
    final recent = await screenshotsAlbum.getAssetListPaged(page: 0, size: 1);
    if (recent.isNotEmpty) {
      final latest = recent.first;
      if (latest.id != lastSeenId) {
        final file = await latest.file;
        if (file != null) {
          lastSeenId = latest.id;
          debugPrint('New screenshot detected: ${file.path}');

          // Show overlay with screenshot
          // if (!await FlutterOverlayWindow.isActive()) {
          //   FlutterOverlayWindow.shareData(file.path);
          //   FlutterOverlayWindow.showOverlay(
          //     alignment: OverlayAlignment.center,
          //   );
          // }

          SystemAlertWindow.showSystemWindow(
            prefMode: SystemWindowPrefMode.OVERLAY,
          );

          // Send data back to main app
          FlutterForegroundTask.sendDataToMain({"screenshotPath": file.path});
        }
      }
    }
  }

  @override
  Future<void> onStart(DateTime timestamp, TaskStarter starter) async {
    debugPrint('Foreground Task Started...');
    _checkForNewScreenshot();
  }

  @override
  void onRepeatEvent(DateTime timestamp) async {
    debugPrint('Checking for screenshots…');
    _checkForNewScreenshot();
  }

  @override
  Future<void> onDestroy(DateTime timestamp, bool isTimeout) async {}
}
