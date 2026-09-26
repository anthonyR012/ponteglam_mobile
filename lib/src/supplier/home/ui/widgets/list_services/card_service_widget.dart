import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:latlong2/latlong.dart';
import 'package:ponte_glam/config/constant/assets_constant.dart';
import 'package:ponte_glam/config/theme/theme.dart';
import 'package:ponte_glam/config/constant/values_constant.dart';
import 'package:ponte_glam/di/shared_imports.dart';
import 'package:ponte_glam/shared/model/headquarter_model.dart';
import 'package:ponte_glam/shared/model/service_model.dart';
import 'package:ponte_glam/src/client/service/ui/service_detail_place.dart';
import 'package:ponte_glam/shared/widgets/rating_bar_widget.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CardServiceUniqueSupplier extends StatefulWidget {
  const CardServiceUniqueSupplier(
      {super.key,
      required this.buildContext,
      required this.isLoading,
      required this.headquarter});
  final BuildContext buildContext;
  final bool isLoading;
  final HeadquarterModel? headquarter;

  @override
  State<CardServiceUniqueSupplier> createState() =>
      _CardServiceUniqueSupplierState();
}

class _CardServiceUniqueSupplierState extends State<CardServiceUniqueSupplier>
    with SingleTickerProviderStateMixin {
  AnimationController? animationController;
  late Animation<double> animation;
  late HeadquarterModel? headquarter;
  late ServiceModel? service;

  @override
  void initState() {
    headquarter = widget.headquarter;
    service = headquarter?.services.first;
    animationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    animationController?.forward();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant CardServiceUniqueSupplier oldWidget) {
    headquarter = widget.headquarter;
    service = headquarter?.services.first;
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    animationController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    animationController?.forward();

    return Padding(
      padding: const EdgeInsets.only(left: 12, right: 12, top: 8, bottom: 16),
      child: InkWell(
        splashColor: Colors.transparent,
        onTap: () {
          context.goNamed(ServiceDetailPage.routeName, extra: {
            "headquarter": headquarter!.toJson(),
            "service": service!.toJson()
          });
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(rounded10)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.grey.withValues(alpha: 0.6),
                offset: const Offset(4, 4),
                blurRadius: 16,
              ),
            ],
          ),
          child: _buildHeaderService(context),
        ),
      ),
    );
  }

  ClipRRect _buildHeaderService(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(rounded10)),
      child: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              _buildImage(service),
              _buildContent(context),
            ],
          ),
        ],
      ),
    );
  }

  Container _buildContent(BuildContext context) {
    return Container(
      color: backgroundColorTheme,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 16, top: 8, bottom: 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    widget.isLoading ? "_" * 3 : service!.name,
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: fontFamilyMontserrat,
                      color: blackColorTheme,
                      fontSize: h3Size,
                    ),
                  ),
                  _DescriptionCard(
                      isLoading: widget.isLoading,
                      headquarter: headquarter,
                      service: service),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16, top: 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Text(
                  widget.isLoading
                      ? "_" * 2
                      : getIt<FormatCurrencyUtil>()
                          .getPriceFormat(service!.price.toString(), context),
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                    fontFamily: fontFamilyMontserrat,
                    fontWeight: FontWeight.bold,
                    fontSize: h4Size,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  AspectRatio _buildImage(ServiceModel? service) {
    return AspectRatio(
      aspectRatio: 2,
      child: widget.isLoading
          ? null
          : Hero(
              tag: "${service!.id}${widget.headquarter!.name}",
              child: ImageLoadWidget(
                  image: service.images.first,
                  typeSourceImage: TypeSourceImage.network,
                  fit: BoxFit.cover)),
    );
  }
}

class _DescriptionCard extends StatefulWidget {
  const _DescriptionCard({
    required this.service,
    required this.headquarter,
    required this.isLoading,
  });

  final ServiceModel? service;
  final HeadquarterModel? headquarter;
  final bool isLoading;

  @override
  State<_DescriptionCard> createState() => _DescriptionCardState();
}

class _DescriptionCardState extends State<_DescriptionCard> {
  final ScrollController scroll = ScrollController();
  late LatLng to;
  late Future<String> distanceTo;

  @override
  void initState() {
    super.initState();
    final latitude = widget.headquarter?.latitude;
    final longitude = widget.headquarter?.longitude;
    to = LatLng(
        widget.isLoading ? 0 : double.tryParse(latitude.toString()) ?? 0,
        widget.isLoading ? 0 : double.tryParse(longitude.toString()) ?? 0);
    distanceTo = getIt<GeoDevice>().distanceTo(to);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          width: MediaQuery.of(context).size.width * .6,
          child: Text(
            widget.isLoading
                ? "_" * 3
                : '${widget.headquarter!.companyInfo?.name ?? ''} (${widget.headquarter!.name})',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
                fontSize: messageSize,
                fontFamily: fontFamilyHind,
                color: grayTextColorTheme),
          ),
        ),
        Scrollbar(
          controller: scroll,
          radius: const Radius.circular(rounded10),
          thumbVisibility: true,
          thickness: 2,
          interactive: false,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            controller: scroll,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                RatingBarWidget(
                    isLoading: widget.isLoading,
                    rating: widget.isLoading ? 0 : widget.service!.rating),
                Text(
                  widget.isLoading
                      ? ("_" * 2)
                      : "(${widget.service!.ratingCount} ${getIt<AppLocalizations>().titleReviews})",
                  style: const TextStyle(
                      color: grayTextColorTheme,
                      fontFamily: fontFamilyMontserrat,
                      fontSize: minimalMonserratSize),
                ),
                const SizedBox(
                  width: spaceBetween10,
                ),
                widget.isLoading
                    ? const Skeleton.leaf(
                        child: Icon(Icons.favorite),
                      )
                    : SvgPicture.asset(
                        '$pathManagementIcons$iconLocation',
                        colorFilter: const ColorFilter.mode(
                            primaryColorTheme, BlendMode.srcIn),
                        width: 15,
                        height: 15,
                      ),
                FutureBuilder<String>(
                    future: distanceTo,
                    builder: (context, snapshot) {
                      final distance = snapshot.data ?? "";
                      return Text(
                        widget.isLoading ? "_" : distance,
                        style: const TextStyle(
                            color: grayTextColorTheme,
                            fontFamily: fontFamilyMontserrat,
                            fontSize: minimalMonserratSize),
                      );
                    }),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
