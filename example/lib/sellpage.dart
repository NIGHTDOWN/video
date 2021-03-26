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
  bool select;
  String api = 'Course/getLiveClassSeries';
  //课程列表
  List courses = [];
  String cacheindex = 'Sellpage';
  String cachetime;

  TextEditingController searword = new TextEditingController();
  initState() {
    cachetime = cacheindex + cacheindex.hashCode.toString();
    //初始化数据
    initcache();
    //判断过期
    checkoutcache();
  }

//加载数据缓存
  initcache() {
    courses = getcache(cacheindex);
    // d(courses);
  }

  checkoutcache() {
    var cacheout = getcache(cachetime);
    // d(cacheout);
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

  Sellpage({Key key});
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Container(
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
      ),
    ));
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
                  margin: EdgeInsets.only(right: 4),
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

  _search() {}
  _clearword() {
    searword.clear();
    initcache();
    reflash();
  }

  Widget beatbtn(int index) {
    return Row(
      children: [
        Expanded(
            child: CupertinoButton(
                borderRadius: BorderRadius.circular(0.0),
                child: Row(
                  children: [
//图片
                    NgImage(courses[index]['pic']),
//文字
                  ],
                )))
      ],
    );
    return CupertinoButton(
      // padding: const EdgeInsets.all(10.0),
      pressedOpacity: 1.0,
      borderRadius: BorderRadius.circular(0.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.cast,
            size: 50.0,
            color: index == select ? Colors.red : Colors.white,
          ),
          Text(
            select.toString(),
            style: TextStyle(color: Colors.white, fontSize: 12),
          )
        ],
      ),
      onPressed: () {
        setState(() {
          // beatnselect = index;
        });
      },
    );
  }
}
