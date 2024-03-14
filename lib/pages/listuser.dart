import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'detailuser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/url.dart' as host;

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
  List<dynamic> data = [];

  Future<List> getDataUser() async {
    var token = await getDataStorage('token');

    var body = {"page": "1", "paging": "10", "token": token.toString()};

    final response =
        await postData(Uri.parse("${host.BASE_URL}user/get_users"), body);

    if (response.statusCode != 200) {
      return [];
    }

    var data = await jsonDecode(response.body);

    if (data['success'] == true) {
      return data['data'];
    } else {
      var data = [];
      return data;
    }
  }

  Future<void> _handleRefresh() async {
    List<dynamic> dataUsers = await getDataUser();

    setState(() {
      data = dataUsers;
    });
  }

  void getData() async {
    List<dynamic> dataUsers = await getDataUser();

    setState(() {
      data = dataUsers;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
            body: RefreshIndicator(
          onRefresh: () => _handleRefresh(),
          child: ListView.separated(
              itemBuilder: (context, index) {
                return ItemList(
                    list: data,
                    name: data[index]['name'],
                    email: data[index]['email'],
                    index: index);
              },
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(),
              itemCount: data.length),
        )));
  }
}

// ignore: must_be_immutable
class ItemList extends StatelessWidget {
  String name = '';
  String email = '';
  int index = 0;
  final List list;
  ItemList(
      {super.key,
      required this.list,
      required this.name,
      required this.email,
      required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5.0),
      child: GestureDetector(
        onTap: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) =>
                DetailUser(list: list, index: index))),
        child: Card(
          child: ListTile(
            title: Text(name),
            subtitle: Text('Email : $email}'),
            leading: const Icon(
              Icons.account_circle,
              size: 50,
              color: Colors.blueGrey,
            ),
          ),
        ),
      ),
    );
  }
}
