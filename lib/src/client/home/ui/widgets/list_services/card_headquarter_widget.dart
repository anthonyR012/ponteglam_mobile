import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:latlong2/latlong.dart';
import 'package:ponte_glam/config/constant/assets_constant.dart';
import 'package:ponte_glam/config/theme/theme.dart';
import 'package:ponte_glam/config/constant/values_constant.dart';
import 'package:ponte_glam/di/shared_imports.dart';
import 'package:ponte_glam/shared/model/headquarter_model.dart';
import 'package:ponte_glam/shared/model/service_model.dart';
import 'package:ponte_glam/src/client/headquarter/ui/headquarter_detail_page.dart';
import 'package:ponte_glam/src/client/service/ui/service_detail_place.dart';
import 'package:ponte_glam/shared/widgets/label_content_widget.dart';
import 'package:ponte_glam/src/client/headquarter/ui/widgets/like_icon_widget.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CardHeadquarterServices extends StatefulWidget {
  const CardHeadquarterServices(
      {super.key,
      required this.buildContext,
      required this.isLoading,
      required this.headquarter});
  final BuildContext buildContext;
  final bool isLoading;
  final HeadquarterModel? headquarter;

  @override
  State<CardHeadquarterServices> createState() =>
      _CardHeadquarterServicesState();
}

class _CardHeadquarterServicesState extends State<CardHeadquarterServices> {
  late List<ServiceModel> services;
  late HeadquarterModel? headquarter;

  @override
  void initState() {
    headquarter = widget.headquarter;
    services = headquarter?.services ?? [];
    super.initState();
  }

