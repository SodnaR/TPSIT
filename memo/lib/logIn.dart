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
      });
    });
  }

  Future get _getPreferences async {
    prefs = await SharedPreferences.getInstance();
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
                title: "Memo browser",
              )),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (prefs == null) {
      _getPreferences;
    }

    /*All WIP always login
    _logged();
    if (logging) {
      /*
      //WIP da aggiungere quando gli account potranno essere univoci
      print('logged');
      return alreadyLog;
      */
      
    } else {
      print('notLogged');
      return doLog;
    }
    */
    return doLog;
  }

  Scaffold get alreadyLog {
    return Scaffold(
      body: Center(
        child: Column(
          children: <Widget>[
            TextFormField(
              controller: mailLogger,
              decoration: const InputDecoration(),
              style: Theme.of(context).textTheme.body1,
            ),
            RaisedButton(
              onPressed: _checkMail,
              child: Text('Log in'),
            ),
          ],
        ),
      ),
    );
  }

  Scaffold get doLog {
    return Scaffold(
      body: Center(
        child: Column(
          children: <Widget>[
            TextFormField(
              controller: mailLogger,
              decoration: const InputDecoration(hintText: "username"),
              style: Theme.of(context).textTheme.body1,
            ),
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
