import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

int _hours = 0, _minutes = 0, _seconds = 0;
bool _started = false;
Duration _second = new Duration(seconds: 1);

Stream _onGoing;

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void startTimer() {
    if (!_started) {
      _onGoing = waiting();
    } else {
      _onGoing.listen(null).resume();
    }

    _onGoing.listen((data) => _incrementCounter());
  }

  void stopTimer() {
    _onGoing.listen(null).pause();
  }

  Stream<int> waiting([var maxCount]) async* {
    int i = 0;
    do {
      await Future.delayed(_second);
      yield i++;
      if (i == maxCount) break;
    } while (true);
  }

  void _incrementCounter() {
    setState(() {
      if (_seconds < 60) {
        _seconds++;
      } else if (_minutes < 60) {
        _minutes++;
        _seconds = 0;
      } else if (_hours < 24) {
        _hours++;
        _minutes = 0;
        _seconds = 0;
      } else {
        _hours = 0;
        _minutes = 0;
        _seconds = 0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '00:00:00',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: startTimer,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
