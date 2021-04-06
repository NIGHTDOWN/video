import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:media_projection_creator/media_projection_creator.dart';

import 'dart:core';

import 'package:zego_faceunity_plugin/zego_faceunity_plugin.dart';

import 'package:zego_express_engine/zego_express_engine.dart';
import 'package:zego_faceunity_plugin_example/beauty_set.dart';
import 'package:zego_faceunity_plugin_example/page/rtmpout/rtmpouts.dart';
import 'package:zego_faceunity_plugin_example/sellpage.dart';
import 'package:zego_faceunity_plugin_example/tool/function.dart';
import 'package:zego_faceunity_plugin_example/tool/url.dart';

import 'package:zego_faceunity_plugin_example/utils/zego_config.dart';

import 'model/msg.dart';
import 'page/rtmpout/rtmpins.dart';
import 'page/rtmpout/rtmpouth.dart';
import 'tool/global.dart';

// import 'manager/screen_capture_manager.dart';

class BeautyCameraPage extends StatefulWidget {
  final int screenWidthPx;
  final int screenHeightPx;

  BeautyCameraPage(this.screenWidthPx, this.screenHeightPx);

  @override
  _BeautyCameraPageState createState() => new _BeautyCameraPageState();
}

class _BeautyCameraPageState extends State<BeautyCameraPage> {
  String _title = '开启推流';
  String _streamID = 's-beauty-camera';

  bool _isPublishing = false;
  bool hidebtn = false; //隐藏按钮
  int _previewViewID = -1;
  Widget _previewViewWidget;
  ZegoCanvas _previewCanvas;
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
  bool _isUseFrontCamera = true;

  TextEditingController _controller = new TextEditingController();

  @override
  void initState() {
    super.initState();
    // getpmpw();
    // if (ZegoConfig.instance.streamID.isNotEmpty) {
    //   _controller.text = ZegoConfig.instance.streamID;
    // }
    //设置流 源 为摄像头
    // ZegoFaceunityPlugin.instance
    //     .setCustomVideoCaptureSource(ZegoCustomSourceType.Camera);
    //配置自定义采集位置为屏幕 ZegoVideoBufferType.SurfaceTexture
    // ZegoExpressEngine.instance.enableCustomVideoCapture(true,
    //     config:
    //         ZegoCustomVideoCaptureConfig(ZegoVideoBufferType.SurfaceTexture));
    // ZegoExpressEngine.instance.enableCustomVideoCapture(true);

    // setPublisherCallback();

    // if (ZegoConfig.instance.enablePlatformView) {
    //   setState(() {
    //     // Create a PlatformView Widget
    //     _previewViewWidget =
    //         ZegoExpressEngine.instance.createPlatformView((viewID) {
    //       _previewViewID = viewID;

    //       // Start preview using platform view
    //       startPreview(viewID);
    //     });
    //   });
    // } else {
    //   // Create a Texture Renderer
    //   //创建预览视频窗口
    //   ZegoExpressEngine.instance
    //       .createTextureRenderer(widget.screenWidthPx, widget.screenHeightPx)
    //       .then((textureID) {
    //     _previewViewID = textureID;

    //     setState(() {
    //       // Create a Texture Widget
    //       _previewViewWidget = Texture(textureId: textureID);
    //     });

    //     // Start preview using texture renderer
    //     startPreview(textureID);
    //   });
    // }
  }

  // void setPublisherCallback() {
  //   // 推流成功的回调处理事件
  //   ZegoExpressEngine.onPublisherStateUpdate = (String streamID,
  //       ZegoPublisherState state,
  //       int errorCode,
  //       Map<String, dynamic> extendedData) {
  //     if (errorCode == 0) {
  //       setState(() {
  //         _isPublishing = true;
  //         _title = '推送中..';
  //       });

