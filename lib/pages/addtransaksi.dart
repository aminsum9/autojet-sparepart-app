import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:item_picker/item_picker.dart';
import 'dart:convert';
import '../config/url.dart' as host;
import '../helper/rupiah.dart' as rupiah;
import '../styles/colors.dart' as colors;

class AddTransaksi extends StatefulWidget {
  AddTransaksi({super.key});

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

    for (var item in barangTransaksi) {
      detailTransaksi.add(item);
    }

    var body = {
      "detail_transaksi": jsonEncode(detailTransaksi),
      "discount": controllerDiscount.text,
      "notes": controllerNotes.text,
      "token": token.toString(),
    };

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
                      ),
                    ],
                  );
                },
              ),
            }
        });
  }

  void confirmQty(String id) {
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
              onPressed: () =>
                  {removeItemBarangTrans(id), Navigator.pop(context)},
              child: const Text("Hapus", style: TextStyle(color: Colors.red)),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Batal", style: TextStyle(color: Colors.black)),
            ),
            TextButton(
              child:
                  const Text('Set Qty', style: TextStyle(color: Colors.green)),
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

    for (var item in barangTransaksi) {
      if (item['id'] == id.toString()) {
        barangTransaksi[index]['qty'] = controllerQty.text;
      }
      index++;
    }

    setState(() {
      controllerQty.text = "";
    });
  }

  void removeItemBarangTrans(id) {
    barangTransaksi
        .removeWhere((item) => item['id'].toString() == id.toString());

    setState(() {
      barangTransaksi = barangTransaksi;
    });
  }

  void addBarangTrans(dynamic item) {
    var newData = {
      "id": item['id'].toString(),
      "name": item['name'].toString(),
      "image": item['image'] != null ? item['image'].toString() : "",
      "qty": "0",
      "price": item['price'].toString(),
      "notes": "",
    };

    barangTransaksi.add(newData);

    setState(() {
      barangTransaksi = barangTransaksi;
    });

    setState(() {
      selectedBarangSrc = item;
    });
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
    // int discount = 0;
    // int grandTotal = 0;

    barangTransaksi.forEach((item) => {
          subTotal = subTotal +
              int.parse(item['qty'].toString()) *
                  int.parse(item['price'].toString())
        });
    // grandTotal =
    //     subTotal - int.parse(controllerDiscount.text.toString() ?? "0");

    return Scaffold(
        appBar: AppBar(
          title: const Text("Buat Transaksi",
              style: TextStyle(color: colors.SECONDARY_COLOR)),
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: colors.SECONDARY_COLOR),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          shadowColor: Colors.transparent,
        ),
        backgroundColor: Colors.white,
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
                  barangTransaksi.isNotEmpty
                      ? ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: barangTransaksi.length,
                          itemBuilder: (BuildContext context, int index) {
                            return ListTile(
                              title: Text(barangTransaksi[index]['name']),
                              subtitle: Text(
                                  "Qty : " + barangTransaksi[index]['qty']),
                              leading: barangTransaksi[index]['image'] != "" &&
                                      barangTransaksi[index]['image'] != null
                                  ? Image.network(
                                      host.BASE_URL_IMAGE +
                                          'images/barang/' +
                                          barangTransaksi[index]['image'],
                                      height: 50,
                                      width: 50,
                                    )
                                  : const Icon(
                                      Icons.widgets,
                                      size: 50,
                                    ),
                              onTap: () {
                                confirmQty(barangTransaksi[index]['id']);
                              },
                            );
                          },
                        )
                      : Container(
                          child: const Center(
                          child: Padding(
                            padding: EdgeInsets.all(30),
                            child: Text(
                              "Anda belum memilih barang.",
                              style:
                                  TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ),
                        )),
                  const Padding(
                    padding: EdgeInsets.all(15.0),
                  ),
                  TextField(
                    keyboardType: TextInputType.number,
                    controller: controllerDiscount,
                    decoration: InputDecoration(
                        hintText: "masukkan diskon",
                        labelText: "Diskon",
                        border: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: colors.PRIMARY_COLOR,
                              width: 10.0,
                            ),
                            borderRadius: BorderRadius.circular(5.0))),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(5.0),
                  ),
                  TextField(
                    controller: controllerNotes,
                    decoration: InputDecoration(
                        hintText: "tambah notes",
                        labelText: "Notes",
                        border: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: colors.PRIMARY_COLOR),
                            borderRadius: BorderRadius.circular(5.0))),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(15.0),
                  ),
                  Text(
                    "Subtotal  : ${rupiah.toRupiah(subTotal)}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(5.0),
                  ),
                  Text(
                    "Total        : ${rupiah.toRupiah(subTotal)}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(20.0),
                  ),
                ],
              ),
            ])),
        bottomNavigationBar: Container(
          padding: const EdgeInsets.all(10),
          child: TextButton(
            onPressed: () {
              handleCreateTransaksi();
            },
            style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                backgroundColor: colors.SECONDARY_COLOR,
                padding: const EdgeInsets.all(15)),
            child: const Text("BUAT TRANSAKSI",
                style: TextStyle(color: Colors.white)),
          ),
        ));
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
                  "${host.BASE_URL_IMAGE}images/barang/${item['image']}",
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
