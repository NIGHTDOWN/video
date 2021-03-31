import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Msg {
  //发消息
  int fuid; //来源用户id
  String fusername; //来源用户id
  String msg;
  int type;
  Msg.fromjson(data, int uid) {
// {msgtype: 5, data: {act_id: null, course_id: 17, pic: http://47.119.145.216:8088/data/image/anony/202103/27/e3c63440dc038fd4.jpg, name: 21天养生计划, all_price: null}}
    fuid = uid;
    fusername = uid.toString();
    type = data['msgtype'];
    msg = data['data'];
  }
  //获取组件
  getwidget() {
    return Row(
      children: [
        Flexible(
            child: Text(
          fusername + ':',
          style: TextStyle(color: Color(0xff6B8FFF)),
        )),
        Expanded(
            child: Text(
          msg,
          style: TextStyle(color: Colors.white),
        ))
      ],
    );
  }
}
