import 'package:memo/entity/memo.dart';
import 'package:floor/floor.dart';

@dao
abstract class MemoDao {
  @Query('SELECT * FROM Memo')
  Future<List<Memo>> findAllMemo();

  @Query('SELECT FROM Memo WHERE id = :id')
  Stream<Memo> findMemoById(int id);

  @Query('SELECT * FROM Memo WHERE anchor = :anchor')
  Stream<Memo> findMemoByAnchor(String anchor);

  @Query('SELECT * FROM Memo WHERE title = :title')
  Future<List<Memo>> findMemoByTitle(String title);

  @Query(
      'UPDATE Memo WHERE title = :title AND field = :field AND anchor = :anchor')
  Future<void> modifyMemo(Memo memo, Memo exMemo);

  @insert
  Future<void> insertMemo(Memo memo);
}
