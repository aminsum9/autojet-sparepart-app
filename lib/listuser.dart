import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'detailuser.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListUser extends StatefulWidget {
  @override
  ListUserState createState() => ListUserState();
}

Future<String> getDataStorage(String key) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString(key).toString();
}

Future<http.Response> postData(Uri url, dynamic body) async {
  final response = await http.post(url, body: body);
  return response;
}

class ListUserState extends State<ListUser> {
  Future<List> getDataUser() async {
    var token = await getDataStorage('token');

    var body = {"page": "1", "paging": "10", "token": token.toString()};

    final response = await postData(
        Uri.parse("http://192.168.43.128:8000/user/get_users"), body);

    if (response.statusCode != 200) {
      return [];
    }

    var data = await jsonDecode(response.body);
    // var data = response.body;

    if (data['success'] == true) {
      return data['data']['data'];
    } else {
      var data = [];
      return data;
    }
    // return [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.pushNamed(context, '/add_user'),
          child: const Icon(Icons.add),
          backgroundColor: Colors.green,
        ),
        body: FutureBuilder(
            future: getDataUser(),
            builder: (context, snapshot) {
              if (snapshot.hasError) print(snapshot.error);
              return snapshot.hasData
                  ? ItemList(list: snapshot.data!)
                  : const Center(
                      child: CircularProgressIndicator(),
                    );
            }));
  }
}

class ItemList extends StatelessWidget {
  final List list;
  ItemList({required this.list});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: list == null ? 0 : list.length,
      itemBuilder: (context, i) {
        return Container(
          padding: const EdgeInsets.all(5.0),
          child: GestureDetector(
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) =>
                    DetailUser(list: list, index: i))),
            child: Card(
              child: ListTile(
                title: Text(list[i]["name"]),
                subtitle: Text('Email : ${list[i]["email"]}'),
                leading: const Icon(Icons.account_circle),
              ),
            ),
          ),
        );
      },
    );
  }
}
