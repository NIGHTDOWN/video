import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:orientation/orientation.dart';
import 'dart:core';
import 'package:zego_express_engine/zego_express_engine.dart';
import 'package:zego_faceunity_plugin_example/beauty_set.dart';
import 'package:zego_faceunity_plugin_example/model/msg.dart';
import 'package:zego_faceunity_plugin_example/model/rtmpbase.dart';
import 'package:zego_faceunity_plugin_example/page/msg/msgwidget.dart';
import 'package:zego_faceunity_plugin_example/sellpage.dart';
import 'package:zego_faceunity_plugin_example/tool/function.dart';
import 'package:zego_faceunity_plugin_example/tool/global.dart';
import 'package:zego_faceunity_plugin_example/utils/base.dart';
import 'package:zego_faceunity_plugin_example/utils/zego_config.dart';

// import 'manager/screen_capture_manager.dart';

// ignore: must_be_immutable
class RtmpInS extends LoginBase {
  String _streamID = '';

  bool _isPlaying = false;
  bool hidebtn = false; //隐藏按钮
  int beatnselect = 0;
  int _publishWidth = 0;
  int _publishHeight = 0;
  double _publishCaptureFPS = 0.0;
  double _publishEncodeFPS = 0.0;
  double _publishSendFPS = 0.0;
  double _publishVideoBitrate = 0.0;
  double _publishAudioBitrate = 0.0;
  bool _isHardwareEncode = false;
  String _networkQuality = '';
  bool _isUseMic = true;

  int screenfx = 3; //横屏旋转方向
  TextEditingController _controller = new TextEditingController();

  bool useSensor = false;
  listScreenFx() {
    OrientationPlugin.onOrientationChange.listen((value) {
      if (!mounted) {
        return;
      }
      if (DeviceOrientation.landscapeLeft == value && screenfx != 1) {
        screenfx = 1;
        reflash();
      }
      if (DeviceOrientation.landscapeRight == value && screenfx != 3) {
        screenfx = 3;
        reflash();
      }
      //这里旋转
      // OrientationPlugin.forceOrientation(value);
    });
  }

  @override
  void initState() {
    super.initState();
    //监听屏幕旋转
    // listScreenFx();
  
    if (ZegoConfig.instance.streamID.isNotEmpty) {
      _controller.text = ZegoConfig.instance.streamID;
    }
    RtmpBase.instance.pullinit();
    setPublisherCallback();
  }

  void setPublisherCallback() {
    // 推流成功的回调处理事件
    ZegoExpressEngine.onPublisherStateUpdate = (String streamID,
        ZegoPublisherState state,
        int errorCode,
        Map<String, dynamic> extendedData) {
      if (errorCode == 0) {
        setState(() {
          _isPlaying = true;
          // _title = '推送中..';
        });

        ZegoConfig.instance.streamID = streamID;
        ZegoConfig.instance.saveConfig();
      } else {
        d('Publish error: $errorCode');
      }
    };
    ZegoExpressEngine.onPlayerStateUpdate = (String streamID,
        ZegoPlayerState state,
        int errorCode,
        Map<String, dynamic> extendedData) {
      print(
          '🚩 📥 Player state update, state: $state, errorCode: $errorCode, streamID: $streamID');
      setState(() {
        _isPlaying = true;
        ZegoConfig.instance.streamID = streamID;
        ZegoConfig.instance.saveConfig();
      });
    };
    //接收消息

    //接收房间消息

    // 推流质量变化处理
    ZegoExpressEngine.onPublisherQualityUpdate =
        (String streamID, ZegoPublishStreamQuality quality) {
      setState(() {
        //推流动态信息
        _publishCaptureFPS = quality.videoCaptureFPS;
        _publishEncodeFPS = quality.videoEncodeFPS;
        _publishSendFPS = quality.videoSendFPS;
        _publishVideoBitrate = quality.videoKBPS;
        _publishAudioBitrate = quality.audioKBPS;
        _isHardwareEncode = quality.isHardwareEncode;

        switch (quality.level) {
          case ZegoStreamQualityLevel.Excellent:
            _networkQuality = '☀️';
            break;
          case ZegoStreamQualityLevel.Good:
            _networkQuality = '⛅️️';
            break;
          case ZegoStreamQualityLevel.Medium:
            _networkQuality = '☁️';
            break;
          case ZegoStreamQualityLevel.Bad:
            _networkQuality = '🌧';
            break;
          case ZegoStreamQualityLevel.Die:
            _networkQuality = '❌';
            break;
          default:
            break;
        }
      });
    };

    // 视频尺寸改变回调处理
    ZegoExpressEngine.onPublisherVideoSizeChanged =
        (int width, int height, ZegoPublishChannel channel) {
      setState(() {
        _publishWidth = width;
        _publishHeight = height;
      });
    };
  }

