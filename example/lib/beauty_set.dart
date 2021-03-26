import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'dart:core';

import 'package:zego_faceunity_plugin/zego_faceunity_plugin.dart';

import 'package:zego_express_engine/zego_express_engine.dart';
import 'package:zego_faceunity_plugin_example/utils/base.dart';

import 'package:zego_faceunity_plugin_example/utils/zego_config.dart';

class BeautySet extends LoginBase {
  int beatnselect = 0;
  List<Map<String, dynamic>> beautyParamList = [
    {'name': '美白', 'value': 1.0, 'min': 0.0, 'max': 2.0},
    {'name': '红润', 'value': 0.5, 'min': 0.0, 'max': 2.0},
    {'name': '磨皮', 'value': 4.2, 'min': 0.0, 'max': 6.0},
    {'name': '大眼', 'value': 0.4, 'min': 0.0, 'max': 1.0},
    {'name': '瘦脸', 'value': 0.0, 'min': 0.0, 'max': 1.0},
    {'name': 'V脸', 'value': 0.5, 'min': 0.0, 'max': 1.0},
    {'name': '窄脸', 'value': 0.0, 'min': 0.0, 'max': 1.0},
    {'name': '小脸', 'value': 0.0, 'min': 0.0, 'max': 1.0},
    {'name': '下巴', 'value': 0.3, 'min': 0.0, 'max': 1.0},
    {'name': '额头', 'value': 0.3, 'min': 0.0, 'max': 1.0},
    {'name': '鼻子', 'value': 0.5, 'min': 0.0, 'max': 1.0},
    {'name': '嘴型', 'value': 0.4, 'min': 0.0, 'max': 1.0},
  ];
  BeautySet({Key key});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      color: Color.fromRGBO(0, 0, 0, 0.8),
      padding: EdgeInsets.only(left: 20, right: 20),
      height: 150.0,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
            children: [
              Expanded(
                child: CupertinoSlider(
                  value: beautyParamList[beatnselect]['value'],
                  min: beautyParamList[beatnselect]['min'],
                  max: beautyParamList[beatnselect]['max'],
                  divisions: 20,
                  onChanged: (value) {
                    setState(() {
                      //调整美颜参数
                      beautyParamList[beatnselect]['value'] = value;
                      setBeautyOption(beatnselect);
                    });
                  },
                ),
              )
            ],
          ),
          Container(
              height: 100.0,
              child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: beautyParamList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(children: [
                      beatbtn(index),
                    ]);
                  }))
        ],
      ),
    );
  }

  Widget beatbtn(int index) {
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
            color: index == beatnselect ? Colors.red : Colors.white,
          ),
          Text(
            beautyParamList[index]['name'],
            style: TextStyle(color: Colors.white, fontSize: 12),
          )
        ],
      ),
      onPressed: () {
        setState(() {
          beatnselect = index;
        });
      },
    );
  }

  void setBeautyOption(int index) {
    //设置美颜效果
    print('cureent value: ${beautyParamList[index]['value']}');
    switch (beautyParamList[index]['name']) {
      case '美白':
        ZegoFaceunityPlugin.instance
            .setBeautyOption(faceWhiten: beautyParamList[index]['value']);
        break;
      case '红润':
        ZegoFaceunityPlugin.instance
            .setBeautyOption(faceRed: beautyParamList[index]['value']);
        break;
      case '磨皮':
        ZegoFaceunityPlugin.instance
            .setBeautyOption(faceBlur: beautyParamList[index]['value']);
        break;
      case '大眼':
        ZegoFaceunityPlugin.instance
            .setBeautyOption(eyeEnlarging: beautyParamList[index]['value']);
        break;
      case '瘦脸':
        ZegoFaceunityPlugin.instance
            .setBeautyOption(cheekThinning: beautyParamList[index]['value']);
        break;
      case 'V脸':
        ZegoFaceunityPlugin.instance
            .setBeautyOption(cheekV: beautyParamList[index]['value']);
        break;
      case '窄脸':
        ZegoFaceunityPlugin.instance
            .setBeautyOption(cheekNarrow: beautyParamList[index]['value']);
        break;
      case '小脸':
        ZegoFaceunityPlugin.instance
            .setBeautyOption(cheekSmall: beautyParamList[index]['value']);
        break;
      case '下巴':
        ZegoFaceunityPlugin.instance
            .setBeautyOption(chinLevel: beautyParamList[index]['value']);
        break;
      case '额头':
        ZegoFaceunityPlugin.instance
            .setBeautyOption(foreHeadLevel: beautyParamList[index]['value']);
        break;
      case '鼻子':
        ZegoFaceunityPlugin.instance
            .setBeautyOption(noseLevel: beautyParamList[index]['value']);
        break;
      case '嘴型':
        ZegoFaceunityPlugin.instance
            .setBeautyOption(mouthLevel: beautyParamList[index]['value']);
        break;
    }
  }
}
