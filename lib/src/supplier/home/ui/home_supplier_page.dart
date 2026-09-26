import 'package:fancy_drawer/fancy_drawer.dart';
import 'package:flutter/material.dart';
import 'package:ponte_glam/config/utils/navigation_util.dart';
import 'package:ponte_glam/shared/model/headquarter_model.dart';
import 'package:ponte_glam/src/supplier/home/ui/responsive/small_mobile_supplier_page.dart';
import 'package:ponte_glam/shared/model/service_model.dart';
import 'package:ponte_glam/di/shared_imports.dart';

class HomePageSupplier extends StatefulWidget {
  const HomePageSupplier({super.key, required this.headquarter});
  static const String routeName = "home_supplier";
  final HeadquarterModel headquarter;

  @override
  State<HomePageSupplier> createState() => _HomePageSupplierState();
}

class _HomePageSupplierState extends State<HomePageSupplier>
    with SingleTickerProviderStateMixin {
  late FancyDrawerController _controllerMenu;
  final NotifierNav _notifierNav =
      NotifierNav(routeName: HomePageSupplier.routeName);
  late HeadquarterModel _currentHeadquarter;

  @override
  void initState() {
    super.initState();
    _currentHeadquarter = widget.headquarter;
    _controllerMenu = FancyDrawerController(
        vsync: this, duration: const Duration(milliseconds: 250))
      ..addListener(() {
        setState(() {});
      });

    _refreshData();
  }

  int _refreshCount = 0;

  Future<void> _refreshData() async {
    final storage = getIt<IStorage>();
    final geoDevice = getIt<GeoDevice>();

    final params = ParamsDoGetServices(
      storage: storage,
      filter: const FilterServiceModel(mine: true),
      geoDevice: geoDevice,
    );

    final result = await getIt<DoGetServices>().call(params: params);

    result.fold(
      (failure) {},
      (paginator) {
        if (mounted) {
          final savedPlaceId = getIt<SharedPreferences>().getInt(keyPlace);
          final validId = (_currentHeadquarter.id != 0) 
              ? _currentHeadquarter.id 
              : savedPlaceId;
              
          final updated = paginator.headquarters.firstWhere(
            (hq) => hq.id == validId,
            orElse: () => paginator.headquarters.isNotEmpty
                ? paginator.headquarters.first
                : _currentHeadquarter,
          );
          setState(() {
            _currentHeadquarter = updated;
            _refreshCount++;
          });
        }
      },
    );
  }

  @override
  void dispose() {
    _controllerMenu.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SmallMobileHomeSupplierPage(
            controllerMenu: _controllerMenu,
            notifierNav: _notifierNav,
            headquarter: _currentHeadquarter,
            refreshCount: _refreshCount,
            onRefreshData: _refreshData,
          );
        },
      ),
    );
  }
}
