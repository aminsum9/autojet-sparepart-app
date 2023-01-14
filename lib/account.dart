import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Akun",
          ),
          backgroundColor: Colors.lightGreen,
        ),
        body: Column(
          children: [
            ItemList(
                routeName: '/edit_user',
                title: "Edit Akun",
                icon: Icons.account_circle),
            ItemList(
                routeName: '/edit_user',
                title: "Laporan",
                icon: Icons.outbox_outlined),
            TextButton(
                style: TextButton.styleFrom(backgroundColor: Colors.lightGreen),
                onPressed: () {
                  removeDataStorage();
                  Navigator.pushNamed(context, '/login');
                },
                child: Column(crossAxisAlignment: CrossAxisAlignment.center,
                    // mainAxisAlignment: MainAxisAlignment.start,
                    children: const [Text("Log Out"), Icon(Icons.outbond)]))
          ],
        ));
  }
}

class ItemList extends StatelessWidget {
  final String routeName;
  final String title;
  final IconData icon;
  // var args = {
  //   // "list": [
  //   //   {
  //   //     "name": "Amin",
  //   //     "email": "amin@gmail.com",
  //   //     "address": "Yogyakarta",
  //   //     "phone": "8085743989094",
  //   //     "id": "1"
  //   //   }
  //   // ],
  //   "list": widget.list,
  //   "index": widget.index
  // };

  ItemList({required this.routeName, required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5.0),
      child: GestureDetector(
        onTap: () => {Navigator.pushNamed(context, routeName)},
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
