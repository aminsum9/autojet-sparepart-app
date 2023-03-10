import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config/url.dart' as host;

class AddUser extends StatefulWidget {
  @override
  AddUserState createState() => AddUserState();
}

class AddUserState extends State<AddUser> {
  TextEditingController controllerName = TextEditingController(text: "");
  TextEditingController controllerEmail = TextEditingController(text: "");
  TextEditingController controllerPhone = TextEditingController(text: "");
  TextEditingController controllerAddress = TextEditingController(text: "");
  TextEditingController controllerPassword = TextEditingController(text: "");

  Future<String> getDataStorage(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key).toString();
  }

  void addData() async {
    var token = await getDataStorage('token');

    var url = "${host.BASE_URL}user/register";

    http.post(Uri.parse(url), body: {
      "name": controllerName.text,
      "email": controllerEmail.text,
      "phone": controllerPhone.text,
      "address": controllerAddress.text,
      "image": "",
      "password": controllerPassword.text,
      "token": token.toString(),
    }).then((response) => {
          if (response.statusCode == 200) {Navigator.pop(context)}
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tambah User"),
        backgroundColor: Colors.lightGreen,
      ),
      body: Container(
          padding: const EdgeInsets.all(20.0),
          child: ListView(children: [
            Column(
              children: [
                TextField(
                  controller: controllerName,
                  decoration: const InputDecoration(
                      hintText: "masukkan nama item", labelText: "Nama"),
                ),
                TextField(
                  controller: controllerEmail,
                  decoration: const InputDecoration(
                      hintText: "masukkan email user baru", labelText: "Email"),
                ),
                TextField(
                  controller: controllerPhone,
                  decoration: const InputDecoration(
                      hintText: "masukkan No. Telp. user baru",
                      labelText: "No. Telepon"),
                ),
                TextField(
                  controller: controllerAddress,
                  decoration: const InputDecoration(
                      hintText: "masukkan alamat", labelText: "Alamat"),
                ),
                TextField(
                  controller: controllerPassword,
                  obscureText: true,
                  decoration: const InputDecoration(
                      hintText: "masukkan password", labelText: "Password"),
                ),
                const Padding(
                  padding: EdgeInsets.all(20.0),
                ),
              ],
            ),
            TextButton(
                onPressed: () {
                  addData();
                },
                child: Text("SUBMIT", style: TextStyle(color: Colors.white)),
                style: TextButton.styleFrom(
                  backgroundColor: Colors.lightGreen,
                )),
          ])),
    );
  }
}
