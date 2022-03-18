import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_players/main.dart';
import 'package:video_players/widget/overlay/videoplayer_both.dart';
import 'package:video_players/widget/overlay/video_full_screen.dart';
import 'package:video_player/video_player.dart';
import 'package:wakelock/wakelock.dart';

class PortraitLandscapePlayerPage extends StatefulWidget {
  @override
  _PortraitLandscapePlayerPageState createState() =>
      _PortraitLandscapePlayerPageState();
}

class _PortraitLandscapePlayerPageState
    extends State<PortraitLandscapePlayerPage> {
  VideoPlayerController controller;

  @override
  void initState() {
    super.initState();

    controller = VideoPlayerController.network('https://assets.mixkit.co/videos/preview/mixkit-group-of-friends-partying-happily-4640-large.mp4')
      ..addListener(() => setState(() {}))
      ..setLooping(true)
      ..initialize().then((_) => controller.play());
  }

  @override
  void dispose() {
    controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(toolbarHeight: 0),
    body: VideoPlayerBothWidget(controller: controller),
  );
}