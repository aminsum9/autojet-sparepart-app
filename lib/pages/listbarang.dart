import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'detailbarang.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/url.dart' as globals;

class ListBarang extends StatefulWidget {
  @override
  ListBarangState createState() => ListBarangState();
}

Future<String> getDataStorage(String key) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString(key).toString();
}

Future<http.Response> postData(Uri url, dynamic body) async {
  final response = await http.post(url, body: body);
  return response;
}

class ListBarangState extends State<ListBarang> {
  Future<List> getData() async {
    var token = await getDataStorage('token');

    var body = {"page": "1", "paging": "10", "token": token.toString()};

    final response = await postData(
        Uri.parse("${globals.BASE_URL}barang/get_barangs"), body);

    final data = jsonDecode(response.body);

    if (data['success'] == true) {
      return data['data'];
    } else {
      var data = [];
      return data;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
            floatingActionButton: FloatingActionButton(
              onPressed: () => Navigator.pushNamed(context, '/add_barang'),
              child: const Icon(Icons.add),
              backgroundColor: Colors.green,
            ),
            body: FutureBuilder(
                future: getData(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) print(snapshot.error);
                  return snapshot.hasData
                      ? ItemList(list: snapshot.data!)
                      : const Center(
                          child: CircularProgressIndicator(),
                        );
                })));
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
                    DetailBarang(list: list, index: i))),
            child: Card(
              child: ListTile(
                title: Text(list[i]["name"]),
                subtitle: Text('Qty : ${list[i]["qty"]}'),
                leading: const Icon(Icons.widgets),
              ),
            ),
          ),
        );
      },
    );
  }
}
