import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import './home.dart';

class EditData extends StatefulWidget {
  final List list;
  final int index;

  EditData({required this.list, this.index = 0});
  @override
  EditDataState createState() => EditDataState();
}

class EditDataState extends State<EditData> {
  TextEditingController controllerCode = TextEditingController(text: "");
  TextEditingController controllerName = TextEditingController(text: "");
  TextEditingController controllerPrice = TextEditingController(text: "");
  TextEditingController controllerStock = TextEditingController(text: "");

  editData() {
    var url = "http://192.168.43.129/barang/update";
    http.post(Uri.parse(url), body: {
      "id": widget.list[widget.index]["id"],
      "item_code": controllerCode.text,
      "item_name": controllerName.text,
      "price": controllerPrice.text,
      "stock": controllerStock.text,
    }).then((value) => Navigator.of(context)
        .push(MaterialPageRoute(builder: (BuildContext context) => Home())));
  }

  @override
  void initState() {
    controllerCode =
        TextEditingController(text: widget.list[widget.index]['item_code']);
    controllerName =
        TextEditingController(text: widget.list[widget.index]['item_name']);
    controllerPrice =
        TextEditingController(text: widget.list[widget.index]['price']);
    controllerStock =
        TextEditingController(text: widget.list[widget.index]['stock']);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("EDIT DATA"),
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
                  const Text("Edit Data",
                      style: TextStyle(
                          fontSize: 25.0, fontWeight: FontWeight.bold)),
                  const Padding(padding: EdgeInsets.all(10.0)),
                  TextField(
                    controller: controllerCode,
                    decoration:
                        const InputDecoration(hintText: "masukkan code"),
                  ),
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
                    controller: controllerStock,
                    decoration:
                        const InputDecoration(hintText: "masukkan stock"),
                  ),
                  const Padding(padding: EdgeInsets.all(10.0)),
                  TextButton(
                    onPressed: () {
                      editData();
                    },
                    child: const Text("EDIT",
                        style: TextStyle(color: Colors.white)),
                    // color: Colors.greenAccent
                  )
                ],
              ),
            ]),
          ))),
    );
  }
}
