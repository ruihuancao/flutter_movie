import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

import 'theme.dart';
import 'scales.dart';

const String pref_key_theme = "pref_key_theme";
const String pref_key_text_scales = "pref_key_text_scales";
const String pref_key_text_direction = "pref_key_text_direction";

// 应用配置类
class Setting {
  Setting(
      {this.textDirection, this.theme, this.platform, this.textScaleFactor});

  // sharepreferences
  static Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  // RTL 或者LRT
  final TextDirection textDirection;

  //应用字体大小设置
  final AppTextScaleValue textScaleFactor;

  // 应用主题设置
  final AppTheme theme;

  // 应用平台
  final TargetPlatform platform;

  // 获取新的配置
  Setting copyWith({
    AppTheme theme,
    AppTextScaleValue textScaleFactor,
    TextDirection textDirection,
    TargetPlatform platform,
  }) {
    Setting settings = new Setting(
      theme: theme ?? this.theme,
      textScaleFactor: textScaleFactor ?? this.textScaleFactor,
      textDirection: textDirection ?? this.textDirection,
      platform: platform ?? this.platform,
    );
    return settings;
  }

  //初始化配置
  static Future<Setting> init() async {
    AppTheme appTheme = await getCurrentTheme();
    AppTextScaleValue appTextScaleValue = await getCurrentAppTextScaleValue();
    TextDirection textDirection = await getCurrentTTextDirection();
    Setting settings = new Setting(
      theme: appTheme,
      textScaleFactor: appTextScaleValue,
      textDirection: textDirection,
      platform: defaultTargetPlatform,
    );
    return settings;
  }

  // 更新配置到shareprefences
  static Future<Setting> update(Setting options) async {
    SharedPreferences prefs = await _prefs;
    prefs.setString(pref_key_theme, options.theme.name);
    prefs.setString(pref_key_text_scales, options.textScaleFactor.label);
    prefs.setString(pref_key_text_direction,
        TextDirection.ltr == options.textDirection ? "ltr" : "rtl");
    return options;
  }

  // 获取当前主题
  static Future<AppTheme> getCurrentTheme() async {
    SharedPreferences prefs = await _prefs;
    String name = prefs.getString(pref_key_theme);
    if (name == kDarkTheme.name) {
      return kDarkTheme;
    } else {
      return kLightTheme;
    }
  }

  // 获取当前文本方向
  static Future<TextDirection> getCurrentTTextDirection() async {
    SharedPreferences prefs = await _prefs;
    String name = prefs.getString(pref_key_text_direction);
    if (name == null || name.isEmpty) {
      return TextDirection.ltr;
    }
    if (name == "rtl") {
      return TextDirection.rtl;
    } else {
      return TextDirection.ltr;
    }
  }

  // 获取当前字体设置大小
  static Future<AppTextScaleValue> getCurrentAppTextScaleValue() async {
    SharedPreferences prefs = await _prefs;
    String name = prefs.getString(pref_key_text_scales);
    AppTextScaleValue appTextScaleValue;

    if (name == null || name == "") {
      appTextScaleValue = kAllAppTextScaleValues[0];
    } else {
      for (int i = 0; i < kAllAppTextScaleValues.length; i++) {
        if (name == kAllAppTextScaleValues[i].label) {
          appTextScaleValue = kAllAppTextScaleValues[i];
          break;
        }
      }
    }
    return appTextScaleValue;
  }

  @override
  bool operator ==(dynamic other) {
    if (runtimeType != other.runtimeType) return false;
    final Setting typedOther = other;
    return theme == typedOther.theme &&
        textScaleFactor == typedOther.textScaleFactor &&
        textDirection == typedOther.textDirection &&
        platform == typedOther.platform;
  }

  @override
  int get hashCode => hashValues(
        theme,
        textScaleFactor,
        textDirection,
        platform,
      );

  @override
  String toString() {
    return '$runtimeType($theme)';
  }
}
