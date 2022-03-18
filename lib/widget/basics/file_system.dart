import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:video_players/widget/video_player_widget.dart';
class FilePlayerWidget extends StatefulWidget {


  @override
  _FilePlayerWidgetState createState() => _FilePlayerWidgetState();
}

class _FilePlayerWidgetState extends State<FilePlayerWidget> {
  VideoPlayerController controller;
  final File file = File(
      '');
  @override
  void initState() {
    super.initState();

    if (file.existsSync()) {
      controller = VideoPlayerController.file(file)
        ..addListener(() => setState(() {}))
        ..setLooping(true)
        ..initialize().then((_) => controller.play());
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          VideoPlayerWidget(controller: controller),
          buildAddButton(),
        ],
      ),
    );


  }
  Widget buildAddButton() => Container(
    padding: EdgeInsets.all(32),
    child: FloatingActionButton(
      child: Icon(Icons.add),
      onPressed: () async {
        final file = await pickVideoFile();
        if (file == null) return;

        controller = VideoPlayerController.file(file)
          ..addListener(() => setState(() {}))
          ..setLooping(true)
          ..initialize().then((_) {
            controller.play();
            setState(() {});
          });
      },

    ),
  );
  Future<File> pickVideoFile() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.video);
    if (result == null) return null;

    return File(result.files.single.path);
  }
}
