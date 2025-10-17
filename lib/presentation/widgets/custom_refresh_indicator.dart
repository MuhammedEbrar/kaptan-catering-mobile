import 'package:flutter/material.dart';

class CustomRefreshIndicator extends StatelessWidget {
  final Future<void> Function() onRefresh;
  final Widget child;

  const CustomRefreshIndicator({
    Key? key,
    required this.onRefresh,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      color: Colors.red,
      backgroundColor: Colors.white,
      strokeWidth: 3.0,
      displacement: 40.0,
      child: child,
    );
  }
}