  //       ZegoConfig.instance.streamID = streamID;
  //       ZegoConfig.instance.saveConfig();
  //     } else {
  //       d('Publish error: $errorCode');
  //     }
  //   };
  //   //接收消息
  //   ZegoExpressEngine.onIMRecvBroadcastMessage =
  //       (String streamID, List<ZegoBroadcastMessageInfo> datas) {
  //     d('接收到消息');
  //     for (var data in datas) {
  //       recvmsg(data.fromUser.userID, data.message);
  //     }
  //   };
  //   ZegoExpressEngine.onRoomUserUpdate =
  //       (String msg, ZegoUpdateType type, List<ZegoUser> users) {
  //     d('新增用户');
  //     for (var user in users) {
  //       recvroom(user.userID, type);
  //     }
  //   };
  //   //接收房间消息

  //   // 推流质量变化处理
  //   ZegoExpressEngine.onPublisherQualityUpdate =
  //       (String streamID, ZegoPublishStreamQuality quality) {
  //     setState(() {
  //       //推流动态信息
  //       _publishCaptureFPS = quality.videoCaptureFPS;
  //       _publishEncodeFPS = quality.videoEncodeFPS;
  //       _publishSendFPS = quality.videoSendFPS;
  //       _publishVideoBitrate = quality.videoKBPS;
  //       _publishAudioBitrate = quality.audioKBPS;
  //       _isHardwareEncode = quality.isHardwareEncode;

  //       switch (quality.level) {
  //         case ZegoStreamQualityLevel.Excellent:
  //           _networkQuality = '☀️';
  //           break;
  //         case ZegoStreamQualityLevel.Good:
  //           _networkQuality = '⛅️️';
  //           break;
  //         case ZegoStreamQualityLevel.Medium:
  //           _networkQuality = '☁️';
  //           break;
  //         case ZegoStreamQualityLevel.Bad:
  //           _networkQuality = '🌧';
  //           break;
  //         case ZegoStreamQualityLevel.Die:
  //           _networkQuality = '❌';
  //           break;
  //         default:
  //           break;
  //       }
  //     });
  //   };

  //   // 视频尺寸改变回调处理
  //   ZegoExpressEngine.onPublisherVideoSizeChanged =
  //       (int width, int height, ZegoPublishChannel channel) {
  //     setState(() {
  //       _publishWidth = width;
  //       _publishHeight = height;
  //     });
  //   };
  // }

  //接收用户房间消息
  // recvroom(userid, ZegoUpdateType msg) {
  //   Msg msgobj;
  //   if (msg == ZegoUpdateType.Add) {
  //     msgobj = Msg.inroom(userid);
  //   } else {
  //     msgobj = Msg.outroom(userid);
  //   }
  //   msgin(msgobj);
  // }

  //接收用户消息
  // recvmsg(userid, msg) {
  //   d(userid);
  //   d(msg);
  // }

  // void startPreview(int viewID) {
  //   // Set the preview canvas
  //   _previewCanvas = ZegoCanvas.view(viewID);

  //   // Start preview
  //   ZegoExpressEngine.instance.startPreview(canvas: _previewCanvas);
  // }

  @override
  void dispose() {
    super.dispose();

    // if (_isPublishing) {
    //   // 销毁时停止推流
    //   ZegoExpressEngine.instance.stopPublishingStream();
    // }

    // // 销毁预览界面
    // ZegoExpressEngine.instance.stopPreview();

    // // Unregister publisher callback
    // ZegoExpressEngine.onPublisherStateUpdate = null;
    // ZegoExpressEngine.onPublisherQualityUpdate = null;
    // ZegoExpressEngine.onPublisherVideoSizeChanged = null;
    // //删除canvas
    // if (ZegoConfig.instance.enablePlatformView) {
    //   // Destroy preview platform view
    //   ZegoExpressEngine.instance.destroyPlatformView(_previewViewID);
    // } else {
    //   // Destroy preview texture renderer
    //   ZegoExpressEngine.instance.destroyTextureRenderer(_previewViewID);
    // }

    // // Logout room
    // //退出房间
    // ZegoExpressEngine.instance.logoutRoom(ZegoConfig.instance.roomID);
    // //移除视频源
    // ZegoFaceunityPlugin.instance.removeCustomVideoCaptureSource();
    // //
    // ZegoExpressEngine.instance.enableCustomVideoCapture(false);
  }

  void onPublishButtonPressed() {
    _streamID = _controller.text.trim();

    // Start publishing stream
    //开启推流
    // ZegoExpressEngine.instance.startPublishingStream(_streamID);
    gourl(context, RtmpOutS());
  }

