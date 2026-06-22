// import 'dart:async';
// import 'package:astro_gurujii/Screens/video_call/Helpers/utils.dart';
// import 'package:agora_rtc_engine/rtc_engine.dart';
// import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
// import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;
// import 'package:get/get.dart';

// class AgoraController extends GetxController {
//   // Meeeting Timer Helper
//   late Timer meetingTimer;
//   int meetingDuration = 0;
//   var meetingDurationTxt = "00:00".obs;

//   // Agora utitilty
//   bool muted = false;
//   bool hands = true;
//   bool muteVideo = false;
//   bool backCamera = false;

//   void onToggleMuteAudio({required RtcEngine engine}) {
//     muted = !muted;
//     engine.muteLocalAudioStream(muted);
//   }
//  void toggleAudioRoute({required RtcEngine engine}) async {
//   hands = !hands;

//   if (hands) {
//     // Route audio to speaker
//     // await engine.setDefaultAudioRouteToSpeakerphone(true);
//     await engine.setEnableSpeakerphone(true);
//   } else {
//     // Route audio to earpiece
//     await engine.setEnableSpeakerphone(false);
//     // await engine.setDefaultAudioRouteToSpeakerphone(false);
//   }

//   print("Audio routed to ${hands ? "SPEAKER" : "EARPIECE"}");
// }

//   void onToggleMuteVideo({required RtcEngine engine}) {
//     muteVideo = !muteVideo;
//     engine.muteLocalVideoStream(muteVideo);
//   }

//   void onSwitchCamera({required RtcEngine engine}) {
//     backCamera = !backCamera;
//     engine.switchCamera();
//   }

//   void startMeetingTimer() async {
//     meetingTimer = Timer.periodic(
//       const Duration(seconds: 1),
//       (meetingTimer) {
//         int min = (meetingDuration ~/ 60);
//         int sec = (meetingDuration % 60).toInt();

//         meetingDurationTxt.value = min.toString() + ":" + sec.toString() + "";

//         if (checkNoSignleDigit(min)) {
//           meetingDurationTxt.value =
//               "0" + min.toString() + ":" + sec.toString() + "";
//         }
//         if (checkNoSignleDigit(sec)) {
//           if (checkNoSignleDigit(min)) {
//             meetingDurationTxt.value =
//                 "0" + min.toString() + ":0" + sec.toString() + "";
//           } else {
//             meetingDurationTxt.value =
//                 min.toString() + ":0" + sec.toString() + "";
//           }
//         }
//         meetingDuration = meetingDuration + 1;
//       },
//     );
//   }
// }

import 'dart:async';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:get/get.dart';

class AgoraController extends GetxController {
  // Meeeting Timer Helper
  Timer? meetingTimer;
  int meetingDuration = 0;
  final RxString meetingDurationTxt = "00:00".obs;

  // Agora utility (used by GetBuilder)
  bool muted = false;
  bool hands = true;        // true = speakerphone
  bool muteVideo = false;
  bool backCamera = false;

  Future<void> onToggleMuteAudio({required RtcEngine engine}) async {
    muted = !muted;
    await engine.muteLocalAudioStream(muted);
    update();
  }

  Future<void> toggleAudioRoute({required RtcEngine engine}) async {
    hands = !hands;
    await engine.setEnableSpeakerphone(hands);
    update();
  }

  Future<void> onToggleMuteVideo({required RtcEngine engine}) async {
    muteVideo = !muteVideo;
    await engine.muteLocalVideoStream(muteVideo);
    update();
  }

  Future<void> onSwitchCamera({required RtcEngine engine}) async {
    backCamera = !backCamera;
    await engine.switchCamera();
    update();
  }

  void startMeetingTimer() {
    meetingTimer?.cancel();
    meetingDuration = 0;
    _emitTime();

    meetingTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      meetingDuration = meetingDuration + 1;
      _emitTime();
    });
  }

  void _emitTime() {
    final min = (meetingDuration ~/ 60).toString().padLeft(2, '0');
    final sec = (meetingDuration % 60).toString().padLeft(2, '0');
    meetingDurationTxt.value = "$min:$sec";
  }

  @override
  void onClose() {
    meetingTimer?.cancel();
    super.onClose();
  }
}
