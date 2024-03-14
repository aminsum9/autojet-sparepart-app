import 'dart:async';
import 'dart:convert';
import 'package:autojet_sparepart/pages/detailwarehouse.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config/url.dart' as host;
import '../styles/colors.dart' as colors;

class ListWarehouse extends StatefulWidget {
  const ListWarehouse({super.key});

  @override
  ListWarehouseState createState() => ListWarehouseState();
}

Future<String> getDataStorage(String key) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString(key).toString();
}

Future<http.Response> postData(Uri url, dynamic body) async {
  final response = await http.post(url, body: body);
  return response;
}

class ListWarehouseState extends State<ListWarehouse> {
  List<dynamic> data = [];

  Future<List> getData() async {
    var token = await getDataStorage('token');

    var body = {"page": "1", "paging": "10", "token": token.toString()};

    final response = await postData(
        Uri.parse("${host.BASE_URL}warehouse/get_warehouses"), body);

    final data = jsonDecode(response.body);

    if (data['success'] == true) {
      return data['data'];
    } else {
      var data = [];
      return data;
    }
  }

  void getDataWarehouse() async {
    List<dynamic> dataWarehouse = await getData();

    setState(() {
      data = dataWarehouse;
    });
  }

  Future<void> _handleRefresh() async {
    List<dynamic> dataWarehouse = await getData();

    setState(() {
      data = dataWarehouse;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDataWarehouse();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
            floatingActionButton: FloatingActionButton(
              onPressed: () => Navigator.pushNamed(context, '/add_warehouse'),
              backgroundColor: colors.SECONDARY_COLOR,
              child: const Icon(Icons.add),
            ),
            body: RefreshIndicator(
                onRefresh: () => _handleRefresh(),
                child: ListView.separated(
                    itemBuilder: (context, index) {
                      return ItemList(
                          name: data[index]["barang"]['name'],
                          qty: data[index]["qty"],
                          list: data,
                          index: index);
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        const Divider(),
                    itemCount: data.length))));
  }
}

// ignore: must_be_immutable
class ItemList extends StatelessWidget {
  String name = '';
  int qty = 0;
  int index = 0;
  List list = [];

  ItemList(
      {super.key,
      required this.list,
      required this.name,
      required this.qty,
      required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5.0),
      child: GestureDetector(
        onTap: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) =>
                DetailWarehouse(list: list, index: index))),
        child: Card(
          child: ListTile(
            title: Text(name),
            subtitle: Text('Qty : $qty'),
            leading: const Icon(
              Icons.warehouse,
              size: 50,
              color: Colors.blueGrey,
            ),
          ),
        ),
      ),
    );
  }
}