  @override
  void didUpdateWidget(covariant CardHeadquarterServices oldWidget) {
    headquarter = widget.headquarter;
    services = headquarter?.services ?? [];
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final widthParent = MediaQuery.of(widget.buildContext).size.width * .9;
    final heightParent = MediaQuery.of(widget.buildContext).size.height * .44;
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(milliseconds: 500),
      builder: (context, value, child) {
        return Opacity(opacity: value, child: child!);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                offset: const Offset(0, 8),
                blurRadius: 24,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: widthParent + (widthParent * .05),
                height: heightParent * .35,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 7),
                  child: _HeaderCardPlace(
                      isLoading: widget.isLoading,
                      headquarter: headquarter,
                      width: widthParent),
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(
                    widget.isLoading ? 3 : services.length,
                    (index) {
                      return InkWell(
                        onTap: () {
                          context.pushNamed(ServiceDetailPage.routeName,
                              extra: {
                                "headquarter": headquarter!.toJson(),
                                "service": services[index].toJson()
                              });
                        },
                        child: _CardService(
                            service: widget.isLoading ? null : services[index],
                            isLoading: widget.isLoading,
                            headquarterName: headquarter?.name ?? "",
                            widthParent: widthParent,
                            heightParent: heightParent),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(
                height: spaceBetween10 - 5,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeaderCardPlace extends StatefulWidget {
  const _HeaderCardPlace(
      {required this.isLoading,
      required this.width,
      required this.headquarter});

  final bool isLoading;
  final double width;
  final HeadquarterModel? headquarter;

  @override
  State<_HeaderCardPlace> createState() => _HeaderCardPlaceState();
}

class _HeaderCardPlaceState extends State<_HeaderCardPlace> {
  late final String? pathImage;
  late final LatLng to;
  late HeadquarterModel? headquarter;

  @override
  void initState() {
    headquarter = widget.headquarter;
    pathImage = widget.isLoading ? "" : headquarter!.imageUrl;
    final loading = widget.isLoading;
    to = LatLng(loading ? 0 : double.tryParse(headquarter!.latitude) ?? 0,
        loading ? 0 : double.tryParse(headquarter!.longitude) ?? 0);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant _HeaderCardPlace oldWidget) {
    headquarter = widget.headquarter;
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildImage(context),
          _buildTitle(context),
          _buildIconLike()
        ],
      ),
    );
  }

  Flexible _buildIconLike() {
    return Flexible(
        flex: 1,
        child: Skeleton.shade(
            shade: widget.isLoading,
            child: LikeInteraction(
              padding: const EdgeInsets.all(8.0),
              isLoading: widget.isLoading,
              headquarter: headquarter,
            )));
  }

  Flexible _buildTitle(BuildContext context) {
    return Flexible(
      flex: 3,
      child: InkWell(
        onTap: () {
          context.pushNamed(HeadquarterDetailPage.routeName,
              extra: headquarter!.toJson());
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 17),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.isLoading
                    ? ("_" * 3)
                    : '${headquarter!.companyInfo?.name ?? ''} (${headquarter!.name})',
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: TextStyle(
                    fontFamily: fontFamilyMontserrat,
                    color: blackColorTheme,
                    fontSize:
                        lerpDouble(h4Size - 5, h4Size, widget.width / 1000),
                    fontWeight: FontWeight.bold),
              ),
              _buildIconsHeader(to)
            ],
          ),
        ),
      ),
    );
  }

  Flexible _buildImage(BuildContext context) {
    return Flexible(
      flex: 1,
      child: Skeleton.replace(
        replace: widget.isLoading,
        replacement:
            const Skeleton.leaf(child: CircleAvatar(backgroundColor: null)),
        child: InkWell(
          onTap: () {
            context.pushNamed(HeadquarterDetailPage.routeName,
                extra: headquarter!.toJson());
          },
          child: Center(
              child: widget.isLoading
                  ? const SizedBox()
                  : Hero(
                      tag:
                          "${headquarter!.id}${headquarter!.imageUrl}${headquarter!.name}",
                      child: Container(
                        clipBehavior: Clip.hardEdge,
                        decoration: const BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(rounded10))),
                        child: ImageLoadWidget(
                          image: pathImage == null || pathImage!.isEmpty
                              ? imageUserOut
                              : pathImage,
                          typeSourceImage:
                              pathImage == null || pathImage!.isEmpty
                                  ? TypeSourceImage.asset
                                  : TypeSourceImage.network,
                          fit: BoxFit.fill,
                        ),
                      ),
                    )),
        ),
      ),
    );
  }

  Widget _buildIconsHeader(LatLng to) {
    bool smaller = widget.width < 420;
    final double widgePercentage = widget.width / 1000;
    final sizeIcon = lerpDouble(17 - 3, 17, widgePercentage) ?? 17;
    final fontSize = lerpDouble(
            minimalMonserratSize - 3, minimalMonserratSize, widgePercentage) ??
        minimalMonserratSize;

    final List<Widget> children = [
      Padding(
        padding: EdgeInsets.only(right: 3, top: smaller ? 0 : 5),
        child: FutureBuilder<String>(
            future: getIt<GeoDevice>().distanceTo(to),
            builder: (context, snapshot) {
              final distance = snapshot.data ?? "";
              return LabelContentWidget(
                icon: iconLocation,
                fontSize: fontSize,
                sizeIcon: sizeIcon,
                isLoading: widget.isLoading ||
                    snapshot.connectionState == ConnectionState.waiting,
                description: distance,
                colorDescription: grayTextColorTheme,
                colorBackground: Colors.transparent,
                colorIcon: primaryColorTheme,
              );
            }),
      ),
    ];
    return smaller
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.center, children: children)
        : Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: children,
          );
  }
}

class _CardService extends StatefulWidget {
  const _CardService({
    required this.widthParent,
    required this.heightParent,
    required this.service,
    required this.isLoading,
    required this.headquarterName,
  });

  final double widthParent;
  final double heightParent;
  final ServiceModel? service;
  final String headquarterName;
  final bool isLoading;

  @override
  State<_CardService> createState() => _CardServiceState();
}

class _CardServiceState extends State<_CardService> {
  String durationPrefix = "";

