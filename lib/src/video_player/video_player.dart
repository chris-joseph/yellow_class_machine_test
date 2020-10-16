import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:yellow_class_machine_test/src/utils/object_factory.dart';
import 'package:yellow_class_machine_test/src/utils/utils.dart';

class VideoPlayer extends StatefulWidget {
  VideoPlayer(this.cameras);
  final List<CameraDescription> cameras;
  @override
  _VideoPlayerState createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer> {
  final String urlToStreamVideo =
      'http://distribution.bbb3d.renderfarming.net/video/mp4/bbb_sunflower_1080p_60fps_normal.mp4';
  VlcPlayerController controller;

  int _volume = 50;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller?.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = new VlcPlayerController(
        // Start playing as soon as the video is loaded.
        onInit: () {
      controller.setVolume(_volume);
      controller.play();
    });
  }

  playStateToggle() {
    controller.isPlaying().then((isPlaying) {
      if (isPlaying) {
        print("pause");
        controller.pause();
        showToast("paused");
      } else {
        controller.play();
        showToast("playing");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    print(MediaQuery.of(context).size.aspectRatio);

    return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.logout),
          onPressed: () async {
            await ObjectFactory().auth.signOut();
            await controller.stop();
            await controller.dispose();
          },
        ),
        body: SizedBox(child: Container(
          child: OrientationBuilder(
            builder: (_, orientation) {
              switch (orientation) {
                case Orientation.landscape:
                  return Container(
                    width: double.infinity,
                    child: buildVlcPlayer(context),
                  );
                case Orientation.portrait:
                  return SizedBox();
                /*Container(
                width: double.infinity,
                height: height / 2.5,
                child: buildVlcPlayer(context, height: height, width: width),
              );*/
                default:
                  return SizedBox();
              }
            },
          ),
        )));
  }

  Widget buildVlcPlayer(BuildContext context, {width, height}) {
    return GestureDetector(
      onTap: playStateToggle,
      child: Stack(
        children: [
          Positioned.fill(
            child: VlcPlayer(
              loop: true,
              aspectRatio: MediaQuery.of(context).size.aspectRatio,
              url: urlToStreamVideo,
              controller: controller,
              placeholder: Center(child: CircularProgressIndicator()),
            ),
          ),
          Positioned(
            top: 30,
            bottom: 30,
            child: RotatedBox(
              quarterTurns: 3,
              child: Slider(
                value: double.parse('$_volume'),
                label: '$_volume',
                min: 0,
                max: 100,
                onChanged: (value) {
                  setState(() {
                    _volume = value.ceil();
                  });
                  print(_volume);
                  controller.setVolume(_volume);
                },
              ),
            ),
          ),
          Positioned.fill(child: GestureDetector(onTap: playStateToggle))
        ],
      ),
    );
  }
}
