import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:item_picker/item_picker.dart';
import 'dart:convert';

class AddTransaksi extends StatefulWidget {
  @override
  AddDataState createState() => AddDataState();
}

class AddDataState extends State<AddTransaksi> {
  TextEditingController controllerDiscount = TextEditingController(text: "");
  TextEditingController controllerNotes = TextEditingController(text: "");
  //
  String selectedBarang = "";
  String selectedUser = "";
  String subTotal = "";
  //
  List<MapEntry<String, dynamic>> dataUsers = [];
  List<MapEntry<String, dynamic>> dataBarang = [];
  List<dynamic> barangTransaksi = [
    {"qty": "10"}
  ];
  //

  Future<http.Response> postData(Uri url, dynamic body) async {
    final response = await http.post(url, body: body);
    return response;
  }

  Future<String> getDataStorage(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key).toString();
  }

  getDataUSers() async {
    var token = await getDataStorage('token');

    var body = {"page": "1", "paging": "10", "token": token.toString()};

    final response = await postData(
        Uri.parse("http://192.168.43.128:8000/user/get_users"), body);

    if (response.statusCode != 200) {
      return [];
    }

    var data = await jsonDecode(response.body);

    if (data['success'] == true) {
      List<MapEntry<String, dynamic>> resultBarang = [];

      data['data']['data'].forEach((dynamic item) =>
          {resultBarang.add(MapEntry(item['name'], item['id'].toString()))});

      setState(() {
        dataUsers = resultBarang;
      });
    } else {
      setState(() {
        dataUsers = [];
      });
    }
  }

  getDataBarang() async {
    var token = await getDataStorage('token');

    var body = {"page": "1", "paging": "10", "token": token.toString()};

    final response = await postData(
        Uri.parse("http://192.168.43.128:8000/barang/get_barangs"), body);

    if (response.statusCode != 200) {
      return [];
    }

    var data = await jsonDecode(response.body);

    if (data['success'] == true) {
      List<MapEntry<String, dynamic>> resultBarang = [];

      data['data']['data'].forEach((dynamic item) =>
          {resultBarang.add(MapEntry(item['name'], item['id'].toString()))});

      setState(() {
        dataBarang = resultBarang;
      });
    } else {
      setState(() {
        dataBarang = [];
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDataUSers();
    getDataBarang();
  }

  void addData() async {
    var token = await getDataStorage('token');

    var url = "http://192.168.43.128:8000/transaksi/create_transaksi";

    List<MapEntry<String, dynamic>> detailTransaksi = [];

    barangTransaksi.forEach((item) {
      barangTransaksi.add(item);
    });

    http.post(Uri.parse(url), body: {
      "user_id": selectedUser,
      "detail_transaksi": detailTransaksi,
      "discount": controllerDiscount.text,
      "notes": controllerNotes.text,
      "token": token.toString(),
    }).then((response) => {
          if (response.statusCode == 200) {Navigator.pop(context)}
        });
  }

  @override
  Widget build(BuildContext context) {
    barangTransaksi.forEach((item) {
      // subTotal = subTotal + item['qty'].toString();
      subTotal = subTotal + item['qty'].toString();
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text("Buat Transaksi"),
        backgroundColor: Colors.lightGreen,
      ),
      body: Container(
          padding: const EdgeInsets.all(20.0),
          child: ListView(children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Customer: ",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                ItemPicker(
                  list: dataUsers,
                  defaultValue: selectedUser,
                  onSelectionChange: (value) => {
                    setState(() {
                      selectedUser = value;
                    })
                  },
                ),
                const Text(
                  "Pilih Barang: ",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                ItemPicker(
                  list: dataBarang,
                  defaultValue: selectedBarang,
                  onSelectionChange: (value) => {
                    setState(() {
                      selectedBarang = value;
                    })
                  },
                ),
                TextField(
                  controller: controllerDiscount,
                  decoration: const InputDecoration(
                      hintText: "masukkan diskon", labelText: "Diskon"),
                ),
                TextField(
                  controller: controllerNotes,
                  decoration: const InputDecoration(
                      hintText: "masukkan notes", labelText: "Notes"),
                ),
                const Padding(
                  padding: EdgeInsets.all(15.0),
                ),
                Text(
                  "Subtotal: ${subTotal}",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const Padding(
                  padding: EdgeInsets.all(20.0),
                ),
              ],
            ),
            TextButton(
                onPressed: () {
                  addData();
                },
                child: Text("BUAT TRANSAKSI",
                    style: TextStyle(color: Colors.white)),
                style: TextButton.styleFrom(
                  backgroundColor: Colors.lightGreen,
                )),
          ])),
    );
  }
}