  @override
  void dispose() {
    super.dispose();
    screenS();
    if (_isPlaying) {
      // 销毁时停止推流
      RtmpBase.instance.stopplay();
    }
  }

  //拉流
  void onPlayButtonPressed() {
    _streamID = _controller.text.trim();
    // Start publishing stream
    //开启推流
    //

    RtmpBase.instance.pull(_streamID);
  }

//显示推流网络状态
  Widget showplayinfo() {
    // d(getscreeFx(context));
    return Container(
        child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10.0),
        ),
        Row(
          children: <Widget>[
            Text(
              'RoomID: ${ZegoConfig.instance.roomID} |  StreamID: ${ZegoConfig.instance.streamID}',
              style: TextStyle(color: Colors.white, fontSize: 9),
            ),
          ],
        ),
        Row(
          children: <Widget>[
            Text(
              'Rendering with: ${ZegoConfig.instance.enablePlatformView ? 'PlatformView' : 'TextureRenderer'}',
              style: TextStyle(color: Colors.white, fontSize: 9),
            ),
          ],
        ),
        Row(
          children: <Widget>[
            Text(
              'Resolution: $_publishWidth x $_publishHeight',
              style: TextStyle(color: Colors.white, fontSize: 9),
            ),
          ],
        ),
        Row(
          children: <Widget>[
            Text(
              'FPS(Capture): ${_publishCaptureFPS.toStringAsFixed(2)}',
              style: TextStyle(color: Colors.white, fontSize: 9),
            ),
          ],
        ),
        Row(
          children: <Widget>[
            Text(
              'FPS(Encode): ${_publishEncodeFPS.toStringAsFixed(2)}',
              style: TextStyle(color: Colors.white, fontSize: 9),
            ),
          ],
        ),
        Row(
          children: <Widget>[
            Text(
              'FPS(Send): ${_publishSendFPS.toStringAsFixed(2)}',
              style: TextStyle(color: Colors.white, fontSize: 9),
            ),
          ],
        ),
        Row(
          children: <Widget>[
            Text(
              'Bitrate(Video): ${_publishVideoBitrate.toStringAsFixed(2)} kb/s',
              style: TextStyle(color: Colors.white, fontSize: 9),
            ),
          ],
        ),
        Row(
          children: <Widget>[
            Text(
              'Bitrate(Audio): ${_publishAudioBitrate.toStringAsFixed(2)} kb/s',
              style: TextStyle(color: Colors.white, fontSize: 9),
            ),
          ],
        ),
        Row(
          children: <Widget>[
            Text(
              'HardwareEncode: ${_isHardwareEncode ? '✅' : '❎'}',
              style: TextStyle(color: Colors.white, fontSize: 9),
            ),
          ],
        ),
        Row(
          children: <Widget>[
            Text(
              'NetworkQuality: $_networkQuality',
              style: TextStyle(color: Colors.white, fontSize: 9),
            ),
          ],
        ),
      ],
    ));
  }

