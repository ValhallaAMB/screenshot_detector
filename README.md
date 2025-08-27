# screenshot_detector

This project detects whenever screenshots are taken and displays an overlay on top of any app.

## Technologies used

- [Flutter overlay window](https://pub.dev/packages/flutter_overlay_window): Used to display the overlay
- [Flutter foreground task](https://pub.dev/packages/flutter_foreground_task): Used to keep the service working when outside of the app
- [Photo manager](https://pub.dev/packages/photo_manager): Used to access media storage inside of the android device
- [Permission handler](https://pub.dev/packages/permission_handler): Used for extra permission handling
