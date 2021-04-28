import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:prenotazioni/pages/homepage.dart';

class Login extends StatefulWidget {
  Login({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: EdgeInsets.all(15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("Email"),
          Padding(
            padding: EdgeInsets.only(top: 7.0, bottom: 7.0),
            child: TextField(
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: 15.0),
                border: OutlineInputBorder(),
                hintText: "email",
              ),
            ),
          ),
          Text("Password"),
          Padding(
            padding: EdgeInsets.only(top: 7.0, bottom: 7.0),
            child: TextField(
              obscureText: true,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: 15.0),
                border: OutlineInputBorder(),
                hintText: "password",
                suffix:
                    IconButton(icon: Icon(Icons.visibility), onPressed: () {}),
              ),
            ),
          ),
          TextButton(
            child: Text("Submit"),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Homepage()),
              );
            },
          )
        ],
      ),
    ));
  }
}
