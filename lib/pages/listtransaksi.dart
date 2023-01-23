import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'detailtransaksi.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/url.dart' as host;
import '../styles/colors.dart' as colors;

class ListTransaksi extends StatefulWidget {
  @override
  ListTransaksiState createState() => ListTransaksiState();
}

Future<String> getDataStorage(String key) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString(key).toString();
}

Future<http.Response> postData(Uri url, dynamic body) async {
  final response = await http.post(url, body: body);
  return response;
}

class ListTransaksiState extends State<ListTransaksi> {
  Future<List> getDataTransaksi() async {
    var token = await getDataStorage('token');

    var body = {"page": "1", "paging": "10", "token": token.toString()};

    final response = await postData(
        Uri.parse("${host.BASE_URL}transaksi/get_transaksis"), body);

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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
            floatingActionButton: FloatingActionButton(
              onPressed: () => Navigator.pushNamed(context, '/add_transaksi'),
              backgroundColor: colors.SECONDARY_COLOR,
              child: const Icon(Icons.add),
            ),
            body: FutureBuilder(
                future: getDataTransaksi(),
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

  Color colorStatus = Colors.lightGreen;
  String status = 'baru';

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: list.isEmpty ? 0 : list.length,
      itemBuilder: (context, i) {
        //handle status
        switch (list[i]['status']) {
          case 'new':
            colorStatus = Colors.orange;
            status = 'baru';
            break;
          case 'pending':
            colorStatus = Colors.blue;
            status = 'sedang diproses';
            break;
          case 'finish':
            colorStatus = Colors.lightGreen;
            status = 'selesai';
            break;
          case 'cancel':
            colorStatus = Colors.red;
            status = 'dibatalkan';
            break;
          case 'refund':
            colorStatus = Colors.purple;
            status = 'refund';
            break;
        }
        //handle date
        var date = DateTime.parse(list[i]["created_at"].split('T')[0]);
        String createdAt = DateFormat('dd MMMM yyy').format(date);

        return Container(
          padding: const EdgeInsets.all(5.0),
          child: GestureDetector(
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) =>
                    DetailTransaksi(list: list, index: i))),
            child: Card(
              child: ListTile(
                title: Row(
                  children: [
                    Text(
                      "${list[i]["trx_id"]}",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Card(
                        color: colorStatus,
                        shadowColor: Colors.transparent,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 5, top: 1, right: 5, bottom: 1),
                          child: Text(
                            status,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ))
                  ],
                ),
                subtitle: Text('Dibuat tgl. : ${createdAt}'),
                leading: const Icon(
                  Icons.book,
                  size: 40,
                  color: Colors.blueGrey,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
