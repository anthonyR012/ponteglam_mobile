import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:ponte_glam/config/constant/assets_constant.dart';
import 'package:ponte_glam/config/theme/theme.dart';
import 'package:ponte_glam/config/constant/values_constant.dart';
import 'package:ponte_glam/di/shared_imports.dart';
import 'package:ponte_glam/shared/model/headquarter_model.dart';
import 'package:ponte_glam/shared/model/service_model.dart';
import 'package:ponte_glam/src/client/service/ui/widgets/place_info_header_detail.dart';
import 'package:ponte_glam/src/client/service/ui/widgets/place_view_carousel_detail.dart';
import 'package:ponte_glam/src/client/service/ui/widgets/translate_animation_detail.dart';
import 'package:ponte_glam/shared/widgets/button_top_widget.dart';
import 'package:ponte_glam/shared/widgets/label_content_widget.dart';

class AnimatedDetailHeader extends StatefulWidget {
  const AnimatedDetailHeader(
      {super.key,
      required this.topPercent,
      required this.bottomPercent,
      required this.placeLocation,
      required this.service,
      required this.headquarter});
  final double topPercent;
  final double bottomPercent;
  final LatLng placeLocation;
  final HeadquarterModel headquarter;
  final ServiceModel service;

  @override
  State<AnimatedDetailHeader> createState() => _AnimatedDetailHeaderState();
}

class _AnimatedDetailHeaderState extends State<AnimatedDetailHeader> {
  late Future<String> distanceTo;
  late final String durationPrefix;

  @override
  void initState() {
    super.initState();
    distanceTo = getIt<GeoDevice>().distanceTo(widget.placeLocation);
    durationPrefix = getIt<ServiceBloc>().doCalculateDurationInMinutes(
        duration: widget.service.serviceDuration, minChar: true);
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    return Stack(
      children: [
        _buildOverBackground(topPadding, context),
        _buildInfoMenu(context),
        Positioned.fill(
            top: null,
            child: TranslateAnimation(
                child: PlaceInfoHeader(
              headquarter: widget.headquarter,
              service: widget.service,
            ))),
      ],
    );
  }

  Positioned _buildInfoMenu(BuildContext context) {
    return Positioned.fill(
        top: null,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: const BoxDecoration(
              color: secondaryColorTheme,
              borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
          height: lerpDouble(130, 160, (widget.topPercent))!.clamp(135, 155),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: spaceBetween10),
                  Expanded(
                    child: Text(
                      widget.service.name,
                      maxLines: 2,
                      overflow: TextOverflow.fade,
                      style: TextStyle(
                          color: whiteColorTheme,
                          fontFamily: fontFamilyMontserrat,
                          fontWeight: FontWeight.bold,
                          fontSize: lerpDouble(
                              h3Size - 4, h3Size, widget.topPercent)),
                    ),
                  ),
                  Text(
                    getIt<FormatCurrencyUtil>().getPriceFormat(
                        widget.service.price.toString(), context),
                    style: TextStyle(
                        color: whiteColorTheme,
                        fontSize:
                            lerpDouble(h3Size - 4, h3Size, widget.topPercent),
                        fontFamily: fontFamilyMontserrat,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 3, top: 5),
                    child: FutureBuilder<String>(
                      future: distanceTo,
                      builder: (context, snapshot) {
                        String distance = snapshot.data ?? '';
                        return LabelContentWidget(
                          icon: iconLocation,
                          isLoading: snapshot.connectionState ==
                              ConnectionState.waiting,
                          description: distance,
                          colorDescription: whiteColorTheme,
                          colorBackground: Colors.transparent,
                          colorIcon: whiteColorTheme,
                        );
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 2,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 3, top: 5),
                    child: LabelContentWidget(
                      icon: iconClock,
                      description: durationPrefix,
                      colorDescription: whiteColorTheme,
                      colorBackground: Colors.transparent,
                      colorIcon: whiteColorTheme,
                    ),
                  )
                ],
              ),
            ],
          ),
        ));
  }

  ClipRRect _buildOverBackground(double topPadding, BuildContext context) {
    return ClipRRect(
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(
              top: (29 + topPadding) * (1 - widget.bottomPercent),
              bottom: 160 * (1 - widget.bottomPercent),
            ),
            child: Transform.scale(
              scale: lerpDouble(1, 1.2, (widget.bottomPercent)),
              child: PlaceImagesPageView(
                  images: widget.service.images,
                  idService: widget.service.id,
                  headquarterName: widget.headquarter.name),
            ),
          ),
          ButtonTopWidget(
              icon: iconBackArrow,
              left: -60 * (1 - widget.bottomPercent),
              onTap: () => Navigator.of(context).pop(),
              topPadding: topPadding),
        ],
      ),
    );
  }
}
