import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

//Custom package
import 'package:prenotazioni/data/prenotations.dart';
import 'package:prenotazioni/data/utenti.dart';
import 'package:prenotazioni/data/classi.dart';
import 'package:prenotazioni/methods/prenotations_dao.dart';
import 'package:prenotazioni/local/db.dart';
import 'package:prenotazioni/pages/login.dart';

//creazione e condivisione degli utenti dal main
Utenti _users;
Utenti get users => _users;

//creazione e condivisione delle aule dal main
Aule _stanze;
Aule get stanze => _stanze;

//nome dell'utente
String username;

//creazione e condivisione database prenotazioni locale
LocalPrenotations _prenotazioni;
LocalPrenotations get prenotazioni => _prenotazioni;

setUser(String user) {
  username = user;
  print(username);
}

void main() {
  _users = new Utenti();
  _stanze = new Aule();
  _prenotazioni = new LocalPrenotations();
  Bloc.observer = MyBlocObserver();
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

//controller dei cubit
//cubit creati in questa app: 4
class MyBlocObserver extends BlocObserver {
  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);
    print('onCreate -- ${bloc.runtimeType}');
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    _prenotazioni.reload();
    print('onChange -- ${bloc.runtimeType}, ');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    print('onError -- ${bloc.runtimeType}, $error');
    super.onError(bloc, error, stackTrace);
  }

  @override
  void onClose(BlocBase bloc) {
    super.onClose(bloc);
    print('onClose -- ${bloc.runtimeType}');
  }
}

//database locale per l'utente
class LocalPrenotations {
  AppDatabase database;
  PrenotationDao prenotationDao;
  List<Prenotation> prenotations = <Prenotation>[], onlinePrenotation;

  LocalPrenotations() {
    onlinePrenotation = [];
    _setOnlinePrenotations();
  }

  void reload() {
    LocalPrenotations();
  }

  Future<List<Prenotation>> fetchPrenotation() async {
    /*
    $FloorAppDatabase.databaseBuilder('app_database.db').build().then((db) => {
          db.prenotationDao.findAllPrenotation().then((pr) {
            database = db;
            prenotationDao = db.prenotationDao;
            prenotations = pr;
          })
        });
  */
    var response = await http.get(Uri.http('10.0.2.2:3000', '/Prenotation'));
    var responsePrenotations = json.decode(response.body) as List;
    if (response.statusCode == 200) {
      return responsePrenotations.map((e) => Prenotation.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load');
    }
  }

  void _setOnlinePrenotations() async {
    onlinePrenotation.addAll(await fetchPrenotation());
    /*
    //Prenotazioni in locale non possibili
    //Creazioni logout necessaria
    onlinePrenotation.forEach((element) {
      database.prenotationDao.insertPrenotation(element);
    });
    */
  }

  //db locale al momento non disponibile
  List<Prenotation> getUserPrenotation() {
    List<Prenotation> _return = <Prenotation>[];
    database.prenotationDao
        .findPrenotationByUser(username)
        .then((data) => _return = data);
    _return.forEach((element) {
      print("${element.codP} ${element.idAula} ${element.date}");
    });
    return _return;
  }
}
