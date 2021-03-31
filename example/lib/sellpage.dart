import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

import 'dart:core';

import 'package:zego_faceunity_plugin/zego_faceunity_plugin.dart';

import 'package:zego_express_engine/zego_express_engine.dart';
import 'package:zego_faceunity_plugin_example/model/course.dart';
import 'package:zego_faceunity_plugin_example/model/sec.dart';
import 'package:zego_faceunity_plugin_example/model/vip.dart';
import 'package:zego_faceunity_plugin_example/tool/function.dart';
import 'package:zego_faceunity_plugin_example/tool/global.dart';
import 'package:zego_faceunity_plugin_example/tool/http.dart';
import 'package:zego_faceunity_plugin_example/tool/loadbox.dart';
import 'package:zego_faceunity_plugin_example/utils/base.dart';

import 'package:zego_faceunity_plugin_example/utils/zego_config.dart';

import 'model/im.dart';
import 'tool/image.dart';

class Sellpage extends LoginBase {
  //是否选中
  static bool select = false;
  //是否编辑中
  static bool editing = false;
  //被编辑的课程
  static Course coursein;
  static String api = 'SellGoods/getAllCourses';
  //课程列表
  static List courses = [];
  static String cacheindex = 'Sellpage';
  static String cachetime;

  static TextEditingController searword = new TextEditingController();
  // static TextEditingController cost = new TextEditingController();
  static TextEditingController seccost = new TextEditingController();
  // static TextEditingController acttime = new TextEditingController();
  static String actime;
  FocusNode _focusNode = FocusNode();
  bool loading = false;
  var btnpadding = EdgeInsets.only(top: 6.0, left: 14, right: 14, bottom: 6);
  initState() {
    editing = false;
    cachetime = cacheindex + cacheindex.hashCode.toString();
    //初始化数据
    initcache();
    //判断过期
    checkoutcache();
  }

//加载数据缓存
  initcache() {
    courses = getcache(cacheindex);
  }

  checkoutcache() {
    var cacheout = getcache(cachetime);

    if (!isnull(cacheout)) {
      httpget();
    }
  }

  //拉取远程数据
  httpget() async {
    var data = await http(
      api,
      {
        // 'type': 'series',
        'page': '1',
        'limit': '30',
      },
      gethead(),
    );
    var ret = getdata(context, data);
    if (isnull(ret)) {
      courses = ret;
      setcache(cacheindex, ret, '-1');
      setcache(cachetime, 1, '30');
      reflash();
    }
  }

  search(String word) async {
    if (!isnull(word)) {
      show(context, '请输入相关课程名称');
      return;
    }
    var data = await http(
      api,
      {
        'search': word,
        'page': '1',
        'limit': '30',
      },
      gethead(),
    );
    var ret = getdata(context, data);
    if (isnull(ret)) {
      courses = ret;
      // setcache(cacheindex, ret, '-1');
      // setcache(cachetime, 1, '30');
      reflash();
    }
  }

  dispose() {
    // d(1111);
  }

