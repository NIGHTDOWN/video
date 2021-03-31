import 'dart:convert';

import 'package:zego_express_engine/zego_express_engine.dart';
import 'package:zego_faceunity_plugin_example/model/course.dart';
import 'package:zego_faceunity_plugin_example/tool/function.dart';
import 'package:zego_faceunity_plugin_example/utils/zego_config.dart';

class Im {
  //发消息
  static send(Object msg) async {
    String roomid = ZegoConfig.instance.roomID;
    ZegoExpressEngine.instance.sendBroadcastMessage(roomid, msg);
  }

  static json(Object msg) {
    return jsonEncode(msg);
  }

  static sendGood(Course course, [actid, allprice]) async {
    Object msg = {
      'msgtype': 5,
      'data': {
        "act_id": actid, //上架活动id
        "course_id": course.id, //上架的课程id
        "pic": course.pic, //封面图
        "name": course.name, //封面图
        "all_price": allprice //总价
      }
    };
    d(msg);
    send(json(msg));
  }
}
