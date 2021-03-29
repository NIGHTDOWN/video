import 'package:zego_faceunity_plugin_example/tool/function.dart';

import 'sec.dart';

class Course {
  //  "course_id": 6,//id
  //     "course_name": "如何养生234",//标题
  //     "course_type": 0,//课程类型:0视频直播,1音频直播,2视频,3音频,4文章,5线下课
  //     "pic": "http://rtmpphp.com/data/image/anony/202103/13/a7eae52b269c4b6e.jpg",//封面图
  //     "course_num": 50,//课时数量(all)
  //     "course_flag": 0,//课程状态:0连载,1完结
  //     "is_free": 1,//是否免费0收费,1免费
  //     "cost": 0,//价格
  //     "sec": 0//已发布的章节数量
  //     "single_cost": 0,//单节课时价格 例：￥35/课
  //     "vip_level": 0,//vip等级 ，
  //     "desc": "这是一个牛逼的简介哇。。。。。。。。",//课程简介
  String pic;
  String name;
  String desc;
  int id;
  int viplevel;
  int cost;
  int sec;
  int singlecost;
  int type;
  int flag;
  int coursenum;
  int isfree;
  //课时
  List tmpsecs;
  List<Sec> secs = [];
  getsec() async {
    String cachename = 'secs' + this.id.toString() + '_' + type.toString();
    String cachenameindex =
        'secs' + this.id.toString() + '_' + type.toString() + 'time';
    //拉缓存
    tmpsecs = getcache(cachename);

    if (isnull(getcache(cachenameindex))) {
      //缓存时间没到期,直接使用缓存
      return;
    }
    //拉http
    tmpsecs = await Sec.gethttpsecs(this);

    if (isnull(tmpsecs)) {
      setcache(cachename, tmpsecs, '-1');
      setcache(cachenameindex, tmpsecs, '30');
    }
  }

  initsec() async {
    await getsec();
    int i = 1;
    for (var item in tmpsecs) {
      secs.add(Sec.fromJson(item, this, i++));
    }
  }

  Course.fromJson(data) {
    this.id = data['course_id'];
    this.name = data['course_name'];
    this.type = data['course_type'];
    this.pic = data['pic'];
    this.coursenum = data['course_num'];
    this.flag = data['course_flag'];
    this.isfree = data['is_free'];
    this.cost = (data['cost'] / 100).toInt();
    this.singlecost = (data['single_cost'] / 100).toInt();
    this.viplevel = data['vip_level'];
    this.desc = data['desc'];
    this.sec = data['sec'];
  }
}
