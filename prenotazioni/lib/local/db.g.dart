// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'db.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder {
  _$AppDatabaseBuilder(this.name);

  final String name;

  final List<Migration> _migrations = [];

  Callback _callback;

  /// Adds migrations to the builder.
  _$AppDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$AppDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String> listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  PrenotationDao _prenotationDaoInstance;

  Future<sqflite.Database> open(String path, List<Migration> migrations,
      [Callback callback]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Prenotation` (`codP` INTEGER, `idAula` INTEGER, `time` TEXT, `username` TEXT, PRIMARY KEY (`codP`))');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  PrenotationDao get prenotationDao {
    return _prenotationDaoInstance ??=
        _$PrenotationDao(database, changeListener);
  }
}

class _$PrenotationDao extends PrenotationDao {
  _$PrenotationDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database, changeListener),
        _prenotationInsertionAdapter = InsertionAdapter(
            database,
            'Prenotation',
            (Prenotation item) => <String, Object>{
                  'codP': item.codP,
                  'idAula': item.idAula,
                }),
        _prenotationUpdateAdapter = UpdateAdapter(
            database,
            'Prenotation',
            ['codP'],
            (Prenotation item) => <String, Object>{
                  'codP': item.codP,
                  'idAula': item.idAula,
                }),
        _prenotationDeletionAdapter = DeletionAdapter(
            database,
            'Prenotation',
            ['codP'],
            (Prenotation item) => <String, Object>{
                  'codP': item.codP,
                  'idAula': item.idAula,
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Prenotation> _prenotationInsertionAdapter;

  final UpdateAdapter<Prenotation> _prenotationUpdateAdapter;

  final DeletionAdapter<Prenotation> _prenotationDeletionAdapter;

  @override
  Future<void> insertPrenotation(Prenotation prenotation) async {
    await _prenotationInsertionAdapter.insert(
        prenotation, OnConflictStrategy.replace);
  }

  @override
  Future<void> modifyPrenotation(Prenotation prenotation) async {
    await _prenotationUpdateAdapter.update(
        prenotation, OnConflictStrategy.replace);
  }

  @override
  Future<void> deletePrenotation(Prenotation prenotation) async {
    await _prenotationDeletionAdapter.delete(prenotation);
  }

  @override
  Future<void> deleteAllPrenotation() async {
    await _queryAdapter.queryNoReturn('DELETE FROM Prenotation');
  }

  @override
  Future<List<Prenotation>> findPrenotationByUser(String username) {
    return _queryAdapter.queryList('SELECT * FROM Prenotation WHERE anchor = ?',
        arguments: <dynamic>[username],
        mapper: (Map<String, dynamic> row) => Prenotation(row['codP'] as int,
            row['idAula'] as int, row['date'] as List<dynamic>));
  }

  @override
  Future<List<Prenotation>> findAllPrenotation() {
    return _queryAdapter.queryList('SELECT * FROM Prenotation',
        mapper: (Map<String, dynamic> row) => Prenotation(row['codP'] as int,
            row['idAula'] as int, row['date'] as List<dynamic>));
  }
}
