import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform;

import 'pages/home.dart';
import 'setting/setting.dart';
import 'setting/theme.dart';
import 'setting/scales.dart';

/// App
class FlutterApp extends StatefulWidget {
  @override
  _FlutterAppState createState() => new _FlutterAppState();
}

class _FlutterAppState extends State<FlutterApp> {

  /// 系统设置
  Setting settings;

  @override
  void initState() {
    debugPrint("初始化");
    settings = new Setting(
      theme: kLightTheme,
      platform: defaultTargetPlatform,
      textScaleFactor: kAllAppTextScaleValues[0],
      textDirection: TextDirection.rtl,
    );
    super.initState();
  }

  /// 设置配置变更
  void settingUpdate(Setting newSettings) {
    debugPrint("配置变更");
    Setting.update(newSettings).then((config) {
      setState(() {
        settings = newSettings;
      });
      debugPrint("配置变更完成");
    });
  }

  /// 修改 字体大小
  Widget applyTextScaleFactor(Widget child) {
    debugPrint("字体大小变更");
    return new Builder(
      builder: (BuildContext context) {
        return new MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaleFactor: settings.textScaleFactor.scale,
          ),
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        theme: settings.theme.data.copyWith(platform: settings.platform),
        builder: (BuildContext context, Widget child) {
          return new Directionality(
            // ltr lrt 支持
            textDirection: settings.textDirection,
            // 字体大小修改
            child: applyTextScaleFactor(child),
          );
        },
        home: Home(
          setting: settings,
          settingUpdate: settingUpdate,
        ));
  }
}

void main() => runApp(new FlutterApp());
