class UserModel {
  final String login;
  final String id;

  String get loginDisplay {
    return login.replaceFirst(login[0], login[0].toUpperCase());
  }
  get idUser => this.id;

    const UserModel({
      this.login,
      this.id

    });

Map<String, dynamic> toJson() {
    return {
      'login': login,
      'id': id,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return UserModel(
      login: map['login'],
      id: map['id'].toString(),
    );
  }
}