  // void onCamStateChanged() {
  //   _isUseFrontCamera = !_isUseFrontCamera;
  //   //ZegoExpressEngine.instance.useFrontCamera(_isUseFrontCamera);
  //   //改变摄像头
  //   ZegoFaceunityPlugin.instance.switchCamera(
  //       _isUseFrontCamera ? ZegoCameraPosition.Front : ZegoCameraPosition.Back);
  // }

  // void onpmChanged() {
  //   // _isUseFrontCamera = !_isUseFrontCamera;
  //   //ZegoExpressEngine.instance.useFrontCamera(_isUseFrontCamera);
  //   //改变摄像头
  //   ZegoFaceunityPlugin.instance
  //       .setCustomVideoCaptureSource(ZegoCustomSourceType.SurfaceTexture);
  // }

  // void onMicStateChanged() {
  //   setState(() {
  //     //关闭音频
  //     _isUseMic = !_isUseMic;
  //     ZegoExpressEngine.instance.muteMicrophone(!_isUseMic);
  //   });
  // }

  // void onVideoMirroModeChanged(int mode) {
  //   //ZegoExpressEngine.instance.setVideoMirrorMode(ZegoVideoMirrorMode.values[mode]);
  // }
//显示推流网络状态
  // Widget showplayinfo() {
  //   // d(getscreeFx(context));
  //   return Container(
  //       child: Column(
  //     children: [
  //       Padding(
  //         padding: const EdgeInsets.only(top: 10.0),
  //       ),
  //       Row(
  //         children: <Widget>[
  //           Text(
  //             'RoomID: ${ZegoConfig.instance.roomID} |  StreamID: ${ZegoConfig.instance.streamID}',
  //             style: TextStyle(color: Colors.white, fontSize: 9),
  //           ),
  //         ],
  //       ),
  //       Row(
  //         children: <Widget>[
  //           Text(
  //             'Rendering with: ${ZegoConfig.instance.enablePlatformView ? 'PlatformView' : 'TextureRenderer'}',
  //             style: TextStyle(color: Colors.white, fontSize: 9),
  //           ),
  //         ],
  //       ),
  //       Row(
  //         children: <Widget>[
  //           Text(
  //             'Resolution: $_publishWidth x $_publishHeight',
  //             style: TextStyle(color: Colors.white, fontSize: 9),
  //           ),
  //         ],
  //       ),
  //       Row(
  //         children: <Widget>[
  //           Text(
  //             'FPS(Capture): ${_publishCaptureFPS.toStringAsFixed(2)}',
  //             style: TextStyle(color: Colors.white, fontSize: 9),
  //           ),
  //         ],
  //       ),
  //       Row(
  //         children: <Widget>[
  //           Text(
  //             'FPS(Encode): ${_publishEncodeFPS.toStringAsFixed(2)}',
  //             style: TextStyle(color: Colors.white, fontSize: 9),
  //           ),
  //         ],
  //       ),
  //       Row(
  //         children: <Widget>[
  //           Text(
  //             'FPS(Send): ${_publishSendFPS.toStringAsFixed(2)}',
  //             style: TextStyle(color: Colors.white, fontSize: 9),
  //           ),
  //         ],
  //       ),
  //       Row(
  //         children: <Widget>[
  //           Text(
  //             'Bitrate(Video): ${_publishVideoBitrate.toStringAsFixed(2)} kb/s',
  //             style: TextStyle(color: Colors.white, fontSize: 9),
  //           ),
  //         ],
  //       ),
  //       Row(
  //         children: <Widget>[
  //           Text(
  //             'Bitrate(Audio): ${_publishAudioBitrate.toStringAsFixed(2)} kb/s',
  //             style: TextStyle(color: Colors.white, fontSize: 9),
  //           ),
  //         ],
  //       ),
  //       Row(
  //         children: <Widget>[
  //           Text(
  //             'HardwareEncode: ${_isHardwareEncode ? '✅' : '❎'}',
  //             style: TextStyle(color: Colors.white, fontSize: 9),
  //           ),
  //         ],
  //       ),
  //       Row(
  //         children: <Widget>[
  //           Text(
  //             'NetworkQuality: $_networkQuality',
  //             style: TextStyle(color: Colors.white, fontSize: 9),
  //           ),
  //         ],
  //       ),
  //     ],
  //   ));
  // }

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
                  '竖屏推流',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () async {
                  await screenS(); //先横屏
                  gourl(context, RtmpOutS());
                },
              ),
            ),
            SizedBox(
              height: 10,
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
                  '横屏推流',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () async {
                  await screenH(); //先横屏
                  gourl(context, RtmpOutH());
                },
              ),
            ),
            SizedBox(
              height: 10,
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
                  '竖屏拉流',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () async {
                  gourl(context, RtmpInS());
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  //获取录屏授权
  // getpmpw() async {
  //   int errorCode = await MediaProjectionCreator.createMediaProjection();
  //   if (errorCode != MediaProjectionCreator.ERROR_CODE_SUCCEED) {
  //     print('Can not get screen capture permission');
  //     return false;
  //   }
  // }

  //屏幕流对象
  // ScreenCaptureManager manager = ScreenCaptureManagerFactory.createManager();
  //分享屏幕
  // sharepm() async {
  //   //停止推流
  //   ZegoExpressEngine.instance.stopPublishingStream();
  //   ZegoExpressEngine.instance.stopPreview();
  //   //屏幕授权
  //   if (ZegoConfig.instance.enablePlatformView) {
  //     // Destroy preview platform view
  //     ZegoExpressEngine.instance.destroyPlatformView(_previewViewID);
  //   } else {
  //     // Destroy preview texture renderer
  //     ZegoExpressEngine.instance.destroyTextureRenderer(_previewViewID);
  //   }
  //   ZegoExpressEngine.instance.logoutRoom(ZegoConfig.instance.roomID);
  //   //移除视频源
  //   ZegoFaceunityPlugin.instance.removeCustomVideoCaptureSource();
  //   //
  //   ZegoExpressEngine.instance.enableCustomVideoCapture(false);

  //   // await ZegoExpressEngine.createEngine(
  //   //     appID, appSign, isTestEnv, ZegoScenario.General);
  //   ZegoExpressEngine.createEngine(
  //       ZegoConfig.instance.appID,
  //       ZegoConfig.instance.appSign,
  //       ZegoConfig.instance.isTestEnv,
  //       ZegoScenario.values[0],
  //       enablePlatformView: ZegoConfig.instance.enablePlatformView);

  //   /// Developers need to write native Android code to access native ZegoExpressEngine
  //   await ZegoExpressEngine.instance.enableCustomVideoCapture(true,
  //       config:
  //           ZegoCustomVideoCaptureConfig(ZegoVideoBufferType.SurfaceTexture));

  //   await ZegoExpressEngine.instance.setVideoConfig(ZegoVideoConfig(
  //       MediaQuery.of(context).size.width.toInt(),
  //       MediaQuery.of(context).size.height.toInt(),
  //       MediaQuery.of(context).size.width.toInt(),
  //       MediaQuery.of(context).size.height.toInt(),
  //       15,
  //       3000,
  //       ZegoVideoCodecID.Default));
  //   // await ZegoExpressEngine.instance
  //   //     .loginRoom(roomID, ZegoUser(userID, userName));
  //   ZegoUser user =
  //       ZegoUser(ZegoConfig.instance.userID, ZegoConfig.instance.userName);

  //   // 登入房间
  //   ZegoExpressEngine.instance.loginRoom(ZegoConfig.instance.roomID, user);
  //   await ZegoExpressEngine.instance.startPublishingStream(_streamID);

  //   // Start screen capture
  //   // await manager.startScreenCapture();
  //   // onPublishButtonPressed();
  //   setState(() {});
  // }

//显示推流时按钮
  // Widget showPublishingToolPage() {
  //   //显示直播状态的相关参数
  //   Widget l1btns = Row(
  //     children: <Widget>[
  //       CupertinoButton(
  //         padding: const EdgeInsets.all(20.0),
  //         pressedOpacity: 1.0,
  //         borderRadius: BorderRadius.circular(0.0),
  //         // child: Image(
  //         //   width: 44.0,
  //         //   image: ImageIcon
  //         // ),
  //         child: Icon(
  //           Icons.switch_camera,
  //           size: 44.0,
  //           color: Colors.white,
  //         ),
  //         onPressed: onCamStateChanged,
  //       ),
  //       Expanded(
  //         child: CupertinoButton(
  //           padding: const EdgeInsets.only(
  //               top: 10.0, bottom: 10, left: 16, right: 16),
  //           pressedOpacity: 1.0,
  //           borderRadius: BorderRadius.circular(20.0),
  //           color: Colors.red,
  //           child: Text('结束直播'),
  //           onPressed: stop,
  //         ),
  //       ),
  //       CupertinoButton(
  //         padding: const EdgeInsets.all(20.0),
  //         pressedOpacity: 1.0,
  //         borderRadius: BorderRadius.circular(0.0),
  //         child: Icon(
  //           _isUseMic ? Icons.mic_none : Icons.mic_off,
  //           size: 44.0,
  //           color: Colors.white,
  //         ),
  //         onPressed: onMicStateChanged,
  //       ),
  //     ],
  //   );
  //   Widget l2btns = Row(
  //     mainAxisAlignment: MainAxisAlignment.end,
  //     children: <Widget>[
  //       // l2btn(
  //       //     Icon(
  //       //       Icons.cast,
  //       //       size: 30.0,
  //       //       color: Colors.white,
  //       //     ),
  //       //     '分享屏幕',
  //       //     sharepm),
  //       l2btn(
  //           Icon(
  //             Icons.auto_awesome,
  //             size: 30.0,
  //             color: Colors.white,
  //           ),
  //           '美颜',
  //           showBottomSettingPage),
  //       l2btn(
  //           Icon(
  //             Icons.shopping_cart,
  //             size: 30.0,
  //             color: Colors.white,
  //           ),
  //           '卖货',
  //           showBottomsell),
  //       // Padding(padding: EdgeInsets.only(right: 10))
  //     ],
  //   );

  //   return Container(
  //     padding: EdgeInsets.only(
  //         left: 10.0,
  //         right: 10.0,
  //         bottom: MediaQuery.of(context).padding.bottom + 20.0),
  //     child: Column(
  //       children: <Widget>[
  //         //这里是推流网络信息
  //         showplayinfo(),
  //         Expanded(
  //           child: Padding(padding: const EdgeInsets.only(top: 10.0)),
  //         ),
  //         l2btns,
  //         l1btns,
  //         //这里是底部按钮信息
  //       ],
  //     ),
  //   );
  // }

//显示美颜设置
//   void showBottomSettingPage() {
//     setState(() {
//       hidebtn = true;
//     });
//     //美颜按钮
//     showModalBottomSheet<void>(
//       barrierColor: Color.fromRGBO(0, 0, 0, 0.1),
//       backgroundColor: Colors.transparent,
//       context: context,
//       builder: (BuildContext context) {
//         return BeautySet();
//       },
//     );
//   }

// //显示卖货设置
//   void showBottomsell() {
//     setState(() {
//       hidebtn = true;
//     });
//     //卖货按钮
//     showModalBottomSheet<void>(
//       // barrierColor: Color.fromRGBO(0, 0, 0, 0.1),
//       // backgroundColor: Colors.transparent,
//       backgroundColor: Color(0xff16181D),
//       context: context,
//       builder: (BuildContext context) {
//         return Sellpage();
//       },
//     );
//   }

//   void onSettingsButtonClicked() {
//     //显示美颜设置
//     showBottomSettingPage();
//   }

//   Widget l2btn(Widget img, String title, Function event) {
//     return CupertinoButton(
//       padding: const EdgeInsets.all(10.0),
//       pressedOpacity: 1.0,
//       borderRadius: BorderRadius.circular(0.0),
//       child: Column(
//         children: [
//           img,
//           Text(
//             title,
//             style: TextStyle(color: Colors.white, fontSize: 12),
//           )
//         ],
//       ),
//       onPressed: event,
//     );
//   }

//停止推流
 

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
              child: _previewViewWidget),
        ),
        showPreviewToolPage()
      ],
    ));
  }

  
}

//去掉滚动水波纹效果
