import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config/url.dart' as globals;

class AddBarang extends StatefulWidget {
  @override
  AddWarehouseState createState() => AddWarehouseState();
}

class AddWarehouseState extends State<AddBarang> {
  TextEditingController controllerName = TextEditingController(text: "");
  TextEditingController controllerPrice = TextEditingController(text: "");
  TextEditingController controllerDiscount = TextEditingController(text: "");
  TextEditingController controllerStock = TextEditingController(text: "");
  TextEditingController controllerDesc = TextEditingController(text: "");

  Future<String> getDataStorage(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key).toString();
  }

  void addDataBarang() async {
    var token = await getDataStorage('token');

    var url = "${globals.BASE_URL}barang/add";

    http.post(Uri.parse(url), body: {
      "name": controllerName.text,
      "price": controllerPrice.text,
      "discount": controllerDiscount.text,
      "qty": controllerStock.text,
      "image": "",
      "desc": controllerDesc.text,
      "token": token.toString(),
    }).then((response) => {
          if (response.statusCode == 200) {Navigator.pop(context)}
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tambah Barang"),
        backgroundColor: Colors.lightGreen,
      ),
      body: Container(
          padding: const EdgeInsets.all(20.0),
          child: ListView(children: [
            Column(
              children: [
                TextField(
                  controller: controllerName,
                  decoration: const InputDecoration(
                      hintText: "masukkan nama item", labelText: "Nama"),
                ),
                TextField(
                  controller: controllerPrice,
                  decoration: const InputDecoration(
                      hintText: "masukkan harga item", labelText: "Harga"),
                ),
                TextField(
                  controller: controllerDiscount,
                  decoration: const InputDecoration(
                      hintText: "masukkan diskon barang", labelText: "Diskon"),
                ),
                TextField(
                  controller: controllerStock,
                  decoration: const InputDecoration(
                      hintText: "masukkan stock item", labelText: "Qty"),
                ),
                TextField(
                  controller: controllerDesc,
                  decoration: const InputDecoration(
                      hintText: "masukkan code item",
                      labelText: "Deskripsi barang"),
                ),
                const Padding(
                  padding: EdgeInsets.all(20.0),
                ),
              ],
            ),
            TextButton(
                onPressed: () {
                  addDataBarang();
                },
                child: Text("SUBMIT", style: TextStyle(color: Colors.white)),
                style: TextButton.styleFrom(
                  backgroundColor: Colors.lightGreen,
                )),
          ])),
    );
  }
}
