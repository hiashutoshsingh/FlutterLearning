import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';

class CustomFormField extends StatelessWidget {
  var label = "";
  var moneyController = MoneyMaskedTextController();
  var percentController = TextEditingController();

  CustomFormField(this.label, {this.percentController, this.moneyController});
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: moneyController != null ? moneyController : percentController,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(labelText: label),
    );
  }
}
