import 'package:autojet_sparepart/models/detail_trans_model.dart';
import 'package:autojet_sparepart/models/supplier_model.dart';
import 'package:autojet_sparepart/models/trans_model.dart';
import 'package:autojet_sparepart/pages/edittransaksi.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config/url.dart' as host;
import '../styles/colors.dart' as colors;
import '../helper/rupiah.dart' as rupiah;

// ignore: must_be_immutable
class DetailTransaksi extends StatefulWidget {
  TransModel trans;
  int index;

  DetailTransaksi({super.key, required this.trans, required this.index});

  @override
  DetailState createState() => DetailState();
}

class DetailState extends State<DetailTransaksi> {
  TransModel? transData;
  List<Widget> detailTransaksi = [];

  void confirmDelete() {
    showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Hapus Transaksi?'),
          content: Text(
              "Apakah anda yakin ingin menghapus dengan id transaksi '${widget.trans.trxId}'?"),
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
    super.initState();
    detailTransaksi = [];
    List<DetailTransModel> detailTransaksis =
        widget.trans.detailTrans as List<DetailTransModel>;

    for (var item in detailTransaksis) {
      List<SupplierModel> suppliers =
          item.barang!.suppliers as List<SupplierModel>;

      String supplier = "";

      for (var e in suppliers) {
        supplier = "$supplier ${e.name},";
      }

      detailTransaksi.add(Container(
          padding: const EdgeInsets.all(10.0),
          child: Card(
              child: ListTile(
            title: Text(
              item.barang != null ? item.barang!.name.toString() : "",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Padding(
              padding:
                  const EdgeInsets.only(left: 10, top: 5, bottom: 5, right: 10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(padding: EdgeInsets.all(5.0)),
                  Text("Qty : ${item.qty}"),
                  Text("Subtotal : ${item.subtotal}"),
                  Text("Diskon : ${item.discount}"),
                  Text("Total : ${item.grandTotal}"),
                  Text("Penyuplai : $supplier"),
                ],
              ),
            ),
          ))));
    }
  }

  Future<String> getDataStorage(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key).toString();
  }

  void deleteData() async {
    var token = await getDataStorage('token');

    var url = "${host.BASE_URL}transaksi/delete";

    http.post(Uri.parse(url), body: {
      "id": widget.trans.id,
      "token": token.toString(),
    }).then((response) =>
        {Navigator.pop(context, true), Navigator.pop(context, true)});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(
              "${widget.trans.trxId}",
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
                    widget.trans.trxId as String,
                    style: const TextStyle(
                        fontSize: 20.0,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(15.0),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 30),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            children: [
                              const Text(
                                "Status         : ",
                                style: TextStyle(
                                    fontSize: 17.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "${widget.trans.status}",
                                style: const TextStyle(fontSize: 17.0),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Text(
                                "Subtotal     : ",
                                style: TextStyle(
                                    fontSize: 17.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                rupiah.toRupiah(widget.trans.subtotal as int),
                                style: const TextStyle(fontSize: 17.0),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Text(
                                "Diskon        : ",
                                style: TextStyle(
                                    fontSize: 17.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                rupiah.toRupiah(widget.trans.discount as int),
                                style: const TextStyle(fontSize: 17.0),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Text(
                                "Total           : ",
                                style: TextStyle(
                                    fontSize: 17.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                rupiah.toRupiah(widget.trans.grandTotal as int),
                                style: const TextStyle(fontSize: 17.0),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Text(
                                "Dibuat oleh :",
                                style: TextStyle(
                                    fontSize: 17.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "${widget.trans.createdBy?.name}",
                                style: const TextStyle(fontSize: 17.0),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Text(
                                "Catatan      : ",
                                style: TextStyle(
                                    fontSize: 17.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                widget.trans.notes as String,
                                style: const TextStyle(fontSize: 17.0),
                              ),
                            ],
                          )
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
                                        trans: widget.trans,
                                        index: widget.index))),
                        child: const Text("EDIT",
                            style: TextStyle(color: Colors.green)),
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
