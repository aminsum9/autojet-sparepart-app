// import 'package:flutter/material.dart';
// import './home.dart';

// class StartAnimation extends StatefulWidget {
//   StartAnimation({Key? key, this.buttonController, this.user, this.password})
//       : shrinkButtonAnimation = Tween(
//           begin: 320.0,
//           end: 70.0,
//         ).animate(
//           CurvedAnimation(
//               curve: Interval(0.0, 0.150), parent: buttonController),
//         ),
//         zoomAnimation = Tween(begin: 70.0, end: 900.0).animate(CurvedAnimation(
//             parent: buttonController,
//             curve: Interval(
//               0.55,
//               0.999,
//               curve: Curves.bounceInOut,
//             ))),
//         super(key: key);

//   final AnimationController buttonController;
//   final Animation shrinkButtonAnimation;
//   final Animation zoomAnimation;

//   final String user;
//   final String password;

//   Widget buildAnimation(BuildContext context, Widget child) {
//     return Padding(
//         padding: const EdgeInsets.only(bottom: 60.0),
//         child: zoomAnimation.value <= 300
//             ? Container(
//                 alignment: FractionalOffset.center,
//                 width: shrinkButtonAnimation.value,
//                 height: 60.0,
//                 decoration: BoxDecoration(
//                     color: Colors.red[700],
//                     borderRadius:
//                         BorderRadius.all(const Radius.circular(30.0))),
//                 child: shrinkButtonAnimation.value > 75
//                     ? Text("Sign In",
//                         style: TextStyle(
//                             fontSize: 20.0,
//                             color: Colors.white,
//                             fontWeight: FontWeight.w300,
//                             letterSpacing: 0.3))
//                     : CircularProgressIndicator(
//                         strokeWidth: 1.0,
//                         valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//                       ))
//             : user == 'amin'
//                 ? Container(
//                     width: zoomAnimation.value,
//                     height: zoomAnimation.value,
//                     decoration: BoxDecoration(
//                       color: Colors.red[700],
//                       shape: zoomAnimation.value < 600
//                           ? BoxShape.circle
//                           : BoxShape.rectangle,
//                     ),
//                   )
//                 : Container(
//                     alignment: FractionalOffset.center,
//                     width: shrinkButtonAnimation.value,
//                     height: 60.0,
//                     decoration: BoxDecoration(
//                         color: Colors.red[700],
//                         borderRadius:
//                             BorderRadius.all(const Radius.circular(30.0))),
//                     child: shrinkButtonAnimation.value > 75
//                         ? Text("Sign In",
//                             style: const TextStyle(
//                                 fontSize: 20.0,
//                                 color: Colors.white,
//                                 fontWeight: FontWeight.w300,
//                                 letterSpacing: 0.3))
//                         : CircularProgressIndicator(
//                             strokeWidth: 1.0,
//                             valueColor:
//                                 AlwaysStoppedAnimation<Color>(Colors.white),
//                           )));
//   }

//   @override
//   _StartAnimationState createState() => _StartAnimationState();
// }

// class _StartAnimationState extends State<StartAnimation> {
//   @override
//   Widget build(BuildContext context) {
//     widget.buttonController.addListener(() {
//       if (widget.zoomAnimation.isCompleted) {
//         if (widget.user == 'amin') {
//           Navigator.of(context).push(
//               MaterialPageRoute(builder: (BuildContext context) => new Home()));
//         }
//       }
//     });
//     return AnimatedBuilder(
//         animation: widget.buttonController, builder: widget.buildAnimation);
//   }
// }
