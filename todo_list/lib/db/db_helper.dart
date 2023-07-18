//初始化数据库
import 'package:sqflite_common/sqlite_api.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import '../models/task.dart';
import 'package:path/path.dart' as path;
class DBHelper{

  static DBHelper? _dbHelper;

  static DBHelper getInstance(){
    if(_dbHelper==null)
      {
        _dbHelper=DBHelper();
      }
    return _dbHelper!;
  }


  Database? _db;
  static final int _version=1;
  static final String _tableName="taskDB";
  static late String _path;

  Future<Database> get database async{
    if(_db!=null){
      return _db!;
    }
    _db=await initDB();
    return _db!;
  }
  /*一旦调用initDB()方法，检查数据库是否为空
   *不为空---->已经初始化 */
   initDB()async{
     sqfliteFfiInit();
     var databaseFactory = databaseFactoryFfi;
     print("数据库地址：${await databaseFactory.getDatabasesPath()}");
     return await databaseFactory.openDatabase(
         path.join(await databaseFactory.getDatabasesPath(), "Todo_list.db"),
         options: OpenDatabaseOptions(
             version:5,
             onCreate: (db,version) async {
               print("creating a new one");
               return await db.execute(
                   "CREATE TABLE $_tableName("
                       "id INTEGER PRIMARY KEY AUTOINCREMENT,"
                       "title STRING,"
                       "note TEXT,"
                       "date STRING,"
                       "startTime STRING,"
                       "endTime STRING,"
                       "remind INTEGER,"
                       "repeat STRING,"
                       "color INTEGER,"
                       "isCompleted INTEGER"
                       ")"
               );
             }
         )
     );
   }

  //获取路径
  Future<String>getPath()async {
  var databaseFactory = databaseFactoryFfi;
  _path=await databaseFactory.getDatabasesPath();
  print("数据库路径：$_path");
  return _path ;
}

  //插入数据
  Future<int>insert(Task? task)async{
     Database db=await database;
     print("insert function called");
     print("插入的数据:${task!.toJson()}");
    /*insert方法会返回最后的行id*/
    return await db.insert(_tableName, task.toJson());
  }

  //查询数据
  Future<List<Map<String,dynamic>>> query() async{
    Database db=await database;
    print("query function called!");
    await db.execute("VACUUM");
    return await db.query(_tableName);
  }

  //删除数据
  Future<void> delete(Task task)async{
    Database db=await database;
    print("delete function called");
    /*删除id=xx的task数据*/
    await db.delete(_tableName,where: "id=?",whereArgs: [task.id]);
    await db.execute('VACUUM');
  }

  //更新数据
  /*根据id更新isCompated*/
  Future<int> update(int ic,int id) async{
     Database db=await database;
     return await db.rawUpdate( '''
     UPDATE $_tableName
     SET isCompleted=?
     WHERE id=?
     ''',
      [ic,id]
     );
  }
}