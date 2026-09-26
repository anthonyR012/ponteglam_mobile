import 'package:flutter/material.dart';
import 'package:ponte_glam/config/theme/theme.dart';
import 'package:ponte_glam/shared/model/headquarter_model.dart';
import 'package:ponte_glam/src/client/headquarter/ui/widgets/content_description_widget.dart';
import 'package:ponte_glam/src/client/headquarter/ui/widgets/head_headquarter_widget.dart';
import 'package:ponte_glam/src/client/headquarter/ui/widgets/services_detail_widget.dart';

class SmallMobileHeadquarterDetailPage extends StatefulWidget {
  const SmallMobileHeadquarterDetailPage(
      {super.key,
      required this.width,
      required this.height,
      required this.headquarter});
  final double width;
  final double height;
  final HeadquarterModel headquarter;

  @override
  State<SmallMobileHeadquarterDetailPage> createState() =>
      _SmallMobileHeadquarterDetailPageState();
}

class _SmallMobileHeadquarterDetailPageState
    extends State<SmallMobileHeadquarterDetailPage> {
  late ScrollController _scrollController;

  @override
  void initState() {
    _scrollController =
        ScrollController(initialScrollOffset: widget.height * .6);
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: backgroundColorTheme,
      body: SafeArea(
        child: SizedBox(
          width: width,
          child: Column(children: [
            HeaderHeadquarterDetail(
                width: width * .9,
                height: height * .35,
                headquarter: widget.headquarter),
            Container(
              height: height * .55,
              width: width,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: ListView(
                children: [
                  ContentDescriptionDetail(headquarter: widget.headquarter),
                  ServicesDetailContentWidget(
                      headquarter: widget.headquarter, width: width)
                ],
              ),
            )
          ]),
        ),
      ),
    );
  }
}
