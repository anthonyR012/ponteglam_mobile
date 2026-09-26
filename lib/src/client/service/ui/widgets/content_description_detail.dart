import 'package:flutter/material.dart';
import 'package:ponte_glam/config/constant/assets_constant.dart';
import 'package:ponte_glam/config/theme/theme.dart';
import 'package:ponte_glam/config/constant/values_constant.dart';
import 'package:ponte_glam/shared/model/service_model.dart';

class ContentDescriptionDetail extends StatefulWidget {
  const ContentDescriptionDetail({super.key, required this.service});
  final ServiceModel service;

  @override
  State<ContentDescriptionDetail> createState() =>
      _ContentDescriptionDetailState();
}

class _ContentDescriptionDetailState extends State<ContentDescriptionDetail> {
  bool _isExpanded = false;
  bool _isTextOverflowing = false;
  final GlobalKey _textKey = GlobalKey();

  Color expandedColor = Colors.blue;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkTextOverflow());
  }

  void _checkTextOverflow() {
    final RenderBox renderBox =
        _textKey.currentContext?.findRenderObject() as RenderBox;

    final textPainter = TextPainter(
      text: TextSpan(
        text: widget.service.description,
        style: const TextStyle(
          color: blackColorTheme,
          fontFamily: fontFamilyHind,
          fontSize: messageSize,
        ),
      ),
      maxLines: 3,
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: renderBox.size.width);

    if (textPainter.didExceedMaxLines) {
      setState(() {
        _isTextOverflowing = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: whiteColorTheme,
      padding: const EdgeInsets.all(paddingInput15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.8,
            padding: const EdgeInsets.only(left: 13),
            child: Text(
              widget.service.description,
              key: _textKey,
              textAlign: TextAlign.start,
              overflow:
                  _isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
              maxLines: _isExpanded ? null : 3,
              style: const TextStyle(
                color: blackColorTheme,
                fontFamily: fontFamilyHind,
                fontSize: messageSize,
              ),
            ),
          ),
          if (_isTextOverflowing)
            Row(
              children: [
                Spacer(),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _isExpanded = !_isExpanded;
                      expandedColor = _isExpanded ? Colors.grey : Colors.blue;
                    });
                  },
                  child: Text(
                    _isExpanded ? "Ver menos" : "Ver más",
                    textAlign: TextAlign.end,
                    style: TextStyle(
                      color: expandedColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
