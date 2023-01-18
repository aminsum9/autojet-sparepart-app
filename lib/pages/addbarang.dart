import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import '../config/url.dart' as globals;

class AddBarang extends StatefulWidget {
  @override
  const AddBarang({super.key});

  AddWarehouseState createState() => AddWarehouseState();
}

class AddWarehouseState extends State<AddBarang> {
  TextEditingController controllerName = TextEditingController(text: "");
  TextEditingController controllerPrice = TextEditingController(text: "");
  TextEditingController controllerDiscount = TextEditingController(text: "");
  TextEditingController controllerStock = TextEditingController(text: "");
  TextEditingController controllerDesc = TextEditingController(text: "");
  //
  String? imageName = "";
  File imageBarang = File("");

  Future<File> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    final imagePath = pickedFile != null ? pickedFile.path : "";

    setState(() {
      imageName = imagePath;
      imageBarang = File(imagePath);
    });
    return File(imagePath);
  }

  Future<String> getDataStorage(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key).toString();
  }

  void addDataBarang() async {
    var token = await getDataStorage('token');

    var url = Uri.parse("${globals.BASE_URL}barang/add");

    var image = imageBarang;

    debugPrint(image.path);

    var request = http.MultipartRequest("POST", url);

    request.fields['name'] = controllerName.text;
    request.fields['price'] = controllerPrice.text.toString();
    request.fields['discount'] = controllerDiscount.text.toString();
    request.fields['qty'] = controllerStock.text.toString();
    request.fields['desc'] = controllerDesc.text;
    request.fields['token'] = token.toString();

    if (image.path != "") {
      request.files.add(await http.MultipartFile.fromPath(
        'image',
        image.path,
      ));
    }

    final response = await request.send();

    final respBody = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      final decodedMap = await json.decode(respBody);

      if (decodedMap['success']) {
        //kadang error karena ditambah pengondisian respnse success
        showDialog<void>(
          context: context,
          barrierDismissible: false, // user must tap button!
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Berhasil menambah barang baru.'),
              // content: Text(jsonDecode(response.toString())['message']),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pushNamed(context, '/home'),
                  child:
                      const Text("OK", style: TextStyle(color: Colors.green)),
                ),
              ],
            );
          },
        );
      } else {
        showDialog<void>(
          context: context,
          barrierDismissible: false, // user must tap button!
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Gagal menambah barang'),
              content: Text(decodedMap['message']),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child:
                      const Text("OK", style: TextStyle(color: Colors.green)),
                )
              ],
            );
          },
        );
      }
    } else {
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
                child: const Text("OK", style: TextStyle(color: Colors.green)),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tambah Barang"),
        backgroundColor: Colors.lightGreen,
      ),
      body: Container(
          padding: const EdgeInsets.all(20.0),
          child: ListView(children: [
            Column(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    imageName != ""
                        ? (Container(
                            width: 100,
                            height: 100,
                            child: ClipRRect(
                                // borderRadius: BorderRadius.circular(100.0),
                                child: Image.file(
                              imageBarang,
                              fit: BoxFit.fill,
                            ))))
                        : (ClipRRect(
                            // borderRadius: BorderRadius.circular(100.0),
                            child: Container(
                              width: 100.0,
                              height: 100.0,
                              child: const Icon(Icons.widgets,
                                  color: Colors.grey, size: 100.0),
                            ),
                          )),
                    imageName == ""
                        ? (TextButton(
                            onPressed: () async {
                              _pickImage();
                            },
                            child: const Text("Pilih gambar")))
                        : (TextButton(
                            onPressed: () async {
                              setState(() {
                                imageName = "";
                                imageBarang = File("");
                              });
                            },
                            child: const Text("Hapus gambar")))
                  ],
                ),
                TextField(
                  controller: controllerName,
                  decoration: const InputDecoration(
                      hintText: "masukkan nama item", labelText: "Nama"),
                ),
                TextField(
                  controller: controllerPrice,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                      hintText: "masukkan harga item", labelText: "Harga"),
                ),
                TextField(
                  controller: controllerDiscount,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                      hintText: "masukkan diskon barang", labelText: "Diskon"),
                ),
                TextField(
                  controller: controllerStock,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                      hintText: "masukkan stock item", labelText: "Qty"),
                ),
                TextField(
                  controller: controllerDesc,
                  decoration: const InputDecoration(
                      hintText: "masukkan code item",
                      labelText: "Deskripsi barang"),
                ),
                const Padding(
                  padding: EdgeInsets.all(20.0),
                ),
              ],
            ),
          ])),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.only(left: 16, right: 16, bottom: 10),
        child: TextButton(
          onPressed: () {
            addDataBarang();
          },
          style: TextButton.styleFrom(
              backgroundColor: Colors.lightGreen,
              padding: const EdgeInsets.all(15)),
          child: const Text("SUBMIT", style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}
