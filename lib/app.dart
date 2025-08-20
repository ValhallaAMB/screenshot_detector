import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  bool _isShow = false;
  String _batteryLevel = "Reading...";

  static const batteryChannel = MethodChannel(
    "com.example.screenshot_detector/battery",
  );

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
                onPressed: () => {
                  setState(() {
                    _isShow = !_isShow;
                  }),
                },
              ),
              // If true then display the container
              _isShow
                  ? Container(
                      constraints: BoxConstraints.tight(Size(144, 40)),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        color: Colors.black.withValues(alpha: 0.2),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.save),
                            onPressed: () => {},
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () => {},
                          ),
                          IconButton(
                            icon: const Icon(Icons.share),
                            onPressed: () => {},
                          ),
                        ],
                      ),
                    )
                  : Text("Click on the burger menu"),
              const SizedBox(height: 20),
              Text(
                _batteryLevel,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24),
              ),
              MaterialButton(
                onPressed: getBatteryLevel,
                color: Color.fromARGB(255, 97, 82, 119),
                textColor: Colors.white,
                child: Text("Get battery percentage"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future getBatteryLevel() async {
    final args = {"title": "Battery level"};
    final String newBatteryLevel = await batteryChannel.invokeMethod(
      "getBatteryLevel",
      args,
    );

    setState(() {
      _batteryLevel = newBatteryLevel;
    });
  }
}
