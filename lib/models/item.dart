
class Item {

  int _id;
  String _name;
  int _timeout;
  bool _favourite;
  int _listId;

  Item(this._name, this._favourite, this._listId, [this._timeout]);

  Item.withId(this._id, this._name, this._favourite, this._listId, [this._timeout]);

  int get id => _id;
  String get name => _name;
  int get timeout => _timeout;
  bool get favorite => _favourite;
  int get listId => _listId;

  set name(String newName) {
    if(newName.length <= 255) {
      this._name = newName;
    }
  }

  set timeout(int newTimeout) {
    if(newTimeout <= 5184000) { // 2 month timeout max
      this._timeout = newTimeout;
    }
  }

  set favourite(bool newFav) {
    this._favourite = newFav;
  }

  set listId(int newListId) {
    this._listId = newListId;
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();

    if(_id != null) {
      map['id'] = _id;
    }

    map['name'] = _name;
    map['timeout'] = _timeout;
    map['favourite'] = (_favourite == true ? 1 : 0);
    map['list_id'] = _listId;

    return map;
  }

  Item.fromMapObj(Map<String, dynamic> map) {
    this._id = map['id'];
    this._name = map['name'];
    this._timeout = map['timeout'];
    this._favourite = (map['favourite'] == 1);
    this._listId = map['list_id'];
  }

  Item.copy(Item input) {
    this._id = input._id;
    this._name = input._name;
    this._timeout = input._timeout;
    this._favourite = input._favourite;
    this._listId = input._listId;
  }
}