import 'package:flutter/material.dart';
import 'package:listaCompras/Models/list_purchase.dart';
import 'package:listaCompras/Pages/add_item.dart';
import 'package:listaCompras/Utils/database_helper.dart';
import 'package:sqflite/sqflite.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DatabaseHelper dbHelper = DatabaseHelper();

  List<Purchase> purchaseList = List<Purchase>();

  @override
  void initState() {
    super.initState();
    updateListView();
  }

  void updateListView() {
    final Future<Database> dbFuture = dbHelper.inicializeDataBase();

    dbFuture.then((database) {
      Future<List<Purchase>> listFuture = dbHelper.getPurchase();

      listFuture.then((result) {
        this.setState(() {
          this.purchaseList = result;
        });
      });
    });
  }

  void onNavigateAdd() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return AddPage(new Purchase.empty());
    })).then((result) {
      if (result == true) {
        updateListView();
      }
    });
  }

  void onNavigateEdit(Purchase edit) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return AddPage(edit);
    })).then((result) {
      if (result == true) {
        updateListView();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Lista de Compras',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.teal[400],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal[400],
        onPressed: onNavigateAdd,
        tooltip: 'Adicionar Produto',
        child: Icon(
          Icons.add_shopping_cart,
          color: Colors.white,
        ),
      ),
      body: buildListView(),
    );
  }

  void deleteItem(int id, BuildContext context) async {
    int result = await dbHelper.delete(id);

    if (result != 0) {
      final snackBar = SnackBar(content: Text('Produto excluido.'));
      Scaffold.of(context).showSnackBar(snackBar);

      updateListView();
    }
  }

  Widget buildListView() {
    return ListView.builder(
        itemCount: purchaseList.length,
        itemBuilder: (BuildContext context, int position) {
          Purchase purchase = purchaseList[position];

          return InkWell(
            onTap: () {
              onNavigateEdit(purchase);
            },
            borderRadius: BorderRadius.all(Radius.zero),
            child: Card(
              elevation: 4,
              margin: EdgeInsets.all(10),
              child: Container(
                padding: EdgeInsets.only(left: 20, top: 6, bottom: 6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          '${position + 1}.',
                          style: TextStyle(fontSize: 16),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 20),
                          child: Text(
                            purchase.name,
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      child: IconButton(
                        color: Colors.grey[850],
                        icon: Icon(
                          Icons.delete,
                        ),
                        onPressed: () {
                          deleteItem(purchase.id, context);
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }
}
