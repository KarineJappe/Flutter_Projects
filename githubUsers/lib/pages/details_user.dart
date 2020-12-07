import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:githubUsers/models/details_model.dart';
import 'package:githubUsers/models/user_model.dart';
import 'package:githubUsers/services/details.dart';
import 'package:transparent_image/transparent_image.dart';

class DetailsPage extends StatefulWidget {
  final UserModel state;

  DetailsPage(this.state);

  @override
  _StatePageState createState() => _StatePageState(this.state);
}

class _StatePageState extends State<DetailsPage> {
  UserModel state;
  DetailsModel stateDetail;
  DetailService stateService;
  bool isLoading = true;

  _StatePageState(this.state);

  @override
  void initState() {
    super.initState();
    stateService = DetailService();
    getStateDetail();
  }

  void getStateDetail() async {
    setState(() {
      isLoading = true;
    });

    DetailsModel serviceResponse =
        await stateService.getUser(state.login);

    setState(() {
      stateDetail = serviceResponse;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color:Colors.black,
        ),
        title: Text('${state.id} - ${state.loginDisplay}',
          style: const TextStyle(
            color: Colors.black
          ),
        ),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: isLoading ? _buildBottomLoader() : 
        Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(20),  
                    child: _buildDetail(stateDetail),
                ),
              ],
            ),
    );
  }

  Widget _buildBottomLoader() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.1,
      width: double.infinity,
      // color: Colors.black,
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

static const IconData people = IconData(0xe8f5, fontFamily: 'MaterialIcons');

  Widget _buildDetail(DetailsModel user){
    return Container(
      
      width: double.infinity,
      // height: double.infinity,
      alignment: Alignment.center, 
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.teal,
          width:2,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(5),
        ),
      ),
      child: SizedBox(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
                Container(
                  child: FadeInImage.memoryNetwork(
                    placeholder: kTransparentImage,
                    image: user.avatar,
                    // height: 300,
                    width: 300,
                    fit: BoxFit.scaleDown,
                  ),
                ),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.only(right: 1),
                  child: Icon(
                    Icons.account_circle,
                    color: Colors.black,
                    size: 30,
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.only(right: 10),
                  child: Text(user.name),
                ),
              ],
            ),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.only(right: 1),
                  child: Icon(
                    Icons.people,
                    color: Colors.black,
                    size: 30,
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.only(right: 10),
                  child: Text('${user.followers} followers ° ${user.following} following'),
                ),
              ],
            ),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.only(right: 1),
                  child: Icon(
                    Icons.update,
                    color: Colors.black,
                    size: 30,
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.only(right: 10),
                  child: Text(user.updated),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

}
