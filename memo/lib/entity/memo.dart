import 'package:floor/floor.dart';

@entity
class Memo {
  @primaryKey
  final int id;
  final String mail;
  final String title;
  final String field;
  final String anchor;

  Memo(this.id, this.mail, this.title, this.field, this.anchor);
}
