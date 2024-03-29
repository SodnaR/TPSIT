import 'package:floor/floor.dart';

@entity
class Memo {
  @primaryKey
  int id;
  String user;
  String title;
  String field;
  String anchor;

  Memo(this.id, this.user, this.title, this.field, this.anchor);

  bool compare(Memo other) {
    return (other.title == title &&
        other.field == field &&
        other.anchor == anchor);
  }

  Memo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    user = json['user'];
    title = json['title'];
    field = json['field'];
    anchor = json['anchor'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user'] = this.user;
    data['title'] = this.title;
    data['field'] = this.field;
    data['anchor'] = this.anchor;
    return data;
  }
}
