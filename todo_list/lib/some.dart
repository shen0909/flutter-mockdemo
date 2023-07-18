/*
static Future<void> initDB()async{
if(_db!=null){
return ;
}
else{
*/
/*获取数据库的路径*//*

Directory directory=await getApplicationDocumentsDirectory();
String _path=join(directory.path,'taskDB.db');
print("数据库路径：${_path}");
_db=await openDatabase(
_path,
version: _version,
*/
/*一旦数据库创建则会调用回调函数onCreate()*//*

onCreate: (Database db,int version){
print("creating a new one");
return db.query(
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
);
}
);
}
*/
/*try{
      *//*
*/
/*获取数据库的路径*//*
*/
/*
      Directory directory=await getApplicationDocumentsDirectory();
      String _path=join(directory.path,'taskDB.db');
      print("数据库路径：${_path}");
      _db=await openDatabase(
        _path,
        version: _version,
        *//*
*/
/*一旦数据库创建则会调用回调函数onCreate()*//*
*/
/*
        onCreate: (db,version){
          print("creating a new one");
          return db.execute(
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
          );
        }
      );
    }catch(e){
      print("错误:${e}");
      // print(e);
    }*//*

}*/
