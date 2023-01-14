// import 'package:crud_flutter/editdata.dart';
import 'package:flutter/material.dart';
import 'editbarang.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'home.dart';

class DetailBarang extends StatefulWidget {
  List list;
  int index;

  DetailBarang({required this.list, required this.index});
  @override
  DetailState createState() => DetailState();
}

class DetailState extends State<DetailBarang> {
  void confirmDelete() {
    showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Hapus Barang?'),
          content: Text(
              "Apakah anda yakin ingin menghapus'${widget.list[widget.index]['name']}'?"),
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

  Future<String> getDataStorage(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key).toString();
  }

  void deleteData() async {
    var token = await getDataStorage('token');

    var url = "http://192.168.43.128:8000/barang/delete";

    http.post(Uri.parse(url), body: {
      "id": widget.list[widget.index]["id"].toString(),
      "token": token.toString(),
    }).then((value) => Navigator.of(context)
        .push(MaterialPageRoute(builder: (BuildContext contex) => Home())));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text("${widget.list[widget.index]['name']}"),
            backgroundColor: Colors.green),
        body: Container(
          height: 300.0,
          padding: const EdgeInsets.all(20.0),
          child: Card(
              child: Center(
                  child: Column(children: [
            const Padding(
              padding: EdgeInsets.all(15.0),
            ),
            Text(
              widget.list[widget.index]['name'],
              style: const TextStyle(
                  fontSize: 20.0,
                  color: Colors.blueAccent,
                  fontWeight: FontWeight.bold),
            ),
            const Padding(
              padding: EdgeInsets.all(15.0),
            ),
            Text(
              "Harga : ${widget.list[widget.index]['price']}",
              style: const TextStyle(fontSize: 17.0),
            ),
            Text(
              "Diskon : ${widget.list[widget.index]['discount']}",
              style: const TextStyle(fontSize: 17.0),
            ),
            Text(
              "Qty : ${widget.list[widget.index]['qty']}",
              style: const TextStyle(fontSize: 17.0),
            ),
            Text(
              "Deskripsi : ${widget.list[widget.index]['desc']}",
              style: const TextStyle(fontSize: 17.0),
            ),
            const Padding(
              padding: EdgeInsets.all(20.0),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) =>
                          EditBarang(list: widget.list, index: widget.index))),
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
