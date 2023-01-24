// import 'package:crud_flutter/editdata.dart';
import 'package:flutter/material.dart';
import 'editbarang.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config/url.dart' as host;
import '../styles/colors.dart' as colors;

class DetailBarang extends StatefulWidget {
  List list;
  int index;

  DetailBarang({required this.list, required this.index});
  @override
  DetailState createState() => DetailState();
}

class DetailState extends State<DetailBarang> {
  String suppliersBy = "";
  String userInput = "";

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
    //supplier
    List<dynamic> suppliers = widget.list[widget.index]['suppliers'];

    String supplier = "";

    suppliers.forEach((e) => {supplier = "${supplier} - ${e['name']}\n"});

    suppliersBy = supplier;
    //barang
    List<dynamic> inputBy = widget.list[widget.index]['input_by'];

    String input_by = "";

    inputBy.forEach((e) => {input_by = "${input_by} - ${e['name']}\n"});

    userInput = input_by;
  }

  Future<String> getDataStorage(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key).toString();
  }

  void deleteData() async {
    var token = await getDataStorage('token');

    var url = "${host.BASE_URL}barang/delete";

    http.post(Uri.parse(url), body: {
      "id": widget.list[widget.index]["id"].toString(),
      "token": token.toString(),
    }).then((value) => Navigator.pushNamed(context, '/home'));
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
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          // padding: const EdgeInsets.all(20.0),
          child: Container(
              // height: 300.0,
              padding: const EdgeInsets.all(10.0),
              child: Center(
                child: Card(
                    child: Padding(
                        padding: const EdgeInsets.only(
                            left: 20, top: 10, right: 20, bottom: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(15.0),
                            ),
                            Center(
                                child: Column(
                              children: [
                                (widget.list[widget.index]["image"]
                                                .toString() !=
                                            "" &&
                                        widget.list[widget.index]["image"] !=
                                            null)
                                    ? (Image.network(
                                        "${host.BASE_URL}/images/barang/${widget.list[widget.index]["image"].toString()}",
                                        width: 150,
                                        height: 100,
                                      ))
                                    : const Icon(Icons.widgets,
                                        color: Colors.grey, size: 100.0),
                                const Padding(
                                  padding: EdgeInsets.all(5.0),
                                ),
                                Text(
                                  widget.list[widget.index]['name'],
                                  style: const TextStyle(
                                      fontSize: 15.0,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            )),
                            const Padding(
                              padding: EdgeInsets.all(15.0),
                            ),
                            Text(
                              "Harga       : ${widget.list[widget.index]['price']}",
                              style: const TextStyle(fontSize: 17.0),
                            ),
                            Text(
                              "Diskon      : ${widget.list[widget.index]['discount']}",
                              style: const TextStyle(fontSize: 17.0),
                            ),
                            Text(
                              "Qty            : ${widget.list[widget.index]['qty']}",
                              style: const TextStyle(fontSize: 17.0),
                            ),
                            Text(
                              "Deskripsi  : ${widget.list[widget.index]['desc']}",
                              style: const TextStyle(fontSize: 17.0),
                            ),
                            const Padding(
                              padding: EdgeInsets.all(10.0),
                            ),
                            const Text(
                              "Penyuplai :",
                              style: TextStyle(
                                  fontSize: 17.0, fontWeight: FontWeight.bold),
                            ),
                            const Padding(
                              padding: EdgeInsets.all(5.0),
                            ),
                            Text(
                              "${suppliersBy}",
                              style: const TextStyle(fontSize: 17.0),
                            ),
                            const Padding(
                              padding: EdgeInsets.all(10.0),
                            ),
                            const Text(
                              "Diinput Oleh :",
                              style: TextStyle(
                                  fontSize: 17.0, fontWeight: FontWeight.bold),
                            ),
                            const Padding(
                              padding: EdgeInsets.all(5.0),
                            ),
                            Text(
                              "${userInput}",
                              style: const TextStyle(fontSize: 17.0),
                            ),
                            const Padding(
                              padding: EdgeInsets.all(20.0),
                            ),
                            Row(
                              // mainAxisSize: MainAxisSize.min,
                              children: [
                                TextButton(
                                  onPressed: () => confirmDelete(),
                                  child: const Text(
                                    "HAPUS",
                                    style: TextStyle(color: Colors.red),
                                  ),
                                  // color: Colors.redAccent
                                ),
                                const Padding(padding: EdgeInsets.all(15.0)),
                                TextButton(
                                  onPressed: () => Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              EditBarang(
                                                  list: widget.list,
                                                  index: widget.index))),
                                  child: const Text("EDIT",
                                      style: TextStyle(color: Colors.green)),
                                ),
                              ],
                            )
                          ],
                        ))),
              )),
        ));
  }
}
