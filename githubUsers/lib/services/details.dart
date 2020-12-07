import 'package:githubUsers/models/details_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:githubUsers/core/constants.dart';

class DetailService{
  final users = 'users';

  Future <DetailsModel> getUser(String login) async{
    final response = await http.get('$SERVER_URL/$users/$login');

    final responseJson = jsonDecode(response.body);
    
    return DetailsModel.fromJson(responseJson);

  }
}
