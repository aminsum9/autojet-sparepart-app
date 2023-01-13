import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddData extends StatefulWidget {
  @override
  AddDataState createState() => AddDataState();
}

class AddDataState extends State<AddData> {
  TextEditingController controllerCode = TextEditingController(text: "");
  TextEditingController controllerName = TextEditingController(text: "");
  TextEditingController controllerPrice = TextEditingController(text: "");
  TextEditingController controllerStock = TextEditingController(text: "");

  void addData() {
    var url = "http://192.168.43.129/barang/add";

    http.post(Uri.parse(url), body: {
      "item_code": controllerCode.text,
      "item_name": controllerName.text,
      "price": controllerPrice.text,
      "stock": controllerStock.text
    }).then((value) => Navigator.pop(context));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ADD DATA"),
      ),
      body: Container(
          padding: const EdgeInsets.all(20.0),
          child: ListView(children: [
            Column(
              children: [
                TextField(
                  controller: controllerCode,
                  decoration: const InputDecoration(
                      hintText: "masukkan code item", labelText: "Item Code"),
                ),
                TextField(
                  controller: controllerName,
                  decoration: const InputDecoration(
                      hintText: "masukkan nama item", labelText: "Name"),
                ),
                TextField(
                  controller: controllerPrice,
                  decoration: const InputDecoration(
                      hintText: "masukkan harga item", labelText: "Price"),
                ),
                TextField(
                  controller: controllerStock,
                  decoration: const InputDecoration(
                      hintText: "masukkan stock item", labelText: "Stock"),
                ),
                const Padding(
                  padding: EdgeInsets.all(20.0),
                ),
                TextButton(
                  onPressed: () {
                    addData();
                  },
                  child: const Text("SUBMIT",
                      style: TextStyle(color: Colors.white)),
                  // color: Colors.blueAccent
                )
              ],
            )
          ])),
    );
  }
}
