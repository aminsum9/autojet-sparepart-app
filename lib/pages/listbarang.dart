import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'detailbarang.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/url.dart' as host;
import '../styles/colors.dart' as colors;

class ListBarang extends StatefulWidget {
  const ListBarang({super.key});

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
  List<dynamic> data = [];

  Future<List> getData() async {
    var token = await getDataStorage('token');

    var body = {"page": "1", "paging": "10", "token": token.toString()};

    final response =
        await postData(Uri.parse("${host.BASE_URL}barang/get_barangs"), body);

    final data = jsonDecode(response.body);

    if (data['success'] == true) {
      return data['data'];
    } else {
      var data = [];
      return data;
    }
  }

  void getDataBarang() async {
    List<dynamic> dataBarang = await getData();

    setState(() {
      data = dataBarang;
    });
  }

  Future<void> _handleRefresh() async {
    List<dynamic> dataBarang = await getData();

    setState(() {
      data = dataBarang;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDataBarang();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
            floatingActionButton: FloatingActionButton(
              onPressed: () => Navigator.pushNamed(context, '/add_barang'),
              backgroundColor: colors.SECONDARY_COLOR,
              child: const Icon(Icons.add),
            ),
            body: RefreshIndicator(
                onRefresh: () => _handleRefresh(),
                child: ListView.separated(
                  padding: const EdgeInsets.all(8),
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    print("image: ${data[index]['image']}");
                    return ItemList(
                        list: data,
                        name: data[index]['name'],
                        image: data[index]['image'],
                        qty: data[index]['qty'],
                        index: index);
                  },
                  separatorBuilder: (BuildContext context, int index) =>
                      const Divider(),
                ))));
  }
}

// ignore: must_be_immutable
class ItemList extends StatelessWidget {
  String name = '';
  String image = '';
  int qty = 0;
  int index = 0;
  List list = [];

  ItemList(
      {super.key,
      required this.list,
      required this.name,
      required this.image,
      required this.qty,
      required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5.0),
      child: GestureDetector(
        onTap: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) =>
                DetailBarang(list: list, index: index))),
        child: Card(
          child: ListTile(
            title: Text(name),
            subtitle: Text('Qty : $qty'),
            leading: image != ""
                ? Image.network(
                    image != ""
                        ? "${host.BASE_URL_IMAGE}/images/barang/$image"
                        : "",
                    width: 50,
                    height: 50,
                  )
                : const Icon(
                    Icons.widgets,
                    size: 50,
                    color: Colors.blueGrey,
                  ),
          ),
        ),
      ),
    );
  }
}
