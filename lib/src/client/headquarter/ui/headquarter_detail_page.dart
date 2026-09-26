import 'package:flutter/material.dart';
import 'package:ponte_glam/shared/model/headquarter_model.dart';
import 'package:ponte_glam/src/client/headquarter/ui/responsive/small_mobile_page.dart';

class HeadquarterDetailPage extends StatelessWidget {
  const HeadquarterDetailPage({super.key, required this.headquarter});
  final HeadquarterModel headquarter;
  static const String routeName = 'headquarter_detail';
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double width = size.width;
    final double height = size.height;
    return LayoutBuilder(
      builder: (context, constraints) {
        return SmallMobileHeadquarterDetailPage(
          width: width,
          height: height,
          headquarter: headquarter,
        );
      },
    );
  }
}
