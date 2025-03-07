import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoPopup extends StatefulWidget {
  final YoutubePlayerController controller;

  const VideoPopup({super.key, required this.controller});

  @override
  VideoPopupState createState() => VideoPopupState();
}

class VideoPopupState extends State<VideoPopup> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onFullScreenChange);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onFullScreenChange);
    _restorePortraitMode();
    super.dispose();
  }

  void _onFullScreenChange() {
    if (widget.controller.value.isFullScreen) {
      // Lock to landscape when full-screen is enabled
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeRight,
        DeviceOrientation.landscapeLeft,
      ]);
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    } else {
      // Restore to portrait when exiting full-screen
      _restorePortraitMode();
    }
  }

  void _restorePortraitMode() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(12),
      backgroundColor: Colors.black,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: YoutubePlayer(
        controller: widget.controller,
        showVideoProgressIndicator: true,
        onReady: () {
          widget.controller.play();
        },
        onEnded: (_) {
          Navigator.of(context).pop(); // Close popup when video ends
        },
      ),
    );
  }
}
