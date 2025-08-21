import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:workmanager/workmanager.dart';

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  File? latestScreenshot;
  String? lastSeenId;
  bool isListening = false;

  void _startListening() {
    // Poll every 2s for new screenshots
    if (isListening) {
      Future.delayed(Duration(seconds: 2), () async {
        await _checkForNewScreenshot();
        if (mounted) _startListening();
      });
    }
  }

  Future<void> _checkForNewScreenshot() async {
    final List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(
      type: RequestType.image,
    );

    // Find "Screenshots" album
    final screenshotsAlbum = albums.firstWhere(
      (a) => a.name.toLowerCase().contains("screenshot"),
      orElse: () => albums.first,
    );

    final recent = await screenshotsAlbum.getAssetListPaged(page: 0, size: 1);

    if (recent.isNotEmpty) {
      final latest = recent.first;
      if (latest.id != lastSeenId) {
        final file = await latest.file;
        if (file != null) {
          setState(() {
            latestScreenshot = file;
            lastSeenId = latest.id;
          });
          // Overlay
          if (await FlutterOverlayWindow.isActive()) {
            FlutterOverlayWindow.closeOverlay();
          } else {
            // share a JSON-encodable value (the file path) instead of a File object
            latestScreenshot != null
                ? FlutterOverlayWindow.shareData(latestScreenshot!.path)
                : FlutterOverlayWindow.shareData(null);
            FlutterOverlayWindow.showOverlay(
              alignment: OverlayAlignment.bottomCenter,
            );
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Screenshot Detector',
      home: Scaffold(
        appBar: AppBar(title: const Text('Screenshot Detector')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Welcome to Screenshot Detector!',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // Start listening for new screenshots
                  setState(() {
                    isListening = !isListening;
                  });
                  if (isListening) {
                    _startListening();
                  }
                },
                child: Text(isListening ? 'Stop Listening' : 'Start Listening'),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                child: const Text('Toggle Overlay'),
                onPressed: () async {
                  String uniqueId = DateTime.now().toIso8601String();
                  Workmanager().registerPeriodicTask(
                    uniqueId,
                    "printInfo",
                    frequency: Duration(seconds: 2),
                  );

                  if (await FlutterOverlayWindow.isActive()) {
                    FlutterOverlayWindow.closeOverlay();
                  } else {
                    // share a JSON-encodable value (the file path) instead of a File object
                    latestScreenshot != null
                        ? FlutterOverlayWindow.shareData(latestScreenshot!.path)
                        : FlutterOverlayWindow.shareData(null);
                    FlutterOverlayWindow.showOverlay(
                      alignment: OverlayAlignment.bottomCenter,
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
