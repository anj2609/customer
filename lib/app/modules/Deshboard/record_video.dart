import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';
import 'package:http/http.dart' as http;
import 'package:vivashri/config/utils/colors.dart';
import 'package:vivashri/config/utils/constants.dart';
import 'package:vivashri/config/utils/style.dart';
import 'package:vivashri/data/controller/userprofile.dart';
import 'package:vivashri/widgets/video_link.dart';
import 'package:video_thumbnail/video_thumbnail.dart' as vt;
import 'package:path_provider/path_provider.dart';

class EnableCameraScreen extends StatefulWidget {
  const EnableCameraScreen({super.key});

  @override
  State<EnableCameraScreen> createState() => _EnableCameraScreenState();
}

class _EnableCameraScreenState extends State<EnableCameraScreen> {
  Future<void> requestPermission(BuildContext context) async {
    final status = await Permission.camera.request();

    if (status.isGranted) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const VideoRecordScreen()),
      );
    }
  }

  final usercontroller = Get.put(UserDetailController());
  Future<File?> getVideoThumbnail(String videoUrl) async {
    final tempDir = await getTemporaryDirectory();

    final thumbPath = await vt.VideoThumbnail.thumbnailFile(
      video: videoUrl,
      thumbnailPath: tempDir.path,
      imageFormat: vt.ImageFormat.JPEG,
      maxHeight: 300,
      quality: 75,
    );

    if (thumbPath == null) return null;
    return File(thumbPath);
  }

  @override
  Widget build(BuildContext context) {
    final u = usercontroller.userData.value!;
    print('jhjhjhjh${u.selfintroductionvideo}');
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text(
          'Record Short Intro',
          style: opensansMedium.copyWith(fontSize: 17),
        ),
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.grey.shade50,
        leading: const BackButton(color: Colors.black),
      ),
      body: u.selfintroductionvideo == null
          ? RefreshIndicator(
              onRefresh: () async {
                setState(() {});
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 160),

                      Image.asset("assets/images/image 20.png", height: 150),

                      const SizedBox(height: 20),

                      Text(
                        "Enable Camera",
                        style: opensansSemiBold.copyWith(fontSize: 20),
                      ),

                      const SizedBox(height: 10),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: Text(
                          "We'll need this permission for accessing the camera roll for recording video",
                          textAlign: TextAlign.center,
                          style: opensansMedium.copyWith(
                            color: Colors.grey,
                            fontSize: 13,
                          ),
                        ),
                      ),

                      const Spacer(),

                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          "SKIP",
                          style: opensansSemiBold.copyWith(
                            color: ColorResources.primarycolor2,
                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(
                          left: 20,
                          right: 20,
                          bottom: 100,
                        ),
                        child: SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ColorResources.primarycolor2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: () => requestPermission(context),
                            child: Text(
                              "Enable Camera",
                              style: opensansSemiBold.copyWith(
                                fontSize: 15,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          : RefreshIndicator(
              onRefresh: () async {
                setState(() {});
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (_) => VideoDialog(
                                videoUrl:
                                    "${ApiConstants.imageurl}${u.selfintroductionvideo}",
                              ),
                            );
                          },
                          child: FutureBuilder<File?>(
                            future: getVideoThumbnail(
                              "${ApiConstants.imageurl}${u.selfintroductionvideo}",
                            ),
                            builder: (context, snapshot) {
                              // 🔄 Loader
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Container(
                                  width: double.infinity,
                                  height: 300,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: Colors.black.withOpacity(0.1),
                                  ),
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      color: ColorResources.primarycolor2,
                                      strokeWidth: 2,
                                    ),
                                  ),
                                );
                              }

                              // ❌ Placeholder
                              if (!snapshot.hasData || snapshot.data == null) {
                                return _videoPlaceholder();
                              }

                              // ✅ Thumbnail
                              return Container(
                                width: double.infinity,
                                height: 300,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  image: DecorationImage(
                                    image: FileImage(snapshot.data!),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                child: _playOverlay(),
                              );
                            },
                          ),
                        ),

                        const Spacer(),

                        Padding(
                          padding: const EdgeInsets.only(
                            left: 20,
                            right: 20,
                            bottom: 150,
                          ),
                          child: SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: ColorResources.primarycolor2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: () => requestPermission(context),
                              child: Text(
                                "Change Recording",
                                style: opensansSemiBold.copyWith(
                                  fontSize: 15,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  Widget _videoPlaceholder() {
    return Container(
      width: double.infinity,
      height: 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        image: const DecorationImage(
          image: AssetImage("assets/images/video_placeholder.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      child: _playOverlay(),
    );
  }

  Widget _playOverlay() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.black.withOpacity(0.4),
          ),
        ),
        Container(
          height: 70,
          width: 70,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.play_arrow, size: 40, color: Colors.black),
        ),
      ],
    );
  }
}

class VideoRecordScreen extends StatefulWidget {
  const VideoRecordScreen({super.key});

