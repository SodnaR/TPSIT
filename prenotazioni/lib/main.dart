import 'package:flutter/material.dart';
import 'package:prenotazioni/data/utenti.dart';

//Custom package
import 'package:prenotazioni/pages/homepage.dart';
import 'package:prenotazioni/pages/login.dart';
import 'prenotationCalendar/relaxCalendar.dart';

Utenti _users;
Utenti get users => _users;

void main() {
  _users = new Utenti();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    _users = new Utenti();
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Login(),
    );
  }
}
