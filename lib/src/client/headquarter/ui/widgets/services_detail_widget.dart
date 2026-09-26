import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ponte_glam/config/constant/assets_constant.dart';
import 'package:ponte_glam/config/theme/theme.dart';
import 'package:ponte_glam/config/constant/enum_constant.dart';
import 'package:ponte_glam/config/constant/values_constant.dart';
import 'package:ponte_glam/di/get_it_instance.dart';
import 'package:ponte_glam/shared/model/headquarter_model.dart';
import 'package:ponte_glam/shared/model/service_model.dart';
import 'package:ponte_glam/src/client/service/ui/service_detail_place.dart';
import 'package:ponte_glam/l10n/app_localizations.dart';
import 'package:ponte_glam/shared/widgets/image_load_widget.dart';

class ServicesDetailContentWidget extends StatelessWidget {
  const ServicesDetailContentWidget({
    super.key,
    required this.headquarter,
    required this.width,
  });

  final HeadquarterModel headquarter;
  final double width;

  @override
  Widget build(BuildContext context) {
    final List<ServiceModel> services = headquarter.services;
    bool moreThenThree = services.length > 3;
    List<ServiceModel> servicesChunk =
        moreThenThree ? services.sublist(0, 4) : services;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          getIt<AppLocalizations>().titleServices,
          textAlign: TextAlign.start,
          style: const TextStyle(
              fontFamily: fontFamilyMontserrat,
              color: blackColorTheme,
              fontWeight: FontWeight.bold,
              fontSize: h3Size),
        ),
        const SizedBox(height: spaceBetween10),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(
            servicesChunk.length,
            (index) {
              if (moreThenThree && index == 3) {
                return InkWell(
                  onTap: () {
                    context.pushNamed(ServiceDetailPage.routeName, extra: {
                      "headquarter": headquarter.toJson(),
                      "service": servicesChunk[index].toJson()
                    });
                  },
                  child: _CardServiceSmall(
                      width: width,
                      service: servicesChunk[index],
                      textTemp: '+${(services.length - 3)}'),
                );
              }
              return InkWell(
                onTap: () {
                  context.pushNamed(ServiceDetailPage.routeName, extra: {
                    "headquarter": headquarter.toJson(),
                    "service": servicesChunk[index].toJson()
                  });
                },
                child: _CardServiceSmall(
                    width: width, service: servicesChunk[index]),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _CardServiceSmall extends StatelessWidget {
  const _CardServiceSmall(
      {required this.width, required this.service, this.textTemp});

  final double width;
  final String? textTemp;
  final ServiceModel service;

  @override
  Widget build(BuildContext context) {
    final widthCard = width * .22;
    return Container(
      height: widthCard,
      width: widthCard,
      padding: const EdgeInsets.all(3),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(
              child: Container(
            clipBehavior: Clip.hardEdge,
            decoration:
                BoxDecoration(borderRadius: BorderRadius.circular(rounded10)),
            child: ImageLoadWidget(
                image: service.images.first,
                typeSourceImage: TypeSourceImage.network),
          )),
          Positioned.fill(
              child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(rounded10),
                      color: Colors.black38))),
          Positioned(
              bottom: textTemp == null ? 0 : null,
              height: widthCard * .5,
              width: widthCard * .8,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  textTemp ?? service.name,
                  maxLines: 2,
                  textAlign: textTemp == null ? null : TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: whiteColorTheme,
                      letterSpacing: 0,
                      wordSpacing: 0,
                      height: 1.0,
                      fontWeight: FontWeight.bold,
                      fontSize: textTemp == null
                          ? minimalMonserratSize
                          : minimalMonserratSize + 8,
                      fontFamily: fontFamilyMontserrat),
                ),
              )),
        ],
      ),
    );
  }
}
