import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_list/ui/theme.dart';

class MyButton extends StatelessWidget {
  final String label;
  final Function()? onTap;


  MyButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 90,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: primaryClr
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(color:Colors.white),
          ),
        ),
      ),
    );
  }
}
