import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pretty_json/pretty_json.dart';
import 'listbarang.dart';
import '../config/url.dart' as globals;

class EditBarang extends StatefulWidget {
  final List list;
  final int index;

  EditBarang({required this.list, this.index = 0});
  @override
  EditBarangState createState() => EditBarangState();
}

class EditBarangState extends State<EditBarang> {
  TextEditingController controllerDesc = TextEditingController(text: "");
  TextEditingController controllerName = TextEditingController(text: "");
  TextEditingController controllerPrice = TextEditingController(text: "");
  TextEditingController controllerQty = TextEditingController(text: "");

  Future<String> getDataStorage(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key).toString();
  }

  editData() async {
    var token = await getDataStorage('token');

    var body = {
      "id": widget.list[widget.index]["id"].toString(),
      "name": controllerName.text,
      "image": "",
      "price": controllerPrice.text.toString(),
      "discount": "0",
      "qty": controllerQty.text.toString(),
      "desc": controllerDesc.text,
      "token": token.toString(),
    };
    // print(prettyJson(body));
    var url = "${globals.BASE_URL}barang/update";
    http.post(Uri.parse(url), body: body).then((value) => Navigator.of(context)
        .push(MaterialPageRoute(
            builder: (BuildContext context) => ListBarang())));
  }

  @override
  void initState() {
    controllerDesc =
        TextEditingController(text: widget.list[widget.index]['desc']);
    controllerName =
        TextEditingController(text: widget.list[widget.index]['name']);
    controllerPrice = TextEditingController(
        text: widget.list[widget.index]['price'] != null
            ? widget.list[widget.index]['price']?.toString()
            : "");
    controllerQty = TextEditingController(
        text: widget.list[widget.index]['qty']?.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Edit Data Barang"),
          backgroundColor: Colors.lightGreen,
        ),
        body: Container(
            padding: const EdgeInsets.all(10.0),
            child: Card(
                child: Container(
              padding: const EdgeInsets.all(10.0),
              child: ListView(children: [
                Column(
                  children: [
                    const Padding(padding: EdgeInsets.all(10.0)),
                    const Text("Edit Data Barang",
                        style: TextStyle(
                            fontSize: 25.0, fontWeight: FontWeight.bold)),
                    const Padding(padding: EdgeInsets.all(10.0)),
                    const Padding(padding: EdgeInsets.all(10.0)),
                    TextField(
                      controller: controllerName,
                      decoration: InputDecoration(
                          hintText: "masukkan nama barang",
                          labelText: "Nama Barang",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0))),
                    ),
                    const Padding(padding: EdgeInsets.all(10.0)),
                    TextField(
                      controller: controllerPrice,
                      decoration: InputDecoration(
                        hintText: "masukkan harga barang",
                        labelText: "Harga Barang",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                      ),
                    ),
                    const Padding(padding: EdgeInsets.all(10.0)),
                    TextField(
                      controller: controllerQty,
                      decoration: InputDecoration(
                          hintText: "masukkan qty barang",
                          labelText: "Qty Barang",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0))),
                    ),
                    const Padding(padding: EdgeInsets.all(10.0)),
                    TextField(
                      controller: controllerDesc,
                      decoration: InputDecoration(
                          hintText: "masukkan deskripsi barang",
                          labelText: "Deskripsi Barang",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0))),
                    ),
                    const Padding(padding: EdgeInsets.all(10.0)),
                  ],
                ),
              ]),
            ))),
        bottomNavigationBar: Container(
          margin: const EdgeInsets.only(left: 16, right: 16, bottom: 10),
          child: TextButton(
            onPressed: () {
              editData();
            },
            style: TextButton.styleFrom(
                backgroundColor: Colors.lightGreen,
                padding: const EdgeInsets.all(15)),
            child: const Text("EDIT", style: TextStyle(color: Colors.white)),
          ),
        ));
  }
}
