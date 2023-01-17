import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:item_picker/item_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pretty_json/pretty_json.dart';
import '../config/url.dart' as globals;

class EditTransaksi extends StatefulWidget {
  final List list;
  final int index;

  EditTransaksi({required this.list, this.index = 0});
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
      "id": widget.list[widget.index]["id"].toString() ?? "",
      "status": status,
      "subtotal": controllerSubTotal.text.toString(),
      "discount": controllerDiscount.text.toString(),
      "grand_total": controllerTotal.text.toString(),
      "notes": controllerNotes.text.toString(),
      "token": token.toString(),
    };

    var url = "${globals.BASE_URL}transaksi/update";
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
    controllerSubTotal = TextEditingController(
        text: widget.list[widget.index]['subtotal'].toString() ?? "");
    controllerDiscount = TextEditingController(
        text: widget.list[widget.index]['discount'].toString() ?? "");
    controllerTotal = TextEditingController(
        text: widget.list[widget.index]['grand_total'].toString() ?? "");
    controllerNotes =
        TextEditingController(text: widget.list[widget.index]['notes'] ?? "");
    var status = widget.list[widget.index]['status'].toString();

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
    debugPrint(selectedStatus.toString());
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Data Transaksi"),
        backgroundColor: Colors.lightGreen,
      ),
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
                  Text("ID Transaksi : ${widget.list[widget.index]['trx_id']}"),
                  Text(
                      "Dibuat oleh : ${widget.list[widget.index]['created_by']['name']}"),
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
              TextButton(
                  onPressed: () {
                    editDataUser();
                  },
                  child: Text("EDIT", style: TextStyle(color: Colors.white)),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.lightGreen,
                  )),
            ]),
          ))),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:pretty_json/pretty_json.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:item_picker/item_picker.dart';
// import 'dart:convert';
// import 'config/url.dart' as globals;

// class EditTransaksi extends StatefulWidget {
//   final List list;
//   final int index;

//   EditTransaksi({required this.list, this.index = 0});

//   @override
//   EditTransaksiState createState() => EditTransaksiState();
// }

// class EditTransaksiState extends State<EditTransaksi> {
//   TextEditingController controllerDiscount = TextEditingController(text: "");
//   TextEditingController controllerNotes = TextEditingController(text: "");
//   TextEditingController controllerQty = TextEditingController(text: "");
//   //
//   String selectedBarang = "";
//   //
//   List<MapEntry<String, dynamic>> dataBarang = [];
//   List<dynamic> barangData = [];
//   List<Widget> detailTransaksi = [];
//   List<dynamic> barangTransaksi = [];
//   //

//   Future<http.Response> postData(Uri url, dynamic body) async {
//     final response = await http.post(url, body: body);
//     return response;
//   }

//   Future<String> getDataStorage(String key) async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getString(key).toString();
//   }

//   getDataBarang() async {
//     var token = await getDataStorage('token');

//     var body = {"page": "1", "paging": "10", "token": token.toString()};

//     final response = await postData(
//         Uri.parse("${globals.BASE_URL}barang/get_barangs"), body);

//     if (response.statusCode != 200) {
//       return [];
//     }

//     var data = await jsonDecode(response.body);

//     if (data['success'] == true) {
//       List<MapEntry<String, dynamic>> resultBarang = [];

//       data['data'].forEach((dynamic item) =>
//           {resultBarang.add(MapEntry(item['name'], item['id'].toString()))});

//       setState(() {
//         dataBarang = resultBarang;
//         barangData = data['data'];
//       });
//     } else {
//       setState(() {
//         barangData = [];
//         barangData = [];
//       });
//     }
//   }

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     getDataBarang();

//     widget.list[widget.index]['detail_transaksi'].forEach((item) => {
//           addBarangTransEditable(item['id'].toString(),
//               widget.list[widget.index]['detail_transaksi'])
//         });

//     barangTransaksi = widget.list[widget.index]['detail_transaksi'] ?? [];
//     controllerDiscount = TextEditingController(
//         text: widget.list[widget.index]['discount'].toString() ?? "");
//     controllerNotes =
//         TextEditingController(text: widget.list[widget.index]['notes'] ?? "");
//   }

//   void editDataUser() async {
//     var token = await getDataStorage('token');

//     var url = "${globals.BASE_URL}transaksi/update";

//     List<dynamic> detailTransaksi = [];

