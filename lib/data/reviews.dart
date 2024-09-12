import 'package:firebase_database/firebase_database.dart';

class Review{
  String id;
  String review;
  String createTime;

  Review(this.id, this.review, this.createTime);

  Review.fromJson(Map<String, dynamic> json)
  : id = json['id'],
    review = json['review'],
    createTime = json['createTime'];

  toJson(){
    return{
      'id' : id,
      'review' : review,
      'createTime' : createTime,
    };


  }
}

