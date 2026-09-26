import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ponte_glam/config/constant/assets_constant.dart';
import 'package:ponte_glam/config/theme/theme.dart';
import 'package:ponte_glam/config/constant/values_constant.dart';
import 'package:ponte_glam/config/utils/alert_default_util.dart';
import 'package:ponte_glam/di/shared_imports.dart';
import 'package:ponte_glam/shared/model/category_model.dart';
import 'package:ponte_glam/shared/model/headquarter_model.dart';
import 'package:ponte_glam/src/client/home/ui/widgets/list_services/appbar_custom_search_widget.dart';
import 'package:ponte_glam/src/client/home/ui/widgets/list_services/card_headquarter_widget.dart';
import 'package:ponte_glam/src/client/home/ui/widgets/list_services/card_service_widget.dart';
import 'package:ponte_glam/src/client/home/ui/widgets/list_services/categories_banner_widget.dart';
import 'package:fancy_drawer/fancy_drawer.dart';
import 'package:ponte_glam/shared/widgets/unavailable_widget.dart';
import 'package:ponte_glam/src/client/home/ui/widgets/list_services/filter_alert_widget.dart';
import 'package:ponte_glam/src/client/home/ui/widgets/list_services/input_search_widget.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HomeDetailPage extends StatefulWidget {
  const HomeDetailPage({
    super.key,
    this.pinned = true,
    this.floating = true,
    required this.controllerMenu,
  });

  final bool pinned;
  final bool floating;
  final FancyDrawerController controllerMenu;

  @override
  State<HomeDetailPage> createState() => _HomeDetailPageState();
}

class _HomeDetailPageState extends State<HomeDetailPage> {
  bool _pinned = true;
  bool _floating = true;
  double width = 0;
  double height = 0;
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  late final SettingBloc _settingBloc;
  late final HomeBloc _homeBloc;
  late final HeadquarterCubit _headquarterCubit;

  @override
  void initState() {
    super.initState();
    _headquarterCubit = context.read<HeadquarterCubit>();
    _homeBloc = context.read<HomeBloc>();
    _settingBloc = context.read<SettingBloc>();
    _scrollController.addListener(() {
      final nextUrl = getIt<HeadquarterCubit>().nextUrlServices;
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          nextUrl != null) {
        var filter = getIt<ServiceBloc>().filterService;
        _homeBloc.add(DoGetServicesEvent(filterService: filter));
      }
    });

    _pinned = widget.pinned;
    _floating = widget.floating;

    _searchFocusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return CustomScrollView(
      controller: _scrollController,
      slivers: <Widget>[
        SliverPersistentHeader(
            pinned: _pinned,
            floating: _floating,
            delegate: _SliverAppBarDelegate(
              maxHeight: 120,
              minHeight: 85,
              child: _onScroll,
            )),
        SliverToBoxAdapter(
            child: Padding(
          padding: const EdgeInsets.only(top: 3.0),
          child: CategoriesList(
            onTapCategory: _onTapCategory,
            height: height * 0.11,
            width: width,
          ),
        )),
        _buildProviderServices(),
      ],
    );
  }

  BlocBuilder<HomeBloc, HomeState> _buildProviderServices() {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        final headquarters = _headquarterCubit.headquarters;
        bool isLoading = state is HomeIsLoading ||
            (state is! GetHeadquartersLoaded &&
                state is! HomeError &&
                headquarters.isEmpty);
        if ((state is HomeError || state is GetHeadquartersLoaded) &&
            headquarters.isEmpty) {
          String message = state is HomeError
              ? state.messageError
              : getIt<AppLocalizations>().failureNoFound("servicios");
          return SliverToBoxAdapter(
            child: UnavailableWidget(
              textDescription: message,
              context: context,
              image: imageNoFound,
              retryTap: () {
                getIt<ServiceBloc>().setFilter(context: context);
              },
            ),
          );
        }
        final hasMore = _headquarterCubit.nextUrlServices != null;
        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              final isLatestOne = index >= headquarters.length;
              final enableLoading = isLoading || isLatestOne;

              HeadquarterModel? headquarter;
              if (!enableLoading) {
                final selectedCategoryId = _settingBloc.categorySelected?.id;
                final originalHeadquarter = headquarters[index];
                final filteredServices = selectedCategoryId == null
                    ? originalHeadquarter.services
                    : originalHeadquarter.services
                        .where((s) => s.categoryServiceId == selectedCategoryId)
                        .toList();
                headquarter =
                    originalHeadquarter.copyWith(services: filteredServices);
              }

              final bool uniqueCard = enableLoading
                  ? false
                  : (headquarter?.services.length ?? 0) == 1;

              return Skeletonizer(
                  enabled: enableLoading,
                  child: uniqueCard
                      ? CardServiceUnique(
                          buildContext: context,
                          isLoading: enableLoading,
                          headquarter: headquarter)
                      : CardHeadquarterServices(
                          buildContext: context,
                          isLoading: enableLoading,
                          headquarter: headquarter));
            },
            addAutomaticKeepAlives: true,
            childCount: isLoading
                ? 4
                : _headquarterCubit.headquarters.length + (hasMore ? 1 : 0),
          ),
        );
      },
    );
  }

  Widget _onScroll(double percentage) {
    InputDecoration? decoration;
    
    // This is the standalone filter icon shown when the search bar is hidden (scrolled down)
    final filterIconStandalone = InkWell(
      splashFactory: InkSplash.splashFactory,
      onTap: () {
        showCustomBottomSheet(context, const BottonFilterWidget());
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 5),
        child: BlocBuilder<ServiceBloc, ServiceState>(
          builder: (context, state) {
            final filter = state is GetFilterServiceLoaded
                ? state.filter
                : getIt<ServiceBloc>().filterService;
            final isFiltering = filter.isFiltering;
            final count = filter.filterCount;

            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isFiltering ? primaryColorTheme : secondaryColorTheme,
                boxShadow: isFiltering
                    ? [
                        BoxShadow(
                          color: primaryColorTheme.withValues(alpha: 0.4),
                          blurRadius: 8,
                          spreadRadius: 1,
                        )
                      ]
                    : null,
              ),
              padding: const EdgeInsets.all(paddingInput5),
              child: Center(
                child: isFiltering
                    ? Text(
                        count.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: h4Size,
                        ),
                      )
                    : SvgPicture.asset(
                        "$pathManagementIcons$iconSettingFilter",
                        semanticsLabel: iconPonteSecondary,
                        width: lerpDouble(13, 15, ((percentage - 1) * -1)),
                        fit: BoxFit.contain,
                        colorFilter: const ColorFilter.mode(
                            whiteColorTheme, BlendMode.srcIn),
                      ),
              ),
            );
          },
        ),
      ),
    );

    return Stack(
      children: [
        Positioned.fill(
          child: AnimatedAppBarCustomSearch(
              width: width,
              iconMenu: true,
              height: height,
              controllerMenu: widget.controllerMenu,
              percentage: percentage),
        ),
        if (percentage > 0.5)
          Align(
              alignment: Alignment.centerRight,
              child: Opacity(
                opacity: percentage,
                child: Padding(
                    padding: const EdgeInsets.only(right: 5),
                    child: filterIconStandalone),
              )),
        if (percentage < 0.5)
          InputSearchCompleteText(
              width: width,
              textInputSearch: _searchController,
              focusNode: _searchFocusNode,
              decoration: decoration,
              percentage: percentage),
      ],
    );
  }

  void _onTapCategory(CategoryModel selected) {
    _settingBloc.categorySelected = selected;
    getIt<ServiceBloc>().setFilter(context: context);
    setState(() {});
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
