import 'package:floor/floor.dart';

@entity
class Account {
  @primaryKey
  final String mail;
  final String password;

  Account(this.mail, this.password);
} //just a trial
