import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:modo_tour/firebase_options.dart';
import 'package:modo_tour/mainPage.dart';
import 'package:modo_tour/signPage.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'firebase_options.dart';
import 'login.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Future<Database> initDatabase() async{
    return openDatabase(
      join(await getDatabasesPath(), 'tour_database.db'),
      onCreate: (db, version){
        return db.execute(
          "CREATE TABLE place(id INTEGER PRIMARY KEY AUTOINCREMENT, "
              "title TEXT, tel TEXT, zipcode TEXT, addr1 TEXT, mapx Number,"
              "mapy Number, imagePath TEXT)",
        );
      },
      version: 1,
    );
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Future<Database> database = initDatabase();
    return MaterialApp(
        title: '모두의 여행',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) =>LoginPage(),
          '/sign' : (context) =>SignPage(),
          '/main' : (context) => MainPage(database),
        }
    );
  }
}