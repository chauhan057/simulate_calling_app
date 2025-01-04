import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import '../utils/enum.dart';

class CallController extends GetxController {
  var callState = CallState.idle.obs;
  var isMuted = false.obs;
  var isVideoCall = false.obs;
  List<CameraDescription>? cameras;
  CameraController? activeCameraController;
  var isFrontCamera = true.obs;

  // Notification setup
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override
  void onInit() {
    super.onInit();
    // Initialize notification
    initializeNotifications();
  }

  // Initialize notifications
  void initializeNotifications() {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    const initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  // Show notification
  Future<void> showNotification(String message) async {
    const androidDetails = AndroidNotificationDetails(
      'channel_id',
      'channel_name',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );
    const notificationDetails = NotificationDetails(android: androidDetails);

    await flutterLocalNotificationsPlugin.show(
      0,
      'Call Notification',
      message,
      notificationDetails,
    );
  }

  Future<void> initCamera() async {
    cameras = await availableCameras();
    if (cameras != null && cameras!.isNotEmpty && activeCameraController == null) {
      activeCameraController = CameraController(cameras![0], ResolutionPreset.high);
      await activeCameraController!.initialize();
    }
  }

  void switchCamera() async {
    if (activeCameraController != null) {
      await activeCameraController!.dispose();
      activeCameraController = null;
    }

    isFrontCamera.value = !isFrontCamera.value;
    final selectedCamera = isFrontCamera.value ? cameras![0] : cameras![1];
    activeCameraController = CameraController(selectedCamera, ResolutionPreset.high);
    await activeCameraController!.initialize();
  }

  void startCall(bool isVideo) {
    callState.value = CallState.inCall;
    isVideoCall.value = isVideo;
    if (isVideoCall.value) {
      initCamera();
    }
  }

  void simulateIncomingCall() {
    callState.value = CallState.ringing;
  }

  void acceptCall() {
    callState.value = CallState.inCall;
    if (isVideoCall.value && activeCameraController == null) {
      initCamera();
    }
    showNotification('Call Accepted');
  }

  void endCall() {
    callState.value = CallState.idle;
    activeCameraController?.dispose();
    activeCameraController = null;
    showNotification('Call Ended');
  }

  void rejectCall() {
    callState.value = CallState.idle;
    showNotification('Call Rejected');
  }

  void toggleMute() {
    isMuted.value = !isMuted.value;
  }

  Future<void> requestPermissions() async {
    var cameraPermission = await Permission.camera.request();
    var micPermission = await Permission.microphone.request();

    if (cameraPermission.isGranted && micPermission.isGranted) {
      initCamera();
    } else {
      Get.dialog(
        AlertDialog(
          title: Text("Permission Denied"),
          content: Text("This app needs Camera and Microphone permissions to function properly."),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Get.back();
              },
            ),
          ],
        ),
      );
    }
  }
}
