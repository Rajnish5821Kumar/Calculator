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
      num1 = double.parse(output);
      operand = buttonText;
      _output = '0';
    } else if (buttonText == '=') {
      num2 = double.parse(output);

    switch (operand) {
        case '+':
          _output = (num1 + num2).toString();
          break;
        case '-':
          _output = (num1 - num2).toString();
          break;
        case '*':
          _output = (num1 * num2).toString();
          break;
        case '/':
          _output = (num1 / num2).toString();
          break;
      }
      num1 = 0.0;
      num2 = 0.0;
      operand = '';
    } else {
      _output += buttonText;
    }
    setState(() {
      output = double.parse(_output).toStringAsFixed(2).replaceAll(RegExp(r'\.0+$'), '');
    });
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
              output,
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
