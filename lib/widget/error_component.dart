import 'package:flutter/material.dart';

class ErrorComponent extends StatelessWidget {
  final String text;
  final Function onClick;

  ErrorComponent({this.text, this.onClick});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
          child: Center(
            child: Text("出错了，点击屏幕重试"),
          )
      ),
      onTap: onClick,
    );
  }
}
