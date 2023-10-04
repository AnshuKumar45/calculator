import 'package:calculator/button_values.dart';
import 'package:flutter/material.dart';

class calculatorScreen extends StatefulWidget {
  const calculatorScreen({super.key});

  @override
  State<calculatorScreen> createState() => _calculatorScreenState();
}

class _calculatorScreenState extends State<calculatorScreen> {
  String number1 = "";
  String operand = "";
  String number2 = "";
  int f = 0;
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                reverse: true,
                child: Container(
                  alignment: Alignment.bottomRight,
                  padding: EdgeInsets.all(18),
                  child: Text(
                    "$number1$operand$number2".isEmpty
                        ? "0"
                        : "$number1$operand$number2",
                    style: TextStyle(fontSize: 50, fontWeight: FontWeight.w600),
                    textAlign: TextAlign.end,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            //buttons
            Wrap(
              children: button.buttonValues
                  .map(
                    (value) => Container(
                        width: value == button.n0
                            ? screenSize.width / 2
                            : screenSize.width / 4,
                        height: screenSize.width / 5,
                        child: buildButton(value)),
                  )
                  .toList(),
            )
          ],
        ),
      ),
    );
  }

  void onBtnTap(String value) {
    if (value == button.back) {
      del();
      return;
    }
    if (value == button.clear) {
      clearAll();
      return;
    }

    if (value == button.per) {
      calculatePercentage();
      return;
    }
    if (value == button.equal) {
      calculateExpr();
      f = 1;
      return;
    }
    append(value);
  }

  void calculateExpr() {
    if (number1.isEmpty) return;
    if (operand.isEmpty) return;
    if (number2.isEmpty) return;

    final double num1 = double.parse(number1);
    final double num2 = double.parse(number2);
    double result = 0.0;
    switch (operand) {
      case button.add:
        result = num1 + num2;
        break;
      case button.sub:
        result = num1 - num2;
        break;
      case button.mul:
        result = num1 * num2;
        break;
      case button.div:
        result = num1 / num2;
        break;
      default:
    }
    setState(() {
      result == 0 ? number1 = "" : number1 = "$result";
      operand = "";
      number2 = "";
      if (number1.endsWith(".0")) {
        number1 = number1.substring(0, number1.length - 2);
      } else if (number1.contains(".") && !number1.contains("e")) {
        int i = number1.indexOf(".");
        if (i <= number1.length - 5) number1 = number1.substring(0, i + 5);
      }
    });
  }

  void calculatePercentage() {
    if (number1.isNotEmpty && operand.isNotEmpty && number2.isNotEmpty) {
      calculateExpr();
    }
    if (operand.isNotEmpty) {
      return;
    }
    final number = double.parse(number1);
    setState(() {
      number1 = "${number / 100}";
      operand = "";
      number2 = "";
    });
  }

  void clearAll() {
    setState(() {
      number1 = "";
      number2 = "";
      operand = "";
    });
  }

  void del() {
    if (number2.isNotEmpty) {
      number2 = number2.substring(0, number2.length - 1);
    } else if (operand.isNotEmpty) {
      operand = "";
    } else if (number1.isNotEmpty) {
      number1 = number1.substring(0, number1.length - 1);
    }
    setState(() {});
  }

  void append(String value) {
    if (value != button.decimal && int.tryParse(value) == null) {
      if (operand.isNotEmpty && number2.isNotEmpty) {
        calculateExpr();
      }
      if (number1.isEmpty || number1 == "-") {
        if (value == button.div || value == button.mul || button.add == value) {
          number1 = "0";
          operand = value;
        } else if (value == button.sub) {
          number1 = "-";
          operand = "";
        }
      } else if (operand.isNotEmpty && number2.isEmpty && value == button.sub) {
        number2 = "-";
      } else
        operand = value;
    } else if (number1.isEmpty || operand.isEmpty) {
      if (value == button.decimal && number1.contains(button.decimal)) return;
      if (value == button.decimal &&
          (number1.isEmpty || number1 == button.n0)) {
        value = "0.";
      }
      if (f == 1) {
        number1 = "";
        f = 0;
      }
      (number1.isEmpty && value == button.n0) ? number1 = "" : number1 += value;
    } else if (number2.isEmpty || operand.isNotEmpty) {
      if (value == button.decimal && number2.contains(button.decimal)) return;
      if (value == button.decimal &&
          (number2.isEmpty || number2 == button.n0)) {
        value = "0.";
      }
      if (value == button.n0 && number2 == "-")
        number2 = "0";
      else
        (number2 == "0") ? number2 = value : number2 += value;
    }

    if (number1.endsWith(".") && number1 != "0.") {
      if (value != button.decimal && int.tryParse(value) == null)
        number1 = number1 + "0";
    }
    setState(() {});
  }

  Widget buildButton(String value) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Material(
          color: [button.clear, button.back].contains(value)
              ? Colors.lightBlue
              : [button.equal].contains(value)
                  ? Colors.orange
                  : Colors.black87,
          clipBehavior: Clip.hardEdge,
          shape: OutlineInputBorder(
              borderRadius: BorderRadius.circular(100),
              borderSide: BorderSide(color: Colors.white30)),
          child: InkWell(
              onTap: () => onBtnTap(value),
              child: Center(
                  child: Text(
                value,
                style: TextStyle(
                    color: [
                      button.add,
                      button.mul,
                      button.div,
                      button.sub,
                      button.per,
                    ].contains(value)
                        ? Colors.orange.shade900
                        : Colors.white,
                    fontSize: 26,
                    fontWeight: [button.clear, button.back].contains(value)
                        ? FontWeight.w400
                        : FontWeight.bold),
              )))),
    );
  }
}
