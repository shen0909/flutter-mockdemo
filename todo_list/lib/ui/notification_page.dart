import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:todo_list/ui/theme.dart';

class NotificationPage extends StatelessWidget {
  String? label;
   NotificationPage({Key? key,required String lable}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Get.isDarkMode?Colors.grey[600]:Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded),
          onPressed: ()=>Get.back(),
        ),
        title:Text(this.label.toString().split("|")[0],style: titleStyle,) ,
      ),
      body: Container(
        child: Text(label.toString().split("|")[1]),
      ),
    );
  }
}
