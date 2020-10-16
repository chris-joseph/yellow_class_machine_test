import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:yellow_class_machine_test/src/utils/utils.dart';

class CameraApp extends StatefulWidget {
  CameraApp(this.cameras);
  final List<CameraDescription> cameras;

  @override
  _CameraAppState createState() => _CameraAppState();
}

class _CameraAppState extends State<CameraApp> {
  CameraController controller;

  setupCamera() async {
    // If the controller is updated then update the UI.
    controller = CameraController(widget.cameras[1], ResolutionPreset.medium);

    controller.addListener(() {
      if (mounted) setState(() {});
      if (controller.value.hasError) {
        showToast('Camera error ${controller.value.errorDescription}');
      }
    });

    try {
      await controller.initialize();
    } on CameraException catch (e) {
      showToast(e.description);
    }

    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setupCamera();
  }

  @override
  Widget build(BuildContext context) {
    if (controller == null || !controller.value.isInitialized) {
      return SizedBox();
    } else {
      return SizedBox(
        width: 150,
        height: 100,
        child: RotatedBox(
          quarterTurns: 3,
          child: AspectRatio(
            aspectRatio: controller.value.aspectRatio,
            child: CameraPreview(controller),
          ),
        ),
      );
    }
  }
}
