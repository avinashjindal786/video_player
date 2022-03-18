import 'package:flutter/material.dart';

import 'package:video_player/video_player.dart';
import 'package:video_players/widget/video_player_widget.dart';

class AssetPlayerWidget extends StatefulWidget {


  @override
  _AssetPlayerWidgetState createState() => _AssetPlayerWidgetState();
}

class _AssetPlayerWidgetState extends State<AssetPlayerWidget> {

  final asset = 'assets/video.mp4';
  VideoPlayerController controller ;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = VideoPlayerController.asset(asset)
      ..addListener(() => setState(() {}))
      ..setLooping(true)
      ..initialize().then((_) => controller.pause());
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final ismuted = controller.value.volume ==0;

    return Column(
      children: [
        VideoPlayerWidget(controller: controller),
        SizedBox(height: 32,),
        CircleAvatar(
          radius: 30,
          backgroundColor: Colors.red,
          child: IconButton(
            icon: Icon(
              ismuted ? Icons.volume_mute : Icons.volume_up,
              color: Colors.white,
            ),
            onPressed: () => controller.setVolume(ismuted ? 1 : 0),
          ),
        )
      ],
    )  ;
  }
}
