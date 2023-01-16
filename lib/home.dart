import 'package:autojet_sparepart/listbarang.dart';
import 'package:autojet_sparepart/listsupplier.dart';
import 'package:autojet_sparepart/listtransaksi.dart';
import 'package:autojet_sparepart/listuser.dart';
import 'package:autojet_sparepart/listwarehouse.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => HomeState();
}

/// [TickerProviderStateMixin].
class HomeState extends State<Home> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    // final state = MyApp.of(context).state;
    return Scaffold(
      appBar: AppBar(
        title: Text("Autojet Sparepart"),
        automaticallyImplyLeading: false,
        actions: <Widget>[
          IconButton(
              icon: const Icon(
                Icons.account_circle,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/account');
              })
        ],
        backgroundColor: Colors.lightGreen,
        bottom: TabBar(
          controller: _tabController,
          tabs: const <Widget>[
            Tab(
              icon: Icon(Icons.book),
              child: Text(
                "Trans.",
                style: TextStyle(fontSize: 11),
              ),
            ),
            Tab(
              icon: Icon(Icons.widgets),
              child: Text("Barang", style: TextStyle(fontSize: 11)),
            ),
            Tab(
              icon: Icon(Icons.warehouse),
              child: Text(
                "Gudang",
                style: TextStyle(fontSize: 11),
              ),
            ),
            Tab(
              icon: Icon(Icons.factory),
              child: Text(
                "Supplier",
                style: TextStyle(fontSize: 11),
              ),
            ),
            Tab(
              icon: Icon(Icons.account_box),
              child: Text(
                "User",
                style: TextStyle(fontSize: 11),
              ),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          ListTransaksi(),
          ListBarang(),
          ListWarehouse(),
          ListSupplier(),
          ListUser(),
        ],
      ),
    );
  }
}
