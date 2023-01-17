import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'edituser.dart';
import 'dart:convert';
import 'package:pretty_json/pretty_json.dart';
import '../config/url.dart' as globals;

class Account extends StatefulWidget {
  @override
  AccountState createState() => AccountState();
}

Future<String> getDataStorage(String key) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString(key).toString();
}

Future removeDataStorage() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.clear();
}

Future<http.Response> postData(Uri url, dynamic body) async {
  final response = await http.post(url, body: body);
  return response;
}

class AccountState extends State<Account> {
  Map<String, dynamic> dataUser = {};

  // AccountState({this.toEditUser});

  getDataUser() async {
    var token = await getDataStorage('token');

    var body = {"token": token.toString()};

    final response =
        await postData(Uri.parse("${globals.BASE_URL}user/get_by_id"), body);

    if (response.statusCode != 200) {
      return [];
    }

    var data = await jsonDecode(response.body);
    // var data = response.body;
    // print(prettyJson(data));
    if (data['success'] == true) {
      setState(() {
        dataUser = data['data'];
      });
    } else {
      var data = [];
      return data;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDataUser();
  }

  void toEditUser() async {
    print(prettyJson(dataUser));
    if (dataUser['name'] != null) {
      await Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) =>
              EditUser(list: [dataUser], index: 0)));
    }
  }

  void toReport() async {
    if (dataUser['name'] != null) {
      await Navigator.pushNamed(context, '/report');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Akun",
          ),
          backgroundColor: Colors.lightGreen,
        ),
        drawerEdgeDragWidth: 10,
        body: ListView(
          children: [
            Container(
              padding: const EdgeInsets.all(5.0),
              child: GestureDetector(
                onTap: () => toEditUser(),
                child: const Card(
                  child: ListTile(
                    title: Text("Edit Akun"),
                    leading: Icon(Icons.account_circle),
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(5.0),
              child: GestureDetector(
                onTap: () => toReport(),
                child: const Card(
                  child: ListTile(
                    title: Text("Laporan"),
                    leading: Icon(Icons.outbox_outlined),
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10.0),
              child: TextButton(
                onPressed: () {
                  removeDataStorage();
                  Navigator.pushNamed(context, '/login');
                },
                child: Text("Log Out", style: TextStyle(color: Colors.white)),
                style: TextButton.styleFrom(backgroundColor: Colors.lightGreen),
              ),
            ),
          ],
        ));
  }
}
