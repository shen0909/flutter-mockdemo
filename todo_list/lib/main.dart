import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_storage/get_storage.dart';
import 'package:todo_list/db/db_helper.dart';
import 'package:todo_list/services/theme_change.dart';
import 'package:todo_list/ui/home_page.dart';
import 'package:todo_list/ui/theme.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  /*初始化数据库*/
  await DBHelper.getInstance().initDB();
  await GetStorage.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "ToDo App",
      debugShowCheckedModeBanner: false,
      /*默认主题
       *primaryColor主要改变appbar button颜色
       * brightness修改亮度 */
      theme: Themes.light,
      /*深色主题*/
      darkTheme:Themes.dark ,
      /*themeMode主题模式,此时默认是浅色模式*/
      themeMode: ThemesChange().theme,
      home: HomePage(),
    );
  }
}



