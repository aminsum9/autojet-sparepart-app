import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/url.dart' as globals;

class LoginPage extends StatefulWidget {
  @override
  LoginPageState createState() => LoginPageState();

  @override
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

class LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  final TextEditingController controllerEmail = TextEditingController(text: '');
  final TextEditingController controllerPassword =
      TextEditingController(text: '');

  var statusClick = 0;
  var sucessLogin = false;
  var errorMessage = "";

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

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

  Future _hadleLogin() async {
    setState(() {
      statusClick = 1;
    });

    var body = {
      'email': controllerEmail.text,
      'password': controllerPassword.text
    };

    final response =
        await postData(Uri.parse('${globals.BASE_URL}user/login'), body);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data['success'] == true) {
        saveDataStorage('token', data['api_key'])
            .then((value) => {Navigator.pushNamed(context, '/home')});
      } else {
        setState(() {
          sucessLogin = false;
          errorMessage = data['message'];
        });
      }
    } else {
      setState(() {
        sucessLogin = false;
        // statusClick = 0;
      });
    }
  }

  void toRegister() {
    Navigator.pushNamed(context, '/register');
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
            body: Container(
          child: Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    colors: [Colors.white, Colors.lightGreen],
                    begin: FractionalOffset.topCenter,
                    end: FractionalOffset.bottomCenter)),
            child: ListView(padding: const EdgeInsets.all(20.0), children: [
              Stack(alignment: AlignmentDirectional.bottomCenter, children: [
                Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 270.0),
                    ),
                    Container(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(10.0),
                          ),
                          TextField(
                            controller: controllerEmail,
                            decoration: const InputDecoration(
                                icon: Icon(
                                  Icons.person,
                                  color: Colors.white,
                                ),
                                hintText: "Email"),
                          ),
                          const Padding(
                            padding: EdgeInsets.all(10.0),
                          ),
                          TextField(
                            controller: controllerPassword,
                            obscureText: true,
                            decoration: const InputDecoration(
                                icon: Icon(
                                  Icons.lock_outline,
                                  color: Colors.white,
                                ),
                                hintText: "Password"),
                          ),
                          const Padding(padding: EdgeInsets.only(top: 13)),
                          errorMessage != ""
                              ? Text(errorMessage,
                                  style: const TextStyle(
                                      fontSize: 12, color: Colors.red))
                              : const Text(""),
                          TextButton(
                              // padding:
                              //     const EdgeInsets.only(top: 220.0, bottom: 30.0),
                              onPressed: () {
                                toRegister();
                              },
                              child: const Text(
                                "Belum punya akun? daftar di sini.",
                                style: TextStyle(
                                    fontSize: 12.0,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w300,
                                    letterSpacing: 0.5),
                              )),
                          InkWell(
                              onTap: () {
                                _hadleLogin();
                              },
                              child: SignIn())
                        ],
                      ),
                    )
                  ],
                ),
              ])
            ]),
          ),
        )));
  }
}

class SignIn extends StatelessWidget {
  @override
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
