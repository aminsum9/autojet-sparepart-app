import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/url.dart' as host;
import '../styles/colors.dart' as colors;

class Register extends StatefulWidget {
  @override
  RegisterState createState() => RegisterState();
}

class RegisterState extends State<Register> {
  TextEditingController controllerNama = TextEditingController(text: '');
  TextEditingController controllerPhone = TextEditingController(text: '');
  TextEditingController controllerEmail = TextEditingController(text: '');
  TextEditingController controllerPassword = TextEditingController(text: '');
  TextEditingController controllerAddress = TextEditingController(text: '');

  void _submitData() {
    showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Apakah data sudah benar?'),
          content: Container(
            height: 200.0,
            width: 200.0,
            // alignment: Alignment.topLeft,
            child: Column(
              children: [
                Text("Nama: ${controllerNama.text}", textAlign: TextAlign.left),
                Text("No. Telepon: ${controllerPhone.text}",
                    textAlign: TextAlign.left),
                Text("Email: ${controllerEmail.text}",
                    textAlign: TextAlign.left),
                Text("Password: ${controllerPassword.text}",
                    textAlign: TextAlign.left),
                Text("Alamat: ${controllerAddress.text}",
                    textAlign: TextAlign.left),
              ],
            ),
          ),
          actions: [
            TextButton(
                child: Text('Daftar Sekarang'),
                onPressed: () => handleRegister())
          ],
        );
      },
    );
    // showDialog(context: context, child: alertDialog);
  }

  Future<bool> saveDataStorage(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setString(key, value);
  }

  Future<http.Response> postData(Uri url, dynamic body) async {
    final response = await http.post(url, body: body);
    return response;
  }

  void handleRegister() async {
    var body = {
      'name': controllerNama.text,
      'email': controllerEmail.text,
      'image': "",
      'phone': controllerPhone.text,
      'address': controllerAddress.text,
      'password': controllerPassword.text,
      'is_verify': '0',
    };

    final response =
        await postData(Uri.parse('${host.BASE_URL}user/register'), body);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data['success'] == true) {
        await saveDataStorage('token', data['api_key']);
        Navigator.pushNamed(context, '/home');
      } else {
        showDialog<void>(
          context: context,
          barrierDismissible: false, // user must tap button!
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Pendaftaran gagal!'),
              content: Container(
                  height: 200.0, width: 200.0, child: Text(data['message'])),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context), child: Text("OK"))
              ],
            );
          },
        );
      }
    } else {
      showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Terjadi kesalahan!'),
            content: Container(
                height: 200.0, width: 200.0, child: Text('Server bermasalah.')),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context), child: Text("OK"))
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Daftar",
          style: TextStyle(color: colors.SECONDARY_COLOR),
        ),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: colors.SECONDARY_COLOR),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        shadowColor: Colors.transparent,
      ),
      body: ListView(children: [
        Container(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 20.0),
              ),
              TextField(
                  controller: controllerNama,
                  decoration: InputDecoration(
                      hintText: "Nama",
                      labelText: "Nama",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0)))),
              const Padding(
                padding: EdgeInsets.only(top: 20.0),
              ),
              TextField(
                  controller: controllerEmail,
                  decoration: InputDecoration(
                      hintText: "Email",
                      labelText: "Email",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0)))),
              const Padding(
                padding: EdgeInsets.only(top: 20.0),
              ),
              TextField(
                  controller: controllerAddress,
                  decoration: InputDecoration(
                      hintText: "Alamat",
                      labelText: "Alamat",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0)))),
              const Padding(
                padding: EdgeInsets.only(top: 20.0),
              ),
              TextField(
                  controller: controllerPhone,
                  decoration: InputDecoration(
                      hintText: "No. Telepon",
                      labelText: "No. Telepon",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0)))),
              const Padding(
                padding: EdgeInsets.only(top: 20.0),
              ),
              TextField(
                  controller: controllerPassword,
                  obscureText: true,
                  decoration: InputDecoration(
                      hintText: "Password",
                      labelText: "Password",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0)))),
              const Padding(
                padding: EdgeInsets.only(top: 20.0),
              ),
            ],
          ),
        ),
      ]),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(5),
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: TextButton(
            onPressed: () {
              _submitData();
            },
            style: TextButton.styleFrom(
                padding: const EdgeInsets.all(15),
                backgroundColor: colors.PRIMARY_COLOR,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10))),
            child: const Text("Daftar", style: TextStyle(color: Colors.white)),
          ),
        ),
      ),
    );
  }
}
