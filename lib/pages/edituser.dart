import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config/url.dart' as host;
import '../styles/colors.dart' as colors;

class EditUser extends StatefulWidget {
  final List list;
  final int index;

  EditUser({required this.list, this.index = 0});
  @override
  EditUserState createState() => EditUserState();
}

class EditUserState extends State<EditUser> {
  TextEditingController controllerAddress = TextEditingController(text: "");
  TextEditingController controllerName = TextEditingController(text: "");
  TextEditingController controllerEmail = TextEditingController(text: "");
  TextEditingController controllerPhone = TextEditingController(text: "");

  Future<String> getDataStorage(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key).toString();
  }

  editDataUser() async {
    var token = await getDataStorage('token');

    var body = {
      "id": widget.list[widget.index]["id"].toString() ?? "",
      "name": controllerName.text,
      "email": controllerEmail.text.toString(),
      "image": "",
      "address": controllerAddress.text,
      "phone": controllerPhone.text.toString(),
      "token": token.toString(),
    };

    var url = "${host.BASE_URL}user/update";
    http
        .post(Uri.parse(url), body: body)
        .then((value) => Navigator.pushNamed(context, '/home'));
  }

  @override
  void initState() {
    controllerAddress =
        TextEditingController(text: widget.list[widget.index]['address'] ?? "");
    controllerName =
        TextEditingController(text: widget.list[widget.index]['name'] ?? "");
    controllerEmail =
        TextEditingController(text: widget.list[widget.index]['email'] ?? "");
    controllerPhone =
        TextEditingController(text: widget.list[widget.index]['phone'] ?? "");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Edit Data User",
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
      body: Container(
          padding: const EdgeInsets.all(10.0),
          child: Card(
              child: Container(
            padding: const EdgeInsets.all(10.0),
            child: ListView(children: [
              Column(
                children: [
                  const Padding(padding: EdgeInsets.all(10.0)),
                  const Padding(padding: EdgeInsets.all(10.0)),
                  const Padding(padding: EdgeInsets.all(10.0)),
                  TextField(
                    controller: controllerName,
                    decoration:
                        const InputDecoration(hintText: "masukkan nama"),
                  ),
                  const Padding(padding: EdgeInsets.all(10.0)),
                  TextField(
                    controller: controllerEmail,
                    decoration:
                        const InputDecoration(hintText: "masukkan email"),
                  ),
                  const Padding(padding: EdgeInsets.all(10.0)),
                  TextField(
                    controller: controllerPhone,
                    decoration: const InputDecoration(
                        hintText: "masukkan nomor telepon"),
                  ),
                  TextField(
                    controller: controllerAddress,
                    decoration:
                        const InputDecoration(hintText: "masukkan alamat"),
                  ),
                  const Padding(padding: EdgeInsets.all(10.0)),
                ],
              ),
            ]),
          ))),
      bottomNavigationBar: Container(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: TextButton(
            onPressed: () {
              editDataUser();
            },
            style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              backgroundColor: colors.PRIMARY_COLOR,
            ),
            child: const Text("EDIT", style: TextStyle(color: Colors.white)),
          ),
        ),
      ),
    );
  }
}
