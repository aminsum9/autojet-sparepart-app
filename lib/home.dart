import 'package:autojet_sparepart/listbarang.dart';
import 'package:autojet_sparepart/listuser.dart';
import 'package:flutter/material.dart';
// import './listbarang.dart';
// import './listuser.dart';

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
    _tabController = TabController(length: 2, vsync: this);
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
              icon: Icon(Icons.widgets),
              child: Text("Daftar Barang"),
            ),
            Tab(
              icon: Icon(Icons.account_box),
              child: Text("Daftar User"),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          ListBarang(),
          ListUser(),
        ],
      ),
    );
  }
}
