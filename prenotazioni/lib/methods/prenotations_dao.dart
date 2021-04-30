import 'package:prenotazioni/data/prenotations.dart';
import 'package:floor/floor.dart';

@dao
abstract class PrenotationDao {
  @Query('SELECT * FROM Prenotation')
  Future<List<Prenotation>> findAllPrenotation();

  @Query('SELECT * FROM Prenotation WHERE username = :username')
  Future<List<Prenotation>> findPrenotationByUser(String username);

  @Update(onConflict: OnConflictStrategy.replace)
  Future<void> modifyPrenotation(Prenotation prenotation);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertPrenotation(Prenotation prenotation);

  @delete
  Future<void> deleteAllPrenotation();

  @delete
  Future<void> deletePrenotation(Prenotation prenotation);
}
