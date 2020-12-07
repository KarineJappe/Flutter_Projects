import 'package:flutter/material.dart';
import 'package:githubUsers/models/user_model.dart';
import 'package:githubUsers/pages/details_user.dart';
import 'package:githubUsers/services/users.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ScrollController _scrollController;
  UserService _userService;
  bool _isLoading = false;

  List<UserModel> _userList;

  @override
  void initState() {
    super.initState();
    
    _userService = UserService();
    _scrollController = ScrollController();
    _scrollController.addListener(_listenScrollController);

    _getAllUser();
  }

  void _getAllUser() async {
    final withLoading = _userList == null;

    if (withLoading) {
      setState(() => _isLoading = true);
    }

    final remoteList = await _userService.getUser();

    setState(() {
      _isLoading = false;
      _userList = remoteList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return _buildLoader();
    }else{
      return _buildList();
    }
  }

  Widget _buildLoader() {
    return LinearProgressIndicator();
  }

  Widget _buildList() {
    if (_userList == null) {
      return const SizedBox();
    }

    return ListView.separated(
      key: const PageStorageKey('myListView'),
      controller: _scrollController,
      padding: const EdgeInsets.all(16.0),
      separatorBuilder: (context, index) => const SizedBox(height: 14.0),
      itemCount: _userList.length,
      itemBuilder: (context, index) {
      //  => _buildCard(_userList[index]),
        if (_userList.length > index) {
          final user = _userList[index];
          return _buildCard(user);
        } else {
          return _buildBottomLoader();
        }            
      },
    );
  }

  Widget _buildBottomLoader() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.01,
      width: double.infinity,
      color: Colors.black,
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildCard(UserModel user) {
    return FutureBuilder<Color>(
      initialData: Colors.teal,
      builder: (context, snapshot) {
        final cardColor = snapshot.data;
        return InkWell( onTap: () => _handleNavigateToState(user),
          // margin: const EdgeInsets.all(0.0),
          child: Container(
            height: 50.0,
            padding: const EdgeInsets.all(10.0),
            // width: double.infinity,
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: const BorderRadius
                .all(Radius.circular(4.0))
            ),
            child: Row(
              children: [
                Text(  '${user.idUser}. ${user.loginDisplay}',
                style: TextStyle(fontWeight: FontWeight.normal)
                ),
              ],
            ),
          ),
        );
      }
    );
  }

void _handleNavigateToState(UserModel state) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return DetailsPage(state);
    })).then((result) {
      _getAllUser();
    });
  }

  void _listenScrollController() {
    if (_scrollController.position.atEdge) {
      _getAllUser();
    }
  }

  Widget _buildAppBar() {
    return AppBar(
      iconTheme: IconThemeData(
        color: Colors.black,
      ),
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      title: Text(
        "Usuários Github",
        style: const TextStyle(
          color: Colors.black
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}


