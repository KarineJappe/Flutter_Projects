import 'package:githubUsers/models/user_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:githubUsers/core/constants.dart';

class UserService{
  final users = 'users';

  Future <List<UserModel>> getUser() async{
    final response = await http.get('$SERVER_URL/$users');

    final responseJson = jsonDecode(response.body) as List<dynamic>;
    
    return (responseJson as List)
    .map((e)=>UserModel.fromJson(e)).toList();

  }
}
