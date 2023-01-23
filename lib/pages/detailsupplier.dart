import 'package:autojet_sparepart/pages/editsupplier.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config/url.dart' as host;
import '../styles/colors.dart' as colors;

class DetailSupplier extends StatefulWidget {
  List list;
  int index;
  DetailSupplier({required this.list, required this.index});
  @override
  DetailState createState() => DetailState();
}

class DetailState extends State<DetailSupplier> {
  void confirmDelete() {
    showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Hapus User?'),
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

    var url = "${host.BASE_URL}supplier/delete";

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
            title: const Text("Detail Supplier",
                style: TextStyle(color: colors.SECONDARY_COLOR)),
            backgroundColor: Colors.transparent,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: colors.SECONDARY_COLOR),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            shadowColor: Colors.transparent),
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
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
            const Padding(
              padding: EdgeInsets.all(15.0),
            ),
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Email        :  ${widget.list[widget.index]['email']}",
                      style: const TextStyle(fontSize: 17.0),
                    ),
                    Text(
                      "Alamat     :  ${widget.list[widget.index]['address']}",
                      style: const TextStyle(fontSize: 17.0),
                    ),
                    Text(
                      "No. Telp.  :  ${widget.list[widget.index]['phone']}",
                      style: const TextStyle(fontSize: 17.0),
                    ),
                    Text(
                      "Deskripsi :  ${widget.list[widget.index]['desc']}",
                      style: const TextStyle(fontSize: 17.0),
                    ),
                  ]),
            ),
            const Padding(
              padding: EdgeInsets.all(20.0),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextButton(
                  onPressed: () => confirmDelete(),
                  child:
                      const Text("HAPUS", style: TextStyle(color: Colors.red)),
                  // color: Colors.redAccent
                ),
                const Padding(padding: EdgeInsets.all(15.0)),
                TextButton(
                  onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => EditSupplier(
                          list: widget.list, index: widget.index))),
                  child:
                      const Text("EDIT", style: TextStyle(color: Colors.green)),
                  // color: Colors.lightGreen
                ),
              ],
            )
          ]))),
        ));
  }
}
