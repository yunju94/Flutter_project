import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modo_tour/main/favoritePage.dart';
import 'package:modo_tour/main/mapPage.dart';
import 'package:modo_tour/main/settingPage.dart';
import 'package:sqflite/sqflite.dart';

class MainPage extends StatefulWidget {
  final Future<Database> database;
  MainPage(this.database);

  @override
  State<MainPage> createState() => _MainPage();
}

class _MainPage extends State<MainPage> with SingleTickerProviderStateMixin{
  TabController? controller;
  FirebaseDatabase? _database;
  DatabaseReference? reference;
  String _databaseURL = 'https://reactchat-8ebc9-default-rtdb.firebaseio.com/';
  String? id;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    controller = TabController(length: 3, vsync: this);
    _database = FirebaseDatabase.instanceFor(app: Firebase.app(), databaseURL : _databaseURL);
    reference = _database!.ref();

  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    id = ModalRoute.of(context)!.settings.arguments as String?;
    return Scaffold(
      body: TabBarView(children: [
        MapPage(
          databaseReference: reference,
          db: widget.database,
          id: id,
        ),
        FavoritePage(
          databaseReference: reference,
          db: widget.database,
          id: id,
        ),
        SettingPage(),
      ],
      controller: controller,
      ),
      bottomNavigationBar: TabBar(tabs: [
        Tab(
          icon: Icon(Icons.map),
        ),
        Tab(
        icon: Icon(Icons.star),
        ),
        Tab(
          icon: Icon(Icons.settings),
        ),
      ],
      labelColor: Colors.amberAccent,
      indicatorColor: Colors.deepOrangeAccent,
      controller: controller,),
    );
  }
}
