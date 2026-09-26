import 'package:flutter/material.dart';

class SmallMobileSettingPage extends StatefulWidget {
  const SmallMobileSettingPage({
    super.key,
    required this.width,
    required this.height,
  });

  final double width;
  final double height;

  @override
  State<SmallMobileSettingPage> createState() => _SmallMobileSettingPageState();
}

class _SmallMobileSettingPageState extends State<SmallMobileSettingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(resizeToAvoidBottomInset: false, body: Container());
  }
}
