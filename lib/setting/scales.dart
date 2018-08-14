import 'package:flutter/material.dart';

//应用字体大小类
class AppTextScaleValue {
  const AppTextScaleValue(this.scale, this.label);

  final double scale;
  final String label;

  @override
  bool operator ==(dynamic other) {
    if (runtimeType != other.runtimeType) return false;
    final AppTextScaleValue typedOther = other;
    return scale == typedOther.scale && label == typedOther.label;
  }

  @override
  int get hashCode => hashValues(scale, label);

  @override
  String toString() {
    return '$runtimeType($label)';
  }
}

final List<AppTextScaleValue> kAllAppTextScaleValues =
    const <AppTextScaleValue>[
  const AppTextScaleValue(1.0, 'System Default'),
  const AppTextScaleValue(0.8, 'Small'),
  const AppTextScaleValue(1.0, 'Normal'),
  const AppTextScaleValue(1.3, 'Large'),
  const AppTextScaleValue(2.0, 'Huge'),
];
