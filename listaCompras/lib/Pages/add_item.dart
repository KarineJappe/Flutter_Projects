import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:listaCompras/Models/list_purchase.dart';
import 'package:listaCompras/Utils/database_helper.dart';


class AddPage extends StatefulWidget {
  final Purchase purchase;

  AddPage(this.purchase);

  @override
  _AddPageState createState() => _AddPageState(this.purchase);
}

class _AddPageState extends State<AddPage> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();

  DatabaseHelper dbHelper = DatabaseHelper();

  Purchase puchase;

  _AddPageState(this.puchase);

  @override
  void initState() {
    if (isEdit()) {
      _nameController.text = puchase.name;
    } else {
      resetFields();
    }

    super.initState();
  }

  void resetState() {
    _nameController.text = '';
  }

  void resetFields() {
    _nameController.text = '';
  }

  bool isEdit() => puchase.name != null;

  Future<bool> add() async {
    String name = _nameController.text;

    Purchase addPurchase = new Purchase(name);

    addPurchase.date = DateFormat.yMMMd().format(DateTime.now());

    int result;

    result = await dbHelper.add(addPurchase);

    Navigator.pop(context, true);
  }

  Future<bool> editPurchase() async {
    String name = _nameController.text;

    puchase.name = name;

    int result;

    result = await dbHelper.update(puchase);

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Adicionar um novo produto',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.teal[300],
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              resetFields();
            },
          )
        ],
      ),
      body: SingleChildScrollView(child: buildForm()),
    );
  }

  Form buildForm() {
    return Form(
      key: _formKey,
      child: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            buildTextFormField(
              control: _nameController,
              error: 'Insira o nome',
              label: 'Nome do produto',
            ),
            RaisedButton(
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  isEdit() ? editPurchase() : add();
                }
              },
              color: Colors.teal[300],
              child: Text(
                isEdit() ? 'Editar' : 'Adicionar',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Container buildTextFormField(
      {TextEditingController control, String error, String label}) {
    return Container(
        margin: EdgeInsets.only(bottom: 30),
        child: TextFormField(
          controller: control,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            labelStyle: TextStyle(
              color: Colors.blueGrey[300],
              decorationColor: Colors.blueGrey[300],
            ),
            labelText: label,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.zero,
            ),
          ),
          validator: (value) {  
            return value.isEmpty ? error : null;
          },
        ));
  }

  
}