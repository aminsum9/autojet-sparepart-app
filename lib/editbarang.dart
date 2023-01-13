import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pretty_json/pretty_json.dart';
import './home.dart';

class EditBarang extends StatefulWidget {
  final List list;
  final int index;

  EditBarang({required this.list, this.index = 0});
  @override
  EditDataState createState() => EditDataState();
}

class EditDataState extends State<EditBarang> {
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
    print(prettyJson(body));
    var url = "http://192.168.43.128:8000/barang/update";
    http.post(Uri.parse(url), body: body).then((value) => Navigator.of(context)
        .push(MaterialPageRoute(builder: (BuildContext context) => Home())));
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
            : "Empty");
    controllerQty = TextEditingController(
        text: widget.list[widget.index]['qty']?.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Data Barang"),
        backgroundColor: Colors.green,
      ),
      body: Container(
          padding: const EdgeInsets.all(20.0),
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
                    decoration:
                        const InputDecoration(hintText: "masukkan nama"),
                  ),
                  const Padding(padding: EdgeInsets.all(10.0)),
                  TextField(
                    controller: controllerPrice,
                    decoration:
                        const InputDecoration(hintText: "masukkan harga"),
                  ),
                  const Padding(padding: EdgeInsets.all(10.0)),
                  TextField(
                    controller: controllerQty,
                    decoration:
                        const InputDecoration(hintText: "masukkan stock"),
                  ),
                  TextField(
                    controller: controllerDesc,
                    decoration:
                        const InputDecoration(hintText: "masukkan deskripsi"),
                  ),
                  const Padding(padding: EdgeInsets.all(10.0)),
                ],
              ),
              TextButton(
                  onPressed: () {
                    editData();
                  },
                  child: Text("EDIT", style: TextStyle(color: Colors.white)),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.green,
                  )),
            ]),
          ))),
    );
  }
}
