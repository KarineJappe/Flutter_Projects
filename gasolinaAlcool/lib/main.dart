import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: Home(),
    debugShowCheckedModeBanner: false,
  ));
}

class Home extends StatefulWidget {
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _gasolinaController = TextEditingController();
  TextEditingController _alcoolController = TextEditingController();
  String _resultado;

  @override
  void initState() {
    super.initState();
    resetFields();
  }

  void resetState() {
    _gasolinaController.text = ' ';
    _alcoolController.text = ' ';
    setState(() {
      _resultado = 'Informe os valores';
    });
  }

  void resetFields() {
    _gasolinaController.text = '';
    _alcoolController.text = '';
    setState(() {
      _resultado = 'Informe os valores';
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: buildMain(),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      title: Text('Alcool ou Gasolina'),
      backgroundColor: Colors.teal,
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.refresh),
          onPressed: () {
            resetFields();
          },
        )
      ],
    );
  }

  Container buildMain() {
    return Container(
        color: Colors.white,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: buildContainer(),
        ));
  }

  Container buildContainer() {
    return Container(
      padding: EdgeInsets.all(50),
      alignment: Alignment.center,
      child: buildForm(),
    );
  }

  Column buildFormContainer() {
    return Column(
      children: <Widget>[
        buildTextFormField(
          control: _alcoolController,
          label: 'Preço do álcool',
          error: 'Insira o valor do alcool',
        ),
        buildTextFormField(
          control: _gasolinaController,
          label: 'Preço da gasolina',
          error: 'Insira o valor da gasolina',
        ),
        buildResult(),
        buildCalculateButton(),
      ],
    );
  }

  Form buildForm() {
    return Form(
      child: buildFormContainer(),
      key: _formKey,
    );
  }

  Container buildTextFormField(
      {TextEditingController control, String error, String label}) {
    return Container(
        margin: EdgeInsets.only(bottom: 30),
        child: TextFormField(
          controller: control,
          keyboardType: TextInputType.number,
          style: TextStyle(
            color: Colors.black,
          ),
          decoration: InputDecoration(
            labelStyle: TextStyle(color: Colors.grey),
            labelText: label,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          validator: (value) {
            return value.isEmpty ? error : null;
          },
        ));
  }

  String calculo() {
    double gasolina = double.parse(_gasolinaController.text);
    double alcool = double.parse(_alcoolController.text);

    double result = double.parse((alcool / gasolina).toStringAsPrecision(2));

    setState(() {
      if (result < 0.7) {
        _resultado = 'Abasteça com Álcol!';
      } else if (result > 0.7){
        _resultado = 'Abasteça com Gasolina!';
      } else if (result.isNaN) {
        _resultado ='Digite um novo valor!';
      }
    });
  }

  RaisedButton buildCalculateButton() {
    return RaisedButton(
      onPressed: () {
        if (_formKey.currentState.validate()) {
          calculo();
        }
      },
      color: Colors.teal,
      child: Text(
        'Calcular',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }

  Padding buildResult() {
    return Padding(
      padding: EdgeInsets.only( bottom: 25),
      child: Text(
        _resultado,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 20,
        ),
      ),
    );
  }
}