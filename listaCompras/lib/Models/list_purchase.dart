class Purchase {
  int _id;
  String _name;
  String _date;

  Purchase(this._name);
  Purchase.empty();

  int get id => _id;
  String get name => _name;
  String get date => _date;

  set name(String newName) {
    if (newName.length <= 255) {
      this._name = newName;
    }
  }

  set date(String newDate) {
    this._date = newDate;
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = _id;
    }
    map['name'] = _name;
    map['date'] = _date;

    return map;
  }

  Purchase.fromMapObject(Map<String, dynamic> map) {
    this._id = map['id'];
    this._name = map['name'];
    this._date = map['date'];
  }
}