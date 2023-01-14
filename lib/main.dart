import 'package:autojet_sparepart/listtransaksi.dart';
import 'package:flutter/material.dart';
import 'listbarang.dart';
import './login.dart';
import './register.dart';
//home
import './home.dart';
//
import './addtransaksi.dart';
import './listtransaksi.dart';
//barang
import './listbarang.dart';
import './addbarang.dart';
import './detailbarang.dart';
import './editbarang.dart';
//user
import './listuser.dart';
import './adduser.dart';
import './detailuser.dart';
import './edituser.dart';
//supplier
import './listsupplier.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, routes: {
      '/': (context) => LoginPage(),
      '/login': (context) => LoginPage(),
      '/register': (context) => Register(),
      '/home': (context) => Home(),
      //transaksi
      '/list_transaksi': (context) => ListTransaksi(),
      '/add_transaksi': (context) => AddTransaksi(),
      //barang
      '/list_barang': (context) => ListBarang(),
      '/detail_barang': (context) => DetailBarang(list: [], index: 0),
      '/add_barang': (context) => AddBarang(),
      '/edit_barang': (context) => EditBarang(list: [], index: 0),
      //user
      '/list_user': (context) => ListUser(),
      '/detail_user': (context) => DetailUser(list: [], index: 0),
      '/add_user': (context) => AddUser(),
      '/edit_user': (context) => EditUser(list: [], index: 0),
      //
      '/list_supplier': (context) => ListSupplier(),
    });
  }
}
