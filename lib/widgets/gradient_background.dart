import 'package:flutter/material.dart';

class GradientBackgroundScreen extends StatelessWidget {
  final Widget body;
  final PreferredSizeWidget? appBar;

  GradientBackgroundScreen({required this.body, this.appBar});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF1a1a2e),
            Color(0xFF16213e),
            Color(0xFF0f3460),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Scaffold(
        appBar: appBar,
        backgroundColor: Colors.transparent,
        body: body,
      ),
    );
  }
}
