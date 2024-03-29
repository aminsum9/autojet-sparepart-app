import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/url.dart' as host;

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  SplashState createState() => SplashState();

  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(60.0),
      child: Container(
        alignment: FractionalOffset.center,
        width: 320.0,
        height: 60.0,
        decoration: BoxDecoration(
            color: Colors.red[700],
            borderRadius: const BorderRadius.all(Radius.circular(30.0))),
        child: const Text("Sign In",
            style: TextStyle(
                fontSize: 20.0,
                color: Colors.white,
                fontWeight: FontWeight.w300,
                letterSpacing: 0.3)),
      ),
    );
  }
}

class SplashState extends State<Splash> with TickerProviderStateMixin {
  final TextEditingController controllerEmail = TextEditingController(text: '');
  final TextEditingController controllerPassword =
      TextEditingController(text: '');

  var statusClick = 0;
  var sucessLogin = false;

  // late AnimationController animationControllerButton;
  late AnimationController animationControllerButton;
  Animation? animation;

  Future<bool> saveDataStorage(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setString(key, value);
  }

  Future<String> getDataStorage(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key).toString();
  }

  Future<http.Response> postData(Uri url, dynamic body) async {
    final response = await http.post(url, body: body);
    return response;
  }

  @override
  void initState() {
    super.initState();
    animationControllerButton =
        AnimationController(duration: const Duration(seconds: 3), vsync: this)
          ..addStatusListener((status) {
            if (status == AnimationStatus.dismissed) {
              setState(() {
                statusClick = 0;
              });
            }
          });
    animationControllerButton.forward();

    getDataStorage('token').then((token) {
      if (token.toString() != "") {
        postData(Uri.parse('${host.BASE_URL}user/check_login'),
            {"token": token.toString()}).then((response) {
          if (response.statusCode == 200) {
            if (jsonDecode(response.body)['success'] == true)
              // ignore: curly_braces_in_flow_control_structures
              Navigator.pushNamed(context, '/home');
          } else {
            Navigator.pushNamed(context, '/login');
          }
        });
      } else {
        Navigator.pushNamed(context, '/login');
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    animationControllerButton.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset(
          "img/icons/icon-autojet-sparepart.png",
          width: 180,
          height: 180,
        ),
      ),
    );
  }
}
