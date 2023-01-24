import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config/url.dart' as host;
import '../styles/colors.dart' as colors;

class AddSupplier extends StatefulWidget {
  @override
  AddSupplierState createState() => AddSupplierState();
}

class AddSupplierState extends State<AddSupplier> {
  TextEditingController controllerName = TextEditingController(text: "");
  TextEditingController controllerEmail = TextEditingController(text: "");
  TextEditingController controllerPhone = TextEditingController(text: "");
  TextEditingController controllerAddress = TextEditingController(text: "");
  TextEditingController controllerDesc = TextEditingController(text: "");

  Future<String> getDataStorage(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key).toString();
  }

  void addData() async {
    var token = await getDataStorage('token');

    var url = "${host.BASE_URL}supplier/add";

    http.post(Uri.parse(url), body: {
      "name": controllerName.text,
      "email": controllerEmail.text,
      "phone": controllerPhone.text,
      "address": controllerAddress.text,
      "image": "",
      "desc": controllerDesc.text,
      "token": token.toString(),
    }).then((response) => {
          if (response.statusCode == 200) {Navigator.pop(context, true)}
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Tambah Supplier",
          style: TextStyle(color: colors.SECONDARY_COLOR),
        ),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: colors.SECONDARY_COLOR),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        shadowColor: Colors.transparent,
      ),
      body: Container(
          padding: const EdgeInsets.all(20.0),
          child: ListView(children: [
            Column(
              children: [
                TextField(
                  controller: controllerName,
                  decoration: const InputDecoration(
                      hintText: "masukkan nama item", labelText: "Nama"),
                ),
                TextField(
                  controller: controllerEmail,
                  decoration: const InputDecoration(
                      hintText: "masukkan email user baru", labelText: "Email"),
                ),
                TextField(
                  controller: controllerPhone,
                  decoration: const InputDecoration(
                      hintText: "masukkan No. Telp. user baru",
                      labelText: "No. Telepon"),
                ),
                TextField(
                  controller: controllerAddress,
                  decoration: const InputDecoration(
                      hintText: "masukkan alamat", labelText: "Alamat"),
                ),
                TextField(
                  controller: controllerDesc,
                  decoration: const InputDecoration(
                      hintText: "masukkan deskripsi", labelText: "Deskripsi"),
                ),
                const Padding(
                  padding: EdgeInsets.all(20.0),
                ),
              ],
            ),
          ])),
      bottomNavigationBar: Container(
          child: Padding(
        padding: const EdgeInsets.all(10),
        child: TextButton(
          onPressed: () {
            addData();
          },
          style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              backgroundColor: colors.PRIMARY_COLOR,
              padding: const EdgeInsets.all(15)),
          child: const Text("SUBMIT", style: TextStyle(color: Colors.white)),
        ),
      )),
    );
  }
}
