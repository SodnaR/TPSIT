import 'package:floor/floor.dart';

@entity
class Prenotation {
  @primaryKey
  int codP;
  int idAula;
  List<dynamic> date;

  Prenotation(this.codP, this.idAula, this.date);

  Prenotation.fromJson(Map<String, dynamic> json) {
    codP = json['id'];
    idAula = json['idAula'];
    date = List<Time>.from(json['date'].map((x) => Time.fromJson(x)));
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.codP;
    data['user'] = this.idAula;
    data['date'] = this.date;
    return data;
  }
}

class Time {
  int year;
  int month;
  int day;
  int hour;
  String booker;

  Time(this.year, this.month, this.day, this.hour, this.booker);

  Time.fromJson(Map<String, dynamic> json) {
    year = json['year'];
    month = json['month'];
    day = json['day'];
    hour = json['hour'];
    booker = json['username'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['year'] = this.year;
    data['month'] = this.month;
    data['day'] = this.day;
    data['hour'] = this.hour;
    data['username'] = this.booker;
    return data;
  }

  DateTime getDateTime() {
    return DateTime(year, month, day);
  }

  int getHour() {
    return hour;
  }
}
