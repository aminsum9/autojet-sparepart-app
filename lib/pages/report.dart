import 'dart:convert';

import 'package:autojet_sparepart/pages/edittransaksi.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/url.dart' as host;
import '../styles/colors.dart' as colors;
import '../helper/rupiah.dart' as rupiah;

class Report extends StatefulWidget {
  List list;
  int index;
  Report({required this.list, required this.index});
  @override
  ReportState createState() => ReportState();
}

class ReportState extends State<Report> {
  String totalBarangTerjual = "";
  int totalSubtotal = 0;
  int totalDiscount = 0;
  int totalGrandTotal = 0;

  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();

  Future<String> getDataStorage(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key).toString();
  }

  Future<http.Response> postData(Uri url, dynamic body) async {
    final response = await http.post(url, body: body);
    return response;
  }

  void getReport(DateTime startDate, DateTime endDate) async {
    var token = await getDataStorage('token');

    var paramStartDate = "${startDate.toString().split(" ")[0]} 00:00:00";
    var paramEndDate = "${endDate.toString().split(" ")[0]} 23:59:00";

    var body = {
      "start_date": paramStartDate,
      "end_date": paramEndDate,
      "token": token.toString(),
    };

    final response =
        await postData(Uri.parse("${host.BASE_URL}transaksi/report"), body);

    if (response.statusCode != 200) {
      // return [];
    }

    var data = await jsonDecode(response.body);
    // var data = response.body;

    if (data['success'] == true) {
      List<dynamic> resBarangTerjual = data['data']['total_barang_terjual'];

      String listBarangTerjual = "";

      resBarangTerjual.forEach((item) => {
            listBarangTerjual =
                "${listBarangTerjual} - ${item['barang']} :  ${item['qty']}\n"
          });
      totalSubtotal = data['data']['total_subtotal'];
      totalDiscount = data['data']['total_diskon'];
      totalGrandTotal = data['data']['total_grand_total'];

      setState(() {
        totalBarangTerjual = listBarangTerjual;
      });
    } else {
      //
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    var date = DateTime.now();
    var startDateInit = DateTime(date.year, date.month, date.day - 7);

    setState(() {
      startDate = startDateInit;
    });

    getReport(startDateInit, DateTime.now());
  }

  Future<void> selectStartDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: startDate,
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != startDate) {
      setState(() {
        startDate = picked;
      });
      getReport(picked, endDate);
    }
  }

  Future<void> selectEndDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: endDate,
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != endDate) {
      setState(() {
        endDate = picked;
      });
      getReport(startDate, picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Laporan Transaksi",
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
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Container(
              // height: 300.0,
              padding: const EdgeInsets.all(20.0),
              child: Card(
                  child: Center(
                      child: Column(children: [
                const Padding(
                  padding: EdgeInsets.all(15.0),
                ),
                Row(
                  children: [
                    TextButton(
                      onPressed: () {
                        selectStartDate();
                      },
                      child: Card(
                          child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 14, top: 10, right: 14, bottom: 10),
                              child: Text(
                                  "Dari : ${startDate.toString().split(' ')[0]}"))),
                    ),
                    const Text("-"),
                    TextButton(
                        onPressed: () {
                          selectEndDate();
                        },
                        child: Card(
                            child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 14, top: 10, right: 14, bottom: 10),
                                child: Text(
                                    "Sampai : ${endDate.toString().split(' ')[0]}")))),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.all(20.0),
                ),
                const Text(
                  "Total Barang Terjual :",
                  style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
                const Padding(
                  padding: EdgeInsets.all(20.0),
                ),
                Text(
                  "${totalBarangTerjual}",
                  style: const TextStyle(fontSize: 17.0),
                ),
                const Padding(
                  padding: EdgeInsets.all(10.0),
                ),
                const Text(
                  "Total Data Transaksi :",
                  style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
                const Padding(
                  padding: EdgeInsets.all(20.0),
                ),
                Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Center(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              "Total Subtotal        : ${rupiah.toRupiah(int.parse(totalSubtotal.toString()))}",
                              style: const TextStyle(fontSize: 17.0),
                            ),
                            Text(
                              "Totas Diskon          : ${rupiah.toRupiah(int.parse(totalDiscount.toString()))}",
                              style: const TextStyle(fontSize: 17.0),
                            ),
                            Text(
                              "Total(Subtotal-Diskon): ${rupiah.toRupiah(int.parse(totalGrandTotal.toString()))}",
                              style: const TextStyle(fontSize: 17.0),
                            ),
                          ]),
                    )),
                const Padding(
                  padding: EdgeInsets.all(20.0),
                ),
              ]))),
            )));
  }
}
