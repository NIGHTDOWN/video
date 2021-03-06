import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


import 'dart:ui' as ui;

import 'package:zego_faceunity_plugin_example/conf/conf.dart';
import 'package:zego_faceunity_plugin_example/tool/toast.dart';

import 'global.dart';
//import 'package:permission_handler/permission_handler.dart';

void d(data, [index = 1]) {
  if (!isdebug) {
    return;
  }
  Iterable<String> lines =
      StackTrace.current.toString().trimRight().split('\n');
  var line = lines.elementAt(index);
  print('输出内容');
  print(data);
  print('行号' + line);
}

//弹出消息提示
void show(BuildContext context, String msg, [ToastPostion positions]) {
  if (!isnull(context)) {
    return;
  }
  if (positions != null) {
    Toast.toast(context, msg: msg, position: positions);
  } else {
    Toast.toast(context, msg: msg, position: ToastPostion.bottom);
  }
}

// showbox(
//   Widget body, [
//   Color bgcolor = Colors.white10,
//   double radius = 10,
//   bool showclosebtn = true,
//   double width,
// ]) {
//   var w = isnull(width) ? width : getScreenWidth(g('context')) * .8;
//   var c = Container(
//     child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Container(
//             // padding: EdgeInsets.all(4),
//             decoration: new BoxDecoration(
//                 color: bgcolor,
//                 borderRadius: new BorderRadius.circular(radius)),
//             child: body,
//             width: w,
//             // height: 250,
//           ),
//           showclosebtn
//               ? GestureDetector(
//                   onTap: () {
//                     // pop(g('context'));
//                   },
//                   child: Container(
//                     margin: EdgeInsets.all(14),
//                     padding: EdgeInsets.all(4),
//                     decoration: new BoxDecoration(
//                       borderRadius: new BorderRadius.circular(25),
//                       border: new Border.all(color: bgcolor, width: 2),
//                     ),
//                     child: Icon(
//                       Icons.clear,
//                       size: 25,
//                       color: bgcolor,
//                     ),
//                   ),
//                 )
//               : Container()
//         ]),
//   );
//   showDialog(context: g('context'), barrierDismissible: true, child: c);
// }

Future msgbox(BuildContext context, Function event,
    [Widget title, Widget body, Widget canceltitle, Widget oktitle]) async {
  if (!isnull(context)) {
    return Container();
  }
  title = isnull(title) ? title : Text(lang('提示'));
  body = isnull(body) ? body : Text(lang('是否删除'));
  canceltitle = isnull(canceltitle) ? canceltitle : Text(lang('取消'));
  oktitle = isnull(oktitle) ? oktitle : Text(lang('确认'));
  final action = await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: title,
        content: body,
        actions: <Widget>[
          TextButton(
            child: canceltitle,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          TextButton(
            child: oktitle,
            onPressed: () {
              Navigator.pop(context);
              event();
            },
          ),
        ],
      );
    },
  );
  return await action;
}

String lang(String s) {
  return s;
}

gethead() {
// apisign
  //Map m={'timestamp':gettime(),'version':g('version'),'devicetype':g('deviceid')};
  Map m = {
    'Content-Type': 'application/x-www-form-urlencoded',
    'timestamp'.toString(): gettime().toString(),
    // 'version'.toString(): g('version').toString(),
    // 'idfa': g('idfa'),
    // 'lang': getlang(),
    "x-token": "EEE99B99DD275CBDFFD8695D5A8FD091",
    // 'qd': downqd,
    // 'devicetype'.toString(): Platform.isAndroid ? 'android' : 'ios'
  };

  // var user = User.get();
  // if (isnull(user)) {
  //   m.addAll({
  //     'uid'.toString(): user['uid'].toString(),
  //     'token'.toString(): user['token'].toString()
  //   });
  // }
  var ret = new Map<String, dynamic>.from(m);

  return ret;
}

// ignore: missing_return
// Future<String> getwifi() async {
//   var connectivityResult = await (Connectivity().checkConnectivity());
//   if (connectivityResult == ConnectivityResult.mobile) {
//     // 网络类型为移动网络
//     return 'mobile';
//   } else if (connectivityResult == ConnectivityResult.wifi) {
//     // 网络类型为WIFI
//     return 'wifi';
//   }
//   return 'none';
// }

Future<ui.Image> getAssetImage(String asset, {width, height}) async {
  ByteData data = await rootBundle.load(asset);

  ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
      targetWidth: width, targetHeight: height);

  ui.FrameInfo fi = await codec.getNextFrame();
  return fi.image;
}

getcache(key, [bool needid = true]) {
  var cache = g('cache');
  String name;
  name = key;
  // if (needid) {
  //   int id = User.getuid();
  //   if (id == 0) {
  //     name = key;
  //   } else {
  //     name = key + id.toString();
  //   }
  // } else {
  //   name = key;
  // }

  // name = name + g('locallg');
  var data = cache.get(name);
  return data;
}

getuser() {
  // var user = User.get();

  // if (!isnull(user)) return false;
  // return user;
}

getuid() {
  // var user = User.get();
  // if (!isnull(user)) return '0';
  // return user['uid'];
}

