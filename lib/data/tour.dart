class TourData{
  String? title;
  String? tel;
  String? zipcode;
  String? addr1;
  var id;
  var mapx;
  var mapy;
  String? imagePath;

  TourData(
    {this.id,
      this.title,
      this.tel,
      this.zipcode,
      this.addr1,
      this.mapx,
      this.mapy,
      this.imagePath,
    });

  TourData.fromJson(Map data)
  : id= data['contentid'],
    title = data['title'],
    tel = data['tel'],
    zipcode = data['zipcode'],
    addr1 = data['addr1'],
    mapx = data['mapx'],
    mapy = data['mapy'],
    imagePath = data['firstimage'];

  Map<String, dynamic> toMap(){
    return{
      'id' : id,
      'title' : title,
      'tel': tel,
      'zipcode' : zipcode,
      'addr1' : addr1,
      'mapx' : mapx,
      'mapy' : mapy,
      'imagePath' : imagePath,
    };
  }
}