import 'package:flutter/material.dart';
//import 'package:expressions/expressions.dart'; // External package for expression evaluation

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Calculator',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Cameron Washburn'),
    );
  }
}

//button panel
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _expression = "0";
  List<int> _expressionNumbers = [];
  List<String> _expressionSymbols = [];
  int _lastInput = 0;
  int _output = 0;
  String _displayOutput = "";

  //number buttons
  void _pressNumber(int number) {
    setState(() {
      if (_lastInput == 0) {
        _expressionNumbers.add(number);
        _expression = "$number";
      } else if (_lastInput == 1) {
        _expressionNumbers.last = _expressionNumbers.last * 10 + number;
        _expression += "$number";
      } else if (_lastInput == 2) {
        _expressionNumbers.add(number);
        _expression += " $number";
      } else if (_lastInput == 3) {
        _expressionNumbers.last = _expressionNumbers.last * number;
        _expression += "$number";
      }
      else if (_lastInput == 4) {
        return;
      }

      _lastInput = 1;
    });
  }

  //operation buttons
  void _pressSymbol(String symbol) {
    setState(() {
      if (_lastInput == 1) {
        _expressionSymbols.add(symbol);
        _expression += " $symbol";
      } else
        return;

      _lastInput = 2;
    });
  }


  //+/- button
  void _pressPositiveNegative() {
    setState(() {
      if (_lastInput == 2) {
        _expressionNumbers.add(-1);
        _expression += " -";
        _lastInput = 3;
      } else if (_lastInput == 3) {
        if (_expression == "-") {
          _expression = "0";
          _lastInput = 0;
          _expressionNumbers.removeLast();
        } else {
          //_expressionNumbers.last = _expressionNumbers.last * -1;
          _expressionNumbers.removeLast();
          _expression = _expression.substring(0, (_expression.length - 2));
          _lastInput = 2;
        }
      } else if (_lastInput == 0) {
        _expressionNumbers.add(-1);
        _expression = "-";
        _lastInput = 3;
      } else
        return;
    });
  }

  //clear button
  void _pressClear() {
    setState(() {
      _expression = "0";
      _expressionNumbers = [];
      _expressionSymbols = [];
      _lastInput = 0;
      _output = 0;
      _displayOutput = "";
    });
  }

  int _getSymbolPriority(String symbol) {
    if (symbol == "x" || symbol == "/")
      return 2;
    else
      return 1;
  }

  //clear button
  void _pressCalculate() {
    setState(() {
      if (_lastInput == 1) {
        _expression += ' =';
        String _currentSymbol = "";
        int _currentSymbolIndex = -1;
        _output = _expressionNumbers[0];
        while (_expressionSymbols.isNotEmpty) {
          _currentSymbol = _expressionSymbols[0];
          _currentSymbolIndex = 0;

          for (int symbolIndex = 1;
              symbolIndex < _expressionSymbols.length;
              symbolIndex++) {
            if (_getSymbolPriority(_currentSymbol) <
                _getSymbolPriority(_expressionSymbols[symbolIndex])) {
              _currentSymbolIndex = symbolIndex;
              _currentSymbol = _expressionSymbols[symbolIndex];
            }
          }

          if (_currentSymbol == "x") {
            _output = _expressionNumbers[_currentSymbolIndex] *
                _expressionNumbers[_currentSymbolIndex + 1];
          } else if (_currentSymbol == "/") {
            if (_expressionNumbers[_currentSymbolIndex + 1] == 0) {
              _displayOutput = "Division By 0 Error";
              _lastInput = 4;
              return;
            }
            _output = _expressionNumbers[_currentSymbolIndex] ~/
                _expressionNumbers[_currentSymbolIndex + 1];
          } else if (_currentSymbol == "+") {
            _output = _expressionNumbers[_currentSymbolIndex] +
                _expressionNumbers[_currentSymbolIndex + 1];
          } else if (_currentSymbol == "-") {
            _output = _expressionNumbers[_currentSymbolIndex] -
                _expressionNumbers[_currentSymbolIndex + 1];
          }

          _expressionNumbers[_currentSymbolIndex] = _output;
          _expressionNumbers.removeAt(_currentSymbolIndex + 1);
          _expressionSymbols.removeAt(_currentSymbolIndex);
        }
        _displayOutput = "$_output";
        _lastInput = 4;
      } else
        return;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '$_expression',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Text(
              '$_displayOutput',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            //Text("$_lastInput"),
            //Text("$_expressionNumbers"),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: OverflowBar(
                alignment: MainAxisAlignment.center,
                spacing: 8.0,
                overflowSpacing: 8.0,
                children: <Widget>[
                  ElevatedButton(
                      child: const Text('7'),
                      onPressed: () => _pressNumber(7),
                      style: ElevatedButton.styleFrom(
                          minimumSize: const Size(80, 40))),
                  ElevatedButton(
                      child: const Text('8'),
                      onPressed: () => _pressNumber(8),
                      style: ElevatedButton.styleFrom(
                          minimumSize: const Size(80, 40))),
                  ElevatedButton(
                      child: const Text('9'),
                      onPressed: () => _pressNumber(9),
                      style: ElevatedButton.styleFrom(
                          minimumSize: const Size(80, 40))),
                  ElevatedButton(
                      child: const Text('+'),
                      onPressed: () => _pressSymbol("+"),
                      style: ElevatedButton.styleFrom(
                          minimumSize: const Size(80, 40))),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: OverflowBar(
                alignment: MainAxisAlignment.center,
                spacing: 8.0,
                overflowSpacing: 8.0,
                children: <Widget>[
                  ElevatedButton(
                      child: const Text('4'),
                      onPressed: () => _pressNumber(4),
                      style: ElevatedButton.styleFrom(
                          minimumSize: const Size(80, 40))),
                  ElevatedButton(
                      child: const Text('5'),
                      onPressed: () => _pressNumber(5),
                      style: ElevatedButton.styleFrom(
                          minimumSize: const Size(80, 40))),
                  ElevatedButton(
                      child: const Text('6'),
                      onPressed: () => _pressNumber(6),
                      style: ElevatedButton.styleFrom(
                          minimumSize: const Size(80, 40))),
                  ElevatedButton(
                      child: const Text("-"),
                      onPressed: () => _pressSymbol("-"),
                      style: ElevatedButton.styleFrom(
                          minimumSize: const Size(80, 40))),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: OverflowBar(
                alignment: MainAxisAlignment.center,
                spacing: 8.0,
                overflowSpacing: 8.0,
                children: <Widget>[
                  ElevatedButton(
                      child: const Text('1'),
                      onPressed: () => _pressNumber(1),
                      style: ElevatedButton.styleFrom(
                          minimumSize: const Size(80, 40))),
                  ElevatedButton(
                      child: const Text('2'),
                      onPressed: () => _pressNumber(2),
                      style: ElevatedButton.styleFrom(
                          minimumSize: const Size(80, 40))),
                  ElevatedButton(
                      child: const Text('3'),
                      onPressed: () => _pressNumber(3),
                      style: ElevatedButton.styleFrom(
                          minimumSize: const Size(80, 40))),
                  ElevatedButton(
                      child: const Text('x'),
                      onPressed: () => _pressSymbol("x"),
                      style: ElevatedButton.styleFrom(
                          minimumSize: const Size(80, 40))),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: OverflowBar(
                alignment: MainAxisAlignment.center,
                spacing: 8.0,
                overflowSpacing: 8.0,
                children: <Widget>[
                  ElevatedButton(
                      child: const Text('0'),
                      onPressed: () => _pressNumber(0),
                      style: ElevatedButton.styleFrom(
                          minimumSize: const Size(80, 40))),
                  ElevatedButton(
                      child: const Text('+/-'),
                      onPressed: () => _pressPositiveNegative(),
                      style: ElevatedButton.styleFrom(
                          minimumSize: const Size(80, 40))),
                  ElevatedButton(
                      child: const Text('Clr'),
                      onPressed: () => _pressClear(),
                      style: ElevatedButton.styleFrom(
                          minimumSize: const Size(80, 40))),
                  ElevatedButton(
                      child: const Text('='),
                      onPressed: () => _pressCalculate(),
                      style: ElevatedButton.styleFrom(
                          minimumSize: const Size(80, 40))),
                  ElevatedButton(
                      child: const Text('/'),
                      onPressed: () => _pressSymbol("/"),
                      style: ElevatedButton.styleFrom(
                          minimumSize: const Size(80, 40))),
                ],
              ),
            ),
          ],
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
