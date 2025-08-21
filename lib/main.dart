import 'package:flutter/material.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:screenshot_detector/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (await FlutterOverlayWindow.isPermissionGranted()) {
    runApp(const MainApp());
  } else {
    await FlutterOverlayWindow.requestPermission();
  }
}

// overlay entry point
@pragma("vm:entry-point")
void overlayMain() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Material(
        borderRadius: BorderRadius.circular(8),
        color: Colors.black.withValues(alpha: 0.1),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: const Icon(Icons.save, color: Colors.teal),
              onPressed: () async {
                if (await FlutterOverlayWindow.isActive()) {
                  FlutterOverlayWindow.closeOverlay();
                }
              },
            ),
            IconButton(
              icon: const Icon(Icons.crop, color: Colors.teal),
              onPressed: () async {
                if (await FlutterOverlayWindow.isActive()) {
                  FlutterOverlayWindow.closeOverlay();
                }
              },
            ),
            IconButton(
              icon: const Icon(Icons.share, color: Colors.teal),
              onPressed: () async {
                if (await FlutterOverlayWindow.isActive()) {
                  FlutterOverlayWindow.closeOverlay();
                }
              },
            ),
          ],
        ),
      ),
    ),
  );
}
