import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pretty_json/pretty_json.dart';
import 'home.dart';

class Report extends StatefulWidget {
  final List list;
  final int index;

  Report({required this.list, this.index = 0});
  @override
  ReportState createState() => ReportState();
}

class ReportState extends State<Report> {
  Future<String> getDataStorage(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key).toString();
  }

  editDataUser() async {
    var token = await getDataStorage('token');

    var body = {
      "id": widget.list[widget.index]["id"] ?? "",
      // "name": controllerName.text,
      // "email": controllerEmail.text.toString(),
      // "image": "",
      // "address": controllerAddress.text,
      // "phone": controllerPhone.text.toString(),
      // "token": token.toString(),
    };

    var url = "http://192.168.43.128:8000/user/update";
    http
        .post(Uri.parse(url), body: body)
        .then((value) => Navigator.pushNamed(context, '/home'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Laporan"),
        backgroundColor: Colors.lightGreen,
      ),
      body: Container(
          padding: const EdgeInsets.all(20.0),
          child: Card(
              child: Container(
            padding: const EdgeInsets.all(10.0),
            child: const Text("report"),
          ))),
    );
  }
}
