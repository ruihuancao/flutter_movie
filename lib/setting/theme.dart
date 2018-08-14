import 'package:flutter/material.dart';

// 应用主题类
class AppTheme {
  const AppTheme._(this.name, this.data);

  final String name;
  final ThemeData data;

  @override
  bool operator ==(dynamic other) {
    if (runtimeType != other.runtimeType) return false;
    final AppTheme typedOther = other;
    return name == typedOther.name && data == typedOther.data;
  }

  @override
  int get hashCode => hashValues(
        name,
        data,
      );
}

final AppTheme kDarkTheme = new AppTheme._('Dark', _buildDarkTheme());
final AppTheme kLightTheme = new AppTheme._('Light', _buildLightTheme());

TextTheme _buildTextLightTheme(TextTheme base) {
  return base.copyWith(
      title: base.title.copyWith(
        //fontFamily: 'DroidKufi',
        color: const Color(0xFF333333),
      )
  );
}

TextTheme _buildTextDarkTheme(TextTheme base) {
  return base.copyWith(
      title: base.title.copyWith(
//        fontFamily: 'DroidKufi',
        color: const Color(0xFFFFFFFF),
      )
  );
}

AppTheme getThemeByName(String name) {
  if (name == "Dark") {
    return kDarkTheme;
  } else {
    return kLightTheme;
  }
}

ThemeData _buildDarkTheme() {
  final ThemeData base = new ThemeData.dark();
//  return base.copyWith(
//    primaryColor: const Color(0xFFFFB146),
//    buttonColor: const Color(0xFFFFB146),
//    indicatorColor: const Color(0xFFFFB146),
//    accentColor: const Color(0xFFFFB146),
//    canvasColor: const Color(0xFF202124),
//    scaffoldBackgroundColor: const Color(0xFF202124),
//    backgroundColor: const Color(0xFF202124),
//    errorColor: const Color(0xFFFFB146),
//    buttonTheme: const ButtonThemeData(
//      textTheme: ButtonTextTheme.primary,
//    ),
//    textTheme: _buildTextDarkTheme(base.textTheme),
//    primaryTextTheme: _buildTextDarkTheme(base.primaryTextTheme),
//    accentTextTheme: _buildTextDarkTheme(base.accentTextTheme),
//    textSelectionColor: const Color(0xFFFFB146),
//    iconTheme: const IconThemeData(color: Colors.white),
//    cardColor: Colors.black,
//  );
  return base.copyWith(primaryColor: Colors.blue);
}

ThemeData _buildLightTheme() {
  final ThemeData base = new ThemeData.light();
//  return base.copyWith(
//    primaryColor: const Color(0xFFFFB146),
//    buttonColor: const Color(0xFFFFB146),
//    indicatorColor: const Color(0xFFFFB146),
//    splashColor: Colors.white24,
//    splashFactory: InkRipple.splashFactory,
//    accentColor: const Color(0xFFFFB146),
//    canvasColor: Colors.white,
//    scaffoldBackgroundColor: const Color(0xFFFFFFFF),
//    backgroundColor: const Color(0xFFF6F6F6),
//    errorColor: const Color(0xFFFFB146),
//    buttonTheme: const ButtonThemeData(
//      textTheme: ButtonTextTheme.primary,
//    ),
//    textTheme: _buildTextLightTheme(base.textTheme),
//    primaryTextTheme: _buildTextLightTheme(base.primaryTextTheme),
//    accentTextTheme: _buildTextLightTheme(base.accentTextTheme),
//    textSelectionColor: const Color(0xFFFFB146),
//    iconTheme: const IconThemeData(color: Color(0xFF666666)),
//    cardColor: Colors.white,
//  );
  return base.copyWith(primaryColor: Colors.blue);
}
