import 'package:autojet_sparepart/listbarang.dart';
import 'package:autojet_sparepart/listsupplier.dart';
import 'package:autojet_sparepart/listtransaksi.dart';
import 'package:autojet_sparepart/listuser.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

/// [AnimationController]s can be created with `vsync: this` because of
/// [TickerProviderStateMixin].
class _HomeState extends State<Home> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.lightGreen,
        bottom: TabBar(
          controller: _tabController,
          tabs: const <Widget>[
            Tab(
              icon: Icon(Icons.book),
              child: Text("Transaksi"),
            ),
            Tab(
              icon: Icon(Icons.widgets),
              child: Text("Barang"),
            ),
            Tab(
              icon: Icon(Icons.account_box),
              child: Text("User"),
            ),
            Tab(
              icon: Icon(Icons.factory),
              child: Text("Supplier"),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          ListTransaksi(),
          ListBarang(),
          ListUser(),
          ListSupplier(),
        ],
      ),
    );
  }
}
