import 'package:flutter/material.dart';

class TopBar extends StatelessWidget {
  final String barTitle;
  final Widget? primaryAction;
  final Widget? secondaryAction;
  final double? fontSize;

  TopBar(
    this.barTitle, {
    super.key,
    this.primaryAction,
    this.secondaryAction,
    this.fontSize =35,
  });

  @override
  Widget build(BuildContext context) {
    final double deviceHeight = MediaQuery.of(context).size.height;
    final double deviceWidth = MediaQuery.of(context).size.width;

    return Container(
      height: deviceHeight * 0.10,
      width: deviceWidth,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          
          if (secondaryAction != null) secondaryAction!,
          Expanded(child: titleBar()),
          if (primaryAction != null) primaryAction!,
        ],
      ),
    );
  }

  Widget titleBar() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Text(
        barTitle,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: Colors.white,
          fontSize: fontSize ?? 16.0, // Default font size
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