setcache(String key, val, String time, [bool needid = true]) {
  var cache = g('cache');
  String name;
  name = key;
  // if (User.islogin()) {
  //   if (needid) {
  //     String id = User.getuid().toString();
  //     name = key + id;
  //   } else {
  //     name = key;
  //   }
  // } else {
  //   name = key;
  // }
  // name = name + g('locallg');
  var data = cache.set(name, val, time);
  return data;
}

String gettime() {
  var tmp = new DateTime.now().millisecondsSinceEpoch;
  tmp = (tmp / 1000).round();
  return tmp.toString();
}

String getmirtime() {
  var tmp = new DateTime.now().millisecondsSinceEpoch;
  // tmp = (tmp / 1000).round() as int;
  return tmp.toString();
}

titlebarcolor(bool lightDark) {
  SystemChrome.setSystemUIOverlayStyle(
      lightDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark);
}

//隐藏状态栏
hidetitlebar() async {
  await SystemChrome.setEnabledSystemUIOverlays([]);
}

//显示状态栏
showtitlebar() {
  SystemChrome.setEnabledSystemUIOverlays(
      [SystemUiOverlay.top, SystemUiOverlay.bottom]);
}

/** 复制到剪粘板 */
copyToClipboard(final String text) async {
  if (text == null) return;
  Clipboard.setData(new ClipboardData(text: text));
}

const RollupSize_Units = ["GB", "MB", "KB", "B"];
/** 返回文件大小字符 */
String getRollupSize(int size) {
  int idx = 3;
  int r1 = 0;
  String result = "";
  while (idx >= 0) {
    int s1 = size % 1024;
    size = size >> 10;
    if (size == 0 || idx == 0) {
      r1 = (r1 * 100) ~/ 1024;
      if (r1 > 0) {
        if (r1 >= 10)
          result = "$s1.$r1${RollupSize_Units[idx]}";
        else
          result = "$s1.0$r1${RollupSize_Units[idx]}";
      } else
        result = s1.toString() + RollupSize_Units[idx];
      break;
    }
    r1 = s1;
    idx--;
  }
  return result;
}

/** 返回两个日期相差的天 */
int daysBetween(DateTime a, DateTime b, [bool ignoreTime = false]) {
  if (ignoreTime) {
    int v = a.millisecondsSinceEpoch ~/ 86400000 -
        b.millisecondsSinceEpoch ~/ 86400000;
    if (v < 0) return -v;
    return v;
  } else {
    int v = a.millisecondsSinceEpoch - b.millisecondsSinceEpoch;
    if (v < 0) v = -v;
    return v ~/ 86400000;
  }
}

/** 获取屏幕宽度 */
double getScreenWidth(BuildContext context) {
  if (!isnull(context)) return 0.0;
  return MediaQuery.of(context).size.width;
}

/** 获取屏幕高度 */
double getScreenHeight(BuildContext context) {
  if (!isnull(context)) return 0.0;
  return MediaQuery.of(context).size.height;
}

/** 获取系统状态栏高度 */
double getSysStatsHeight(BuildContext context) {
  if (!isnull(context)) return 0.0;
  return MediaQuery.of(context).padding.top;
}

//判断对象是否存在
bool isnull(dynamic data, [var index]) {
  if (null == data) {
    return false;
  }
  if (data is String) {
    //d('是string');
    data = data.trim();
    if ('null' == data) {
      return false;
    }
    if ('' == data) {
      return false;
    }
    if ('0' == data) {
      return false;
    }
  }
  if (data is int) {
    if (0 == data) {
      return false;
    }
  }
  if (data is bool) {
    return data;
  }
  // if ( data  is Object ) {
  //    d('是Object');
  //   return false;
  // }
  if (data is List) {
    if (data.length == 0) {
      return false;
    }
    // d('是List');
  }

  if (data is Map || data is List) {
    if (data.isEmpty) {
      return false;
    }
    if (null != index) {
      // d(data);
      // d(index);
      // d(isnull(data[index]));
      try {
        return isnull(data[index]);
      } catch (e) {
        return false;
      }
    }
    //d('是Map');

  }
  return true;
}

pop(context, [data]) {
  if (!isnull(context)) {
    return false;
  }
  if (isnull(data)) {
    Navigator.pop(context, data);
  } else {
    Navigator.of(context).pop(1);
  }
}

//
setDeviceOrientation([DeviceOrientation fx]) {
  SystemChrome.setPreferredOrientations([fx]);

// SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeLeft, DeviceOrientation.portraitUp]);
}

void selectbox(BuildContext context, List<Widget> childrens) async {
  if (!isnull(context)) return;
  await showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) => Container(
            child: Column(mainAxisSize: MainAxisSize.min, children: childrens),
          ));
}

toint(var str) {
  if (str is int) {
    return str;
  }
  if (str is String) {
    return int.parse(str);
  }
  return 0;
}

//强制竖屏
screenS() async {
  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
}

//强制横屏
screenH() async {
  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
}

//获取屏幕方向
getscreeFx(context) {
  Orientation now = MediaQuery.of(context).orientation;
  // final orientation = NativeDeviceOrientationReader.orientation(context);
  // d('Received new orientation: $orientation');
  // d(now);
  if (Orientation.portrait == now) {
    //返回竖屏
    return 's';
  }
  //返回横屏
  return 'h';
}
