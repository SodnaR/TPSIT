import 'dart:convert';

import 'package:http/http.dart' as http;

class Utente {
  String email;
  String password;
  String username;

  Utente(this.email, this.password, this.username);

  String getUsername() {
    return username;
  }

  Utente.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    password = json['password'];
    username = json['username'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    data['password'] = this.password;
    data['username'] = this.username;
    return data;
  }
}

class Utenti {
  Future<List<Utente>> futureUtenti;
  List<Utente> utenti;

  Utenti() {
    futureUtenti = fetchUtenti();
    _updateUtenti();
    utenti = List.empty();
  }

  Future<List<Utente>> fetchUtenti() async {
    var response = await http.get(Uri.http('10.0.2.2:3000', '/Aula'));
    var stanze = json.decode(response.body) as List;
    if (response.statusCode == 200) {
      return stanze.map((e) => Utente.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load memo');
    }
  }

  void _updateUtenti() async {
    futureUtenti.then((aule) {
      aule.forEach((element) {
        utenti.add(element);
      });
    });
  }
}
