import 'package:flutter/material.dart';
// import './loginAnimation.dart';
import 'dart:async';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Login Animation Tutorial',
        home: new LoginPage());
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  final TextEditingController controllerUser = TextEditingController(text: '');
  final TextEditingController controllerPassword =
      TextEditingController(text: '');

  var statusClick = 0;

  // late AnimationController animationControllerButton;
  late AnimationController animationControllerButton;
  Animation? animation;

  @override
  void initState() {
    super.initState();
    animationControllerButton =
        AnimationController(duration: Duration(seconds: 3), vsync: this)
          ..addStatusListener((status) {
            if (status == AnimationStatus.dismissed) {
              setState(() {
                statusClick = 0;
              });
            }
          });
    animationControllerButton.forward();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    animationControllerButton.dispose();
  }

  Future<Null> _playAnimation() async {
    try {
      animationControllerButton.forward();
      animationControllerButton.reverse();
    } on TickerCanceled {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('img/bg.jpg'), fit: BoxFit.cover)),
      child: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [
              Color.fromRGBO(162, 146, 199, 0.8),
              Color.fromRGBO(51, 51, 63, 0.9)
            ],
                begin: FractionalOffset.topCenter,
                end: FractionalOffset.bottomCenter)),
        child: ListView(padding: const EdgeInsets.all(20.0), children: [
          Stack(alignment: AlignmentDirectional.bottomCenter, children: [
            Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 270.0),
                ),
                Container(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                      ),
                      TextField(
                        controller: controllerUser,
                        decoration: InputDecoration(
                            icon: Icon(
                              Icons.person,
                              color: Colors.white,
                            ),
                            hintText: "Username"),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                      ),
                      TextField(
                        controller: controllerPassword,
                        decoration: InputDecoration(
                            icon: Icon(
                              Icons.lock_outline,
                              color: Colors.white,
                            ),
                            hintText: "Password"),
                      ),
                      TextButton(
                          // padding:
                          //     const EdgeInsets.only(top: 220.0, bottom: 30.0),
                          onPressed: null,
                          child: Text(
                            "Dont have any account? Sign up here.",
                            style: TextStyle(
                                fontSize: 12.0,
                                color: Colors.white,
                                fontWeight: FontWeight.w300,
                                letterSpacing: 0.5),
                          ))
                    ],
                  ),
                )
              ],
            ),
            // statusClick == 0
            //     ?
            InkWell(
                onTap: () {
                  setState(() {
                    statusClick = 1;
                  });
                  _playAnimation();
                },
                child: SignIn())
            // : StartAnimation(
            //     buttonController: animationControllerButton.view,
            //     user: controllerUser.text,
            //     password: controllerPassword.text,
            //   )
          ])
        ]),
      ),
    ));
  }
}

class SignIn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Padding(
      padding: const EdgeInsets.all(60.0),
      child: Container(
        alignment: FractionalOffset.center,
        width: 320.0,
        height: 60.0,
        decoration: BoxDecoration(
            color: Colors.red[700],
            borderRadius: BorderRadius.all(const Radius.circular(30.0))),
        child: new Text("Sign In",
            style: new TextStyle(
                fontSize: 20.0,
                color: Colors.white,
                fontWeight: FontWeight.w300,
                letterSpacing: 0.3)),
      ),
    );
  }
}
