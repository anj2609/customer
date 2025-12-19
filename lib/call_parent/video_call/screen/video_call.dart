// import 'package:agora/notification_code/notification_service.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:vivashri/call_parent/chat/models/chat_user.dart';
import 'package:vivashri/call_parent/video_call/service/call_notification_service.dart';
import 'package:vivashri/call_parent/video_call/util/constant.dart';

class VideoCall extends StatefulWidget {
  final String fcmToken;
  final String channelId;
  VideoCall({super.key, required this.channelId, required this.fcmToken});

  @override
  State<VideoCall> createState() => _VideoCallState();
}

class _VideoCallState extends State<VideoCall> {
  late RtcEngine _engine;
  int? _remoteUid;
  bool localUserJoined = false;
  bool isMuted = false;
  bool isVideoOff = false;
  bool _alreadyEnded = false;

  @override
  void initState() {
    initAgora();
    super.initState();
  }

  @override
  void dispose() {
    _dispose();
    super.dispose();
  }

  Future<void> initAgora() async {
    await [Permission.microphone, Permission.camera].request();

    _engine = createAgoraRtcEngine();

    await _engine.initialize(
      const RtcEngineContext(
        appId: appId,
        channelProfile: ChannelProfileType.channelProfileCommunication,
      ),
    );

    await _engine.enableVideo();
    await _engine.startPreview();

    _engine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (connection, elapsed) {
          debugPrint("local user ${connection.localUid} joined");
          setState(() => localUserJoined = true);
        },
        onUserJoined: (connection, remoteUid, elapsed) {
          debugPrint("remote user $remoteUid joined");
          setState(() => _remoteUid = remoteUid);
        },
        onUserOffline: (connection, remoteUid, reason) {
          debugPrint("remote user $remoteUid left");
          setState(() => _remoteUid = null);
        },
      ),
    );

    await _engine.joinChannel(
      token: token,
      channelId: widget.channelId,
      uid: 0,
      options: const ChannelMediaOptions(
        autoSubscribeAudio: true,
        autoSubscribeVideo: true,
        publishCameraTrack: true,
        publishMicrophoneTrack: true,
        clientRoleType: ClientRoleType.clientRoleBroadcaster,
      ),
    );
  }

  Future<void> _dispose() async {
    if (_alreadyEnded) return; // Prevent multiple execution
    _alreadyEnded = true;

    // Send call end notification only once
    NotificationService.sendCallEndedNotification(
      widget.fcmToken,
      widget.channelId,
    );

    await _engine.leaveChannel();
    await _engine.release();
  }

  Widget _remoteVideo() {
    if (_remoteUid != null) {
      return AgoraVideoView(
        controller: VideoViewController.remote(
          rtcEngine: _engine,
          canvas: VideoCanvas(uid: _remoteUid),
          connection: RtcConnection(channelId: widget.channelId),
        ),
      );
    } else {
      return const Center(
        child: Text(
          'Please wait for remote user to join',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Video call"),
        // actions: [
        //   ElevatedButton(
        //     child: const Text("Start Video Call"),
        //     onPressed: () {
        //       Navigator.push(
        //         context,
        //         MaterialPageRoute(builder: (_) => const VideoCallPage()),
        //       );
        //     },
        //   )
        // ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Center(child: _remoteVideo()),

            /// Local video preview
            Positioned(
              top: 20,
              left: 20,
              child: SizedBox(
                width: 100,
                height: 150,
                child: localUserJoined
                    ? AgoraVideoView(
                        controller: VideoViewController(
                          rtcEngine: _engine,
                          canvas: const VideoCanvas(uid: 0),
                        ),
                      )
                    : const CircularProgressIndicator(),
              ),
            ),

            /// Bottom control buttons
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    /// Mute / Unmute
                    FloatingActionButton(
                      backgroundColor: Colors.grey[800],
                      child: Icon(
                        isMuted ? Icons.mic_off : Icons.mic,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        setState(() => isMuted = !isMuted);
                        _engine.muteLocalAudioStream(isMuted);
                      },
                    ),

                    /// End Call
                    FloatingActionButton(
                      backgroundColor: Colors.red,
                      child: const Icon(Icons.call_end, color: Colors.white),
                      onPressed: () {
                        _dispose();

                        Navigator.pop(context);
                      },
                    ),

                    /// Video On / Off
                    FloatingActionButton(
                      backgroundColor: Colors.grey[800],
                      child: Icon(
                        isVideoOff ? Icons.videocam_off : Icons.videocam,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        setState(() => isVideoOff = !isVideoOff);
                        _engine.muteLocalVideoStream(isVideoOff);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
