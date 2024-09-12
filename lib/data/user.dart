class User{
  String id;
  String pw;
  String createTime;



  User(this.id, this.pw, this.createTime);

  User.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        pw = json['pw'],
        createTime = json['createTime'];





  toJson(){
    return{
      'id': id,
      'pw': pw,
      'createTime' : createTime,
    };
  }
}


