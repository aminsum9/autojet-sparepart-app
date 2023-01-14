import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pretty_json/pretty_json.dart';

class EditTransaksi extends StatefulWidget {
  final List list;
  final int index;

  EditTransaksi({required this.list, this.index = 0});
  @override
  EditTransaksiState createState() => EditTransaksiState();
}

class EditTransaksiState extends State<EditTransaksi> {
  TextEditingController controllerTrxId = TextEditingController(text: "");
  TextEditingController controllerUser = TextEditingController(text: "");
  TextEditingController controllerStatus = TextEditingController(text: "");
  TextEditingController controllerSubTotal = TextEditingController(text: "");
  TextEditingController controllerDiscount = TextEditingController(text: "");
  TextEditingController controllerTotal = TextEditingController(text: "");
  TextEditingController controllerNotes = TextEditingController(text: "");

  Future<String> getDataStorage(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key).toString();
  }

  editDataUser() async {
    var token = await getDataStorage('token');

    var body = {
      "id": widget.list[widget.index]["id"].toString() ?? "",
      "name": controllerSubTotal.text,
      "email": controllerDiscount.text.toString(),
      "image": "",
      "address": controllerTrxId.text,
      "phone": controllerTotal.text.toString(),
      "desc": controllerNotes.text.toString(),
      "token": token.toString(),
    };

    var url = "http://192.168.43.128:8000/supplier/update";
    http
        .post(Uri.parse(url), body: body)
        .then((value) => Navigator.pushNamed(context, '/home'));
  }

  @override
  void initState() {
    controllerTrxId =
        TextEditingController(text: widget.list[widget.index]['trx_id'] ?? "");
    controllerUser = TextEditingController(
        text: widget.list[widget.index]['user_id'].toString() ?? "");
    controllerSubTotal = TextEditingController(
        text: widget.list[widget.index]['subtotal'].toString() ?? "");
    controllerStatus = TextEditingController(
        text: widget.list[widget.index]['status'].toString() ?? "");
    controllerDiscount = TextEditingController(
        text: widget.list[widget.index]['discount'].toString() ?? "");
    controllerTotal = TextEditingController(
        text: widget.list[widget.index]['grand_total'].toString() ?? "");
    controllerNotes =
        TextEditingController(text: widget.list[widget.index]['notes'] ?? "");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Data Transaksi"),
        backgroundColor: Colors.lightGreen,
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
                  const Text("Edit Data Transaksi",
                      style: TextStyle(
                          fontSize: 25.0, fontWeight: FontWeight.bold)),
                  const Padding(padding: EdgeInsets.all(10.0)),
                  const Padding(padding: EdgeInsets.all(10.0)),
                  TextField(
                    controller: controllerTrxId,
                    decoration: const InputDecoration(hintText: "ID TRANSAKSI"),
                  ),
                  TextField(
                    controller: controllerUser,
                    decoration: const InputDecoration(hintText: "User"),
                  ),
                  TextField(
                    controller: controllerStatus,
                    decoration: const InputDecoration(hintText: "Status"),
                  ),
                  TextField(
                    controller: controllerSubTotal,
                    decoration: const InputDecoration(hintText: "Subtotal"),
                  ),
                  const Padding(padding: EdgeInsets.all(10.0)),
                  TextField(
                    controller: controllerDiscount,
                    decoration: const InputDecoration(hintText: "Diskon"),
                  ),
                  const Padding(padding: EdgeInsets.all(10.0)),
                  TextField(
                    controller: controllerTotal,
                    decoration: const InputDecoration(hintText: "Total"),
                  ),
                  TextField(
                    controller: controllerNotes,
                    decoration: const InputDecoration(hintText: "Notes"),
                  ),
                  const Padding(padding: EdgeInsets.all(10.0)),
                ],
              ),
              TextButton(
                  onPressed: () {
                    editDataUser();
                  },
                  child: Text("EDIT", style: TextStyle(color: Colors.white)),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.lightGreen,
                  )),
            ]),
          ))),
    );
  }
}
