import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config/url.dart' as host;
import '../styles/colors.dart' as colors;

class DetailUser extends StatefulWidget {
  List list;
  int index;

  DetailUser({required this.list, required this.index});

  @override
  DetailState createState() => DetailState();
}

class DetailState extends State<DetailUser> {
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

    var url = "${host.BASE_URL}user/delete";

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
          title: Text(
            "${widget.list[widget.index]['name']}",
            style: const TextStyle(color: colors.SECONDARY_COLOR),
          ),
          backgroundColor: Colors.white,
          shadowColor: Colors.transparent,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: colors.SECONDARY_COLOR),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        backgroundColor: Colors.white,
        body: Container(
          height: 350.0,
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
                padding: const EdgeInsets.all(20),
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          const Text("Email          :  ",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(
                            "${widget.list[widget.index]['email']}",
                            style: const TextStyle(fontSize: 17.0),
                          ),
                        ],
                      ),
                      Row(children: [
                        const Text("Alamat       :  ",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text(
                          "${widget.list[widget.index]['address']}",
                          style: const TextStyle(fontSize: 17.0),
                        ),
                      ]),
                      Row(children: [
                        const Text("Email          :  ",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text(
                          "${widget.list[widget.index]['phone']}",
                          style: const TextStyle(fontSize: 17.0),
                        ),
                      ]),
                    ],
                  ),
                )),
            const Padding(
              padding: EdgeInsets.all(20.0),
            ),
            TextButton(
              onPressed: () => confirmDelete(),
              child: const Text(
                "HAPUS USER",
                style: TextStyle(color: Colors.red),
              ),
              // color: Colors.redAccent
            )
          ]))),
        ));
  }
}
