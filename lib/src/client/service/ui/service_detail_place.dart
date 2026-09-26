import 'package:flutter/material.dart';
import 'package:ponte_glam/shared/model/headquarter_model.dart';
import 'package:ponte_glam/shared/model/service_model.dart';
import 'package:ponte_glam/src/client/service/ui/responsive/small_mobile_page.dart';

class ServiceDetailPage extends StatelessWidget {
  const ServiceDetailPage(
      {super.key, required this.headquarter, required this.service});
  final HeadquarterModel headquarter;
  final ServiceModel service;
  static const String routeName = 'service_detail';

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double width = size.width;
    final double height = size.height;
    return LayoutBuilder(
      builder: (context, constraints) {
        return SmallMobileServicePage(
          width: width,
          height: height,
          headquarter: headquarter,
          service: service,
        );
      },
    );
  }
}
