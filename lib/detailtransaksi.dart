import 'dart:convert';

import 'package:autojet_sparepart/edittransaksi.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class DetailTransaksi extends StatefulWidget {
  List list;
  int index;
  DetailTransaksi({required this.list, required this.index});
  @override
  DetailState createState() => DetailState();
}

class DetailState extends State<DetailTransaksi> {
  List<dynamic> detailTransaksis = [];
  List<Widget> detailTransaksi = [];

  void confirmDelete() {
    showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Hapus Transaksi?'),
          content: Text(
              "Apakah anda yakin ingin menghapus dengan id transaksi '${widget.list[widget.index]['trx_id']}'?"),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("BATAL",
                  style: TextStyle(color: Colors.lightGreen)),
              // color: Colors.lightGreen
            ),
            TextButton(
              child: const Text('HAPUS', style: TextStyle(color: Colors.red)),
              onPressed: () {
                deleteData();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    detailTransaksi = [];
    detailTransaksis = widget.list[widget.index]['detail_transaksi'];

    detailTransaksis.forEach((item) {
      detailTransaksi.add(Container(
          padding: const EdgeInsets.all(10.0),
          child: Card(
            child: Column(
              children: [
                Text("Qty : ${item['qty'].toString()}"),
                Text("Subtotal : ${item['subtotal'].toString()}"),
                Text("Diskon : ${item['discount'].toString()}"),
                Text("Total : ${item['grand_total'].toString()}"),
                Text(
                    "Barang : ${item['barang'] != null ? item['barang']['name'].toString() : ""}"),
              ],
            ),
          )));
    });
  }

  Future<String> getDataStorage(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key).toString();
  }

  void deleteData() async {
    var token = await getDataStorage('token');

    var url = "http://192.168.43.128:8000/transaksi/delete";

    http.post(Uri.parse(url), body: {
      "id": widget.list[widget.index]["id"].toString(),
      "token": token.toString(),
    }).then((response) =>
        {Navigator.pop(context, true), Navigator.pop(context, true)});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text("${widget.list[widget.index]['trx_id']}"),
            backgroundColor: Colors.lightGreen),
        body: Container(
          // height: 300.0,
          padding: const EdgeInsets.all(20.0),
          child: Card(
              child: Center(
                  child: Column(children: [
            const Padding(
              padding: EdgeInsets.all(15.0),
            ),
            Text(
              widget.list[widget.index]['trx_id'],
              style: const TextStyle(
                  fontSize: 20.0,
                  color: Colors.blueAccent,
                  fontWeight: FontWeight.bold),
            ),
            const Padding(
              padding: EdgeInsets.all(15.0),
            ),
            Text(
              "Status : ${widget.list[widget.index]['status']}",
              style: const TextStyle(fontSize: 17.0),
            ),
            Text(
              "Subtotal : ${widget.list[widget.index]['subtotal']}",
              style: const TextStyle(fontSize: 17.0),
            ),
            Text(
              "Discount. : ${widget.list[widget.index]['discount']}",
              style: const TextStyle(fontSize: 17.0),
            ),
            Text(
              "Total : ${widget.list[widget.index]['grand_total']}",
              style: const TextStyle(fontSize: 17.0),
            ),
            const Padding(
              padding: EdgeInsets.all(20.0),
            ),
            const Text(
              "Detail Transaksi",
              style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: detailTransaksi,
            ),
            const Padding(
              padding: EdgeInsets.all(20.0),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => EditTransaksi(
                          list: widget.list, index: widget.index))),
                  child: const Text("EDIT"),
                  // color: Colors.lightGreen
                ),
                const Padding(padding: EdgeInsets.all(15.0)),
                TextButton(
                  onPressed: () => confirmDelete(),
                  child: const Text("DELETE"),
                  // color: Colors.redAccent
                )
              ],
            )
          ]))),
        ));
  }
}
