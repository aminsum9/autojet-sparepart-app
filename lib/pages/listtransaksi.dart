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
  const ListTransaksi({super.key});

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
  List<dynamic> data = [];

  @protected
  @mustCallSuper
  void initState() {
    getData();
  }

  void getData() async {
    List<dynamic> dataTrans = await getDataTransaksi();

    print("data get:  ${data.length.toString()}");

    setState(() {
      data = dataTrans;
    });
  }

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

  Future<void> _handleRefresh() async {
    List<dynamic> dataTrans = await getDataTransaksi();

    setState(() {
      data = dataTrans;
    });
  }

  @override
  Widget build(BuildContext context) {
    print("data: ${data.length}");
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () => Navigator.pushNamed(context, '/add_transaksi'),
            backgroundColor: colors.SECONDARY_COLOR,
            child: const Icon(Icons.add),
          ),
          body: RefreshIndicator(
            onRefresh: () => _handleRefresh(),
            child: ListView.separated(
              padding: const EdgeInsets.all(8),
              itemCount: data.length,
              itemBuilder: (context, index) {
                print("item: ${data[index]['status']}");
                return ItemList(
                    list: data,
                    trxStatus: data[index]['status'],
                    trxId: data[index]['trx_id'],
                    trxCreatedAt: data[index]['created_at'],
                    index: index);
              },
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(),
            ),
          ),
        ));
  }
}

// ignore: must_be_immutable
class ItemList extends StatelessWidget {
  String trxStatus = '';
  String trxId = '';
  String trxCreatedAt = '';
  List list = [];
  int index = 0;

  ItemList(
      {super.key,
      required this.list,
      required this.trxStatus,
      required this.trxId,
      required this.trxCreatedAt,
      required this.index});

  Color colorStatus = Colors.lightGreen;
  String status = 'baru';

  @override
  Widget build(BuildContext context) {
    //handle status
    switch (trxStatus) {
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
    var now = DateTime.now().toString();
    var date = trxCreatedAt != ''
        ? DateTime.parse(trxCreatedAt.split('T')[0])
        : DateTime.parse(now.split('T')[0]);
    String createdAt = DateFormat('dd MMMM yyy').format(date);

    return SizedBox(
      child: GestureDetector(
        onTap: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) =>
                DetailTransaksi(list: list, index: index))),
        child: Card(
          child: ListTile(
            title: Row(
              children: [
                Text(
                  trxId,
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
            subtitle: Text('Dibuat tgl. : $createdAt'),
            leading: const Icon(
              Icons.book,
              size: 40,
              color: Colors.blueGrey,
            ),
          ),
        ),
      ),
    );
  }
}
