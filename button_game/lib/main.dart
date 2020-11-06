import 'dart:developer';

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Chronometer'),
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
  int _hours = 0, _minutes = 0, _seconds = 0;
  bool _started = false, stop = false;
  Duration _second = new Duration(seconds: 1);

  Stream _onGoing;

  void startTimer() {
    if (!_started) {
      _onGoing = waiting();
      _started = !_started;
      _onGoing.listen((data) => _incrementCounter());
    } else {
      stop = !stop;
    }
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
      if (!stop) {
        if (_seconds < 59) {
          _seconds++;
        } else if (_minutes < 59) {
          _minutes++;
          _seconds = 00;
        } else if (_hours < 23) {
          _hours++;
          _minutes = 00;
          _seconds = 00;
        } else {
          _hours = 00;
          _minutes = 00;
          _seconds = 00;
        }
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
              '${hourstoString()}:${minutestoString()}:${secondstoString()}',
              style: Theme.of(context).textTheme.headline4,
            ),
            Row(
              children: <Widget>[
                ButtonBar(
                  children: <Widget>[
                    FlatButton(
                      onPressed: null,
                      child: null)
                    )
                  ],
                )
              ],
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: startTimer,
        tooltip: 'Start and stop the chronometer',
        child: Icon(Icons.access_time),
      ),
    );
  }

  String hourstoString() {
    if (_hours < 10) {
      return "0$_hours";
    } else {
      return "$_hours";
    }
  }

  String minutestoString() {
    if (_minutes < 10) {
      return "0$_minutes";
    } else {
      return "$_minutes";
    }
  }

  String secondstoString() {
    if (_seconds < 10) {
      return "0$_seconds";
    } else {
      return "$_seconds";
    }
  }
}

class SecondRoute extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Timer,
    );
  }
}
