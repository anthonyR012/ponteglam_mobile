import 'package:flutter/material.dart';
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

class CardServiceUnique extends StatefulWidget {
  const CardServiceUnique(
      {super.key,
      required this.buildContext,
      required this.isLoading,
      this.service,
      this.isSupplierMode = false,
      this.onRefreshData,
      required this.headquarter});
  final BuildContext buildContext;
  final bool isLoading;
  final HeadquarterModel? headquarter;
  final ServiceModel? service;
  final bool isSupplierMode;
  final VoidCallback? onRefreshData;

  @override
  State<CardServiceUnique> createState() => _CardServiceUniqueState();
}

class _CardServiceUniqueState extends State<CardServiceUnique>
    with SingleTickerProviderStateMixin {
  AnimationController? animationController;
  late Animation<double> animation;
  late HeadquarterModel? headquarter;
  late ServiceModel? service;

  @override
  void initState() {
    headquarter = widget.headquarter;
    service = widget.service ??
        (headquarter?.services.isNotEmpty == true
            ? headquarter!.services.first
            : null);
    animationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    animationController?.forward();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant CardServiceUnique oldWidget) {
    headquarter = widget.headquarter;
    service = widget.service ??
        (headquarter?.services.isNotEmpty == true
            ? headquarter!.services.first
            : null);
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
        onTap: () async {
          if (widget.isSupplierMode) {
            final result = await context.pushNamed('SupplierServiceDetailPage',
                extra: {
                  "headquarter": headquarter!.toJson(),
                  "service": service!.toJson()
                });
            if (result == true && widget.onRefreshData != null) {
              widget.onRefreshData!();
            }
          } else {
            context.goNamed(ServiceDetailPage.routeName, extra: {
              "headquarter": headquarter!.toJson(),
              "service": service!.toJson()
            });
          }
        },
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
          child: _buildHeaderService(context),
        ),
      ),
    );
  }

  ClipRRect _buildHeaderService(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          _buildImage(service),
          _buildContent(context),
        ],
      ),
    );
  }

  Container _buildContent(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  widget.isLoading ? "_" * 3 : service!.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontFamily: fontFamilyMontserrat,
                    color: Colors.black87,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 6),
                _DescriptionCard(
                    isLoading: widget.isLoading,
                    headquarter: headquarter,
                    service: service),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Text(
                widget.isLoading
                    ? "_" * 2
                    : getIt<FormatCurrencyUtil>()
                        .getPriceFormat(service!.price.toString(), context),
                style: const TextStyle(
                  fontFamily: fontFamilyMontserrat,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: primaryColorTheme,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildImage(ServiceModel? service) {
    bool hasHomeService = service != null &&
        (service.onlyHomeService || service.homeServicePrice != null);
    return AspectRatio(
      aspectRatio: 2,
      child: widget.isLoading
          ? null
          : Stack(
              fit: StackFit.expand,
              children: [
                Hero(
                    tag: "${service!.id}${widget.headquarter!.name}",
                    child: ImageLoadWidget(
                        image: service.images.isNotEmpty
                            ? service.images.first
                            : '',
                        typeSourceImage: TypeSourceImage.network,
                        fit: BoxFit.cover)),
                if (hasHomeService)
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.95),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.home_rounded,
                            color: primaryColorTheme,
                            size: 18,
                          ),
                          SizedBox(width: 4),
                          Text(
                            "A domicilio",
                            style: TextStyle(
                              color: primaryColorTheme,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              fontFamily: fontFamilyMontserrat,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
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
                const SizedBox(width: 4),
                Text(
                  widget.isLoading
                      ? ("_" * 2)
                      : "(${widget.service!.ratingCount})",
                  style: const TextStyle(
                      color: Colors.black54,
                      fontFamily: fontFamilyMontserrat,
                      fontWeight: FontWeight.w600,
                      fontSize: 12),
                ),
                const SizedBox(
                  width: 12,
                ),
                widget.isLoading
                    ? const Skeleton.leaf(
                        child: Icon(Icons.favorite, size: 14),
                      )
                    : const Icon(
                        Icons.location_on_rounded,
                        color: Colors.black38,
                        size: 14,
                      ),
                const SizedBox(width: 4),
                FutureBuilder<String>(
                    future: distanceTo,
                    builder: (context, snapshot) {
                      final distance = snapshot.data ?? "";
                      return Text(
                        widget.isLoading ? "_" : distance,
                        style: const TextStyle(
                            color: Colors.black54,
                            fontFamily: fontFamilyMontserrat,
                            fontSize: 12),
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
