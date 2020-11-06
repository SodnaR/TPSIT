import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

bool stop = false;

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
  bool _started = false;
  Duration _second = new Duration(seconds: 1);

  Stream _onGoing;

  void startTimer() {
    if (!_started) {
      _onGoing = waiting();
      _started = !_started;
      _onGoing.listen((data) => _incrementCounter());
      stop = false;
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

  void reset() {
    _hours = _minutes = _seconds = 0;
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
            Container(
              child: ButtonBar(
                alignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  FlatButton(
                      onPressed: startTimer,
                      child: Text(
                          "${(_started) ? (stop) ? "START" : "STOP" : "START"}")),
                  FlatButton(
                      onPressed: reset,
                      child: Text(
                          "${(stop) ? "RESET" : ""}") // have to add the laps
                      )
                ],
              ),
            )
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerTop,
      bottomNavigationBar: BottomAppBar(
        child: Stack(alignment: Alignment.bottomCenter, children: <Widget>[
          ButtonBar(
            children: <Widget>[
              RaisedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyApp()),
                  );
                },
                child: Text("Chronometer"),
              ),
              RaisedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SecondRoute()),
                  );
                },
                child: Text("Timer"),
              )
            ],
          ),
        ]),
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

class SecondRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Timer"),
      ),
      body: Center(),
    );
  }
}
