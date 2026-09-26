import 'package:flutter/material.dart';
import 'package:ponte_glam/src/client/setting/ui/responsive/small_mobile_page.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  double width = 0;
  double height = 0;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    width = size.width;
    height = size.height;
    return LayoutBuilder(
      builder: (context, constraints) {
        return SmallMobileSettingPage(height: height, width: width);
      },
    );
  }
}
