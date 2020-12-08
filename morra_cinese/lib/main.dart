import 'dart:io';
import 'package:flutter/material.dart';
import 'package:imagebutton/imagebutton.dart';
import 'server/server.dart';

Socket _socket;
bool _inGame = true;
dynamic points; //da implementare

SocketException exception;

void main() {
  Socket.connect("192.168.1.105", 3000).then((socket) {
    print('Connected to: '
        '${socket.remoteAddress.address}:${socket.remotePort}');
    _socket = socket;
    runApp(MyApp());
  }).catchError((e) {
    if (e is SocketException) {
      print('SocketException => $e');
      exception = e;
    }
    runApp(ServerApp());
  });
}

class ServerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: ServerNotFound(title: "Can't find the server"));
  }
}

class ServerNotFound extends StatefulWidget {
  ServerNotFound({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _ServerNotFoundState createState() => _ServerNotFoundState();
}

class _ServerNotFoundState extends State<ServerNotFound> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Row(
          children: [Text("Can't reach the server")],
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      /*
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      */
      home: MyHomePage(title: 'Morra cinese', mySocket: _socket),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title, this.mySocket}) : super(key: key);
  final String title;
  final Socket mySocket;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String dot = ".";
  int no = 1;
  Stream searching;

  Stream<int> tick() async* {
    int i = 1;
    do {
      await Future.delayed(Duration(seconds: 3));
      yield ++i;
      if (i == 3) i = 1;
    } while (true);
  }

  String wait() {
    searching.listen((data) => pointAnimation());
    return dot;
  }

  void pointAnimation() {
    setState(() {
      switch (no) {
        case 1:
          no++;
          dot = "..";
          break;
        case 2:
          no++;
          dot = "...";
          break;
        case 3:
          no = 1;
          dot = ".";
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    searching = tick();
    if (!_inGame) {
      return Scaffold(
        body: Center(
            child: Row(
          children: [
            Text("Waiting for opponent "),
            Text("${wait()}"),
          ],
        )),
      );
    } else {
      return Scaffold(
          appBar: AppBar(
            title: Text(widget.title),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(),//Row for points
                Row(children: <Widget>[
                  ButtonBar(
                      alignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        FlatButton(
                            onPressed: () {
                              widget.mySocket.write("sasso");
                            },
                            //child: Image.asset('immagini/sasso.png')),
                            child: Text("Sasso")),
                        FlatButton(
                            onPressed: () {
                              widget.mySocket.write("carta");
                            },
                            child: Text('Carta')),
                        FlatButton(
                            onPressed: () {
                              widget.mySocket.write("forbice");
                            },
                            child: Text('Forbici')),
                      ]),
                ])
              ],
            ),
          ));
    }
  }

  Widget myButton(String path) {
    return ImageButton(
      children: <Widget>[],
      width: 91,
      height: 36,
      paddingTop: 5,
      pressedImage: Image.asset(
        "${path}premuta.png",
      ),
      unpressedImage: Image.asset("$path.png"),
      onTap: () {
        print('test');
      },
    );
  }
}
