import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'edituser.dart';
import 'dart:convert';
import 'package:pretty_json/pretty_json.dart';
import '../config/url.dart' as host;
import '../styles/colors.dart' as colors;

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
        await postData(Uri.parse("${host.BASE_URL}user/get_by_id"), body);

    if (response.statusCode != 200) {
      return [];
    }

    var data = await jsonDecode(response.body);

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
      backgroundColor: Colors.white,
      drawerEdgeDragWidth: 10,
      body: ListView(
        children: [
          Container(
            padding:
                const EdgeInsets.only(left: 5, top: 10, right: 5, bottom: 5),
            child: GestureDetector(
              onTap: () => toEditUser(),
              child: const Card(
                child: ListTile(
                  title: Text("Edit Akun"),
                  leading: Icon(
                    Icons.account_circle,
                    color: colors.PRIMARY_COLOR,
                  ),
                ),
              ),
            ),
          ),
          Container(
            padding:
                const EdgeInsets.only(left: 5, top: 0, right: 5, bottom: 5),
            child: GestureDetector(
              onTap: () => toReport(),
              child: const Card(
                child: ListTile(
                  title: Text("Laporan"),
                  leading:
                      Icon(Icons.outbox_outlined, color: colors.PRIMARY_COLOR),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(10.0),
        child: TextButton(
          onPressed: () {
            removeDataStorage();
            Navigator.pushNamed(context, '/login');
          },
          style: TextButton.styleFrom(backgroundColor: colors.PRIMARY_COLOR),
          child: const Text("Log Out", style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}
