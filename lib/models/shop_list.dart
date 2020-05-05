
class ShopList {
  
  int _id;
  String _title;
  int _dateCreated; // Eventually change this to DateTime obj

  ShopList(this._title, this._dateCreated);
  ShopList.withId(this._id, this._title, this._dateCreated);

  int get id => this._id;
  String get title => this._title;
  int get dateCreated => this._dateCreated;

  set title(String newTitle) {
    if(newTitle.length <= 255) {
      this._title = newTitle;
    }
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();

    if(_id != null) {
      map['id'] = _id;
    }

    map['title'] = _title;
    map['dateCreated'] = _dateCreated;  // Convert to DateTime obj when optimised

    return map;
  }

  ShopList.fromMapObj(Map<String, dynamic> map) {
    this._id = map['id'];
    this._title = map['title'];
    this._dateCreated = map['dateCreated']; // Covert from DateTime obj when optimised
  }

}