import 'package:firebase_database/firebase_database.dart';

class DisableInfo{
  String? key;
  int? disable1;
  int? disable2;
  String? id;
  String? createTime;

  DisableInfo(this.id, this.disable1, this.disable2, this.createTime);

  DisableInfo.fromSnapshot(DataSnapshot snapshot, Map<String, dynamic> json)
  : key = snapshot.key,
    id = json['id'],
    disable1 = json['disable1'],
    disable2 = json['disable2'],
    createTime = json['createTime'];

  toJson(){
    return{
      'id' : id,
      'disable1' : disable1,
      'disable2' : disable2,
      'createTime' : createTime,
    };
  }

}