//     barangTransaksi.forEach((item) {
//       detailTransaksi.add(item);
//     });

//     var body = {
//       "detail_transaksi": jsonEncode(detailTransaksi),
//       "discount": controllerDiscount.text ?? "0",
//       "notes": controllerNotes.text,
//       "token": token.toString(),
//     };

//     // printPrettyJson(body);

//     http.post(Uri.parse(url), body: body).then((response) => {
//           // printPrettyJson(jsonDecode(response.body)),
//           if (response.statusCode == 200)
//             {
//               if (jsonDecode(response.body)['success'])
//                 {Navigator.pop(context)}
//               else
//                 {
//                   showDialog<void>(
//                     context: context,
//                     barrierDismissible: false, // user must tap button!
//                     builder: (BuildContext context) {
//                       return AlertDialog(
//                         title: const Text('Gagal melakukan transaksi!'),
//                         content: Text(jsonDecode(response.body)['message']),
//                         actions: <Widget>[
//                           TextButton(
//                             onPressed: () => Navigator.pop(context),
//                             child: const Text("OK",
//                                 style: TextStyle(color: Colors.green)),
//                             // color: Colors.lightGreen
//                           ),
//                         ],
//                       );
//                     },
//                   ),
//                 }
//             }
//           else
//             {
//               showDialog<void>(
//                 context: context,
//                 barrierDismissible: false, // user must tap button!
//                 builder: (BuildContext context) {
//                   return AlertDialog(
//                     title: const Text('Gagal melakukan transaksi!'),
//                     content: Text("Terjadi kesalahan pada server."),
//                     actions: <Widget>[
//                       TextButton(
//                         onPressed: () => Navigator.pop(context),
//                         child: const Text("OK",
//                             style: TextStyle(color: Colors.green)),
//                         // color: Colors.lightGreen
//                       ),
//                     ],
//                   );
//                 },
//               ),
//             }
//         });
//   }

//   void confirmQty(String id) {
//     // if (qty != "") {
//     //   setState(() {
//     //     controllerQty.text = qty;
//     //   });
//     // }

