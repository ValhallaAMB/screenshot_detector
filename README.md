# screenshot_detector

This project detects whenever screenshots are taken and displays an overlay on top of any app.

## How does it work?

As soon as the application launches, you are greeted with the option of accepting the permission in order for the app to run properly. After you accept all of the permissions, you can start listening for screenshots. Upon pressing the button, a preview of the overlay will be displayed, using the latest picture from your gallery as a placeholder. Finally, as soon as you take a screenshot, the overlay will be displayed automatically. 

### Extra notes

- The lister checks for changes every 2 seconds.
- flutter_overlay_window's permission functionality doesn't work with Android versions lower than 10, so Permission_helper is used instead of it. 

## Technologies used

- [Flutter overlay window](https://pub.dev/packages/flutter_overlay_window): Used to display the overlay
- [Flutter foreground task](https://pub.dev/packages/flutter_foreground_task): Used to keep the service working when outside of the app
- [Photo manager](https://pub.dev/packages/photo_manager): Used to access media storage inside of the Android device
- [Permission handler](https://pub.dev/packages/permission_handler): Used for extra permission handling
