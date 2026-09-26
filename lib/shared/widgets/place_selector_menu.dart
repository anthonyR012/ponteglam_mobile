import 'package:flutter/material.dart';
import 'package:ponte_glam/config/constant/assets_constant.dart';
import 'package:ponte_glam/config/theme/theme.dart';
import 'package:ponte_glam/config/utils/overlay_util.dart';
import 'package:ponte_glam/di/shared_imports.dart';
import 'package:ponte_glam/shared/model/headquarter_model.dart';
import 'package:ponte_glam/shared/model/user_model.dart';
import 'package:ponte_glam/shared/widgets/circle_image_profile_widget.dart';
import 'package:ponte_glam/src/supplier/home/ui/home_supplier_page.dart';
import 'package:ponte_glam/src/client/home/ui/home_page.dart';
import 'package:ponte_glam/shared/model/service_model.dart';
import 'package:ponte_glam/shared/widgets/modern_form_elements.dart';

class PlaceSelectorMenu extends StatefulWidget {
  const PlaceSelectorMenu({
    super.key,
    required this.overlayController,
    required this.appLocalization,
    required this.user,
  });

  final OverlayController overlayController;
  final AppLocalizations appLocalization;
  final UserModel user;

  @override
  State<PlaceSelectorMenu> createState() => _PlaceSelectorMenuState();
}

class _PlaceSelectorMenuState extends State<PlaceSelectorMenu> {
  List<HeadquarterModel> _places = [];
  final ScrollController _scrollController = ScrollController();
  int? _idSelected;
  bool _isLoading = false;

  @override
  void initState() {
    _idSelected = getIt<SharedPreferences>().getInt(keyPlace);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchMyHeadquarters();
    });
    super.initState();
  }

  Future<void> _fetchMyHeadquarters() async {
    if (mounted) setState(() => _isLoading = true);

    final storage = getIt<IStorage>();
    final geoDevice = getIt<GeoDevice>();

    final params = ParamsDoGetServices(
      storage: storage,
      filter: const FilterServiceModel(mine: true),
      geoDevice: geoDevice,
    );

    final result = await getIt<DoGetServices>().call(params: params);

    result.fold(
      (failure) {
        if (mounted) setState(() => _isLoading = false);
      },
      (paginator) {
        if (mounted) {
          setState(() {
            _places = paginator.headquarters;
            _isLoading = false;
          });
        }
        _scrollToSelectedPlace();
      },
    );
  }

  /// Returns one representative HeadquarterModel per company.
  /// Prefers the currently selected HQ; otherwise picks the first one found.
  List<HeadquarterModel> _groupedPlaces() {
    final Map<int, HeadquarterModel> seen = {};
    for (final place in _places) {
      final cid = place.companyId;
      if (cid == null) continue;
      if (!seen.containsKey(cid)) {
        seen[cid] = place;
      } else if (place.id == _idSelected) {
        // Prefer the currently active HQ as the representative
        seen[cid] = place;
      }
    }
    return seen.values.toList();
  }

  void _scrollToSelectedPlace() {
    if (_idSelected == null) return;
    final selectedIndex =
        _places.indexWhere((place) => place.id == _idSelected);
    if (selectedIndex < 0) return;

    const itemWidth = 100.0;
    const itemPadding = 16.0;
    final offset = (selectedIndex + 1) * (itemWidth + itemPadding);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          offset,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  Future<void> _onPlaceSelected(int? id) async {
    if (mounted) setState(() => _idSelected = id);

    if (id == null) {
      await getIt<SharedPreferences>().remove(keyPlace);
      widget.overlayController.hide();
      if (mounted) {
        context.pushReplacementNamed(HomePage.routeName);
      }
    } else {
      await getIt<SharedPreferences>().setInt(keyPlace, id);
      widget.overlayController.hide();
      if (mounted) {
        final headquarterModel = _places.firstWhere(
          (element) => element.id == id,
          orElse: () => HeadquarterModel.empty(),
        );
        context.pushReplacementNamed(HomePageSupplier.routeName,
            extra: headquarterModel);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ModernFormCard(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ModernSectionHeader(
                title: widget.appLocalization.sentenceChoosePlace),
            IconButton(
              onPressed: () => widget.overlayController.hide(),
              icon: const Icon(Icons.close_rounded, color: secondaryColorTheme),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 125,
          child: _isLoading
              ? const Center(
                  child: CircularProgressIndicator(color: primaryColorTheme))
              : ListView(
                  controller: _scrollController,
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  children: [
                    _PlaceItem(
                      title: widget.user.fullName ?? '',
                      image: widget.user.picture,
                      isSelected: _idSelected == null,
                      isPersonal: true,
                      onTap: () => _onPlaceSelected(null),
                    ),
                    ..._groupedPlaces().map((place) => _PlaceItem(
                          title: place.companyInfo?.name ?? '',
                          image: place.companyInfo?.imageUrl,
                          isSelected: _places
                              .where((p) => p.companyId == place.companyId)
                              .any((p) => p.id == _idSelected),
                          isCompany: true,
                          onTap: () => _onPlaceSelected(place.id),
                        )),
                  ],
                ),
        ),
      ],
    );
  }
}

class _PlaceItem extends StatelessWidget {
  const _PlaceItem({
    required this.title,
    this.image,
    this.isSelected = false,
    this.isCompany = false,
    this.isPersonal = false,
    required this.onTap,
  });

  final String title;
  final String? image;
  final bool isSelected;
  final bool isCompany;
  final bool isPersonal;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: Stack(
        children: [
          InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(12),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 100,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isSelected
                    ? primaryColorTheme.withValues(alpha: 0.05)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected ? primaryColorTheme : Colors.transparent,
                  width: 2,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleImageProfile(
                    size: 60,
                    showSubIcon: false,
                    typeSourceImage: TypeSourceImage.network,
                    imageMain: image,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.w500,
                      color:
                          isSelected ? primaryColorTheme : secondaryColorTheme,
                      fontFamily: fontFamilyMontserrat,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isPersonal)
            Positioned(
              top: 4,
              left: 4,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: primaryColorTheme,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: primaryColorTheme.withValues(alpha: 0.2),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Text(
                  'Personal',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                    fontFamily: fontFamilyMontserrat,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
