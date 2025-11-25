import 'package:flutter/material.dart';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String output = '0';
  String _output = '0';
  double num1 = 0.0;
  double num2 = 0.0;
  String operand = '';

  buttomnPressed(String buttonText) {
    
    if (buttonText == 'C') {
      _output = '0';
      num1 = 0.0;
      num2 = 0.0;
      operand = '';
    } else if (buttonText == '+' || buttonText == '-' || buttonText == '*' || buttonText == '/') {
      // If an operator is already set and the user hasn't entered a new number
      // (raw `_output` is still '0'), treat this as changing the operator only
      if (operand.isNotEmpty && (_output == '0' || _output.isEmpty)) {
        operand = buttonText;
        setState(() {});
        return;
      }

      // Store the current raw input as num1
      try {
        num1 = double.parse(_output);
      } catch (_) {
        num1 = 0.0;
      }
      operand = buttonText;
      // leave _output empty to indicate we're ready for second operand
      _output = '';
    } else if (buttonText == '=') {
      // Parse the second operand from the raw input
      try {
        num2 = double.parse(_output);
      } catch (_) {
        num2 = 0.0;
      }

      double result = 0.0;
      bool error = false;
      switch (operand) {
        case '+':
          result = num1 + num2;
          break;
        case '-':
          result = num1 - num2;
          break;
        case '*':
          result = num1 * num2;
          break;
        case '/':
          if (num2 == 0) {
            error = true;
          } else {
            result = num1 / num2;
          }
          break;
        default:
          result = num2;
          break;
      }

      if (error) {
        _output = 'Error';
        output = 'Error';
      } else {
        _output = result.toString();
      }

      num1 = 0.0;
      num2 = 0.0;
      operand = '';
    } else if (buttonText == '.') {
      // Decimal point handling
      if (_output.contains('.')) {
        return; // ignore extra decimal
      }
      if (_output == '0' || _output.isEmpty) {
        _output = '0.';
      } else {
        _output += '.';
      }
    } else {
      // Digit pressed
      if (_output == '0' || _output.isEmpty) {
        _output = buttonText; // start new input or replace leading zero
      } else if (_output == 'Error') {
        _output = buttonText;
      } else {
        _output += buttonText;
      }
    }
    setState(() {
      if (_output == 'Error') {
        output = 'Error';
        return;
      }
      // If waiting for second operand (empty _output) show stored first number
      if (_output.isEmpty && operand.isNotEmpty) {
        double v = num1;
        if (v == v.toInt()) {
          output = v.toInt().toString();
        } else {
          String s = v.toStringAsFixed(8);
          s = s.replaceFirst(RegExp(r'0+$'), '');
          s = s.replaceFirst(RegExp(r'\.$'), '');
          output = s;
        }
        return;
      }
      try {
        double v = double.parse(_output);
        if (v == v.toInt()) {
          output = v.toInt().toString();
        } else {
          String s = v.toStringAsFixed(8);
          // trim trailing zeros and optional trailing dot
          s = s.replaceFirst(RegExp(r'0+$'), '');
          s = s.replaceFirst(RegExp(r'\.$'), '');
          output = s;
        }
      } catch (_) {
        output = _output;
      }
    });
  }

  String formatDouble(double v) {
    if (v == v.toInt()) return v.toInt().toString();
    String s = v.toStringAsFixed(8);
    s = s.replaceFirst(RegExp(r'0+$'), '');
    s = s.replaceFirst(RegExp(r'\.$'), '');
    return s;
  }

  String formatRaw(String raw) {
    if (raw.isEmpty) return '';
    if (raw == 'Error') return raw;
    try {
      double v = double.parse(raw);
      return formatDouble(v);
    } catch (_) {
      return raw;
    }
  }

  String getDisplayText() {
    // If waiting for second operand, show "num1 <operator>" so operator is visible
    if (operand.isNotEmpty) {
      // show "num1 <operator> [current input]" so user sees the whole expression
      final second = formatRaw(_output);
      if (second.isEmpty) return '${formatDouble(num1)} $operand';
      return '${formatDouble(num1)} $operand $second';
    }
    return output;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        backgroundColor: Colors.grey[850],
        title: const Text('Calculator App', style: TextStyle(color: Colors.white)),
      ),
      body: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.symmetric(
              vertical: 24,
              horizontal: 12,
            ),
            child: Text(
              getDisplayText(),
              style: const TextStyle(
                fontSize: 48,
                color: Colors.white,
              ),
            ),
          ),
          const Divider(color: Colors.grey),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    buildButton('7', Colors.grey),
                    buildButton('8', Colors.grey),
                    buildButton('9', Colors.grey),
                    buildButton('/', Colors.orange),
                  ],
                ),
                Row(
                  children: [
                    buildButton('4', Colors.grey),
                    buildButton('5', Colors.grey),
                    buildButton('6', Colors.grey),
                    buildButton('*', Colors.orange),
                  ],
                ),
                Row(
                  children: [
                    buildButton('1', Colors.grey),
                    buildButton('2', Colors.grey),
                    buildButton('3', Colors.grey),
                    buildButton('-', Colors.orange),
                  ],
                ),
                Row(
                  children: [
                    buildButton('0', Colors.grey),
                    buildButton('.', Colors.grey),
                    buildButton('C', Colors.orange),
                    buildButton('+', Colors.orange),
                  ],
                ),

                Row(
                  children: [
                    buildButton('=', Colors.orange),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildButton(String buttonText, Color buttonColor) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(8),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: buttonColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: () {
            buttomnPressed(buttonText);
          },
          child: Text(
            buttonText,
            style: const TextStyle(fontSize: 24, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
