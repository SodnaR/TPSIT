import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:prenotazioni/pages/homepage.dart';
import 'package:prenotazioni/data/utenti.dart';
import 'package:prenotazioni/main.dart' as user_import;

final username = userCubit("");

class Login extends StatefulWidget {
  Login({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  List<Utente> users;

  final emailController = TextEditingController();
  final pswController = TextEditingController();
  bool obscure = true;

  @override
  void initState() {
    super.initState();
    users = user_import.users.utenti;
  }

  bool logged() {
    bool _return = false;
    users.forEach((user) {
      if (user.email.compareTo(emailController.text) == 0) {
        if (user.password.compareTo(pswController.text) == 0) {
          _return = true;
          setState(() {
            username.nickname(user.username);
          });
        }
      }
    });
    return _return;
  }

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
              controller: emailController,
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
              controller: pswController,
              obscureText: obscure,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: 15.0),
                border: OutlineInputBorder(),
                hintText: "password",
                suffix: IconButton(
                    icon: Icon(Icons.visibility),
                    onPressed: () {
                      setState(() {
                        obscure = !obscure;
                      });
                    }),
              ),
              keyboardType: TextInputType.text,
            ),
          ),
          TextButton(
            child: Text("Submit"),
            onPressed: () {
              if (logged()) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Homepage()),
                );
              } else {
                //add text
              }
            },
          ),
        ],
      ),
    ));
  }
}

// ignore: camel_case_types
class userCubit extends Cubit<String> {
  userCubit(String initialState) : super(initialState);

  void nickname(String username) => emit(username);

  @override
  void onChange(Change<String> change) {
    super.onChange(change);
    user_import.setUser(change.nextState.toString());
    print("$change from user");
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    print('$error, $stackTrace');
    super.onError(error, stackTrace);
  }
}
