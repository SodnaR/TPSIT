import 'package:floor/floor.dart';

@entity
class Prenotation {
  @primaryKey
  int codP;
  int idAula;
  String time;
  String username;

  Prenotation(this.codP, this.idAula, this.time, this.username);

  Prenotation.fromJson(Map<String, dynamic> json) {
    codP = json['codP'];
    idAula = json['idAula'];
    time = json['time'];
    username = json['username'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.codP;
    data['user'] = this.idAula;
    data['title'] = this.time;
    data['field'] = this.username;
    return data;
  }
}
