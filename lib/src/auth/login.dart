import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yellow_class_machine_test/src/utils/utils.dart';

class Login extends StatefulWidget {
  Login({this.cameras});
  final List<CameraDescription> cameras;
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(MediaQuery.of(context).orientation.index);
    print(MediaQuery.of(context).size.width);

    return Scaffold(
      body: OrientationBuilder(
        builder: (_, orientation) {
          switch (orientation) {
            case Orientation.landscape:
              SystemChrome.setPreferredOrientations([
                DeviceOrientation.landscapeLeft,
              ]);
              return buildColumn(1);
            case Orientation.portrait:
              SystemChrome.setPreferredOrientations([
                DeviceOrientation.portraitUp,
              ]);
              return buildColumn(3);
            default:
              return SizedBox();
          }
        },
      ),
    );
  }

  Widget buildColumn(flex) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Flexible(
          fit: FlexFit.tight,
          flex: flex,
          child: Image.asset("assets/images/firebase.png"),
        ),
        Flexible(
          flex: 1,
          child: LoginRoundedButton(
            hasImageBackground: true,
            title: "Google",
            action: () async {
              await signInWithGoogle().then((value) {
                SystemChrome.setPreferredOrientations([
                  DeviceOrientation.landscapeLeft,
                ]);
                /*Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => UserHome(
                          cameras: widget.cameras, width: 0, height: 0)),
                  ModalRoute.withName('/'),
                );*/
              }, onError: () {
                showToast("Something went wrong");
              });
            },
            icon: Container(
                width: 35,
                height: 35,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    image: DecorationImage(
                      fit: BoxFit.fitWidth,
                      image: AssetImage("assets/images/google.png"),
                    ))),
            color: Colors.blue,
          ),
        ),
      ],
    );
  }
}

class LoginRoundedButton extends StatelessWidget {
  LoginRoundedButton(
      {this.title,
      this.icon,
      this.action,
      this.hasImageBackground = false,
      this.color});

  final String title;
  final Widget icon;
  final bool hasImageBackground;
  final action;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 70,
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: RaisedButton(
        textColor: Colors.white,
        color: color,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            icon != null
                ? icon
                : SizedBox(
                    width: 35,
                  ),
            Expanded(
              child: Container(
                child: Text(
                  title,
                  style: TextStyle(
                      letterSpacing: 1,
                      fontSize: 18,
                      fontWeight: FontWeight.w800),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            SizedBox(
              width: 35,
            )
          ],
        ),
        onPressed: () {
          action();
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(70.0),
        ),
      ),
    );
  }
}
