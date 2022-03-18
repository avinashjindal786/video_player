import 'package:flutter/material.dart';
import 'package:video_players/widget/other/tabbar_widget.dart';
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:video_player/video_player.dart';
import 'package:video_players/widget/video_player_widget.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:path/path.dart';

import 'dart:typed_data';

class fireStorageSystem extends StatefulWidget {


  @override
  _fireStorageSystemState createState() => _fireStorageSystemState();
}

class _fireStorageSystemState extends State<fireStorageSystem> {

  @override
  Widget build(BuildContext context) => TabBarWidget(
    tabs: [
      Tab(icon: Icon(Icons.file_copy), text: 'Asset'),
      Tab(icon: Icon(Icons.attach_file), text: 'File'),

    ],
    children: [
      buildAssets(),
      buildFiles(),

    ],
  );


  Widget buildFiles() {
    CollectionReference ref3 = FirebaseFirestore.instance.collection('video');
    return StreamBuilder(
        stream: ref3.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot)
        {
          return Expanded(child:
          ListView.builder(
              scrollDirection: Axis.vertical,

              itemCount: snapshot.data.docs.length,
            itemBuilder: (BuildContext context, int index)
            {
              var doc = snapshot.data.docs[index];
              final value = doc.get('videos');
              return AssetPlayerWidget(value: value,);
            },
          )
          );
        });
  }


}

class buildAssets extends StatefulWidget {


  @override
  _buildAssetsState createState() => _buildAssetsState();
}

class _buildAssetsState extends State<buildAssets> {
  UploadTask task;
  File file;
  String filename;

  final _firestore = FirebaseFirestore.instance.collection('video').doc("khwhdhwhhwjkwkjcwk");

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }


  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(32),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ButtonWidget(
                text: 'Select File',
                icon: Icons.attach_file,
                onClicked: ()
                {
                  selectFile();
                },
              ),
              SizedBox(height: 8),
              Text(
                file != null ? basename(file.path) : 'No File Selected',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 48),
              ButtonWidget(
                text: 'Upload File',
                icon: Icons.cloud_upload_outlined,
                onClicked: ()
                {
                  uploadFile();
                },
              ),
              SizedBox(height: 20),
              task != null ? buildUploadStatus(task) : Container(),
            ],
          ),
        ));
  }

  Widget buildUploadStatus(UploadTask task) => StreamBuilder<TaskSnapshot>(
    stream: task.snapshotEvents,
    builder: (context, snapshot) {
      
      if (snapshot.hasData) {
        final snap = snapshot.data;

        print(snap);
        final progress = snap.bytesTransferred / snap.totalBytes;
        final percentage = (progress * 100).toStringAsFixed(2);

        return Text(
          '$percentage %',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        );
      } else {
        return Container();
      }
    },
  );

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false,type: FileType.video);

    if (result == null) return;
    final path = result.files.single.path;

    setState(() => file = File(path));
  }

  Future uploadFile() async {
    if (file == null) return;

    final fileName = basename(file.path);
    final destination = 'files/$fileName';

    task = FirebaseApi.uploadFile(destination, file);
    setState(() {});

    if (task == null) return;

    final snapshot = await task.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();
    urlDownload != null ? await _firestore.set({
      "videos": urlDownload.toString(),
    }) : null ;
    print('Download-Link: $urlDownload');
  }
}



class ButtonWidget extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onClicked;

  const ButtonWidget({

    @required this.icon,
    @required this.text,
    @required this.onClicked,
  }) ;

  @override
  Widget build(BuildContext context) => ElevatedButton(
    style: ElevatedButton.styleFrom(
      primary: Color.fromRGBO(29, 194, 95, 1),
      minimumSize: Size.fromHeight(50),
    ),
    child: buildContent(),
    onPressed: onClicked,
  );

  Widget buildContent() => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(icon, size: 28),
      SizedBox(width: 16),
      Text(
        text,
        style: TextStyle(fontSize: 22, color: Colors.white),
      ),
    ],
  );
}


class FirebaseApi {
  static UploadTask uploadFile(String destination, File file) {
    try {
      final ref = FirebaseStorage.instance.ref(destination);

      return ref.putFile(file);
    } on FirebaseException catch (e) {
      return null;
    }
  }

  static UploadTask uploadBytes(String destination, Uint8List data) {
    try {
      final ref = FirebaseStorage.instance.ref(destination);

      return ref.putData(data);
    } on FirebaseException catch (e) {
      return null;
    }
  }
}

class AssetPlayerWidget extends StatefulWidget {

  String value;

  AssetPlayerWidget({this.value});
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
    controller = VideoPlayerController.network(widget.value)
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
        // SizedBox(height: 32,),
        // CircleAvatar(
        //   radius: 30,
        //   backgroundColor: Colors.red,
        //   child: IconButton(
        //     icon: Icon(
        //       ismuted ? Icons.volume_mute : Icons.volume_up,
        //       color: Colors.white,
        //     ),
        //     onPressed: () => controller.setVolume(ismuted ? 1 : 0),
        //   ),
        // )
      ],
    )  ;
  }
}