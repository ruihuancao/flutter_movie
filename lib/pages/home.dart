import 'package:flutter/material.dart';
import '../setting/setting.dart';
import 'video.dart';

class Home extends StatefulWidget {
  Setting setting;
  Function settingUpdate;

  Home({this.setting, this.settingUpdate});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    initSetting();
    super.initState();
  }

  void initSetting() {
    debugPrint("初始化设置");
    Setting.init().then((setting) {
      widget.settingUpdate(setting);
    });
  }

  @override
  Widget build(BuildContext context) {
    return VideoPage();
  }
}
