import 'dart:convert';

import 'package:autojet_sparepart/models/trans_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:item_picker/item_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/url.dart' as host;
import '../styles/colors.dart' as colors;

class EditTransaksi extends StatefulWidget {
  final TransModel trans;
  final int index;

  const EditTransaksi({super.key, required this.trans, this.index = 0});
  @override
  EditTransaksiState createState() => EditTransaksiState();
}

class EditTransaksiState extends State<EditTransaksi> {
  List<MapEntry<String, dynamic>> listStatus = [
    const MapEntry('new', 1),
    const MapEntry('pending', 2),
    const MapEntry('finish', 3),
    const MapEntry('cancel', 4),
    const MapEntry('refund', 5),
  ];
  int selectedStatus = 1;

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

    var status = 'new';

    if (selectedStatus == 1) {
      status = 'new';
    } else if (selectedStatus == 2) {
      status = 'pending';
    } else if (selectedStatus == 3) {
      status = 'finish';
    } else if (selectedStatus == 4) {
      status = 'cancel';
    } else if (selectedStatus == 5) {
      status = 'refund';
    }

    var body = {
      "id": widget.trans.id ?? "",
      "status": status,
      "subtotal": controllerSubTotal.text.toString(),
      "discount": controllerDiscount.text.toString(),
      "grand_total": controllerTotal.text.toString(),
      "notes": controllerNotes.text.toString(),
      "token": token.toString(),
    };

    var url = "${host.BASE_URL}transaksi/update";
    http.post(Uri.parse(url), body: body).then((value) => {
          if (jsonDecode(value.body)['success'] == true)
            {Navigator.pushNamed(context, '/home')}
          else
            {
              //
            }
        });
  }

  @override
  void initState() {
    super.initState();
    controllerSubTotal =
        TextEditingController(text: widget.trans.subtotal.toString());
    controllerDiscount =
        TextEditingController(text: widget.trans.discount.toString());
    controllerTotal =
        TextEditingController(text: widget.trans.grandTotal.toString());
    controllerNotes = TextEditingController(text: widget.trans.notes);
    var status = widget.trans.status;

    if (status == 'new') {
      setState(() {
        selectedStatus = 1;
      });
    } else if (status == 'pending') {
      setState(() {
        selectedStatus = 2;
      });
    } else if (status == 'finish') {
      setState(() {
        selectedStatus = 3;
      });
    } else if (status == 'cancel') {
      setState(() {
        selectedStatus = 4;
      });
    } else if (status == 'refund') {
      setState(() {
        selectedStatus = 5;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Data Transaksi",
            style: TextStyle(color: colors.SECONDARY_COLOR)),
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
                  Text("ID Transaksi : ${widget.trans.trxId}"),
                  Text("Dibuat oleh : ${widget.trans.createdBy?.name}"),
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
                  const Text("Pilih Status",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  ItemPicker(
                    list: listStatus,
                    defaultValue: selectedStatus,
                    onSelectionChange: (value) => {
                      setState(() {
                        selectedStatus = value;
                      })
                    },
                  ),
                  const Padding(padding: EdgeInsets.all(10.0)),
                ],
              ),
            ]),
          ))),
      bottomNavigationBar: Container(
          child: Padding(
        padding: const EdgeInsets.all(10),
        child: TextButton(
          onPressed: () {
            editDataUser();
          },
          style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              backgroundColor: colors.PRIMARY_COLOR,
              padding: const EdgeInsets.all(15)),
          child: const Text("EDIT", style: TextStyle(color: Colors.white)),
        ),
      )),
    );
  }
}