  @override
  State<VideoRecordScreen> createState() => _VideoRecordScreenState();
}

class _VideoRecordScreenState extends State<VideoRecordScreen> {
  CameraController? controller;
  bool isRecording = false;

  Timer? timer;
  int seconds = 0;

  @override
  void initState() {
    super.initState();
    initFrontCamera();
  }

  Future<void> initFrontCamera() async {
    final cameras = await availableCameras();

    final frontCam = cameras.firstWhere(
      (c) => c.lensDirection == CameraLensDirection.front,
    );

    controller = CameraController(
      frontCam,
      ResolutionPreset.medium,
      enableAudio: true,
    );

    await controller!.initialize();
    setState(() {});
  }

  /// ⏱ Start Timer
  void startTimer() {
    seconds = 0;
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      setState(() {
        seconds++;
      });

      if (seconds >= 60) {
        stopRecording();
      }
    });
  }

  /// 🛑 Stop Timer
  void stopTimer() {
    timer?.cancel();
    timer = null;
  }

  Future<void> startRecording() async {
    await controller!.startVideoRecording();
    isRecording = true;
    startTimer();
    setState(() {});
  }

  Future<void> stopRecording() async {
    if (!isRecording) return;

    stopTimer();
    isRecording = false;

    final video = await controller!.stopVideoRecording();

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => VideoPreviewScreen(videoFile: File(video.path)),
      ),
    );
  }

  String formatTime(int sec) {
    final m = (sec ~/ 60).toString().padLeft(2, '0');
    final s = (sec % 60).toString().padLeft(2, '0');
    return "$m:$s";
  }

  @override
  Widget build(BuildContext context) {
    if (controller == null || !controller!.value.isInitialized) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          CameraPreview(controller!),

          Positioned(
            top: 50,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  formatTime(seconds),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),

          /// RECORD BUTTON
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: GestureDetector(
                onTap: isRecording ? stopRecording : startRecording,
                child: Container(
                  height: 70,
                  width: 70,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isRecording ? Colors.red : Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    stopTimer();
    controller?.dispose();
    super.dispose();
  }
}

class VideoPreviewScreen extends StatefulWidget {
  final File? videoFile;
  const VideoPreviewScreen({super.key, this.videoFile});

  @override
  State<VideoPreviewScreen> createState() => _VideoPreviewScreenState();
}

class _VideoPreviewScreenState extends State<VideoPreviewScreen> {
  late VideoPlayerController player;
  bool isUploading = false;
  final usercontroller = Get.put(UserDetailController());

  @override
  void initState() {
    super.initState();
    player = VideoPlayerController.file(widget.videoFile!)
      ..initialize().then((_) {
        setState(() {});
      });
  }

  Future<void> uploadVideo() async {
    setState(() => isUploading = true);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? profileid = prefs.getString("profileid");

    String? token = prefs.getString("token");

    final uri = Uri.parse(
      "https://vivashri.com/vivashribackend/api/user/self-introduction-video",
    );

    final request = http.MultipartRequest('POST', uri);

    /// 🔐 HEADERS
    request.headers.addAll({
      "Authorization": "Bearer $token",
      "Accept": "application/json",
    });

    final videoFile = await http.MultipartFile.fromPath(
      "self_introduction_video",
      widget.videoFile!.path,
      contentType: MediaType("video", "mp4"),
      filename: "self_intro.mp4",
    );

    request.files.add(videoFile);

    final response = await request.send();

    setState(() => isUploading = false);

    final responseBody = await response.stream.bytesToString();
    print("STATUS: ${response.statusCode}");
    print("BODY: $responseBody");

    if (response.statusCode == 200 || response.statusCode == 201) {
      await Future.delayed(const Duration(milliseconds: 500));
      usercontroller.fetchUserDetail(profileid.toString());

      Get.back();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Upload Failed (${response.statusCode})")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("Preview"),
      ),
      body: Column(
        children: [
          /// VIDEO PLAYER
          AspectRatio(
            aspectRatio: player.value.aspectRatio,
            child: VideoPlayer(player),
          ),

          const SizedBox(height: 20),

          /// PLAY / PAUSE
          IconButton(
            iconSize: 50,
            color: Colors.white,
            icon: Icon(
              player.value.isPlaying ? Icons.pause_circle : Icons.play_circle,
            ),
            onPressed: () {
              setState(() {
                player.value.isPlaying ? player.pause() : player.play();
              });
            },
          ),

          const Spacer(),

          /// BUTTONS
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                /// CHANGE VIDEO
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.white),
                    minimumSize: const Size(double.infinity, 48),
                  ),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const VideoRecordScreen(),
                      ),
                    );
                  },
                  child: Text("Change Video"),
                ),

                const SizedBox(height: 10),

                /// UPLOAD VIDEO
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorResources.primarycolor2,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  onPressed: isUploading ? null : uploadVideo,
                  child: isUploading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                          "Upload Video",
                          style: opensansSemiBold.copyWith(color: Colors.white),
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }
}
