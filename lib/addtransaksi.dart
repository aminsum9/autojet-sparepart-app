import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pretty_json/pretty_json.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:item_picker/item_picker.dart';
import 'dart:convert';
import 'config/url.dart' as globals;

class AddTransaksi extends StatefulWidget {
  @override
  AddDataState createState() => AddDataState();
}

class AddDataState extends State<AddTransaksi> {
  TextEditingController controllerDiscount = TextEditingController(text: "");
  TextEditingController controllerNotes = TextEditingController(text: "");
  TextEditingController controllerQty = TextEditingController(text: "");
  //
  String selectedBarang = "";
  //
  List<MapEntry<String, dynamic>> dataBarang = [];
  List<dynamic> barangData = [];
  List<Widget> detailTransaksi = [];
  List<dynamic> barangTransaksi = [];
  //

  Future<http.Response> postData(Uri url, dynamic body) async {
    final response = await http.post(url, body: body);
    return response;
  }

  Future<String> getDataStorage(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key).toString();
  }

  getDataBarang() async {
    var token = await getDataStorage('token');

    var body = {"page": "1", "paging": "10", "token": token.toString()};

    final response = await postData(
        Uri.parse("${globals.BASE_URL}barang/get_barangs"), body);

    if (response.statusCode != 200) {
      return [];
    }

    var data = await jsonDecode(response.body);

    if (data['success'] == true) {
      List<MapEntry<String, dynamic>> resultBarang = [];

      data['data']['data'].forEach((dynamic item) =>
          {resultBarang.add(MapEntry(item['name'], item['id'].toString()))});

      setState(() {
        dataBarang = resultBarang;
        barangData = data['data']['data'];
      });
    } else {
      setState(() {
        barangData = [];
        barangData = [];
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDataBarang();
  }

  void addData() async {
    var token = await getDataStorage('token');

    var url = "${globals.BASE_URL}transaksi/create_transaksi";

    List<dynamic> detailTransaksi = [];

    barangTransaksi.forEach((item) {
      detailTransaksi.add(item);
    });

    var body = {
      "trx_id": "TESSS", // tes
      "user_id": "1", // tes
      "detail_transaksi": jsonEncode(detailTransaksi),
      "discount": controllerDiscount.text ?? "0",
      "notes": controllerNotes.text,
      "token": token.toString(),
    };

    // printPrettyJson(body);

    http.post(Uri.parse(url), body: body).then((response) => {
          // printPrettyJson(jsonDecode(response.body)),
          if (response.statusCode == 200)
            {
              if (jsonDecode(response.body)['success'])
                {Navigator.pop(context)}
              else
                {
                  showDialog<void>(
                    context: context,
                    barrierDismissible: false, // user must tap button!
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Gagal melakukan transaksi!'),
                        content: Text(jsonDecode(response.body)['message']),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text("OK",
                                style: TextStyle(color: Colors.green)),
                            // color: Colors.lightGreen
                          ),
                        ],
                      );
                    },
                  ),
                }
            }
          else
            {
              showDialog<void>(
                context: context,
                barrierDismissible: false, // user must tap button!
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Gagal melakukan transaksi!'),
                    content: Text("Terjadi kesalahan pada server."),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("OK",
                            style: TextStyle(color: Colors.green)),
                        // color: Colors.lightGreen
                      ),
                    ],
                  );
                },
              ),
            }
        });
  }

  void confirmQty(String id) {
    // if (qty != "") {
    //   setState(() {
    //     controllerQty.text = qty;
    //   });
    // }

    showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Ubah Qty'),
          content: TextField(
            controller: controllerQty,
            decoration: const InputDecoration(
                hintText: "masukkan qty", labelText: "Qty"),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("BATAL",
                  style: TextStyle(color: Colors.lightGreen)),
              // color: Colors.lightGreen
            ),
            TextButton(
              child:
                  const Text('SET QTY', style: TextStyle(color: Colors.green)),
              onPressed: () {
                setQty(id);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void setQty(String id) {
    int index = 0;
    barangTransaksi.forEach((item) {
      if (item['id'] == id.toString()) {
        barangTransaksi[index]['qty'] = controllerQty.text;

        detailTransaksi[index] = Container(
            padding: const EdgeInsets.all(10.0),
            child: Card(
              child: Column(
                children: [
                  const Padding(padding: EdgeInsets.all(15.0)),
                  Text("${barangTransaksi[index]['name'].toString()}"),
                  TextButton(
                      onPressed: () {
                        confirmQty(id);
                      },
                      child: Text("Qty : ${controllerQty.text}"))
                ],
              ),
            ));
      }
      index++;
    });

    setState(() {
      controllerQty.text = "";
    });
  }

  void addBarangTrans(String item_id) {
    var barang = {};

    barangData.forEach((item) {
      if (item['id'].toString() == item_id.toString()) {
        barang = {
          "id": item['id'].toString(),
          "name": item['name'].toString(),
          "price": item['price'].toString(),
        };
      }
    });

    var newData = {
      "id": barang['id'].toString(),
      "name": barang['name'].toString(),
      "qty": "0",
      "price": barang['price'].toString(),
      "notes": "",
    };

    barangTransaksi.add(newData);

    barangTransaksi = barangTransaksi;

    detailTransaksi.add(Container(
        padding: const EdgeInsets.all(10.0),
        child: Card(
          child: Column(
            children: [
              const Padding(padding: EdgeInsets.all(15.0)),
              Text("${barang['name'].toString()}"),
              TextButton(
                  onPressed: () {
                    var id = barang['id'];
                    confirmQty(id);
                  },
                  child: const Text("Qty : 0"))
            ],
          ),
        )));
  }

  @override
  Widget build(BuildContext context) {
    int subTotal = 0;

    barangTransaksi.forEach((item) {
      // subTotal = subTotal + int.parse(item['qty']);
      // subTotal = subTotal + int.parse(item['qty']) * int.parse(item['price']);
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text("Buat Transaksi"),
        backgroundColor: Colors.lightGreen,
      ),
      body: Container(
          padding: const EdgeInsets.all(20.0),
          child: ListView(children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Pilih Barang: ",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const Padding(padding: EdgeInsets.all(10.0)),
                ItemPicker(
                  list: dataBarang,
                  defaultValue: selectedBarang,
                  onSelectionChange: (value) => {
                    addBarangTrans(value),
                    setState(() {
                      selectedBarang = value;
                    })
                  },
                ),
                const Padding(padding: EdgeInsets.all(10.0)),
                const Text(
                  "Barang Transaksi: ",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: detailTransaksi,
                ),
                TextField(
                  controller: controllerDiscount,
                  decoration: const InputDecoration(
                      hintText: "masukkan diskon", labelText: "Diskon"),
                ),
                TextField(
                  controller: controllerNotes,
                  decoration: const InputDecoration(
                      hintText: "masukkan notes", labelText: "Notes"),
                ),
                const Padding(
                  padding: EdgeInsets.all(15.0),
                ),
                Text(
                  "Subtotal: ${subTotal.toString()}",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const Padding(
                  padding: EdgeInsets.all(20.0),
                ),
              ],
            ),
            TextButton(
                onPressed: () {
                  addData();
                },
                child: Text("BUAT TRANSAKSI",
                    style: TextStyle(color: Colors.white)),
                style: TextButton.styleFrom(
                  backgroundColor: Colors.lightGreen,
                )),
          ])),
    );
  }
}
