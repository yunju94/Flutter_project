import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'data/user.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  FirebaseDatabase? _database;
  DatabaseReference? reference;
  String _databaseURL = 'https://reactchat-8ebc9-default-rtdb.firebaseio.com/';

  double opacity = 0;
  AnimationController? _animationController;
  Animation? _animation;
  TextEditingController? _idTextController;
  TextEditingController? _pwTextController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _idTextController = TextEditingController();
    _pwTextController = TextEditingController();

    _animationController =
        AnimationController(duration: Duration(seconds: 3), vsync: this);
    _animation =
        Tween<double>(begin: 0, end: pi * 2).animate(_animationController!);
    _animationController!.repeat();

    Timer(Duration(seconds: 2), () {
      setState(() {
        opacity = 1;
      });
    });
    _database = FirebaseDatabase.instanceFor(
        app: Firebase.app(), databaseURL: _databaseURL);
    reference = _database?.ref().child('user');
  }

  @override
  void dispose() {
    _animationController!.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Column(
            children: [
              AnimatedBuilder(
                animation: _animationController!,
                builder: (context, widget) {
                  return Transform.rotate(
                    angle: _animation!.value,
                    child: widget,
                  );
                },
                child: Icon(
                  Icons.airplanemode_active,
                  color: Colors.deepPurpleAccent,
                  size: 80,
                ),
              ),
              SizedBox(
                height: 100,
                child: Center(
                  child: Text('더조은 여행', style: TextStyle(fontSize: 30)),
                ),
              ),
              AnimatedOpacity(
                opacity: opacity,
                duration: Duration(seconds: 1),
                child: Column(
                  children: [
                    SizedBox(
                      width: 200,
                      child: TextField(
                        controller: _idTextController,
                        maxLines: 1,
                        decoration: InputDecoration(
                            labelText: '아이디', border: OutlineInputBorder()),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: 200,
                      child: TextField(
                        controller: _pwTextController,
                        obscureText: true,
                        maxLines: 1,
                        decoration: InputDecoration(
                            labelText: '비밀번호', border: OutlineInputBorder()),
                      ),
                    ),
                    Row(
                      children: [
                        TextButton(
                            onPressed: () {
                              Navigator.of(context).pushNamed('/sign');
                            },
                            child: Text('회원가입')),
                        TextButton(
                            onPressed: () {
                              if (_idTextController!.value.text.length == 0 ||
                                  _pwTextController!.value.text.length == 0) {
                                makeDialog('빈칸이 있습니다.');
                              } else {
                                reference!
                                    .child(_idTextController!.value.text)
                                    .onValue
                                    .listen((event) {
                                  if (event.snapshot.value == null) {
                                    makeDialog("아이디가 없습니다.");
                                  } else {
                                    reference!
                                        .child(_idTextController!.value.text)
                                        .onChildAdded
                                        .listen((event) {
                                      print(event.snapshot);

                                      // Map<Object?, Object?> 타입을 Map<String, dynamic>으로 변환
                                      Map<dynamic, dynamic> rawData = event
                                          .snapshot
                                          .value as Map<dynamic, dynamic>;

                                      // Map<dynamic, dynamic>을 Map<String, dynamic>으로 변환
                                      Map<String, dynamic> data = rawData.map(
                                          (key, value) => MapEntry(
                                              key.toString(),
                                              value as dynamic));

                                      // User 객체로 변환
                                      User user = User.fromJson(data);
                                      var bytes = utf8.encode(
                                          _pwTextController!.value.text);
                                      var digest = sha1.convert(bytes);
                                      if (user.pw == digest.toString()) {
                                        Navigator.of(context)
                                            .pushReplacementNamed('/main',
                                                arguments: _idTextController!
                                                    .value.text);
                                      } else {
                                        makeDialog('비밀번호가 틀립니다.');
                                      }
                                    });
                                  }
                                });
                              }
                            },
                            child: Text('로그인'))
                      ],
                      mainAxisAlignment: MainAxisAlignment.center,
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void makingDialog(String text) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text(text),
          );
        });
  }

  void makeDialog(String text) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text(text),
          );
        });
  }
}
