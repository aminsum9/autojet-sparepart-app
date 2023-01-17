import 'dart:ffi';

import 'package:flutter/material.dart';
import 'home.dart';

class StartAnimation extends StatefulWidget {
  StartAnimation(
      {Key? key, required this.buttonController, required this.successLogin})
      : shrinkButtonAnimation = Tween(
          begin: 320.0,
          end: 70.0,
        ).animate(
          CurvedAnimation(
              curve: const Interval(0.0, 0.150), parent: buttonController),
        ),
        zoomAnimation = Tween(begin: 70.0, end: 200.0).animate(CurvedAnimation(
            parent: buttonController,
            curve: const Interval(
              0.55,
              0.999,
              curve: Curves.bounceInOut,
            ))),
        super(key: key);

  AnimationController buttonController;
  Animation shrinkButtonAnimation;
  Animation zoomAnimation;

  bool successLogin;

  Widget buildAnimation(BuildContext context, Widget? child) {
    return Padding(
        padding: const EdgeInsets.only(bottom: 60.0),
        child: zoomAnimation.value <= 100
            ? Container(
                alignment: FractionalOffset.center,
                width: shrinkButtonAnimation.value,
                height: 60.0,
                decoration: BoxDecoration(
                    color: Colors.red[700],
                    borderRadius:
                        const BorderRadius.all(Radius.circular(30.0))),
                child: shrinkButtonAnimation.value > 75
                    ? const Text("Sign In",
                        style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.white,
                            fontWeight: FontWeight.w300,
                            letterSpacing: 0.3))
                    : const CircularProgressIndicator(
                        strokeWidth: 1.0,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ))
            : successLogin
                ? Container(
                    width: zoomAnimation.value,
                    height: zoomAnimation.value,
                    decoration: BoxDecoration(
                      color: Colors.red[700],
                      shape: zoomAnimation.value < 600
                          ? BoxShape.circle
                          : BoxShape.rectangle,
                    ),
                  )
                : Container(
                    alignment: FractionalOffset.center,
                    width: shrinkButtonAnimation.value,
                    height: 60.0,
                    decoration: BoxDecoration(
                        color: Colors.red[700],
                        borderRadius:
                            const BorderRadius.all(Radius.circular(30.0))),
                    child: shrinkButtonAnimation.value > 75
                        ? const Text("Sign In",
                            style: TextStyle(
                                fontSize: 20.0,
                                color: Colors.white,
                                fontWeight: FontWeight.w300,
                                letterSpacing: 0.3))
                        : const CircularProgressIndicator(
                            strokeWidth: 1.0,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          )));
  }

  @override
  StartAnimationState createState() => StartAnimationState();
}

class StartAnimationState extends State<StartAnimation>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    widget.buttonController.addListener(() {
      // if (widget.zoomAnimation.isCompleted) {
      if (widget.successLogin == true) {
        Navigator.pushNamed(context, '/home');
        // }
      }
    });

    return AnimatedBuilder(
        animation: widget.buttonController, builder: widget.buildAnimation);
  }
}
