import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'dart:core';

import 'package:zego_faceunity_plugin/zego_faceunity_plugin.dart';

import 'package:zego_express_engine/zego_express_engine.dart';
import 'package:zego_faceunity_plugin_example/model/course.dart';
import 'package:zego_faceunity_plugin_example/tool/function.dart';
import 'package:zego_faceunity_plugin_example/tool/global.dart';
import 'package:zego_faceunity_plugin_example/tool/http.dart';
import 'package:zego_faceunity_plugin_example/utils/base.dart';

import 'package:zego_faceunity_plugin_example/utils/zego_config.dart';

import 'tool/image.dart';

class Sellpage extends LoginBase {
  //是否选中
  static bool select = false;
  //是否编辑中
  static bool editing = false;
  //被编辑的课程
  static Course coursein;
  static String api = 'Course/getLiveClassSeries';
  //课程列表
  static List courses = [];
  static String cacheindex = 'Sellpage';
  static String cachetime;

  static TextEditingController searword = new TextEditingController();
  static TextEditingController cost = new TextEditingController();
  static TextEditingController seccost = new TextEditingController();
  static TextEditingController acttime = new TextEditingController();
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
        'type': 'series',
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

  dispose() {
    // d(1111);
  }

  Sellpage({Key key});
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
    d(searword.text);
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
                                editbtn(course),
                                SizedBox(
                                  width: 8,
                                ),
                                editbtn(course),
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

  getinut(String hint, TextEditingController control) {
    var inputField = new TextFormField(
      maxLines: 1,
      controller: control,
      onChanged: (str) {
        // ? haveword = true : haveword = false;
      },
      onEditingComplete: () {},
      decoration: new InputDecoration(
          contentPadding: EdgeInsets.only(top: -4.0, left: 14, right: 14),
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
      child: inputField,
      margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
          color: Color(0xff414352), borderRadius: BorderRadius.circular(6.0)),
    );
  }

  Widget edit() {
    return Container(
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
                getinut('请输入价格', acttime),
                gettitle('课时配置'),
                Container(
                  height: g('h') * 0.3,
                  child: Row(
                    children: [
                      SizedBox(
                        width: 1,
                      ),
                      Column(
                        children: [
                          GestureDetector(
                            child: Text('data'),
                            onTap: zxf,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Row(),
          Row(),
        ],
      ),
    );
  }

  zxf() {
    selectbox(context, _sex());
  }

  List<Widget> _sex() {
    var values = {'1', '2'};
    var sexname = {'1': lang('男'), '2': lang('女')};
    return values.map((local) {
      return ListTile(
        title: Text(
          "${sexname[local]}",
          textAlign: TextAlign.center,
          // style: TextStyle(
          //     color: local == sexid ? SQColor.primary : SQColor.darkGray),
        ),
        onTap: () {
          // sexid = local;
          // sex = sexname[local];
          // Navigator.pop(context);
          // if (sexid != user['sex'].toString() && sexid != '0') {
          //   post = true;
          // }
          // if (sexid == '0') {
          //   post = false;
          // }
          reflash();
        },
      );
    }).toList();
  }

  Widget editbtn(Course course) {
    return CupertinoButton(
      padding: const EdgeInsets.all(6.0),
      minSize: 30,
      pressedOpacity: 1.0,
      borderRadius: BorderRadius.circular(6.0),
      color: Color(0xffFF8A00),
      child: Text(
        '编辑',
        style: TextStyle(color: Colors.white, fontSize: 12),
      ),
      onPressed: () {
        coursein = course;
        editing = true;
        reflash();
      },
    );
  }
}
