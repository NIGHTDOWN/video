import 'package:zego_faceunity_plugin_example/model/course.dart';
import 'package:zego_faceunity_plugin_example/tool/function.dart';
import 'package:zego_faceunity_plugin_example/tool/global.dart';
import 'package:zego_faceunity_plugin_example/tool/http.dart';

class Vip {
  static List vip = [
    {'name': '免费'},
    {'name': '初级VIP'},
    {'name': '高级VIP'},
    {'name': '合伙人'},
  ];
  static getindec(int viplevel) {
    return vip[viplevel];
  }

  static getvip() {
    return vip;
  }

  static getvipkey() {
    return List<int>.generate(vip.length, (int index) => index);
  }
}
