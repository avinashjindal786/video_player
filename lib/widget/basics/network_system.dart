import 'package:flutter/material.dart';
import 'package:video_players/widget/video_player_widget.dart';
import 'package:video_player/video_player.dart';
import 'package:video_players/widget/other/flotingbutton.dart';
import 'package:video_players/widget/other/textbar.dart';
import 'package:video_players/main.dart';
class NetworkPlayerWidget extends StatefulWidget {
  @override
  _NetworkPlayerWidgetState createState() => _NetworkPlayerWidgetState();
}

class _NetworkPlayerWidgetState extends State<NetworkPlayerWidget> {

  final textController = TextEditingController(text: 'https://assets.mixkit.co/videos/preview/mixkit-group-of-friends-partying-happily-4640-large.mp4');
  VideoPlayerController controller;

  @override
  void initState() {
    super.initState();

    controller = VideoPlayerController.network(textController.text)
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
  Widget build(BuildContext context) => Container(
    alignment: Alignment.center,
    child: Column(
      children: [
        VideoPlayerWidget(controller: controller),
        buildTextField(),
      ],
    ),
  );

  Widget buildTextField() => Container(
    padding: EdgeInsets.all(32),
    child: Row(
      children: [
        Expanded(
          child: TextFieldWidget(
            controller: textController,
            hintText: 'Enter Video Url',
          ),
        ),
        const SizedBox(width: 12),
        FloatingActionButtonWidget(
          onPressed: () {
            if (textController.text.trim().isEmpty) return;
            controller = VideoPlayerController.network(textController.text)
              ..addListener(() => setState(() {}))
              ..setLooping(true)
              ..initialize().then((_) => controller.play());
          },
        ),
      ],
    ),
  );
}