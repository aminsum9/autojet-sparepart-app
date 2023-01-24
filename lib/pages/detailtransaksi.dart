import 'package:autojet_sparepart/pages/edittransaksi.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config/url.dart' as host;
import '../styles/colors.dart' as colors;

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
      List<dynamic> suppliers = item['barang']['suppliers'];

      String supplier = "";

      suppliers.forEach((e) => {supplier = "${supplier} ${e['name']},"});

      detailTransaksi.add(Container(
          padding: const EdgeInsets.all(10.0),
          child: Card(
              child: ListTile(
            title: Text(
              item['barang'] != null ? item['barang']['name'].toString() : "",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Padding(padding: EdgeInsets.all(5.0)),
                  Text("Qty : ${item['qty'].toString()}"),
                  Text("Subtotal : ${item['subtotal'].toString()}"),
                  Text("Diskon : ${item['discount'].toString()}"),
                  Text("Total : ${item['grand_total'].toString()}"),
                  Text("Penyuplai : ${supplier}"),
                ],
              ),
            ),
          ))));
    });
  }

  Future<String> getDataStorage(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key).toString();
  }

  void deleteData() async {
    var token = await getDataStorage('token');

    var url = "${host.BASE_URL}transaksi/delete";

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
              "${widget.list[widget.index]['trx_id']}",
              style: const TextStyle(color: colors.SECONDARY_COLOR),
            ),
            backgroundColor: Colors.white,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: colors.SECONDARY_COLOR),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            shadowColor: Colors.transparent),
        backgroundColor: Colors.white,
        body: Container(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
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
                        color: Colors.black,
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
                  Text(
                    "Dibuat oleh : ${widget.list[widget.index]['created_by']?['name'] ?? ""}",
                    style: const TextStyle(fontSize: 17.0),
                  ),
                  Text(
                    "Catatan : ${widget.list[widget.index]['notes'] ?? ""}",
                    style: const TextStyle(fontSize: 17.0),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(20.0),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextButton(
                        onPressed: () => confirmDelete(),
                        child: const Text("HAPUS",
                            style: TextStyle(color: Colors.red)),
                        // color: Colors.redAccent
                      ),
                      const Padding(padding: EdgeInsets.all(15.0)),
                      TextButton(
                        onPressed: () => Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    EditTransaksi(
                                        list: widget.list,
                                        index: widget.index))),
                        child: const Text("EDIT"),
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.all(10.0),
                  ),
                  const Text(
                    "Detail Transaksi",
                    style:
                        TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(10.0),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: detailTransaksi,
                  ),
                ]))))));
  }
}
