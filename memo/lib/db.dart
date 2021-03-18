import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import 'methods/memo_dao.dart';
import 'entity/memo.dart';

part 'db.g.dart'; // the generated code will be there

@Database(version: 1, entities: [Memo])
abstract class AppDatabase extends FloorDatabase {
  MemoDao get memoDao;
}
