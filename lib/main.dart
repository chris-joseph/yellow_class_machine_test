import 'dart:io';

import 'package:camera/camera.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yellow_class_machine_test/src/home/home.dart';
import 'package:yellow_class_machine_test/src/utils/object_factory.dart';
import 'package:yellow_class_machine_test/src/utils/utils.dart';

import 'src/auth/login.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  List<CameraDescription> cameras = await availableCameras();
  runApp(MyApp(cameras: cameras));
}

class MyApp extends StatefulWidget {
  MyApp({this.cameras});
  final List<CameraDescription> cameras;

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ///TODO :Make sure that following line in <project root>/ios/Podfile uncommented:
  //
  // platform :ios, '9.0'

  Widget initApp(BuildContext context, User user) {
    print('here we are');
    if (user == null) {
      print('User is not signed in!');
      if (Platform.isAndroid) {
        return Login();
      } else {
        double height = MediaQuery.of(context).size.height;
        double width = MediaQuery.of(context).size.width;
        return UserHome(
          width: MediaQuery.of(context).orientation.index == 1 ? width : height,
          height:
              MediaQuery.of(context).orientation.index == 1 ? height : width,
          cameras: widget.cameras,
          orientation: MediaQuery.of(context).orientation,
        );
      }
    } else {
      print('User is signed in!');
      showToast('signed in as ${user.displayName}');
      double height = MediaQuery.of(context).size.height;
      double width = MediaQuery.of(context).size.width;
      return UserHome(
        width: MediaQuery.of(context).orientation.index == 1 ? width : height,
        height: MediaQuery.of(context).orientation.index == 1 ? height : width,
        cameras: widget.cameras,
      );
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      shortcuts: <LogicalKeySet, Intent>{
        LogicalKeySet(LogicalKeyboardKey.select): ActivateIntent(),
      },
      child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            // This is the theme of your application.
            //
            // Try running your application with "flutter run". You'll see the
            // application has a blue toolbar. Then, without quitting the app, try
            // changing the primarySwatch below to Colors.green and then invoke
            // "hot reload" (press "r" in the console where you ran "flutter run",
            // or simply save your changes to "hot reload" in a Flutter IDE).
            // Notice that the counter didn't reset back to zero; the application
            // is not restarted.
            primarySwatch: Colors.blue,
            // This makes the visual density adapt to the platform that you run
            // the app on. For desktop platforms, the controls will be smaller and
            // closer together (more dense) than on mobile platforms.
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: Scaffold(
              body: StreamBuilder(
                  stream: ObjectFactory().auth.authStateChanges(),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                        return SizedBox();
                      case ConnectionState.waiting:
                        return CircularProgressIndicator();
                      case ConnectionState.done:
                      case ConnectionState.active:
                        return initApp(context, snapshot.data);
                      default:
                        return SizedBox();
                    }
                  }))
          // MyHomePage(title: 'Flutter Demo Home Page'),
          ),
    );
  }
}
