/*get_storage:---->GetX提供的本地存储*/
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/utils.dart';
import 'package:get_storage/get_storage.dart';

class ThemesChange{
  /*创建一个名为_box的GetStorage()实例*/
  final _box=GetStorage();
  /*第一次调用_key时，里面没有值*/
  final _key="isDarkMode";
  _saveThemeToBox(bool isDarkMode)=>_box.write(_key, isDarkMode);

  /*??左侧值为null则返回右侧值，否则返回左侧值
   *初始时，_key中没有值
   *从_Box中读取_key,如果该值为null则返回false,否则，返回true*/
  bool _loadThemeFromBox()=>_box.read(_key)??false;

  /*首先，最开始键值_Key里面并没有value，所以，调用_loadThemeFromBox()函数时一定会返回false
   *所以三元运算符会返回ThemeMode.light */
  // ThemeMode get theme=>_loadThemeFromBox()?ThemeMode.dark:ThemeMode.light;
  /*定义一个名为theme的get方法，方法调用_loadThemeFromBox()返回主题*/
  ThemeMode get theme {
    print("getTheme---->${_loadThemeFromBox()}");
    print("getThemekey---->${_box.read(_key)}");
    return _loadThemeFromBox()?ThemeMode.dark:ThemeMode.light;
  }
  /*程序最初创建时，_key里面没有值，所以_loadThemeFromBox为false--->返回dark模式*/
  void switchTheme(){
    Get.changeThemeMode(_loadThemeFromBox()?ThemeMode.light:ThemeMode.dark);
    _saveThemeToBox(!(_loadThemeFromBox()));
    print("switchThemekey---->${_box.read(_key)}");
    print("switchTheme---->${_loadThemeFromBox()}");

  }
}