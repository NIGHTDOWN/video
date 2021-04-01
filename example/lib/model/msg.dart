import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum MsgType {
  TXT, //文本消息
  IMG, //图片消息
  VIDEO, //视频消息
  VOICE, //语音消息
  FILE, //文件消息
  GOODS, //商品消息
  RRWARD, //打赏消息
  IN_ROOM, //进入房间
  OUT_ROOM, //退出房间
}

class Msg {
  //发消息
  String fuid; //来源用户id
  String fusername; //来源用户id
  String msg;
  MsgType type;
  Map data;
  Msg.fromjson(data, String uid) {
// {msgtype: 5, data: {act_id: null, course_id: 17, pic: http://47.119.145.216:8088/data/image/anony/202103/27/e3c63440dc038fd4.jpg, name: 21天养生计划, all_price: null}}
    fuid = uid;
    fusername = uid.toString();
    // type = data['msgtype'];
    msg = data['data'];
  }
  _fromdata(String uid, MsgType type, Map data) {
    fuid = uid;
    fusername = uid.toString();
    type = type;
    msg = data['data'];
  }

  Msg.txt(String uid, String msg) {
    _fromdata(uid, MsgType.TXT, {'data': msg});
  }
  Msg.inroom(String uid) {
    _fromdata(uid, MsgType.IN_ROOM, {'data': '进入直播间'});
  }
  Msg.outroom(String uid) {
    _fromdata(uid, MsgType.OUT_ROOM, {'data': '退出直播间'});
  }
  //获取组件
  getwidget() {
    var box = BoxDecoration(
      // F2599A
      // color: type == MsgType.TXT ? Color(0x55323232) : Color(0xf0F2599A),
      color: Color(0x55323232),
      borderRadius: BorderRadius.circular(4.0),
    );
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
            child: Container(
                margin: EdgeInsets.all(3),
                padding: EdgeInsets.all(5),
                decoration: box,
                child: AutoSizeText.rich(
                  TextSpan(
                      text: fusername + (MsgType.TXT == type ? ' : ' : ' '),
                      style: TextStyle(color: Color(0xff6B8FFF)),
                      children: <TextSpan>[
                        TextSpan(
                            text: msg,
                            style: TextStyle(
                                color: type == MsgType.TXT
                                    ? Colors.white
                                    : Color(0xf0F2599A))),
                      ]),
                  // style: TextStyle(fontSize: 20),
                  minFontSize: 5,
                )))
      ],
    );
  }
}
