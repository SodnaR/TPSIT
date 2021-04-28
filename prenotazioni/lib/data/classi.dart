import 'dart:convert';

import 'package:http/http.dart' as http;

class Aula {
  int idAula;
  String intestazione;

  Aula(this.idAula, this.intestazione);

  String getIntestazione() {
    return intestazione;
  }

  int getidAula() {
    return idAula;
  }

  Aula.fromJson(Map<String, dynamic> json) {
    idAula = json['id'];
    intestazione = json['intestazione'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.idAula;
    data['user'] = this.intestazione;
    return data;
  }
}

class Aule {
  Future<List<Aula>> futureAule;
  List<Aula> stanze;

  Aule() {
    futureAule = fetchAule();
    _updateAule();
    stanze = List.empty();
  }

  Future<List<Aula>> fetchAule() async {
    var response = await http.get(Uri.http('10.0.2.2:3000', '/Aula'));
    var stanze = json.decode(response.body) as List;
    if (response.statusCode == 200) {
      return stanze.map((e) => Aula.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load memo');
    }
  }

  void _updateAule() async {
    futureAule.then((aule) {
      aule.forEach((element) {
        stanze.add(element);
      });
    });
  }
}
