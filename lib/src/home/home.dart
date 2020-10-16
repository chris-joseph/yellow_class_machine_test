import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yellow_class_machine_test/src/camera_preview/camera_preview.dart';
import 'package:yellow_class_machine_test/src/video_player/video_player.dart';

class UserHome extends StatefulWidget {
  UserHome({Key key, this.cameras, this.height, this.width, this.orientation})
      : super(key: key);
  final List<CameraDescription> cameras;
  final double height;
  final double width;
  final Orientation orientation;
  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  _UserHomeState createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> {
  double xPosition;
  double yPosition;
  double xLimit;
  double yLimit;

  @override
  void initState() {
    super.initState();
    xPosition = widget.width - 150;
    yPosition = widget.height - 100;
    xLimit = widget.width - 150;
    yLimit = widget.height - 100;
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(body: buildStack());
  }

  Stack buildStack() {
    return Stack(
      children: [
        Positioned.fill(child: VideoPlayer(widget.cameras)),
        Positioned(
            top: yPosition,
            left: xPosition,
            child: GestureDetector(
                onPanUpdate: (tapInfo) {
                  if (false) {
                    print("sadasDASDasdASDasdASSSSSSSSSSSSSSSSSSSSSSS");
                    if ((yPosition + tapInfo.delta.dx) >= 0 &&
                        (yPosition + tapInfo.delta.dx) <= xLimit) {
                      if ((xPosition + tapInfo.delta.dy) >= 0 &&
                          (xPosition + tapInfo.delta.dy) <= yLimit) {
                        setState(() {
                          yPosition += tapInfo.delta.dx;
                          xPosition += tapInfo.delta.dy;
                        });
                      }
                    }
                  } else {
                    if ((xPosition + tapInfo.delta.dx) >= 0 &&
                        (xPosition + tapInfo.delta.dx) <= xLimit) {
                      if ((yPosition + tapInfo.delta.dy) >= 0 &&
                          (yPosition + tapInfo.delta.dy) <= yLimit) {
                        setState(() {
                          xPosition += tapInfo.delta.dx;
                          yPosition += tapInfo.delta.dy;
                        });
                      }
                    }
                  }
                },
                child: CameraApp(widget.cameras))),
      ],
    );
  }
}
