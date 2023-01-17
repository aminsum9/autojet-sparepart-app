import 'package:flutter/material.dart';
//
import 'pages/splash.dart';
import 'pages/login.dart';
import 'pages/register.dart';
//home
import 'pages/home.dart';
import 'pages/account.dart';
import 'pages/report.dart';
//
import 'pages/addtransaksi.dart';
import 'pages/detailtransaksi.dart';
import 'pages/listtransaksi.dart';
import 'pages/edittransaksi.dart';
//barang
import 'pages/listbarang.dart';
import 'pages/addbarang.dart';
import 'pages/detailbarang.dart';
import 'pages/editbarang.dart';
//user
import 'pages/listuser.dart';
import 'pages/adduser.dart';
import 'pages/detailuser.dart';
import 'pages/edituser.dart';
//supplier
import 'pages/addsupplier.dart';
import 'pages/listsupplier.dart';
import 'pages/detailsupplier.dart';
import 'pages/editsupplier.dart';
//warehouse
import 'pages/listwarehouse.dart';
import 'pages/addwarehouse.dart';
import 'pages/detailwarehouse.dart';
import 'pages/editwarehouse.dart';

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
            home: Splash(),
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              brightness: Brightness.light,
              // add tabBarTheme
              tabBarTheme: const TabBarTheme(
                  labelColor: Colors.white,
                  labelStyle: TextStyle(color: Colors.white), // color for text
                  indicator: UnderlineTabIndicator(
                      // color for indicator (underline)
                      borderSide: BorderSide(color: Colors.white))),
              primaryColor:
                  Colors.lightGreen, // outdated and has no effect to Tabbar
            ),
            routes: {
              '/login': (context) => LoginPage(),
              '/register': (context) => Register(),
              '/home': (context) => Home(),
              '/account': (context) => Account(),
              '/report': (context) => Report(list: [], index: 0),
              //transaksi
              '/list_transaksi': (context) => ListTransaksi(),
              '/detail_transaksi': (context) =>
                  DetailTransaksi(list: [], index: 0),
              '/add_transaksi': (context) => AddTransaksi(),
              '/edit_transaksi': (context) => EditTransaksi(list: [], index: 0),
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
              '/add_supplier': (context) => AddSupplier(),
              '/detail_supplier': (context) =>
                  DetailSupplier(list: [], index: 0),
              '/edit_supplier': (context) => EditSupplier(list: [], index: 0),
              //warehouse
              '/list_warehouse': (context) => ListWarehouse(),
              '/add_warehouse': (context) => AddWarehouse(),
              '/detail_warehouse': (context) =>
                  DetailWarehouse(list: [], index: 0),
              '/edit_warehouse': (context) => EditWarehouse(list: [], index: 0),
            }));
  }
}