//     showDialog<void>(
//       context: context,
//       barrierDismissible: false, // user must tap button!
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Ubah Qty'),
//           content: TextField(
//             controller: controllerQty,
//             decoration: const InputDecoration(
//                 hintText: "masukkan qty", labelText: "Qty"),
//           ),
//           actions: <Widget>[
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: const Text("BATAL",
//                   style: TextStyle(color: Colors.lightGreen)),
//               // color: Colors.lightGreen
//             ),
//             TextButton(
//               child:
//                   const Text('SET QTY', style: TextStyle(color: Colors.green)),
//               onPressed: () {
//                 setQty(id);
//                 Navigator.pop(context);
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   void setQty(String id) {
//     int index = 0;
//     barangTransaksi.forEach((item) {
//       if (item['id'] == id.toString()) {
//         barangTransaksi[index]['qty'] = controllerQty.text;

//         detailTransaksi[index] = Container(
//             padding: const EdgeInsets.all(10.0),
//             child: Card(
//                 child: ListTile(
//               contentPadding: EdgeInsets.all(15.0),
//               title: Text(
//                 "${barangTransaksi[index]['name'].toString()}",
//                 style: TextStyle(fontWeight: FontWeight.bold),
//               ),
//               subtitle: Column(
//                 children: [
//                   const Padding(padding: EdgeInsets.all(15.0)),
//                   TextButton(
//                       onPressed: () {
//                         confirmQty(id);
//                       },
//                       child: Text("Qty : ${controllerQty.text}"))
//                 ],
//               ),
//             )));
//       }
//       index++;
//     });

//     setState(() {
//       controllerQty.text = "";
//     });
//   }

//   void addBarangTransEditable(String item_id, List<dynamic> barangData) {
//     var barang = {};

//     barangData.forEach((item) {
//       if (item['id'].toString() == item_id.toString()) {
//         barang = {
//           "id": item['product_id'].toString(),
//           "name": item['name'].toString() ?? "",
//           "qty": item['qty'].toString(),
//           "price": int.parse(item['subtotal'].toString()) /
//               int.parse(item['qty'].toString()),
//         };
//       }
//     });

//     var newData = {
//       "id": barang['id'].toString(),
//       "name": barang['name'].toString(),
//       "qty": barang['qty'].toString(),
//       "price": barang['price'].toString(),
//       "notes": "",
//     };

//     barangTransaksi.add(newData);

//     barangTransaksi = barangTransaksi;

//     detailTransaksi.add(Container(
//         // padding: const EdgeInsets.all(10.0),
//         child: Card(
//       child: ListTile(
//         contentPadding: EdgeInsets.all(15.0),
//         title: Text(
//           "${barang['name'].toString()}",
//           style: TextStyle(fontWeight: FontWeight.bold),
//         ),
//         subtitle: Column(
//           children: [
//             const Padding(padding: EdgeInsets.all(15.0)),
//             TextButton(
//                 onPressed: () {
//                   var id = barang['id'];
//                   confirmQty(id);
//                 },
//                 child: const Text("Qty : 0"))
//           ],
//         ),
//       ),
//     )));
//   }

//   void addBarangTrans(String item_id) {
//     var barang = {};

//     barangData.forEach((item) {
//       if (item['id'].toString() == item_id.toString()) {
//         barang = {
//           "id": item['id'].toString(),
//           "name": item['name'].toString(),
//           "price": item['price'].toString(),
//         };
//       }
//     });

//     var newData = {
//       "id": barang['id'].toString(),
//       "name": barang['name'].toString(),
//       "qty": "0",
//       "price": barang['price'].toString(),
//       "notes": "",
//     };

//     barangTransaksi.add(newData);

//     barangTransaksi = barangTransaksi;

//     detailTransaksi.add(Container(
//         // padding: const EdgeInsets.all(10.0),
//         child: Card(
//       child: ListTile(
//         contentPadding: EdgeInsets.all(15.0),
//         title: Text(
//           "${barang['name'].toString()}",
//           style: TextStyle(fontWeight: FontWeight.bold),
//         ),
//         subtitle: Column(
//           children: [
//             const Padding(padding: EdgeInsets.all(15.0)),
//             TextButton(
//                 onPressed: () {
//                   var id = barang['id'];
//                   confirmQty(id);
//                 },
//                 child: const Text("Qty : 0"))
//           ],
//         ),
//       ),
//     )));
//   }

//   @override
//   Widget build(BuildContext context) {
//     int subTotal = 0;

//     barangTransaksi.forEach((item) {
//       // subTotal = subTotal + int.parse(item['qty']);
//       // subTotal = subTotal + int.parse(item['qty']) * int.parse(item['price']);
//     });

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Edit Transaksi"),
//         backgroundColor: Colors.lightGreen,
//       ),
//       body: Container(
//           padding: const EdgeInsets.all(20.0),
//           child: ListView(children: [
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text(
//                   "Pilih Barang: ",
//                   style: TextStyle(fontWeight: FontWeight.bold),
//                 ),
//                 const Padding(padding: EdgeInsets.all(10.0)),
//                 ItemPicker(
//                   list: dataBarang,
//                   defaultValue: selectedBarang,
//                   onSelectionChange: (value) => {
//                     addBarangTrans(value),
//                     setState(() {
//                       selectedBarang = value;
//                     })
//                   },
//                 ),
//                 const Padding(padding: EdgeInsets.all(10.0)),
//                 const Text(
//                   "Barang Transaksi: ",
//                   style: TextStyle(fontWeight: FontWeight.bold),
//                 ),
//                 const Padding(padding: EdgeInsets.all(5.0)),
//                 Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: detailTransaksi,
//                 ),
//                 TextField(
//                   controller: controllerDiscount,
//                   decoration: const InputDecoration(
//                       hintText: "masukkan diskon", labelText: "Diskon"),
//                 ),
//                 TextField(
//                   controller: controllerNotes,
//                   decoration: const InputDecoration(
//                       hintText: "masukkan notes", labelText: "Notes"),
//                 ),
//                 const Padding(
//                   padding: EdgeInsets.all(15.0),
//                 ),
//                 Text(
//                   "Subtotal: ${subTotal.toString()}",
//                   style: TextStyle(fontWeight: FontWeight.bold),
//                 ),
//                 const Padding(
//                   padding: EdgeInsets.all(20.0),
//                 ),
//               ],
//             ),
//             TextButton(
//                 onPressed: () {
//                   editDataUser();
//                 },
//                 child: Text("BUAT TRANSAKSI",
//                     style: TextStyle(color: Colors.white)),
//                 style: TextButton.styleFrom(
//                   backgroundColor: Colors.lightGreen,
//                 )),
//           ])),
//     );
//   }
// }
