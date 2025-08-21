import 'package:flutter/material.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
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
              const Text('Welcome to Screenshot Detector!'),
              IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () async {
                  if (await FlutterOverlayWindow.isActive()) {
                    FlutterOverlayWindow.closeOverlay();
                  } else {
                    FlutterOverlayWindow.showOverlay(
                      height: 80,
                      width: 300,
                      startPosition: OverlayPosition(0, 200),
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
