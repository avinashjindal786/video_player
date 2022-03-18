import 'package:flutter/material.dart';
import 'package:video_players/widget/other/tabbar_widget.dart';
import 'package:video_players/widget/basics/asset_player_widget.dart';
import 'package:video_players/widget/basics/file_system.dart';
import 'package:video_players/widget/basics/network_system.dart';

class BasicsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => TabBarWidget(
    tabs: [
      Tab(icon: Icon(Icons.file_copy), text: 'Asset'),
      Tab(icon: Icon(Icons.attach_file), text: 'File'),
      Tab(icon: Icon(Icons.ondemand_video_outlined), text: 'Network'),
    ],
    children: [
      buildAssets(),
      buildFiles(),
      buildNetwork(),
    ],
  );

  Widget buildAssets() => AssetPlayerWidget();

  Widget buildFiles() => FilePlayerWidget();

  Widget buildNetwork() => NetworkPlayerWidget();
}
