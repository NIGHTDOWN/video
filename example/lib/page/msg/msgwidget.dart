import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:zego_faceunity_plugin_example/model/msg.dart';
import 'package:zego_faceunity_plugin_example/model/rtmpbase.dart';
import 'package:zego_faceunity_plugin_example/tool/function.dart';
import 'package:zego_faceunity_plugin_example/tool/global.dart';
import 'package:zego_faceunity_plugin_example/utils/base.dart';
import 'package:zego_express_engine/zego_express_engine.dart';

// ignore: must_be_immutable
class MsgWidget extends LoginBase {
  List msg = [];
  static ScrollController _scrollController = new ScrollController();

  //加载
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    listen();
  }

  listen() {
    ZegoExpressEngine.onIMRecvBroadcastMessage =
        (String streamID, List<ZegoBroadcastMessageInfo> datas) {
      d('接收到消息');
      for (var data in datas) {
        recvmsg(data.fromUser.userID, data.message);
      }
    };
    ZegoExpressEngine.onRoomUserUpdate =
        (String msg, ZegoUpdateType type, List<ZegoUser> users) {
      d('新增用户');
      for (var user in users) {
        recvroom(user.userID, type);
      }
    };
  }

  //销毁
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    ZegoExpressEngine.onIMRecvBroadcastMessage = null;
    ZegoExpressEngine.onRoomUserUpdate = null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        //宽度高度固定
        margin: EdgeInsets.only(left: 20),
        height: g('h') * 0.3,
        width: g('w') * 0.6,
        // color: Colors.blue,
        child: ListView.builder(
            physics: BouncingScrollPhysics(),
            shrinkWrap: true,
            controller: _scrollController,
            reverse: true,
            itemCount: msg.length,
            itemBuilder: (context, i) {
              return msg[i].getwidget();
            }));
  }

//接收用户房间消息
  recvroom(userid, ZegoUpdateType msg) {
    Msg msgobj;
    if (msg == ZegoUpdateType.Add) {
      msgobj = Msg.inroom(userid);
    } else {
      msgobj = Msg.outroom(userid);
    }
    msgin(msgobj);
  }

  //接收用户消息
  recvmsg(userid, msg) {
    d(userid);
    d(msg);
  }

  msgin(Msg obj) {
    //插入要显示的消息
    setState(() {
      msg.insert(0, obj);
    });
    d(msg);
    _msglast();
  }

  _msglast() {
    _scrollController.animateTo(
      0.0,
      curve: Curves.easeOut,
      duration: const Duration(milliseconds: 300),
    );
  }
}
