import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/CallController.dart';
import '../utils/colors.dart';
import '../utils/enum.dart';

class CallScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final CallController callController = Get.put(CallController());

    return Scaffold(
      backgroundColor: AppColors.vcBackgroundColor,
      appBar: AppBar(
        title: Center(child:  Text('Console Calling App', style: TextStyle(color: Colors.white))),
        backgroundColor: AppColors.vcTitle,
      ),
      body: Container(
        width: Get.width,
        padding: EdgeInsets.all(16.0),
        child: Obx(() {
          switch (callController.callState.value) {
            case CallState.idle:
              return idleView(callController);
            case CallState.ringing:
              return ringingView(callController);
            case CallState.inCall:
              return inCallView(callController);
            default:
              return SizedBox.shrink();
          }
        }),
      ),
    );
  }
// widget for audio call
  Widget idleView(CallController callController) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Ready to make a call',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 40),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            backgroundColor: Colors.green,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          ),
          onPressed: () => callController.startCall(false),
          icon: Icon(Icons.call, size: 30),
          label: Text('Audio Call'),
        ),
        SizedBox(height: 16),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            backgroundColor: Colors.blue,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          ),
          onPressed: () => callController.startCall(true),
          icon: Icon(Icons.video_call, size: 30),
          label: Text('Video Call'),
        ),
        SizedBox(height: 16),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            backgroundColor: Colors.orange,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          ),
          onPressed: callController.simulateIncomingCall,
          icon: Icon(Icons.phone_in_talk, size: 30),
          label: Text('Simulate Incoming Call'),
        ),
      ],
    );
  }

// widget for video call
  Widget ringingView(CallController callController) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Incoming Call...',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
              onPressed: callController.acceptCall,
              child: Text('Accept'),
            ),
            SizedBox(width: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
              onPressed: callController.rejectCall,
              child: Text('Reject'),
            ),
          ],
        ),
      ],
    );
  }


// widget for Simulated incoming call
  Widget inCallView(CallController callController) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (callController.isVideoCall.value)
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.grey[200], // Optional background color
            ),
            child: Icon(
              callController.isFrontCamera.value ? Icons.camera_front : Icons.camera_rear,
              size: 100,
              color: Colors.black,
            ),
          ),
        SizedBox(height: 30),
        Text(
          callController.isVideoCall.value ? 'Video Call in Progress' : 'Audio Call in Progress',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                backgroundColor: callController.isMuted.value ? Colors.grey : Colors.blue,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
              onPressed: callController.toggleMute,
              icon: Icon(callController.isMuted.value ? Icons.volume_off : Icons.volume_up, size: 30),
              label: Text(callController.isMuted.value ? 'Unmute' : 'Mute'),
            ),
            SizedBox(width: 20),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
              onPressed: callController.endCall,
              icon: Icon(Icons.call_end, size: 30),
              label: Text('End Call'),
            ),
          ],
        ),
        if (callController.isVideoCall.value)
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                backgroundColor: Colors.orange,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
              onPressed: callController.switchCamera,
              icon: Icon(Icons.switch_camera, size: 30),
              label: Text('Switch Camera'),
            ),
          ),
      ],
    );
  }
}
