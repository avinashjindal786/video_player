import 'package:flutter/material.dart';
import 'package:video_players/page/basics_page.dart';
import 'package:video_players/page/orientation_page.dart';
import 'package:video_players/page/firestorage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Video Player',
      theme: ThemeData(
        primaryColor: Colors.blueAccent,
        scaffoldBackgroundColor: Colors.black,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        colorScheme: ColorScheme.dark(),
      ),
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int index = 0;

  @override
  Widget build(BuildContext context) => Scaffold(
    bottomNavigationBar: buildBottomBar(),
    body: buildPages(),
  );

  Widget buildBottomBar() {
    final style = TextStyle(color: Colors.white);

    return BottomNavigationBar(
      backgroundColor: Theme.of(context).primaryColor,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white70,
      currentIndex: index,
      items: [
        BottomNavigationBarItem(
          icon: Text('VideoPlayer', style: style),
          title: Text('Basics'),
        ),
        BottomNavigationBarItem(
          icon: Text('VideoPlayer', style: style),
          title: Text('Orientation'),
        ),
        BottomNavigationBarItem(
          icon: Text('fireBase', style: style),
          title: Text('upload'),
        ),
      ],
      onTap: (int index) => setState(() => this.index = index),
    );
  }

  Widget buildPages() {
    switch (index) {
      case 0:
        return BasicsPage();
      case 1:
        return OrientationPage();
      case 2:
        return fireStorageSystem();
      default:
        return Container();
    }
  }
}