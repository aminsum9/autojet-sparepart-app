import 'dart:async';
import 'dart:convert';
import 'package:autojet_sparepart/pages/detailsupplier.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config/url.dart' as host;
import '../styles/colors.dart' as colors;

class ListSupplier extends StatefulWidget {
  const ListSupplier({super.key});

  @override
  ListSupplierState createState() => ListSupplierState();
}

Future<String> getDataStorage(String key) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString(key).toString();
}

Future<http.Response> postData(Uri url, dynamic body) async {
  final response = await http.post(url, body: body);
  return response;
}

class ListSupplierState extends State<ListSupplier> {
  List<dynamic> data = [];

  Future<List> getDataSuppliers() async {
    var token = await getDataStorage('token');

    var body = {"page": "1", "paging": "10", "token": token.toString()};

    final response = await postData(
        Uri.parse("${host.BASE_URL}supplier/get_suppliers"), body);

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

  void getData() async {
    List<dynamic> dataSuppliers = await getDataSuppliers();

    setState(() {
      data = dataSuppliers;
    });
  }

  Future<void> _handleRefresh() async {
    List<dynamic> dataSuppliers = await getDataSuppliers();

    setState(() {
      data = dataSuppliers;
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
            floatingActionButton: FloatingActionButton(
              onPressed: () => Navigator.pushNamed(context, '/add_supplier'),
              backgroundColor: colors.SECONDARY_COLOR,
              child: const Icon(Icons.add),
            ),
            body: RefreshIndicator(
              onRefresh: () => _handleRefresh(),
              child: ListView.separated(
                  itemBuilder: (context, index) {
                    return ItemList(
                        name: data[index]["name"],
                        email: data[index]["email"],
                        index: index,
                        list: data);
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
                DetailSupplier(list: list, index: index))),
        child: Card(
          child: ListTile(
            title: Text(name),
            subtitle: Text('Email : $email'),
            leading: const Icon(
              Icons.factory,
              size: 50,
            ),
          ),
        ),
      ),
    );
  }
}