  @override
  void initState() {
    durationPrefix = getIt<ServiceBloc>().doCalculateDurationInMinutes(
        duration: widget.service?.serviceDuration, minChar: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final widthCard = widget.widthParent * .42;
    final heightCard = widget.heightParent * .55;
    return Skeleton.shade(
      shade: widget.isLoading,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
        child: Container(
            width: widthCard,
            height: heightCard,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.all(Radius.circular(16)),
                border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
                boxShadow: const [
                  BoxShadow(
                      color: Color(0x08000000),
                      blurRadius: 8,
                      offset: Offset(0, 4))
                ]),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(flex: 1, child: _buildImagePanel()),
                Expanded(flex: 1, child: _buildInfoMenu(context)),
              ],
            )),
      ),
    );
  }

  Widget _buildInfoMenu(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            widget.isLoading ? ("_" * 2) : widget.service!.name,
            maxLines: 2,
            textAlign: TextAlign.start,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontFamily: fontFamilyMontserrat,
                color: Colors.black87,
                fontSize: 13),
          ),
          Row(
            children: [
              widget.isLoading
                  ? const SizedBox()
                  : const Icon(Icons.star_rounded,
                      color: primaryColorTheme, size: 14),
              if (!widget.isLoading) const SizedBox(width: 4),
              if (!widget.isLoading)
                Text(
                  widget.service!.rating.toStringAsFixed(1),
                  style: const TextStyle(
                      color: Colors.black87,
                      fontFamily: fontFamilyMontserrat,
                      fontWeight: FontWeight.bold,
                      fontSize: 12),
                ),
              if (!widget.isLoading) const SizedBox(width: 4),
              if (!widget.isLoading)
                Text(
                  "(${widget.service!.ratingCount})",
                  style: const TextStyle(
                      color: Colors.black54,
                      fontFamily: fontFamilyMontserrat,
                      fontWeight: FontWeight.w500,
                      fontSize: 10),
                ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                flex: 1,
                child: Text(
                  widget.isLoading
                      ? ("_" * 2)
                      : getIt<FormatCurrencyUtil>().getPriceFormat(
                          widget.service!.price.toString(), context),
                  textAlign: TextAlign.start,
                  style: const TextStyle(
                      fontFamily: fontFamilyMontserrat,
                      fontWeight: FontWeight.bold,
                      color: primaryColorTheme,
                      fontSize: 13),
                ),
              ),
              Flexible(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3),
                    child: LabelContentWidget(
                      icon: iconClock,
                      isLoading: widget.isLoading,
                      sizeIcon: 11,
                      fontSize: 10,
                      description: durationPrefix,
                      colorDescription: grayTextColorTheme,
                      colorBackground: Colors.transparent,
                      colorIcon: grayTextColorTheme,
                    ),
                  ))
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildImagePanel() {
    bool hasHomeService = widget.service != null &&
        (widget.service!.onlyHomeService ||
            widget.service!.homeServicePrice != null);

    return Stack(
      children: [
        widget.isLoading
            ? Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
              )
            : Hero(
                tag: "${widget.service!.id}${widget.headquarterName}",
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  clipBehavior: Clip.hardEdge,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                  child: ImageLoadWidget(
                      image: widget.service != null &&
                              widget.service!.images.isNotEmpty
                          ? widget.service!.images.first
                          : null,
                      typeSourceImage: TypeSourceImage.network,
                      fit: BoxFit.fill),
                ),
              ),
        Positioned(
          top: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.all(4.2),
            decoration: BoxDecoration(
              boxShadow: const [
                BoxShadow(
                    blurStyle: BlurStyle.inner,
                    blurRadius: 5,
                    color: Colors.black26,
                    spreadRadius: 1)
              ],
              border: Border.all(color: whiteColorTheme),
              borderRadius: const BorderRadius.all(Radius.circular(rounded10)),
            ),
            child: SvgPicture.asset(
              '$pathManagementIcons$iconForwardArrow',
              colorFilter:
                  const ColorFilter.mode(whiteColorTheme, BlendMode.srcIn),
              width: 12,
              height: 12,
            ),
          ),
        ),
        if (hasHomeService)
          Positioned(
            top: 6,
            left: 6,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.95),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.home_rounded,
                    color: primaryColorTheme,
                    size: 10,
                  ),
                  SizedBox(width: 3),
                  Text(
                    "A domicilio",
                    style: TextStyle(
                      color: primaryColorTheme,
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                      fontFamily: fontFamilyMontserrat,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
