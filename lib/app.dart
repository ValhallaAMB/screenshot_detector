import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  bool _isShow = false;

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
            ],
          ),
        ),
      ),
    );
  }
}
