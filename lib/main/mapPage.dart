import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modo_tour/data/tour.dart';
import 'package:http/http.dart' as http;
import 'package:modo_tour/main/tourDetailPage.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../data/lostData.dart';

class MapPage extends StatefulWidget {
  final DatabaseReference? databaseReference;
  final Future<Database>? db;
  final String? id;

  MapPage({this.databaseReference, this.db, this.id});

  @override
  State<StatefulWidget> createState() => _MapPage();
}

class _MapPage extends State<MapPage> {
  List<DropdownMenuItem<Item>> list = List.empty(growable: true);
  List<DropdownMenuItem<Item>> sublist = List.empty(growable: true);
  List<TourData> tourData = List.empty(growable: true);
  ScrollController? _scrollController;

  String authkey = 'X2Yuu3C3jhdMk8hPMxwwdGzeqwm81Trs0V0%2BNT2A6tjtVTp7rkRXBGD4X4uNQPkMl3laQv7tyS89cXnHnlufvg%3D%3D';

  Item? area;
  Item? kind;
  int page = 1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    list = Area().seoulArea;
    sublist = Kind().kinds;

    area = list[0].value;
    kind = sublist[0].value;

    _scrollController = new ScrollController();
    _scrollController!.addListener(() {
      if (_scrollController!.offset >=
          _scrollController!.position.maxScrollExtent &&
          !_scrollController!.position.outOfRange) {
        page++;
        getAreaList(area: area!.value, contentTypeId: kind!.value, page: page);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('검색하기'),
      ),
      body: Container(
        child: Column(
          children: [
            Row(
              children: [
                DropdownButton(items: list, onChanged: (value) {
                  Item selectedItem = value!;
                  setState(() {
                    area = selectedItem;
                  });
                },
                  value: area,
                ),
                SizedBox(
                  width: 10,
                ),
                DropdownButton<Item>(items: sublist, onChanged: (value) {
                  Item selectedItem = value!;
                  setState(() {
                    kind = selectedItem;
                  });
                },
                  value: kind,
                ),
                SizedBox(
                  width: 10,
                ),
                ElevatedButton(onPressed: () {
                  page = 1;
                  tourData.clear();
                  getAreaList(
                      area: area!.value,
                      contentTypeId: kind!.value,
                      page: page);
                }, child: Text('검색하기', style: TextStyle(color: Colors.black),
                ),
                  style: ButtonStyle(backgroundColor: WidgetStateProperty.all(
                      Colors.indigo[200])),
                )
              ],
              mainAxisAlignment: MainAxisAlignment.spaceAround,
            ),
            Expanded(
                child: ListView.builder(
                  itemBuilder: (context, index) {
              return Card(
                child: InkWell(
                  child: Row(
                    children: [
                      Hero(tag: 'tourinfo$index',
                          child: Container(
                        margin: EdgeInsets.all(10),
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: Colors.black, width: 1),
                            image: DecorationImage(fit: BoxFit.fill,
                                image: getImage(tourData[index].imagePath))
                        ),
                      )),
                      SizedBox(
                        width: 20,
                      ),
                      Container(
                        child: Column(
                          children: [
                            Text(tourData[index].title!,
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text('주소 : ${tourData[index].addr1}'),
                            tourData[index].tel != ""
                                ? Text('전화번호 : ${tourData[index].tel}')
                                : Container(),
                          ],
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        ),
                        width: MediaQuery
                            .of(context)
                            .size
                            .width - 150,
                      )
                    ],
                  ),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=> TourDetailPage(
                      id: widget.id,
                      tourData: tourData[index],
                      index: index,
                      databaseReference : widget.databaseReference,
                    )));
                  },
                  onDoubleTap: (){
                    insertTour(widget.db!, tourData[index]);
                  },
                ),
              );
            },
              itemCount: tourData.length,
              controller: _scrollController,
            ))
          ],
          mainAxisAlignment: MainAxisAlignment.start,
        ),
      ),
    );
  }
  ImageProvider getImage(String? imagePath){
    if(imagePath != null){
      return NetworkImage(imagePath);
    }else{
      return AssetImage('repo/images/map_location.png');
    }
  }

  void getAreaList({required int area, required int contentTypeId, required int page})
    async{
      var url = 'http://api.visitkorea.or.kr/openapi/service/rest/KorService/'
              'areaBasedList?ServiceKey=$authkey&MobileOS=AND&MobileApp=ModuTour&'
              '_type=json&numOfRows=10&areaCode=1&sigunguCode=$area&pageNo=$page';
      if(contentTypeId !=0){
        url = url + '&contentTypeId=$contentTypeId';
      }
      var response = await http.get(Uri.parse(url));
      String body = utf8.decode(response.bodyBytes);
      print(body);
      var json = jsonDecode(body);
      if(json['response']['header']['resultCode']=="0000"){
        if(json['response']['body']['items']==''){
          showDialog(
              context: context as BuildContext,
              builder: (context){
            return AlertDialog(
              content: Text('마지막 데이터 입니다.'),
            );
          });
        }else{
          List jsonArray = json['response']['body']['items']['item'];
          for(var s in jsonArray){
            setState(() {
              tourData.add(TourData.fromJson(s));
            });
          }
        }
      }else{
        print('error');
      }
    }
}
  void insertTour(Future<Database> db, TourData info) async{
  final Database database = await db;
  await database
    .insert('place', info.toMap(), conflictAlgorithm: ConflictAlgorithm.replace)
    .then((value){
      ScaffoldMessenger.of(context as BuildContext)
          .showSnackBar(SnackBar(content: Text('즐겨찾기에 추가되었습니다.')));
  });
  }
