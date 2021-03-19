import 'package:memo/entity/memo.dart';
import 'package:floor/floor.dart';

@dao
abstract class MemoDao {
  @Query('SELECT * FROM Person')
  Future<List<Memo>> findAllMemo();

  @Query('SELECT * FROM Person WHERE id = :id')
  Stream<Memo> findMemoByAnchor(String anchor);

  @insert
  Future<void> insertMemo(Memo memo);
}