  Sellpage({Key key});
  @override
  Widget build(BuildContext context) {
    s('context', context);
    Widget w = SingleChildScrollView(
        child: !editing
            ? Container(
                color: Color.fromRGBO(0, 0, 0, 0.8),
                padding: EdgeInsets.only(left: 20, right: 20),
                height: g('h') * 0.5,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(
                      height: 18,
                    ),
                    buildserechbtn(),
                    SizedBox(
                      height: 18,
                    ),
                    Expanded(
                        child: Container(
                            height: 100.0,
                            child: ListView.builder(
                                shrinkWrap: true,
                                // scrollDirection: Axis.horizontal,
                                itemCount: courses.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Column(children: [
                                    beatbtn(index),
                                  ]);
                                })))
                  ],
                ))
            : edit());
    return Loadbox(
      loading: loading,
      child: w,
      // bgColor: Colors.red,
    );
  }

  //搜索框栏目
  Widget buildserechbtn() {
    var w = getScreenWidth(context);
    var color = Color(0xff292A33);
    var textFormField = new TextFormField(
      maxLines: 1,
      controller: searword,
      onChanged: (str) {
        // ? haveword = true : haveword = false;
      },
      onEditingComplete: () {
        _search();
      },
      decoration: new InputDecoration(
          contentPadding: EdgeInsets.only(top: -4.0, left: 14, right: 14),
          hintText: lang("输入课程名称"),
          hintStyle: new TextStyle(color: Color(0xff999999)),
          border: InputBorder.none),
      style: new TextStyle(fontSize: 16, color: Colors.white),
      //验证
      validator: (String value) {
        // if (value.isEmpty) {
        //   cansubmit = cansubmit && false;
        //   return lang('请填写账号');
        // }
        return '';
      },
      onSaved: (value) {},
    );

    // var  = textFormField2;
    var c = Container(
      decoration: BoxDecoration(
        //中间按钮背景框
        borderRadius: BorderRadius.all(Radius.circular(25)),
        color: color,
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: textFormField,
            ),
            GestureDetector(
              child: Container(
                  margin: EdgeInsets.only(right: 14),
                  child: Icon(
                    Icons.close,
                    color: Colors.grey[200],
                    size: 30,
                  )),
              onTap: _clearword,
            ),
          ],
        ),
      ),
    );
    return c;
  }

  _search() {
    search(searword.text);
  }

  _clearword() {
    searword.clear();
    initcache();
    reflash();
  }

  Widget beatbtn(int index) {
    Course course = Course.fromJson(courses[index]);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
            child: Container(
                margin: EdgeInsets.only(bottom: 18),
                padding: EdgeInsets.all(18),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Color(0xff292A33),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
//图片
                    NgImage(
                      course.pic,
                      width: g('w') * 0.4,
                      height: g('w') * 0.4 / 1.65,
                    ),
//文字
                    SizedBox(
                      width: 18,
                    ),
                    Expanded(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              course.name,
                              style: TextStyle(
                                  color: Color(0xffFFFFFF),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15),
                            ),
                            SizedBox(
                              height: 6,
                            ),
                            Text(
                              "" +
                                  course.sec.toString() +
                                  "课/共" +
                                  course.coursenum.toString() +
                                  "课",
                              style: TextStyle(
                                  color: Color(0xffFFFFFF),
                                  // fontWeight: FontWeight.bold,
                                  fontSize: 13),
                            ),
                            SizedBox(
                              height: 6,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        '￥',
                                        style: TextStyle(
                                            color: Color(0xffFF0000),
                                            // fontWeight: FontWeight.bold,
                                            fontSize: 8),
                                      ),
                                      Text(course.cost.toString(),
                                          style: TextStyle(
                                              color: Color(0xffFF0000),
                                              // fontWeight: FontWeight.bold,
                                              fontSize: 13)),
                                    ]),
                                Expanded(child: SizedBox()),
                                editbtn('编辑', course, () {
                                  _edit(course);
                                }),
                                SizedBox(
                                  width: 8,
                                ),
                                editbtn('上架', course, () {
                                  d('直接上架');
                                  if (!course.up) {
                                    course.up = true;
                                    Im.sendGood(course);
                                  }
                                }),
                              ],
                            ),
                          ]),
                    )
                  ],
                )))
      ],
    );
  }

  gettitle(String title) {
    TextStyle t1style = TextStyle(fontSize: 16, color: Colors.white);
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      // margin: EdgeInsets.all(20),
      child: Text(
        title,
        style: t1style,
      ),
    );
  }

  getinut(String hint, TextEditingController control, [FocusNode node]) {
    var inputField = new TextFormField(
      focusNode: isnull(node) ? node : null,
      maxLines: 1,
      controller: control,
      onChanged: (str) {
        // ? haveword = true : haveword = false;
      },
      onEditingComplete: () {},
      decoration: new InputDecoration(
          contentPadding: EdgeInsets.only(left: 14, right: 14, top: -8),
          hintText: hint,
          hintStyle: new TextStyle(color: Color(0xff414352)),
          border: InputBorder.none),
      style: new TextStyle(fontSize: 15, color: Colors.white),
      //验证
      validator: (String value) {
        return '';
      },
      onSaved: (value) {},
    );
    return Container(
      child: Center(
        child: inputField,
      ),
      height: 40,
      width: 100,
      margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
          color: Color(0xff414352), borderRadius: BorderRadius.circular(6.0)),
    );
  }

  getinutcost(String hint, TextEditingController control, [FocusNode node]) {
    var inputField = new TextFormField(
      focusNode: isnull(node) ? node : null,
      maxLines: 1,
      controller: control,
      onChanged: (str) {
        // ? haveword = true : haveword = false;
        // RegExp reg = new RegExp(r'^\d{1}[\d,\.]{0,}$');
        // if (!reg.hasMatch(str)) {
        //   d(str);
        //   return '';
        // }
      },
      onEditingComplete: () {},
      decoration: new InputDecoration(
          contentPadding: EdgeInsets.only(left: 14, right: 14, top: -8),
          hintText: hint,
          hintStyle: new TextStyle(color: Colors.white),
          border: InputBorder.none),
      style: new TextStyle(fontSize: 15, color: Colors.white),
      //验证
      validator: (String value) {
        // RegExp reg = new RegExp(r'^\d{11}$');
        // if (!reg.hasMatch(value)) {
        //   return '请输入正确金额';
        // }
        return null;
      },
      onSaved: (value) {},
    );
    return Container(
      child: Center(
        child: inputField,
      ),
      height: 40,
      width: 100,
      margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
          color: Color(0xff414352), borderRadius: BorderRadius.circular(6.0)),
    );
  }

  Widget edit() {
    Widget w = Container(
      padding: EdgeInsets.only(left: 20, right: 20, top: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 10,
                ),
                // gettitle('修改直播间优惠价格'),
                // getinut('请输入价格', cost),
                gettitle('活动结束时间'),
                Row(
                  children: [
                    Expanded(
                        child: secbtn(
                            !isnull(actime) ? '请选择活动结束时间' : actime, false, () {
                      picktime();
                    })),
                    // Expanded(child: getinut('请输入价格', acttime, _focusNode))
                  ],
                ),
                Container(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          gettitle('课时列表'),
                          Container(
                            height: g('h') * 0.3,
                            width: g('w') * 0.35,
                            child: ListView(
                              shrinkWrap: true,
                              children: [
                                secbtn(
                                    '全选',
                                    selectsec.length >= coursein.tmpsecs.length,
                                    secall),
                                Column(
                                  children: getseclist(),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                      Expanded(
                          child: Container(
                        child: Center(
                          child: SizedBox(
                            width: 1,
                            height: g('h') * 0.2,
                            child: DecoratedBox(
                              decoration:
                                  BoxDecoration(color: Color(0xff414352)),
                            ),
                          ),
                        ),
                      )),
                      Container(
                          // height: g('h') * 0.3,
                          width: g('w') * 0.35,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              gettitle('配置费用类型'),
                              selectboxw(sexname[isfree], zxf),
                              isfree == '1'
                                  ? selectboxw(
                                      Vip.getindec(viplevel)['name'], setvip)
                                  : Container(),
                              isfree == '2'
                                  ? Row(
                                      children: [
                                        Expanded(
                                            child:
                                                getinutcost('请输入价格', seccost))
                                      ],
                                    )
                                  : Container(),
                              Row(
                                children: [
                                  Expanded(
                                      child: btn('设置选中', Color(0xffFF1425), () {
                                    //循环设置各个章节
                                    if (isfree == '0') {
                                      show(context, '请选择费用类型');
                                      return '';
                                    }
                                    if (selectsec.length <= 0) {
                                      show(context, '请选择要设置的课时');
                                      return '';
                                    }
                                    double coin;
                                    RegExp reg =
                                        new RegExp(r'^\d{1}[\d,\.]{0,}$');

                                    for (var index in selectsec) {
                                      if (isfree == '1') {
                                        coursein.secs[index].setvip(viplevel);
                                      }
                                      if (isfree == '2') {
                                        if (!reg.hasMatch(seccost.text)) {
                                          d('请输入正确的金额');
                                          return '';
                                        }
                                        coin = double.parse(seccost.text);
                                        coursein.secs[index].setcost(coin);
                                      }
                                    }
                                    //取消全选
                                    secall();
                                  }))
                                ],
                              ),
                            ],
                          )),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Expanded(
                  child: btn('确定并上架', Color(0xff416FFF), () async {
                //这里生成post数据
                loading = true;
                reflash();

                var post = {
                  'course_id': coursein.id,
                  'sec_data': jsonEncode(coursein.getsecjson()),
                  'event_time': actime,
                  'from_sec_id': ZegoConfig.instance.streamID,
                };
                //生成活动id

                //发送消息
                var ret = await createact(post);
                if (isnull(ret)) {
                  d('send');
                  d(ret);
                  Im.sendGood(coursein, ret['act_id'], ret['all_price']);
                  //弹出
                  pop(context);
                }
                // Im.sendGood(coursein);
                loading = false;
                reflash();
              })),
            ],
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );

    return w;
  }

  //创建活动
  createact(post) async {
    String actapi = 'SellGoods/putOnCourse';
    var data = await http(actapi, post, gethead());
    var ret = getdata(context, data);
    if (isnull(ret)) {
      return ret;
    }
    return null;
  }

  picktime() {
    // DateTimePickerModel
    DatePicker.showDateTimePicker(context,
        locale: LocaleType.zh,
        // 是否展示顶部操作按钮
        showTitleActions: true,
        // 最小时间
        // minTime: DateTime(2018, 3, 5),
        // 最大时间
        minTime: DateTime.now(),
        // change事件
        onChanged: (date) {},
        // 确定事件
        onConfirm: (date) {
      actime = date.toString();

      reflash();
    });
  }

//选中的章节
  Widget selectboxw(String txt, Function call) {
    Widget opetion = GestureDetector(
      child: Container(
        // width: g('w') * 0.35,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(txt, style: new TextStyle(fontSize: 15, color: Colors.white)),
            Icon(Icons.arrow_drop_down),
          ],
        ),
        margin: EdgeInsets.only(bottom: 10),
        padding: EdgeInsets.only(top: 6.0, left: 14, right: 0, bottom: 6),
        decoration: BoxDecoration(
            color: Color(0xff414352), borderRadius: BorderRadius.circular(6.0)),
      ),
      onTap: call,
    );
    return Row(
      children: [Expanded(child: opetion)],
    );
  }

  List selectsec = [];
  getseclist() {
    List<Widget> secwidget = [];
    for (var i = 0; i < coursein.tmpsecs.length; i++) {
      secwidget.add(getsecwidget(i));
    }
    return secwidget;
  }

  getsecwidget(index) {
    //判断是否选中
    //选中就变色
    if (!isnull(coursein.secs)) {
      return Container();
    }
    Sec thissec = coursein.secs[index];
    int ins = selectsec.indexOf(index);
    String txt = thissec.orders.toString() +
        '|' +
        (thissec.isfree
            ? Vip.getindec(thissec.viplevel)['name']
            : ("￥" + thissec.cost.toString()));
    bool ison = ins != -1;
    Function call = () {
      secon(thissec);
    };
    return secbtn(txt, ison, call);
  }

  secon(Sec sec) {
    int index = sec.orders - 1;
    int ins = selectsec.indexOf(index);
    if (ins != -1) {
      selectsec.remove(index);
    } else {
      selectsec.add(index);
    }
    reflash();
  }

  secall() {
    if (selectsec.length > 0) {
//清空
      selectsec = [];
    } else {
//全选
      selectsec =
          List<int>.generate(coursein.secs.length, (int index) => index);
    }
    reflash();
  }

  zxf() {
    selectbox(context, _sex());
  }

  setvip() {
    selectbox(context, _vip());
  }

  secbtn(String txt, bool ison, Function call) {
    var tn = new TextStyle(fontSize: 15, color: Colors.white);
    var tun = new TextStyle(fontSize: 15, color: Color(0xff416FFF));
    var bun = Color(0x20416FFF);
    var bn = Color(0xff414352);
    return GestureDetector(
      child: Container(
        width: g('w') * 0.35,
        child: Center(
          child: Text(txt, style: ison ? tun : tn),
        ),
        margin: EdgeInsets.only(bottom: 10),
        padding: btnpadding,
        decoration: BoxDecoration(
            color: ison ? bun : bn,
            border: !ison
                ? Border.all(width: 1)
                : new Border.all(
                    //边框颜色
                    color: new Color(0xFF416FFF),
                    //边框宽1
                    width: 1),
            borderRadius: BorderRadius.circular(6.0)),
      ),
      onTap: () {
        call();
      },
    );
  }

  static String isfree = '0';
  var sexname = {'0': '请选择', '1': lang('免费'), '2': lang('收费')};
  List<Widget> _sex() {
    var values = {'0', '1', '2'};
    return values.map((local) {
      return ListTile(
        title: Text(
          "${sexname[local]}",
          textAlign: TextAlign.center,
          // style: TextStyle(
          //     color: local == sexid ? SQColor.primary : SQColor.darkGray),
        ),
        onTap: () {
          //取消聚焦
          FocusScope.of(context).requestFocus(FocusNode());
          if (local == '0') {
            show(context, '请选择费用类型');
            return;
          }
          if (local == '1') {}
          if (local == '2') {
            // 聚焦
            // FocusScope.of(context).requestFocus(_focusNode);/
          }
          isfree = local;
          pop(context);
          reflash();
        },
      );
    }).toList();
  }

  int viplevel = 0;
  List<Widget> _vip() {
    List values = Vip.getvipkey();
    return values.map((local) {
      return ListTile(
        title: Text(
          Vip.getindec(local)['name'],
          textAlign: TextAlign.center,
        ),
        onTap: () {
          viplevel = local;
          d(viplevel);
          pop(context);
          reflash();
        },
      );
    }).toList();
  }

  Widget btn(String txt, Color color, Function fun) {
    return CupertinoButton(
      padding: btnpadding,
      minSize: 30,
      pressedOpacity: 1.0,
      borderRadius: BorderRadius.circular(6.0),
      color: color,
      child: Text(
        txt,
        style: TextStyle(color: Colors.white, fontSize: 15),
      ),
      onPressed: () async {
        fun();
      },
    );
  }

  Widget editbtn(String title, Course course, Function call) {
    return CupertinoButton(
      padding: const EdgeInsets.all(6.0),
      minSize: 30,
      pressedOpacity: 1.0,
      borderRadius: BorderRadius.circular(6.0),
      color: Color(0xffFF8A00),
      child: Text(
        title,
        style: TextStyle(color: Colors.white, fontSize: 12),
      ),
      onPressed: () async {
        call();
      },
    );
  }

  _edit(Course course) async {
    coursein = course;
    editing = true;
    await course.initsec();
    reflash();
  }
}
