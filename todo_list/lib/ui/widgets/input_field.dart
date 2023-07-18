import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../theme.dart';

class InputField extends StatelessWidget {

  final String title;
  final String hinttext;
  final TextEditingController? controller;
  final Widget? widget;
  final bool readonly;

  InputField({required this.title, required this.hinttext,this.controller,this.widget,this.readonly=false,});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 16),
      child:Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: titleStyle,
          ),
          SizedBox(height: 10,),
          Container(
            height: 42,
            child:Row(
              children: [
                Expanded(
                    child: TextFormField(
                      readOnly: readonly,
                      autofocus: false,
                      cursorColor: Get.isDarkMode?Colors.grey[100]:Colors.grey[700],
                      controller: controller,
                      style: subtitleStyle,
                      decoration: InputDecoration(
                        suffixIcon:widget,
                        hintText: hinttext,
                        hintStyle: TextStyle(color: readonly?Colors.black:Colors.grey),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide(
                            width: 0,
                            color: Colors.grey
                          )
                        ),
                        focusedBorder: readonly?
                        OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(
                                width: 0,
                                color: Colors.blue
                            )
                        ):
                        OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(
                                width: 0,
                                color: Colors.yellow
                            )
                        ),
                    )
                )
                )
              ],
            ) ,
          )
        ],
      ) ,
    );
  }
}
