import 'package:flutter/material.dart';
import '../res/string.dart';

class EmptyComponent extends StatelessWidget {
  final String text;

  EmptyComponent({this.text});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(text ?? AppStrings.tip_empty),
    );
  }
}
