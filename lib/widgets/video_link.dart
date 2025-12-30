import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:vivashri/config/utils/colors.dart';

class VideoDialog extends StatefulWidget {
  final String videoUrl;
  const VideoDialog({Key? key, required this.videoUrl}) : super(key: key);

  @override
  _VideoDialogState createState() => _VideoDialogState();
}

class _VideoDialogState extends State<VideoDialog> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.all(10),
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.only(top: 30),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(10),
            ),
            child: _controller.value.isInitialized
                ? AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  )
                : Center(
                    child: CircularProgressIndicator(
                      color: ColorResources.primarycolor2,
                    ),
                  ),
          ),

          /// CLOSE ICON TOP RIGHT
          Positioned(
            right: 0,
            child: IconButton(
              icon: Icon(Icons.close, color: Colors.white, size: 26),
              onPressed: () {
                _controller.pause();
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}
