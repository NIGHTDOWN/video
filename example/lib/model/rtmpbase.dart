import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:media_projection_creator/media_projection_creator.dart';
import 'package:zego_faceunity_plugin/zego_faceunity_plugin.dart';
import 'package:zego_express_engine/zego_express_engine.dart';
import 'package:zego_faceunity_plugin_example/page/msg/msgwidget.dart';
import 'package:zego_faceunity_plugin_example/tool/function.dart';
import 'package:zego_faceunity_plugin_example/tool/global.dart';
import 'package:zego_faceunity_plugin_example/utils/zego_config.dart';

class RtmpBase {
  static final RtmpBase instance = RtmpBase._internal();

  bool isPublishing;

  int _previewViewID = -1;
  RtmpBase._internal();
  int screenWidthPx;
  int screenHeightPx;
  //创建一个画板
  ZegoCanvas _previewCanvas;
  //视频预览控件
  Widget viewwidget;
  Widget msgwidget;
  //极购创建的预览id
  //初始化
  init() {
    screenWidthPx = g('w').toInt();
    screenHeightPx = g('h').toInt();
    //设置流 源 为摄像头
    ZegoFaceunityPlugin.instance
        .setCustomVideoCaptureSource(ZegoCustomSourceType.Camera);
    // ZegoExpressEngine.instance.enableCustomVideoCapture(true,
    //     config:
    //         ZegoCustomVideoCaptureConfig(ZegoVideoBufferType.SurfaceTexture));
    // 销毁之前的预览页面
    stopview();
    ZegoExpressEngine.instance.enableCustomVideoCapture(true);
    // //设置流 源 为摄像头
    // ZegoFaceunityPlugin.instance
    //     .setCustomVideoCaptureSource(ZegoCustomSourceType.Camera);
    //配置自定义采集位置为屏幕 ZegoVideoBufferType.SurfaceTexture
    if (ZegoConfig.instance.enablePlatformView) {
      //默认不支持这玩意
      viewwidget = ZegoExpressEngine.instance.createPlatformView((viewID) {
        _startPreview(viewID);
      });
    } else {
      // Create a Texture Renderer
      //创建预览视频窗口
      ZegoExpressEngine.instance
          .createTextureRenderer(screenWidthPx, screenHeightPx)
          .then((textureID) {
        viewwidget = Texture(textureId: textureID);
        _startPreview(textureID);
      });
    }
    msgwidget = MsgWidget();
  }

  Widget getMsgWidget() {
    if (isnull(msgwidget)) {
      return msgwidget;
    }
    return Container();
  }

  void _startPreview(int viewID) {
    // Set the preview canvas

    _previewViewID = viewID;
    _previewCanvas = ZegoCanvas.view(viewID);
    // Start preview
    ZegoExpressEngine.instance.startPreview(canvas: _previewCanvas);
    // }
  }

//获取预览窗口
  getviewWidget() {
    return viewwidget;
  }

  push(String _streamID) {
    ZegoExpressEngine.instance.startPublishingStream(_streamID);
  }

  stopview() {
    if (ZegoConfig.instance.enablePlatformView) {
      // Destroy preview platform view
      ZegoExpressEngine.instance.destroyPlatformView(_previewViewID);
    } else {
      // Destroy preview texture renderer
      ZegoExpressEngine.instance.destroyTextureRenderer(_previewViewID);
    }
  }

  exit() {
    //停止推流
    stoppush();
    // 销毁预览界面
    ZegoExpressEngine.instance.stopPreview();
    //清空回调
    ZegoExpressEngine.onPublisherStateUpdate = null;
    ZegoExpressEngine.onPublisherQualityUpdate = null;
    ZegoExpressEngine.onPublisherVideoSizeChanged = null;
    //删除canvas
    stopview();

    //退出房间
    ZegoExpressEngine.instance.logoutRoom(ZegoConfig.instance.roomID);
    //移除视频源
    ZegoFaceunityPlugin.instance.removeCustomVideoCaptureSource();
    ZegoExpressEngine.instance.enableCustomVideoCapture(false);
  }

  //切换前后摄像头
  switchCamera(bool frontOrBack) {
    ZegoFaceunityPlugin.instance.switchCamera(
        frontOrBack ? ZegoCameraPosition.Front : ZegoCameraPosition.Back);
  }

  //改变麦克风状态
  micChanged(bool openOrClose) {
    ZegoExpressEngine.instance.muteMicrophone(!openOrClose);
  }

//停止推流
  stoppush() {
    ZegoExpressEngine.instance.stopPublishingStream();
  }

  //获取录屏授权
  getpmpw() async {
    int errorCode = await MediaProjectionCreator.createMediaProjection();
    if (errorCode != MediaProjectionCreator.ERROR_CODE_SUCCEED) {
      print('Can not get screen capture permission');
      return false;
    }
  }
}

//去掉滚动水波纹效果
class NonBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    if (Platform.isAndroid || Platform.isFuchsia) {
      return child;
    } else {
      return super.buildViewportChrome(context, child, axisDirection);
    }
  }
}
