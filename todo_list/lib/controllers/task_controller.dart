import 'package:get/get.dart';
import 'package:todo_list/db/db_helper.dart';
import '../models/task.dart';

class TaskController extends GetxController{

  @override
  void onReady() {
    super.onReady();
  }
  //声明任务列表---->是task类型的
  var taskList=<Task>[].obs;

  Future<int> addTask({Task? task})async{
    return await DBHelper.getInstance().insert(task);
  }

  //从数据库中获取数据,并且保存在taskList列表中
  Future<void> getTask() async {
    List<Map<String,dynamic>> task=await DBHelper.getInstance().query();
    for(int i=0;i<task.length;i++){
      print("task:${task[i]}\n");
    }
    taskList.assignAll(task.map((data) => new Task.fromJson(data)).toList());
    /*打印出的是Instance of 'Task'----->Task类型的实例
     *就是task对象的实例
     *所以可以直接用task.成员名 */
    /*for(int i=0;i<taskList.length;i++){
      print("taskList:${taskList[i]}\n");
    }*/
  }

  //删除任务
  Future<void> delete(Task task) async {
    return await DBHelper.getInstance().delete(task);
  }

  //更新任务--->完成任务
  updateTask(int ic,int id) async {
    await DBHelper.getInstance().update(ic,id);
  }
}