import 'package:flutter/material.dart';

class EmptyWidget extends StatelessWidget {
  final Color color;
  EmptyWidget(this.color);
  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
    );
  }
}