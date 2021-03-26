import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:zego_faceunity_plugin_example/tool/global.dart';

import 'utils/zego_config.dart';

import 'package:zego_faceunity_plugin_example/beauty_camera_init_page.dart';

// void main() => runApp(MyApp());
Future main() async {
  //flutter 1.9必须执行 WidgetsFlutterBinding.ensureInitialized();

  WidgetsFlutterBinding.ensureInitialized();
  // checkpower();
  // if (!await Power.requestPermissions()) {
  //   //检查权限
  //   //  await AppUtils.popApp();
  // } else {}

  // runApp(new MyApp());
  i().then((data) {
    //加载缓存
    //加载sql

    runApp(new MyApp());
  });
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    s('context', context);
    // int screenWidthPx = MediaQuery.of(context).size.width.toInt();
    //   int screenHeightPx = MediaQuery.of(context).size.height.toInt();

    return MaterialApp(
        title: 'ZegoFaceUnityPluginExample',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: HomePage());
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    // Load config
    ZegoConfig.instance.init();
  }

  void onEnterBeautyCameraPagePressed() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (BuildContext context) {
      return BeautyCameraInitPage();
    }));
  }

  @override
  Widget build(BuildContext context) {
    s('w', MediaQuery.of(context).size.width);
    s('h', MediaQuery.of(context).size.height);
    return Scaffold(
        appBar: AppBar(
          title: Text('ZegoFaceUnityExample'),
        ),
        body: SafeArea(
            child: Center(
          child: CupertinoButton(
              color: Color(0xff0e88eb),
              child: Text('Beauty Camera'),
              onPressed: onEnterBeautyCameraPagePressed),
        )));
  }
}
