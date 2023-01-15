import 'package:autojet_sparepart/listsupplier.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:item_picker/item_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class AddWarehouse extends StatefulWidget {
  @override
  AddWarehouseState createState() => AddWarehouseState();
}

class AddWarehouseState extends State<AddWarehouse> {
  TextEditingController controllerStock = TextEditingController(text: "");
  String selectedBarang = "";
  String selectedSupplier = "";
  //
  List<MapEntry<String, dynamic>> dataBarang = [];
  List<MapEntry<String, dynamic>> dataSuppliers = [];
  //

  Future<String> getDataStorage(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key).toString();
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

  getDataSuppliers() async {
    var token = await getDataStorage('token');

    var body = {"page": "1", "paging": "10", "token": token.toString()};

    final response = await postData(
        Uri.parse("http://192.168.43.128:8000/supplier/get_suppliers"), body);

    if (response.statusCode != 200) {
      return [];
    }

    var data = await jsonDecode(response.body);

    if (data['success'] == true) {
      List<MapEntry<String, dynamic>> resultSuppliers = [];

      data['data']['data'].forEach((dynamic item) =>
          {resultSuppliers.add(MapEntry(item['name'], item['id'].toString()))});

      setState(() {
        dataSuppliers = resultSuppliers;
      });
    } else {
      setState(() {
        dataSuppliers = [];
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDataBarang();
    getDataSuppliers();
  }

  void addWarehouse() async {
    var token = await getDataStorage('token');

    var url = "http://192.168.43.128:8000/warehouse/add";

    http.post(Uri.parse(url), body: {
      "barang_id": selectedBarang,
      "supplier_id": selectedSupplier,
      "qty": controllerStock.text,
      "token": token.toString(),
    }).then((response) => {
          if (response.statusCode == 200) {Navigator.pop(context)}
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tambah Data Barang Masuk"),
        backgroundColor: Colors.green,
      ),
      body: Container(
          padding: const EdgeInsets.all(20.0),
          child: ListView(
              // scrollDirection: Axis.vertical,
              // shrinkWrap: true,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Nama Supplier: ",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    ItemPicker(
                      list: dataSuppliers,
                      defaultValue: selectedSupplier,
                      onSelectionChange: (value) => {
                        setState(() {
                          selectedSupplier = value;
                        })
                      },
                    ),
                    const Text(
                      "Nama Barang: ",
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
                      controller: controllerStock,
                      decoration: const InputDecoration(
                          hintText: "masukkan Qty", labelText: "Qty"),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(20.0),
                    ),
                  ],
                ),
                TextButton(
                    onPressed: () {
                      addWarehouse();
                    },
                    child: Text("Tambah Data",
                        style: TextStyle(color: Colors.white)),
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.green,
                    )),
              ])),
    );
  }
}
