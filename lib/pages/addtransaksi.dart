import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pretty_json/pretty_json.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:item_picker/item_picker.dart';
import 'dart:convert';
import '../config/url.dart' as host;
import '../helper/rupiah.dart' as rupiah;

class AddTransaksi extends StatefulWidget {
  @override
  AddDataState createState() => AddDataState();
}

class AddDataState extends State<AddTransaksi> {
  TextEditingController controllerDiscount = TextEditingController(text: "");
  TextEditingController controllerNotes = TextEditingController(text: "");
  TextEditingController controllerQty = TextEditingController(text: "");
  //
  dynamic selectedBarangSrc = {'name': 'Pilih barang...'};
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void handleCreateTransaksi() async {
    var token = await getDataStorage('token');

    var url = "${host.BASE_URL}transaksi/create_transaksi";

    List<dynamic> detailTransaksi = [];

    barangTransaksi.forEach((item) {
      detailTransaksi.add(item);
    });

    var body = {
      "detail_transaksi": jsonEncode(detailTransaksi),
      "discount": controllerDiscount.text ?? "0",
      "notes": controllerNotes.text,
      "token": token.toString(),
    };

    // printPrettyJson(body);

    http.post(Uri.parse(url), body: body).then((response) => {
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
                    content: const Text("Terjadi kesalahan pada server."),
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
                child: ListTile(
              contentPadding: EdgeInsets.all(15.0),
              title: Text(
                "${barangTransaksi[index]['name'].toString()}",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                children: [
                  const Padding(padding: EdgeInsets.all(15.0)),
                  TextButton(
                      onPressed: () {
                        confirmQty(id);
                      },
                      child: Text("Qty : ${controllerQty.text}"))
                ],
              ),
            )));
      }
      index++;
    });

    setState(() {
      controllerQty.text = "";
    });
  }

  void removeItemBarangTrans(id) {
    print(id.toString());

    // int index = 0;
    // int indexDetailTrans = 0;
    // barangTransaksi.forEach((item) {
    //   if (item['id'] == id.toString()) {
    //     indexDetailTrans = index;
    //   }
    //   index++;
    // });

    // barangTransaksi
    //     .removeWhere((item) => item['id'].toString() == id.toString());
    // detailTransaksi.remove(detailTransaksi[indexDetailTrans]);
    // print(barangTransaksi.length.toString());
    // print(detailTransaksi.length.toString());
    // barangTransaksi = barangTransaksi;
    // detailTransaksi = detailTransaksi;
  }

  void addBarangTrans(dynamic item) {
    var barang = {};

    barang = {
      "id": item['id'].toString(),
      "name": item['name'].toString(),
      "price": item['price'].toString(),
    };

    var newData = {
      "id": barang['id'].toString(),
      "name": barang['name'].toString(),
      "qty": "0",
      "price": barang['price'].toString(),
      "notes": "",
    };

    barangTransaksi.add(newData);

    barangTransaksi = barangTransaksi;

    setState(() {
      selectedBarangSrc = item;
    });

    detailTransaksi.add(Container(
        // padding: const EdgeInsets.all(10.0),
        child: Card(
      child: ListTile(
        contentPadding: const EdgeInsets.all(10),
        title: Stack(
          children: [
            Text("${barang['name'].toString()}",
                style: const TextStyle(fontWeight: FontWeight.bold)),
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                width: 30,
                height: 30,
                child: TextButton(
                    onPressed: () => removeItemBarangTrans(barang['id']),
                    child: const Icon(
                      Icons.close,
                      color: Colors.black,
                      size: 15,
                    )),
              ),
            ),
          ],
        ),
        subtitle: Column(
          children: [
            const Padding(padding: EdgeInsets.all(15.0)),
            TextButton(
                onPressed: () {
                  var id = barang['id'];
                  confirmQty(id);
                },
                child: const Text("Qty : 0"))
          ],
        ),
      ),
    )));
  }

  Future<List<dynamic>> getDataBarang(filter) async {
    var token = await getDataStorage('token');

    if (filter == "") {
      return [];
    }

    var body = {
      "page": "1",
      "paging": "10",
      'keyword': filter,
      "token": token.toString()
    };

    final response =
        await postData(Uri.parse("${host.BASE_URL}barang/get_barangs"), body);

    if (response.statusCode != 200) {
      return [];
    }

    var data = await jsonDecode(response.body);

    if (data['success'] == true) {
      return data['data'];
    } else {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    int subTotal = 0;
    int discount = 0;
    // int grandTotal = 0;

    barangTransaksi.forEach((item) {
      subTotal = subTotal + int.parse(item['qty']) * int.parse(item['price']);
    });
    // print(controllerDiscount.text.toString());
    // grandTotal =
    //     subTotal - int.parse(controllerDiscount.text.toString() ?? "0");
    // print(grandTotal.toString());

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
                DropdownSearch(
                  asyncItems: (filter) => getDataBarang(filter),
                  compareFn: (i, s) => i == s,
                  popupProps: PopupPropsMultiSelection.modalBottomSheet(
                    isFilterOnline: true,
                    showSelectedItems: true,
                    showSearchBox: true,
                    selectionWidget: ((context, item, isSelected) =>
                        Text((item as dynamic)['name'])),
                    itemBuilder: itemSearch,
                  ),
                  selectedItem: selectedBarangSrc['name'],
                  onChanged: (value) => {addBarangTrans(value)},
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
                const Padding(padding: EdgeInsets.all(5.0)),
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
                  "Subtotal: ${rupiah.toRupiah(subTotal)}",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                // Text(
                //   "Total: ${grandTotal.toString()}",
                //   style: TextStyle(fontWeight: FontWeight.bold),
                // ),
                const Padding(
                  padding: EdgeInsets.all(20.0),
                ),
              ],
            ),
            TextButton(
              onPressed: () {
                handleCreateTransaksi();
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.lightGreen,
              ),
              child: const Text("BUAT TRANSAKSI",
                  style: TextStyle(color: Colors.white)),
            ),
          ])),
    );
  }

  Widget itemSearch(
    BuildContext context,
    dynamic? item,
    bool isSelected,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: !isSelected
          ? null
          : BoxDecoration(
              border: Border.all(color: Theme.of(context).primaryColor),
              borderRadius: BorderRadius.circular(5),
              color: Colors.white,
            ),
      child: ListTile(
          selected: isSelected,
          title: Text(item['name'] ?? ''),
          subtitle: Text(item['price'].toString()),
          leading: item['image'] != "" && item['image'] != null
              ? Image.network(
                  "${host.BASE_URL}images/barang/${item['image']}",
                  height: 50,
                  width: 50,
                )
              : const Icon(
                  Icons.widgets_rounded,
                  size: 50,
                )),
    );
  }
}
