import 'dart:async';

import 'package:flutter/material.dart';

import '../../utils/theme/themes.dart';

class CounterDivider extends StatefulWidget {
  const CounterDivider({super.key, required this.doneFunction});
  final VoidCallback doneFunction;

  @override
  State<CounterDivider> createState() => _CounterDividerState();
}

class _CounterDividerState extends State<CounterDivider> {
  final _key = GlobalKey();

  double _size = 0;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      double widgetWidth = _key.currentContext?.size?.width ?? 0;
      double halfWidgetWidth = widgetWidth / 2;
      double indent = halfWidgetWidth / 30;
      int seconds = 0;
      Timer timer = Timer.periodic(Duration(seconds: 1), (timer) {
        setState(() {
          _size = indent * seconds;
        });
        seconds++;
      });
      Future.delayed(Duration(seconds: 30), () {
        timer.cancel();
        setState(() {
          _size = halfWidgetWidth;
        });
        widget.doneFunction();
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Divider(
      indent: _size,
      endIndent: _size,
      key: _key,
      color: AppThemes.lightPrimary500,
    );
  }
}
