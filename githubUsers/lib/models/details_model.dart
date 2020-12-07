class DetailsModel {
  String _login;
  String _id;
  String _avatar;
  String _nodeId;
  String _name;
  String _followers;
  String _following;
  String _updated;
  

  DetailsModel(
    this._login,
    this._id,
    this._avatar,
    this._nodeId,
    this._name,
    this._followers,
    this._following,
    this._updated,
  );

  get login => this._login;
  get id =>  this._id;
  get avatar => this._avatar;
  get node_id => this._nodeId;
  get name => this._name;
  get followers => this._followers;
  get following => this._following;
  get updated => this._updated;
  
  String get loginDisplay {
    return login.replaceFirst(login[0], login[0].toUpperCase());
  }

  factory DetailsModel.fromJson(Map<String, dynamic> map) {
    return DetailsModel(
      map['login'],
      map['id'].toString(), 
      map['avatar_url'],
      map['node_id'],
      map['name'],
      map['followers'].toString(),
      map['following'].toString(),
      map['updated_at'].toString(),
    );
  }
}
