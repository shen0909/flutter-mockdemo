import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:todo_list/controllers/task_controller.dart';
import 'package:todo_list/ui/theme.dart';
import 'package:todo_list/ui/widgets/input_field.dart';
import 'package:todo_list/ui/widgets/my_button.dart';

import '../models/task.dart';
//添加任务页面
class AddTaskPage extends StatefulWidget {
  const AddTaskPage({Key? key}) : super(key: key);

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {

  /*使用Getx的依赖注入功能来创建和注册一个TaskController对象_taskController*/
  final TaskController _taskController=Get.put(TaskController());
  /*文本编辑器*/
  final TextEditingController _titleController=TextEditingController();
  final TextEditingController _noteContrller=TextEditingController();
  /*选中日期*/
  DateTime _selectedDate=DateTime.now();
  String _endTime="24:00 PM";
  String _startTime=DateFormat("hh:mm a").format(DateTime.now()).toString();

  int _selectedRemind=5;
  List<int> remindList=[5,10,15,20];

  String _selectedRepeat="None";
  List<String> RepeatList=["None","Daily","Weekly","Monthly","Yearly"];
  int _selectedColor=0;

  _appBar(BuildContext context){
    return AppBar(
      elevation: 0,
      /*获取上下文主题的背景色*/
      backgroundColor: context.theme.backgroundColor,
      /*actions从左边开始放东西*/
      actions: [
        CircleAvatar(child: Icon(Icons.person),),
        SizedBox(width: 10,)
      ],
      leading: GestureDetector(
        onTap: (){
          print("返回上一页");
          Navigator.pop(context);
        },
        child: Icon(
          Icons.arrow_back_ios_rounded,
          // Get.isDarkMode? Icons.wb_sunny_outlined: Icons.nightlight_round,
          size: 20,
          /*根据主题修改图标颜色*/
          color: Get.isDarkMode? Colors.white:Colors.black,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context),
      body:Container(
        padding: EdgeInsets.only(left: 20,right: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Add Task",style:headStyle,),
              InputField(
                title: "Title",
                hinttext: "Enter title here",
                controller: _titleController,
                widget:  IconButton(
                  icon: Icon(Icons.highlight_remove_outlined),
                  onPressed: (){
                    print("清除输入内容");
                    _titleController.text="";
                  },
                ),
              ),
              InputField(
                title: "Notes",
                hinttext: "Enter Notes here",
                controller: _noteContrller,
                widget:  IconButton(
                  icon: Icon(Icons.highlight_remove_outlined,),
                  onPressed: () {
                    print("清除输入内容");
                  },
                ),
              ),
              InputField(
                title: "Date",
                hinttext: DateFormat.yMd().format(_selectedDate),
                readonly: true,
                widget:  IconButton(
                  icon: Icon(
                      Icons.calendar_month,
                    color: Colors.redAccent,
                  ),
                  onPressed: () {
                    print("click 日历");
                    _getDateFromUser();
                  },
                ),
              ),
              Row(
                children: [
                  Expanded(
                      child: InputField(
                        title: "Start Time",
                        hinttext: _startTime,
                        readonly: true,
                        widget: IconButton(
                          icon: Icon(Icons.access_time_rounded),
                          onPressed: (){
                            print("click choose time");
                            _getTimeFromUser(isStartTime: true);
                          },
                        ),
                      )
                  ),
                  SizedBox(width: 10,),
                  Expanded(
                      child: InputField(
                        title: "End Time",
                        hinttext: _endTime,
                        readonly: true,
                        widget: IconButton(
                          icon: Icon(Icons.access_time_rounded),
                          onPressed: (){
                            print("click choose time");
                            _getTimeFromUser(isStartTime: false);
                          },
                        ),
                      )
                  ),
                ],
              ),
              InputField(
                title: "Remind",
                hinttext: "$_selectedRemind minutes early",
                readonly: true,
                /*创建了一个下拉菜单按钮*/
                widget:DropdownButton(
                  icon: Icon(Icons.keyboard_arrow_down,color: Colors.grey,),
                  iconSize: 26,
                  elevation: 4,
                  style: subtitleStyle,
                  underline: Container(),
                  /*当选项被选择时，调用回调函数*/
                  onChanged: (String? newvalue) {
                    setState((){
                      _selectedRemind=int.parse(newvalue!);
                    });
                  },
                  /*创建一个下拉列表
                   *使用map()方法将整数映射到DropdownMenuItem对象上
                   *map方法的返回对象是<DropdownMenuItem<String>>
                   *value: value.toString()--->将整数类型转换成字符串类型
                   *.toList()--->转换成列表
                   * int value是remindList列表中的一个元素  */
                  items: remindList.map<DropdownMenuItem<String>>((int value){
                    return DropdownMenuItem<String>(
                        value: value.toString(),
                        child: Text(value.toString())
                    );
                  }).toList(),

                ) ,
              ),
              InputField(
                title: "Repeat",
                hinttext: _selectedRepeat,
                readonly: true,
                widget: DropdownButton(
                  icon: Icon(Icons.keyboard_arrow_down,color: Colors.grey,),
                  iconSize: 26,
                  elevation: 4,
                  style: subtitleStyle,
                  underline: Container(),
                  // autofocus: false,
                  focusColor: Colors.transparent,
                  /*下拉列表颜色*/
                  // dropdownColor: Colors.greenAccent,
                  onChanged: (String? newValue){
                    setState((){
                      _selectedRepeat=newValue!;
                    });
                  },
                  /*String? value是RepeatList中的一个元素*/
                  items: RepeatList.map<DropdownMenuItem<String>>(
                          (String? value){
                            return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value!,)
                            );
                          }).toList(),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 16),
                child: Row(
                  children: [
                    _colorPallete(),
                    Expanded(child: Container()),
                    MyButton(
                        label: "Create Task",
                        onTap: (){
                          _validateDate();
                        })
                  ],
                ),
              )
            ],
          ),
        ),
      ) ,
    );
  }

  /*验证表单信息*/
  _validateDate(){
    /*如果标题输入、note输入都不为空
     *则验证成功，将数据保存到数据库并且返回到主页显示 */
    if(_titleController.text.isNotEmpty&&_noteContrller.text.isNotEmpty){
      print("Create Task");
      //将内容添加到数据库中
      /*将数据传输到controller*/
      _addTaskToDB();
      Get.back();
      _taskController.getTask();
    }
    /*其中一个是空的*/
    else if(_titleController.text.isEmpty){
      Get.snackbar(
          "Warnning", "You should complete title!",
          icon: Icon(Icons.warning_amber_rounded,color:Colors.redAccent ,),
          colorText: Colors.redAccent,
          // snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.white
      );
    }
    else if(_noteContrller.text.isEmpty){
      Get.snackbar(
          "Warnning", "You should complete Notes!",
          icon: Icon(Icons.warning_amber_rounded,color:Colors.redAccent ,),
          // snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.white,
          colorText: Colors.redAccent
      );
    }
  }

  //将Task模型传入到taskcontroller中，在里面调用函数，插入到数据库中
  _addTaskToDB() async {
    /*将任务信息传送到任务模型中---->需要更改模式
     *所以要将数据传递给控制器 */
    int value=await _taskController.addTask(
        task:Task(
            note: _noteContrller.text,
            title: _titleController.text,
            date: DateFormat.yMd().format(_selectedDate),
            startTime: _startTime,
            endTime: _endTime,
            remind: _selectedRemind,
            repeat: _selectedRepeat,
            color: _selectedColor,
            isCompleted: 0
        )
    );
    print("最后一行数据行数为:${value}");
  }

  /*颜色--调色板*/
  _colorPallete(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Color",style: titleStyle,),
        SizedBox(height: 10,),
        /*wrap可以帮助把东西放在一条水平线上
                         *使用了List.generate()方法来生成一个包含3个CircleAvatar widget 的列表
                         *List.generate()方法有两个元素
                         *第一个是要生成的元素数量
                         *第二个是生成元素的回调函数  */
        Wrap(
          children: List<Widget>.generate(
              3,
                  (int index) {
                return GestureDetector(
                  onTap: (){
                    print("click No.${index+1} colors");
                    setState((){
                      _selectedColor=index;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: CircleAvatar(
                        radius: 14,
                        backgroundColor:index==0?primaryClr:index==1?pinkClr:yellowClr,
                        /*当选中的颜色索引和当前索引一致时，会返回一个check图标，否则返回空*/
                        child: _selectedColor==index?Icon(Icons.check,size: 16,color: Colors.white,):Container()
                    ),
                  ),
                );
              }),
        )
      ],
    );
  }

  /*定义一个函数--->选择日期*/
  _getDateFromUser() async {
    DateTime? _pickerDate=await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2015),
        lastDate: DateTime(2030));
    if(_pickerDate!=null){
      setState((){
        _selectedDate=_pickerDate;
      });
    }
  }

  /*选择时间*/
  _getTimeFromUser({required bool isStartTime}) async {

    var pickedTime= await _showTimePicker();
    String _formatedTime= pickedTime.format(context);
    print("${_formatedTime}");
    /*如果选择的时间=null*/
    if(pickedTime==null){
      print("Time is cancled");/*时间取消*/
    }
    /*如果被选择的是初始时间，更新初始时间*/
    else if(isStartTime==true){
      setState((){
        _startTime=_formatedTime;
      });
    }
    /*如果被选择是截止时间，更新截止时间*/
    else if(isStartTime==false){
      setState((){
        _endTime=_formatedTime;
      });
    }
  }

  _showTimePicker(){
    return showTimePicker(
      initialEntryMode: TimePickerEntryMode.dial,
      context: context,
      initialTime:TimeOfDay(
          hour: int.parse(_startTime.split(":")[0]),
          minute: int.parse(_startTime.split(":")[1].split(" ")[0])
      ),
    );
  }

}
