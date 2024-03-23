import 'dart:async';
import 'dart:convert';
import 'package:autojet_sparepart/models/barang_model.dart';
import 'package:autojet_sparepart/models/detail_trans_model.dart';
import 'package:autojet_sparepart/models/supplier_model.dart';
import 'package:autojet_sparepart/models/trans_model.dart';
import 'package:autojet_sparepart/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'detailtransaksi.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/url.dart' as host;
import '../styles/colors.dart' as colors;

class ListTransaksi extends StatefulWidget {
  const ListTransaksi({super.key});

  @override
  ListTransaksiState createState() => ListTransaksiState();
}

Future<String> getDataStorage(String key) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString(key).toString();
}

Future<http.Response> postData(Uri url, dynamic body) async {
  final response = await http.post(url, body: body);
  return response;
}

class ListTransaksiState extends State<ListTransaksi> {
  List<TransModel> data = [];

  @protected
  @mustCallSuper
  void initState() {
    getData();
  }

  void getData() async {
    List<TransModel> dataTrans = await getDataTransaksi();

    setState(() {
      data = dataTrans;
    });
  }

  Future<List<TransModel>> getDataTransaksi() async {
    var token = await getDataStorage('token');

    var body = {"page": "1", "paging": "10", "token": token.toString()};

    final response = await postData(
        Uri.parse("${host.BASE_URL}transaksi/get_transaksis"), body);

    if (response.statusCode != 200) {
      return [];
    }

    var data = await jsonDecode(response.body);

    List<TransModel> ressData = [];

    if (data['success'] == true) {
      for (var i = 0; i < data['data'].length; i++) {
        var item = data['data'][i];

        List<DetailTransModel> detailTrans = [];

        for (var j = 0; j < item['detail_transaksi'].length; j++) {
          var itemDetailTrans = item['detail_transaksi'][j];

          List<SupplierModel> barangSuppliers = [];

          for (var j = 0;
              j < itemDetailTrans['barang']['suppliers'].length;
              j++) {
            var itemSupplier = itemDetailTrans['barang']['suppliers'][j];

            barangSuppliers.add(SupplierModel(
              id: itemSupplier['id'],
              name: itemSupplier['name'],
              email: itemSupplier['email'],
              image: itemSupplier['image'],
              address: itemSupplier['address'],
              phone: itemSupplier['phone'],
              desc: itemSupplier['desc'],
              createdAt: itemSupplier['created_at'],
              updatedAt: itemSupplier['updated_at'],
            ));
          }

          detailTrans.add(DetailTransModel(
              id: itemDetailTrans['id'],
              transId: itemDetailTrans['trans_id'],
              barangId: itemDetailTrans['barang_id'],
              qty: itemDetailTrans['qty'],
              subtotal: itemDetailTrans['subtotal'],
              discount: itemDetailTrans['discount'],
              grandTotal: itemDetailTrans['grand_total'],
              notes: itemDetailTrans['notes'],
              barang: BarangModel(
                id: itemDetailTrans['barang']['id'],
                name: itemDetailTrans['barang']['name'],
                alias: itemDetailTrans['barang']['alias'],
                image: itemDetailTrans['barang']['image'],
                qty: itemDetailTrans['barang']['qty'],
                price: itemDetailTrans['barang']['price'],
                discount: itemDetailTrans['barang']['discount'],
                desc: itemDetailTrans['barang']['desc'],
                suppliers: barangSuppliers,
                createdAt: itemDetailTrans['barang']['created_at'],
                updatedAt: itemDetailTrans['barang']['updated_at'],
              ),
              createdAt: itemDetailTrans['created_at'],
              updatedAt: itemDetailTrans['updated_at']));
        }

        ressData.add(TransModel(
            id: item['id'],
            trxId: item['trx_id'],
            userId: item['user_id'],
            subtotal: item['subtotal'],
            discount: item['discount'],
            grandTotal: item['grand_total'],
            notes: item['notes'],
            status: item['status'],
            detailTrans: detailTrans,
            createdBy: UserModel(
                id: item['created_by']['id'],
                name: item['created_by']['name'],
                email: item['created_by']['email'],
                image: item['created_by']['image'],
                address: item['created_by']['address'],
                phone: item['created_by']['phone'],
                isVerify: item['created_by']['is_verify'],
                createdAt: item['created_by']['created_at'],
                updatedAt: item['created_by']['updated_at']),
            createdAt: item['created_at'],
            updatedAt: item['updated_at']));
      }

      return ressData;
    } else {
      return ressData;
    }
  }

  Future<void> _handleRefresh() async {
    List<TransModel> dataTrans = await getDataTransaksi();

    setState(() {
      data = dataTrans;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () => Navigator.pushNamed(context, '/add_transaksi'),
            backgroundColor: colors.SECONDARY_COLOR,
            child: const Icon(Icons.add),
          ),
          body: RefreshIndicator(
            onRefresh: () => _handleRefresh(),
            child: ListView.separated(
              padding: const EdgeInsets.all(8),
              itemCount: data.length,
              itemBuilder: (context, index) {
                return ItemTrans(
                    item: data[index],
                    trxStatus: data[index].status as String,
                    trxId: data[index].trxId as String,
                    trxCreatedAt: data[index].createdAt as String,
                    index: index);
              },
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(),
            ),
          ),
        ));
  }
}

// ignore: must_be_immutable
class ItemTrans extends StatelessWidget {
  String trxStatus = '';
  String trxId = '';
  String trxCreatedAt = '';
  TransModel item;
  int index = 0;

  ItemTrans(
      {super.key,
      required this.item,
      required this.trxStatus,
      required this.trxId,
      required this.trxCreatedAt,
      required this.index});

  Color colorStatus = Colors.lightGreen;
  String status = 'baru';

  @override
  Widget build(BuildContext context) {
    //handle status
    switch (trxStatus) {
      case 'new':
        colorStatus = Colors.orange;
        status = 'baru';
        break;
      case 'pending':
        colorStatus = Colors.blue;
        status = 'sedang diproses';
        break;
      case 'finish':
        colorStatus = Colors.lightGreen;
        status = 'selesai';
        break;
      case 'cancel':
        colorStatus = Colors.red;
        status = 'dibatalkan';
        break;
      case 'refund':
        colorStatus = Colors.purple;
        status = 'refund';
        break;
    }

    //handle date
    var now = DateTime.now().toString();
    var date = trxCreatedAt != ''
        ? DateTime.parse(trxCreatedAt.split('T')[0])
        : DateTime.parse(now.split('T')[0]);
    String createdAt = DateFormat('dd MMMM yyy').format(date);

    return SizedBox(
      child: GestureDetector(
        onTap: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) =>
                DetailTransaksi(trans: item, index: index))),
        child: Card(
          child: ListTile(
            title: Row(
              children: [
                Text(
                  trxId,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Card(
                    color: colorStatus,
                    shadowColor: Colors.transparent,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 5, top: 1, right: 5, bottom: 1),
                      child: Text(
                        status,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ))
              ],
            ),
            subtitle: Text('Dibuat tgl. : $createdAt'),
            leading: const Icon(
              Icons.book,
              size: 40,
              color: Colors.blueGrey,
            ),
          ),
        ),
      ),
    );
  }
}
