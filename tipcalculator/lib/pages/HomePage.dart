import 'package:calculadora_gorjeta/DarkModeController.dart';
import 'package:calculadora_gorjeta/widgets/CustomFormField.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  MoneyMaskedTextController moneyController =
      MoneyMaskedTextController(decimalSeparator: ",", thousandSeparator: ".");
  TextEditingController percentController = TextEditingController();
  bool isGorjeta = false;
  String txtGorjeta;
  String txtTotal;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Calculadora de Gorjetas"),
        actions: <Widget>[
          Switch(
            onChanged: (value) {
              DarkMode.instance.changeTheme();
            },
            value: DarkMode.instance.isDarkMode,
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              CustomFormField(
                "Valor da conta",
                moneyController: moneyController,
              ),
              CustomFormField(
                "Porcentagem em %",
                percentController: percentController,
              ),
              Center(
                child: FlatButton(
                  color: Colors.blueAccent,
                  child: Text("Calcular"),
                  onPressed: () {
                    setState(() {
                      calculate();
                    });
                  },
                ),
              ),
              isGorjeta == true
                  ? Column(
                      children: <Widget>[
                        Card(
                          child: ListTile(
                            subtitle: Text(txtGorjeta),
                            title: Text("Valor da Gorjeta:"),
                          ),
                        ),
                        Card(
                          child: ListTile(
                            subtitle: Text(txtTotal),
                            title: Text("Total:"),
                          ),
                        ),
                      ],
                    )
                  : SizedBox(),
            ],
          ),
        ),
      ),
    );
  }

  void calculate() {
    double valorCompra = moneyController.numberValue;
    double percent = double.parse(percentController.text);
    double gorjeta = valorCompra / 100 * percent;
    double total = valorCompra + gorjeta;

    txtGorjeta = "R\$ ${gorjeta.toStringAsFixed(2).replaceAll(".", ",")} ";
    txtTotal = "R\$ ${total.toStringAsFixed(2).replaceAll(".", ",")} ";
    isGorjeta = true;
  }
}
