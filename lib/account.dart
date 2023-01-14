// import 'dart:async';
import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';

class Account extends StatefulWidget {
  @override
  AccountState createState() => AccountState();
}

// Future<String> getDataStorage(String key) async {
//   final prefs = await SharedPreferences.getInstance();
//   return prefs.getString(key).toString();
// }

// Future<http.Response> postData(Uri url, dynamic body) async {
//   final response = await http.post(url, body: body);
//   return response;
// }

class AccountState extends State<Account> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Akun",
          ),
          backgroundColor: Colors.lightGreen,
        ),
        body: Container(
            child: Column(
          children: [
            ItemList(title: "Edit Akun", icon: Icons.account_circle),
            ItemList(title: "Laporan", icon: Icons.report),
            ItemList(title: "Log Out", icon: Icons.outbox)
          ],
        )));
  }
}

class ItemList extends StatelessWidget {
  final String title;
  final IconData icon;

  ItemList({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5.0),
      child: GestureDetector(
        // onTap: () => Navigator.of(context).push(MaterialPageRoute(
        //     builder: (BuildContext context) =>
        //         DetailUser(list: list, index: i))),
        child: Card(
          child: ListTile(
            title: Text(title),
            leading: Icon(icon),
          ),
        ),
      ),
    );
  }
}
