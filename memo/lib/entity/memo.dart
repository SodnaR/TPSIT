import 'package:floor/floor.dart';

@entity
class Memo {
  @primaryKey
  final String title;
  final String field;
  final String anchor;

  Memo(this.title, this.field, this.anchor);
}
