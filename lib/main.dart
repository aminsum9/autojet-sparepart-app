import 'package:flutter/material.dart';
import 'listbarang.dart';
import './login.dart';
import './register.dart';
//home
import './home.dart';
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

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(routes: {
      '/': (context) => LoginPage(),
      '/home': (context) => Home(),
      '/listbarng': (context) => ListBarang(),
      '/login': (context) => LoginPage(),
      '/register': (context) => Register(),
      '/add_barang': (context) => AddBarang(),
      '/detail_barang': (context) => DetailBarang(list: [], index: 0),
      '/edit_barang': (context) => EditBarang(list: [], index: 0),
      '/list_user': (context) => ListUser(),
      '/add_user': (context) => AddUser(),
      '/detail_user': (context) => DetailUser(list: [], index: 0),
      '/edit_user': (context) => EditUser(list: [], index: 0),
    });
    // debugShowCheckedModeBanner: false,
    // title: 'Login Animation Tutorial',
    // home: LoginPage());
  }
}
