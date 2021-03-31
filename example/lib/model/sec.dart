import 'package:zego_faceunity_plugin_example/model/course.dart';
import 'package:zego_faceunity_plugin_example/tool/function.dart';
import 'package:zego_faceunity_plugin_example/tool/global.dart';
import 'package:zego_faceunity_plugin_example/tool/http.dart';

class Sec {
  String pic;
  String name;
  String desc;
  String res;
  int id;
  int viplevel;
  double cost;
  int sec;

  int type;
  int flag;
  //章节序号
  int orders;
  bool isfree = true;
  int freetime;
  //课时

  getsec() {}
  setcost(double coin) {
    isfree = false;
    cost = coin;
  }

  setvip(int tmpviplevel) {
    isfree = true;
    viplevel = tmpviplevel;
  }

  Sec.fromJson(data, Course course, int listorders) {
    // d(data);
    id = data['sec_id'];
    name = data['sec_name'];
    viplevel = data['sec_vip_level'];
    cost = data['sec_cost'] / 100;
    freetime = data['free_time'];
    res = data['res'];
    orders = listorders;
    isfree = course.isfree == 1 ? true : false;
  }
  //远程拉取章节列表
  static gethttpsecs(Course course) async {
    String api = '/SellGoods/getListOfSec';
    var data = {
      'course_id': course.id,
      // 'type': 'list',
      // 'page': '0',
      // 'limit': '30',
    };
    var httpdata = await http(api, data, gethead());
    var ret = getdata(g('context'), httpdata);
    if (isnull(ret)) {
      return ret;
    }
    return null;
  }

  tojson() {
    return {
      "sec_id": id,
      "list_orders": orders,
      "sec_vip_level": viplevel,
      "sec_cost": cost,
      "is_free": isfree
    };
  }
}
