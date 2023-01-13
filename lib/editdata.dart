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
  TextEditingController controllerDesc = TextEditingController(text: "");
  TextEditingController controllerName = TextEditingController(text: "");
  TextEditingController controllerPrice = TextEditingController(text: "");
  TextEditingController controllerQty = TextEditingController(text: "");

  editData() {
    var url = "http://192.168.43.128:8000/barang/update";
    http.post(Uri.parse(url), body: {
      "id": widget.list[widget.index]["id"],
      "desc": controllerDesc.text,
      "name": controllerName.text,
      "price": controllerPrice.text,
      "stock": controllerQty.text,
      "discount": "0",
    }).then((value) => Navigator.of(context)
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
                    controller: controllerDesc,
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
                    controller: controllerQty,
                    decoration:
                        const InputDecoration(hintText: "masukkan stock"),
                  ),
                  const Padding(padding: EdgeInsets.all(10.0)),
                ],
              ),
              TextButton(
                  onPressed: () {
                    editData();
                  },
                  child:
                      const Text("EDIT", style: TextStyle(color: Colors.white)),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.green,
                  )),
            ]),
          ))),
    );
  }
}
