import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import '../methods/prenotations_dao.dart';
import '../data/prenotations.dart';

part 'db.g.dart'; // the generated code will be there

@Database(version: 1, entities: [Prenotation])
abstract class AppDatabase extends FloorDatabase {
  PrenotationDao get prenotationDao;
}
