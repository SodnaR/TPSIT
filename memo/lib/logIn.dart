import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'main.dart';

dynamic _mail;

class LogIn extends StatefulWidget {
  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  TextEditingController mailLogger = TextEditingController();
  SharedPreferences prefs;
  String user;
  bool logging;

  @override
  void initState() {
    super.initState();

    _getPreferences.then((data) {
      setState(() {
        this.prefs = data;
        _logged();
      });
    });
  }

  Future get _getPreferences async {
    return SharedPreferences.getInstance();
  }

  void _logged() {
    mailLogger = TextEditingController(
        text: prefs.getString('username') ?? ''.toString());
    if (mailLogger.text.isEmpty)
      logging = false;
    else
      logging = true;
  }

  void _checkMail() async {
    prefs.setString('username', mailLogger.text);

    _mail = prefs.getString('username') ?? ''.toString();
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => MyHomePage(
                title: _mail,
              )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: <Widget>[
            TextFormField(
              controller: mailLogger,
              decoration: const InputDecoration(hintText: "username"),
              // ignore: deprecated_member_use
              style: Theme.of(context).textTheme.body1,
            ),
            // ignore: deprecated_member_use
            RaisedButton(
              onPressed: _checkMail,
              child: Text('Log in'),
            ),
          ],
        ),
      ),
    );
  }
}
