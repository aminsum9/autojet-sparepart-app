import 'package:autojet_sparepart/detailsupplier.dart';
import 'package:autojet_sparepart/listtransaksi.dart';
import 'package:flutter/material.dart';
import 'listbarang.dart';
import './login.dart';
import './register.dart';
//home
import './home.dart';
import './account.dart';
//
import './addtransaksi.dart';
import './detailtransaksi.dart';
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
import './detailsupplier.dart';

class AppRouter extends InheritedWidget {
  final Color color;

  AppRouter({
    super.key,
    required this.color,
    required Widget child,
  }) : super(child: child);

  @override
  bool updateShouldNotify(AppRouter oldWidget) {
    return color != Colors.lightGreen;
  }

  static AppRouter? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AppRouter>();
  }
}

class RouterApp extends StatefulWidget {
  const RouterApp({super.key});

  @override
  RouterState createState() => RouterState();
}

class RouterState extends State<RouterApp> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return AppRouter(
        color: Colors.lightGreen,
        child: MaterialApp(
            home: LoginPage(),
            debugShowCheckedModeBanner: false,
            routes: {
              '/login': (context) => LoginPage(),
              '/register': (context) => Register(),
              '/home': (context) => Home(),
              '/account': (context) => Account(),
              //transaksi
              '/list_transaksi': (context) => ListTransaksi(),
              '/detail_transaksi': (context) =>
                  DetailTransaksi(list: [], index: 0),
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
              '/detail_supplier': (context) =>
                  DetailSupplier(list: [], index: 0),
            }));
  }
}
