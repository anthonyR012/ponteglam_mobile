import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:ponte_glam/di/shared_imports.dart';
import 'package:ponte_glam/shared/model/headquarter_model.dart';
import 'package:ponte_glam/shared/model/service_model.dart';
import 'package:ponte_glam/src/client/service/ui/widgets/animated_header_detail.dart';
import 'package:ponte_glam/src/client/service/ui/widgets/content_description_detail.dart';
import 'package:ponte_glam/src/client/service/ui/widgets/amenities_detail.dart';
import 'package:ponte_glam/src/client/service/ui/widgets/map_content_detail.dart';
import 'package:ponte_glam/src/client/service/ui/widgets/reserve_now_detail.dart';
import 'package:ponte_glam/src/shared/wallet/ui/cubit/wallet_cubit.dart';

class SmallMobileServicePage extends StatefulWidget {
  const SmallMobileServicePage(
      {super.key,
      required this.width,
      required this.height,
      required this.headquarter,
      required this.service});
  final double width;
  final double height;
  final HeadquarterModel headquarter;
  final ServiceModel service;

  @override
  State<SmallMobileServicePage> createState() => _SmallMobileServicePageState();
}

class _SmallMobileServicePageState extends State<SmallMobileServicePage> {
  late ScrollController _scrollController;
  late LatLng _locationPlace;
  late ServiceModel _service;
  late final WalletCubit _walletCubit;

  @override
  void initState() {
    _scrollController =
        ScrollController(initialScrollOffset: widget.height * .6);
    _locationPlace = LatLng(
        double.tryParse(widget.headquarter.latitude.toString()) ?? 0,
        double.tryParse(widget.headquarter.longitude.toString()) ?? 0);
    _service = widget.service;
    _walletCubit = getIt<WalletCubit>()..loadWallet();
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
      body: CustomScrollView(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverPersistentHeader(
              pinned: true,
              delegate: _SliverAppBarDelegate(
                maxHeight: height,
                minHeight: 240,
                child: (double percentage) {
                  return AnimatedDetailHeader(
                    service: _service,
                    headquarter: widget.headquarter,
                    placeLocation: _locationPlace,
                    topPercent: ((1 - percentage) / .7).clamp(0.0, 1.0),
                    bottomPercent: (percentage / .3).clamp(0.0, 1.0),
                  );
                },
              )),
          SliverToBoxAdapter(
            child: ContentDescriptionDetail(service: _service),
          ),
          if (_service.amenities.isNotEmpty)
            SliverToBoxAdapter(
              child: AmenitiesSectionDetail(
                  width: width, amenities: _service.amenities),
            ),
          SliverToBoxAdapter(
            child: MapSectionDetail(
                width: width,
                location: _locationPlace,
                address: widget.headquarter.address ??
                    getIt<AppLocalizations>().failureNoFound("")),
          ),
          SliverToBoxAdapter(
            child: BlocProvider<WalletCubit>.value(
              value: _walletCubit,
              child: ReserveNowSection(
                  width: width,
                  service: _service,
                  headquarter: widget.headquarter),
            ),
          )
        ],
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });
  final double minHeight;
  final double maxHeight;
  final Widget Function(double) child;

  @override
  double get minExtent => minHeight;
  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child(shrinkOffset / maxHeight));
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
