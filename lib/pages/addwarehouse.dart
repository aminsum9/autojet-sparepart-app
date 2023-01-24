import 'package:autojet_sparepart/pages/listsupplier.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:item_picker/item_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../config/url.dart' as host;
import '../styles/colors.dart' as colors;

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

    final response =
        await postData(Uri.parse("${host.BASE_URL}barang/get_barangs"), body);

    if (response.statusCode != 200) {
      return [];
    }

    var data = await jsonDecode(response.body);

    if (data['success'] == true) {
      List<MapEntry<String, dynamic>> resultBarang = [];

      data['data'].forEach((dynamic item) =>
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
        Uri.parse("${host.BASE_URL}supplier/get_suppliers"), body);

    if (response.statusCode != 200) {
      return [];
    }

    var data = await jsonDecode(response.body);

    if (data['success'] == true) {
      List<MapEntry<String, dynamic>> resultSuppliers = [];

      data['data'].forEach((dynamic item) =>
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

    var url = "${host.BASE_URL}warehouse/add";

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
          title: const Text(
            "Tambah Data Barang Masuk",
            style: TextStyle(color: colors.SECONDARY_COLOR),
          ),
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: colors.SECONDARY_COLOR),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          shadowColor: Colors.transparent,
        ),
        backgroundColor: Colors.white,
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
                      const Padding(padding: EdgeInsets.all(10)),
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
                      const Padding(padding: EdgeInsets.all(10)),
                      TextField(
                        controller: controllerStock,
                        decoration: InputDecoration(
                          hintText: "masukkan Qty",
                          labelText: "Qty",
                          border: OutlineInputBorder(
                              borderSide:
                                  const BorderSide(color: colors.PRIMARY_COLOR),
                              borderRadius: BorderRadius.circular(5.0)),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(20.0),
                      ),
                    ],
                  ),
                ])),
        bottomNavigationBar: Container(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: TextButton(
              onPressed: () {
                addWarehouse();
              },
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                backgroundColor: colors.PRIMARY_COLOR,
                padding: const EdgeInsets.all(15),
              ),
              child: const Text("Tambah Data",
                  style: TextStyle(color: Colors.white)),
            ),
          ),
        ));
  }
}
