import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';

class OverlayMain extends StatefulWidget {
  const OverlayMain({super.key});

  @override
  State<OverlayMain> createState() => _OverlayMainState();
}

class _OverlayMainState extends State<OverlayMain> {
  File? latestScreenshot;
  String? screenshotPath;

  @override
  void initState() {
    super.initState();
    FlutterOverlayWindow.overlayListener.listen((data) {
      debugPrint('Overlay event data: $data');
      if (data is String && data.isNotEmpty) {
        setState(() {
          screenshotPath = data;
          latestScreenshot = File(data);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Material(
        color: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (latestScreenshot != null)
              Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withValues(alpha: 0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(
                    latestScreenshot!,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withValues(alpha: 0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildActionButton(
                    icon: Icons.crop,
                    onPressed: () async {
                      debugPrint('Crop pressed');
                      await FlutterOverlayWindow.closeOverlay();
                    },
                  ),
                  _buildActionButton(
                    icon: Icons.save,
                    onPressed: () async {
                      debugPrint('Save pressed');
                      await FlutterOverlayWindow.closeOverlay();
                    },
                  ),
                  _buildActionButton(
                    icon: Icons.delete,
                    onPressed: () async {
                      debugPrint('Delete pressed');
                      await FlutterOverlayWindow.closeOverlay();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return IconButton(
      icon: Icon(icon, size: 20),
      onPressed: onPressed,
      color: Color(0xFF6851A5),
    );
  }
}