//显示开始推流按钮
  Widget showPreviewToolPage() {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 50.0),
            ),
            Row(
              children: <Widget>[
                Text(
                  'StreamID: ',
                  style: TextStyle(color: Colors.white),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
            ),
            TextField(
              controller: _controller,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                  contentPadding: const EdgeInsets.only(
                      left: 10.0, top: 12.0, bottom: 12.0),
                  hintText: 'Please enter streamID',
                  hintStyle:
                      TextStyle(color: Color.fromRGBO(255, 255, 255, 0.8)),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xff0e88eb)))),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
            ),
            Text(
              'StreamID must be globally unique and the length should not exceed 255 bytes',
              style: TextStyle(color: Colors.white),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 30.0),
            ),
            Container(
              padding: const EdgeInsets.all(0.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
                color: Color(0xee0e88eb),
              ),
              width: 240.0,
              height: 60.0,
              child: CupertinoButton(
                child: Text(
                  '开始播放',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: onPlayButtonPressed,
              ),
            )
          ],
        ),
      ),
    );
  }

//显示推流时按钮
  Widget showPublishingToolPage() {
    //显示直播状态的相关参数
    Widget l1btns = Row(
      children: <Widget>[
        CupertinoButton(
          padding: const EdgeInsets.all(20.0),
          pressedOpacity: 1.0,
          borderRadius: BorderRadius.circular(0.0),
          // child: Image(
          //   width: 44.0,
          //   image: ImageIcon
          // ),
          child: Icon(
            Icons.switch_camera,
            size: 44.0,
            color: Colors.white,
          ),
          // onPressed: onCamStateChanged,
        ),
        Expanded(
          child: CupertinoButton(
            padding: const EdgeInsets.only(
                top: 10.0, bottom: 10, left: 16, right: 16),
            pressedOpacity: 1.0,
            borderRadius: BorderRadius.circular(20.0),
            color: Colors.red,
            child: Text('结束直播'),
            onPressed: stop,
          ),
        ),
        CupertinoButton(
          padding: const EdgeInsets.all(20.0),
          pressedOpacity: 1.0,
          borderRadius: BorderRadius.circular(0.0),
          child: Icon(
            _isUseMic ? Icons.mic_none : Icons.mic_off,
            size: 44.0,
            color: Colors.white,
          ),
          // onPressed: onMicStateChanged,
        ),
      ],
    );
    Widget l2btns = Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        // l2btn(
        //     Icon(
        //       Icons.cast,
        //       size: 30.0,
        //       color: Colors.white,
        //     ),
        //     '分享屏幕',
        //     sharepm),

        // Padding(padding: EdgeInsets.only(right: 10))
      ],
    );

    return Container(
      padding: EdgeInsets.only(
          left: 10.0,
          right: 10.0,
          bottom: MediaQuery.of(context).padding.bottom + 20.0),
      child: Column(
        children: <Widget>[
          //这里是推流网络信息
          showplayinfo(),
          Expanded(
            child: Padding(padding: const EdgeInsets.only(top: 10.0)),
          ),
          l2btns,
          l1btns,
          //这里是底部按钮信息
        ],
      ),
    );
  }

//停止推流
  void stop() {
    if (_isPlaying) {
      // 销毁时停止推流
      _isPlaying = !_isPlaying;
      RtmpBase.instance.stopplay();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: GestureDetector(
            onTap: () {
              setState(() {
                hidebtn = !hidebtn;
              });
            },
            child: DecoratedBox(
              decoration: BoxDecoration(color: Colors.yellow),
              child: RotatedBox(
                quarterTurns: 0, //旋转180度(2/4圈)
                child: RtmpBase.instance.getplayWidget(),
              ),
            ),
          ),
        ),
        showmsg(),
        _isPlaying
            ? hidebtn
                ? Container()
                : showPublishingToolPage()
            : showPreviewToolPage(),
      ],
    ));
  }

  Widget showmsg() {
    return Positioned(
      bottom: 94,
      child: RtmpBase.instance.msgwidget,
    );
  }
}
