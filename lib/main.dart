import 'package:flutter/material.dart';
import './home.dart';
import './login.dart';
//barang
import './addbarang.dart';
import './detailbarang.dart';
import './editbarang.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(routes: {
      '/': (context) => LoginPage(),
      '/home': (context) => Home(),
      '/login': (context) => LoginPage(),
      '/add_barang': (context) => AddBarang(),
      '/detail_barang': (context) => DetailBarang(list: [], index: 0),
      '/edit_barang': (context) => EditBarang(list: [], index: 0),
    });
    // debugShowCheckedModeBanner: false,
    // title: 'Login Animation Tutorial',
    // home: LoginPage());
  }
}
