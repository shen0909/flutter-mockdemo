/*1、如何获取数据
 *2、如何保存数据
 *3、数据格式  */
//任务模型
class Task{

  int? id;
  var title;/*标题*/
  String? note;/*内容*/
  String? date;/*日期*/
  String? startTime;/*开始时间*/
  String? endTime;/*结束时间*/
  int? color;/*颜色索引*/
  int? remind;/*提醒时间*/
  String? repeat;/*重复周期*/

  int ?isCompleted;/*是否已完成*/

  Task({
    this.id,
    this.title,
    this.note,
    this.date,
    this.startTime,
    this.endTime,
    this.color,
    this.remind,
    this.repeat,
    this.isCompleted
  });
  //当我们将数据保存到数据库中时，必须得转换成json格式
  /*json格式-->
   *key键值
   *key:value
   *value是从本地获取的*/
  Map<String,dynamic> toJson(){
    final Map<String,dynamic> data=new Map<String,dynamic>();
    data['id']=this.id;
    data['title']=this.title;
    data['date']=this.date;
    data['note']=this.note;
    data['isCompleted']=this.isCompleted;
    data['startTime']=this.startTime;
    data['endTime']=this.endTime;
    data['color']=this.color;
    data['remind']=this.remind;
    data['repeat']=this.repeat;
    return data;
  }
  //从数据库中获取数据时从json数据转换成task对象
  Task.fromJson(Map<String,dynamic> json){
    id=json['id'];
    title=json['title'];
    note=json['note'];
    isCompleted=json['isCompleted'];
    date=json['date'];
    startTime=json['startTime'];
    endTime=json['endTime'];
    color=json['color'];
    remind=json['remind'];
    repeat=json['repeat'];
  }

  //controllers帮助我们处理数据后将数据提交到数据库中
  /*json的结构：Map<键-值>
   **Map<String,dynamic>:String类型的键和动态类型的值
   *序列化：将数据结构或对象转换成某种可以在网络上传输或存储在磁盘上的格式，例如json格式----->toJson()
   *反序列化:获取原始数据(json数据)重建对象模型(例如上述的Task对象)----->fromJson()
   **传入到数据库中的数据是json类型的（Map<String,dynamic>）*/
}