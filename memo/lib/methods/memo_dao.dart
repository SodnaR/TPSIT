import 'package:memo/entity/memo.dart';
import 'package:floor/floor.dart';

@dao
abstract class MemoDao {
  @Query('SELECT * FROM Memo')
  Future<List<Memo>> findAllMemo();

  @Query('SELECT * FROM Memo WHERE id = :id')
  Future<List<Memo>> findMemoById(int id);

  @Query('SELECT * FROM Memo WHERE title = :title')
  Future<List<Memo>> findMemoByTitle(String title);

  @Query('SELECT * FROM Memo WHERE anchor = :anchor')
  Future<List<Memo>> findMemoByAnchor(String anchor);

  @Update(onConflict: OnConflictStrategy.replace)
  Future<void> modifyMemo(Memo memo);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertMemo(Memo memo);

  @delete
  Future<void> deleteAllMemo();

  @delete
  Future<void> deleteMemo(Memo memo);
}
