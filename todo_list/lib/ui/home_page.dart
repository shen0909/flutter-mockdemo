import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:todo_list/controllers/task_controller.dart';
import 'package:todo_list/models/task.dart';
import 'package:todo_list/services/notification_services.dart';
import 'package:todo_list/services/theme_change.dart';
import 'package:todo_list/ui/add_task_page.dart';
import 'package:todo_list/ui/theme.dart';
import 'package:todo_list/ui/widgets/my_button.dart';
import 'package:todo_list/ui/widgets/task_title.dart';

//点击更换主题时，获取本地通知
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final _taskController=Get.put(TaskController());
  var notifyHelper;
  DateTime _selectedDate=DateTime.now();

  /*初始化--->请求ios权限 */
  @override
  void initState() {
    super.initState();
    notifyHelper=NotifyHelper();
    notifyHelper.initializeNotification();
    notifyHelper.requestIOSPermissions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: Column(
        children: [
          //添加任务导航栏
          _addTaskBar(),
          //日期选择器
          _addDateBar(),
          SizedBox(height: 10,),
          //展示任务列表
          _showTasks(),
        ],
      ),
      //右下角浮动按钮添加任务
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print("click add task button");
          Get.to(()=>AddTaskPage());
          },
        backgroundColor: primaryClr,
        child: Icon(Icons.add),
      ),
    );
  }

  //应用导航栏
  _appBar(){
    return AppBar(
      elevation: 0,
      /*获取上下文主题的背景色*/
      backgroundColor: context.theme.backgroundColor,
      /*actions从左边开始放东西*/
      actions: [
        CircleAvatar(
          child: Icon(Icons.person),
        ),
        SizedBox(width: 10,)
      ],
      leading: GestureDetector(
        onTap: (){
          print("更改颜色");
          ThemesChange().switchTheme();
          /*调用显示通知功能*/
          notifyHelper.displayNotification(
            title:"Theme change",
            body:Get.isDarkMode?"正在使用深色模式":"正在使用浅色模式",
          );
          /*单击按钮后预定一个通知*/
          notifyHelper.scheduledNotification();
        },
        child: Icon(
          Get.isDarkMode? Icons.wb_sunny_outlined: Icons.nightlight_round,
          size: 20,
          /*根据主题修改图标颜色*/
          color: Get.isDarkMode? Colors.white:Colors.black,
        ),
      ),
    );
  }
  //添加任务导航栏
  _addTaskBar(){
    return Container(
      margin: EdgeInsets.only(top: 10,left: 5,right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            /*设置水平方向的左右间距为20*/
            margin: const EdgeInsets.symmetric(horizontal:20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /*DateFormat将本地日期转换成---->日期格式  月份 日期 年*/
                Text(
                  DateFormat.yMMMd().format(DateTime.now()),
                  style: subHeadingStyle,
                  // style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold,color:Get.isDarkMode? Colors.grey[400]:Colors.grey),
                ),
                Text("Today",style: headStyle,),
              ],
            ),
          ),
          MyButton(
              label: "+ Add Task",
              onTap: () async {
                print("click add task");
                await Get.to(()=>AddTaskPage());
                // _taskController.getTask();
              })
        ],
      ),
    );
  }
  //日期时间轴
  _addDateBar(){
    return Container(
      margin: EdgeInsets.only(left: 6,right: 5),
      child: DatePicker(
        height: 85,
        width: 70,
        /*开始日期*/
        DateTime.now(),
        /*初始选择日期时间*/
        initialSelectedDate: DateTime.now(),
        selectedTextColor: Colors.white,
        selectionColor: primaryClr,
        dateTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.grey
        ),
        /*dateTextStyle: GoogleFonts.lato(textStyle:TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.grey
        )),*/
        dayTextStyle: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: Colors.red
        ),
        monthTextStyle: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.grey
        ),
        /*选择不同日期时的回调函数----->修改当前选中日期并输出*/
        onDateChange:(date){
          setState((){
            _selectedDate=date;
            print(_selectedDate);
          });
        },
      ),
    );
  }

  //展示任务列表
  /*获取数据库的数据*/
  /*var taskList=<Task>[].obs;
  * taskList是可观察的
  * 使用Obx()监听taskList的值，当数据发生变化时，更新UI界面*/
  _showTasks(){
    _taskController.getTask();/*获取到taskList的值*/
    return Expanded(
        child: Obx(
            (){
              return ListView.builder(
                itemCount:_taskController.taskList.length ,
                itemBuilder: (context,index){
                  // return GestureDetector(
                  //   onTap: (){
                  //     /*传入一个元素作为参数，元素是Task类型的*/
                  //     _taskController.delete(_taskController.taskList[index]);
                  //     _taskController.getTask();
                  //   },
                  //   child: Container(
                  //     width: 150,
                  //     height: 50,
                  //     margin: const EdgeInsets.only(top: 10),
                  //     decoration: BoxDecoration(
                  //       borderRadius: BorderRadius.circular(12),
                  //       color: Colors.green,
                  //     ),
                  //     child: Text(
                  //       "${_taskController.taskList[index].title}"
                  //     ),
                  //     ),
                  // );
                  /*task是来自任务模型的一个实例*/
                  Task task=_taskController.taskList[index];
                  /*设置显示条件
                   *日期--重复判断
                   *点击任务弹出BottonSheet(),传入当前的task元素作为参数，在里面进行完成-取消完成-删除-关闭操作  */
                  if(task.repeat=="Daily"){
                    //根据日期通知
                    /*Tep1、拆分开始时间，将开始时间从字符串格式转变成日期对象，因为开始时间后*/
                    DateTime date=DateFormat.jm().parse(task.startTime.toString());
                    /*Tep2、将日期对象格式化成小时-分钟*/
                    var myTime=DateFormat("HH:mm").format(date);/*现在就去掉了时间后面的AM PM*/
                    /*调用预定通知函数，传入小时、分钟、任务对象作为参数
                     *将HH:mm对象进行拆分 */
                    notifyHelper.scheduledNotification(
                      int.parse(myTime.toString().split(":")[0]),
                      int.parse(myTime.toString().split(":")[1]),
                      task,
                    );
                    return  AnimationConfiguration.staggeredList(
                      position: index,
                      child: SlideAnimation(
                        child: FadeInAnimation(
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: (){
                                  print("Tapped");
                                  _showBottonSheet(context,task);
                                },
                                child: TaskTile(task),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                  else if(task.date==DateFormat.yMd().format(_selectedDate)){
                    return  AnimationConfiguration.staggeredList(
                      position: index,
                      child: SlideAnimation(
                        child: FadeInAnimation(
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: (){
                                  print("Tapped");
                                  _showBottonSheet(context,task);
                                },
                                child: TaskTile(task),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                  return Container();
                  },
              );
            }
        )
    );
  }

  //点击任务显示任务详情操作
  /*bottomSheet底部弹出
   *GetX的BottomSheet底部弹出是自定义通过路由push的方法实现底部弹窗的一个效果 */
  _showBottonSheet(BuildContext context,Task task){
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.only(top: 4),
        height: MediaQuery.of(context).size.height*0.32,
        decoration: BoxDecoration(
          color: Get.isDarkMode?darkGreyClr:Colors.white,
          borderRadius: BorderRadius.circular(20)
        ),
        child: Center(
          child: Column(
            children: [
              Container(
                height: 6,
                width: 120,
                decoration: BoxDecoration(
                    color: Get.isDarkMode?Colors.grey[600]:Colors.grey[400],
                    borderRadius: BorderRadius.circular(10)
                ),
              ),
              Spacer(),
              /*根据任务是否完成，显示底部弹窗中的操作按钮
               *主要差别在于：完成任务--取消完成
               *内部逻辑：调用_taskController.updateTask(),更新对应task的incomplated值
               *0---修改为未完成
               *1---修改为完成
               *再重新调用_taskController.getTask()，更新taskList的值 */
              task.isCompleted==0?
                  _bottomSheetButton(
                      lable: "Task Complated",
                      onTap: (){
                        print("click Task complated");
                        _taskController.updateTask(1,task.id!);
                        _taskController.getTask();/*此处会重新更新taskList的值，Obx()监听到后会更新UI*/
                        Get.back();
                      },
                      color: primaryClr,
                      context: context
                  ) :
              _bottomSheetButton(
                  lable: "Cancle Complated",
                  onTap: (){
                    print("click Task complated");
                    _taskController.updateTask(0,task.id!);
                    _taskController.getTask();
                    Get.back();
                  },
                  color: primaryClr,
                  context: context
              ),
              SizedBox(height: 20,),
              /*点击删除任务
               *调用_taskController.delete方法，将当前的task传入进去作为参数
               *删除之后，重新调用_taskController.getTask()方法，重新获取taskList列表
               *最后返回到上一页*/
              _bottomSheetButton(
                  lable: "Delete Task",
                  onTap: (){
                    print("click Delete Task");
                    _taskController.delete(task);
                    _taskController.getTask();
                    Get.back();
                  },
                  color: Colors.red[300],
                  context: context
              ),
              SizedBox(height: 15,),
              _bottomSheetButton(
                  lable: "Close",
                  onTap: (){
                    print("click Task complated");
                    Get.back();
                  },
                  color: primaryClr,
                  context: context,
                  isClose: true
              ),
              // SizedBox(height: 5,),
            ],
          ),
        ),
      )
    );
  }

  _bottomSheetButton({required String lable,required Function()? onTap,required Color? color,required BuildContext context,bool isClose=false}){
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        height: 55,
        width: MediaQuery.of(context).size.width*0.9,
        decoration: BoxDecoration(
          color: isClose?Get.isDarkMode?darkGreyClr:Colors.white:color,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              width: 2,
              color: isClose?Get.isDarkMode?Colors.grey[600]!:Colors.grey[300]!:color!
          )
        ),
        child: Center(
          child: Text(
            lable,
            /*如果isClose为true，则使用titleStyle格式，
             *如果为false，则使用titleStyle格式，但将颜色改为白色*/
            style: isClose?titleStyle:titleStyle.copyWith(color: Colors.white),),
        ),
      ),
    );
  }

}
