import 'package:flutter/material.dart';
import 'package:ponte_glam/config/constant/values_constant.dart';
import 'package:ponte_glam/config/theme/theme.dart';
import 'package:ponte_glam/shared/widgets/title_label_widget.dart';

class AppBarProfileWidget extends StatefulWidget {
  const AppBarProfileWidget({super.key, required this.title});
  final String title;

  @override
  State<AppBarProfileWidget> createState() => _AppBarProfileWidgetState();
}

class _AppBarProfileWidgetState extends State<AppBarProfileWidget> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.close, color: whiteColorTheme),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      title: TextLabelWidget(
        text: widget.title,
        styleTextItem: const StyleTextItem(
            fontWeight: FontWeight.bold,
            colorText: whiteColorTheme,
            fontSize: h3Size),
      ),
      centerTitle: true,
    );
  }
}
