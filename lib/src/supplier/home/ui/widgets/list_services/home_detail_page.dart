import 'package:flutter/material.dart';
import 'package:ponte_glam/config/constant/assets_constant.dart';
import 'package:ponte_glam/config/theme/theme.dart';
import 'package:ponte_glam/config/constant/values_constant.dart';
import 'package:ponte_glam/shared/model/headquarter_model.dart';
import 'package:ponte_glam/shared/model/service_model.dart';
import 'package:ponte_glam/src/supplier/home/ui/widgets/list_services/appbar_custom_search_widget.dart';
import 'package:fancy_drawer/fancy_drawer.dart';
import 'package:ponte_glam/shared/widgets/ponte_alert_dialog.dart';
import 'package:ponte_glam/shared/widgets/snack_bar_simple_widget.dart';
import 'package:ponte_glam/shared/widgets/button_main_widget.dart';
import 'package:ponte_glam/src/supplier/home/ui/home_supplier_page.dart';
import 'package:ponte_glam/src/supplier/service/ui/create_service_page.dart';
import 'package:ponte_glam/src/client/home/ui/widgets/list_services/card_service_widget.dart';
import 'package:ponte_glam/src/supplier/headquarter/ui/cubit/headquarter_cubit.dart';
import 'package:ponte_glam/src/supplier/headquarter/ui/cubit/headquarter_state.dart'
    as supplier_hq_state;
import 'package:ponte_glam/src/supplier/headquarter/ui/create_headquarter_page.dart';
import 'package:ponte_glam/src/client/headquarter/ui/headquarter_detail_page.dart';
import 'package:ponte_glam/di/shared_imports.dart';

class HomeDetailSupplierPage extends StatelessWidget {
  const HomeDetailSupplierPage({
    super.key,
    required this.controllerMenu,
    required this.headquarter,
    required this.refreshCount,
    required this.onRefreshData,
  });

  final FancyDrawerController controllerMenu;
  final HeadquarterModel headquarter;
  final int refreshCount;
  final VoidCallback onRefreshData;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SupplierHeadquarterCubit>(
      create: (_) => getIt<SupplierHeadquarterCubit>(),
      child: _HomeDetailSupplierView(
        controllerMenu: controllerMenu,
        headquarter: headquarter,
        refreshCount: refreshCount,
        onRefreshData: onRefreshData,
      ),
    );
  }
}

class _HomeDetailSupplierView extends StatefulWidget {
  const _HomeDetailSupplierView({
    required this.controllerMenu,
    required this.headquarter,
    required this.refreshCount,
    required this.onRefreshData,
  });

  final FancyDrawerController controllerMenu;
  final HeadquarterModel headquarter;
  final int refreshCount;
  final VoidCallback onRefreshData;

  @override
  State<_HomeDetailSupplierView> createState() =>
      _HomeDetailSupplierViewState();
}

class _HomeDetailSupplierViewState extends State<_HomeDetailSupplierView> {
  double width = 0;
  double height = 0;
  final ScrollController _scrollController = ScrollController();

  List<HeadquarterModel> _headquarters = [];
  int? _selectedHqId;
  bool _loadingHqs = false;

  @override
  void initState() {
    super.initState();
    _selectedHqId = widget.headquarter.id;
    _loadHeadquarters();
  }

  @override
  void didUpdateWidget(covariant _HomeDetailSupplierView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.headquarter != widget.headquarter ||
        oldWidget.refreshCount != widget.refreshCount) {
      if (widget.headquarter.id != 0) {
        _selectedHqId = widget.headquarter.id;
      }
      _loadHeadquarters();
    }
  }

  Future<void> _loadHeadquarters() async {
    setState(() => _loadingHqs = true);
    final result = await getIt<DoGetServices>().call(
      params: ParamsDoGetServices(
        filter: const FilterServiceModel(mine: true),
        geoDevice: getIt<GeoDevice>(),
        storage: getIt<IStorage>(),
      ),
    );
    if (!mounted) return;
    result.fold(
      (_) => setState(() => _loadingHqs = false),
      (paginator) => setState(() {
        _headquarters = paginator.headquarters;
        if ((_selectedHqId == null || _selectedHqId == 0) &&
            _headquarters.isNotEmpty) {
          final savedPlaceId = getIt<SharedPreferences>().getInt(keyPlace);
          if (savedPlaceId != null &&
              _headquarters.any((h) => h.id == savedPlaceId)) {
            _selectedHqId = savedPlaceId;
          } else {
            _selectedHqId = _headquarters.first.id;
          }
        }
        _loadingHqs = false;
      }),
    );
  }

  HeadquarterModel get _selectedHeadquarter {
    return _headquarters.firstWhere(
      (h) => h.id == _selectedHqId,
      orElse: () => widget.headquarter,
    );
  }

  void _confirmDeleteHeadquarter(HeadquarterModel hq) {
    PonteAlertDialog.show(
      context,
      title: 'Eliminar sede',
      message:
          '¿Estás seguro de que deseas eliminar la sede "${hq.name}"? Se eliminarán todos sus servicios despues de 5 dias.',
      confirmText: 'Eliminar',
      isDanger: true,
      onConfirm: () {
        context
            .read<SupplierHeadquarterCubit>()
            .deleteHeadquarter(headquarterId: hq.id);
      },
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    final services = _selectedHeadquarter.services;
    return BlocListener<SupplierHeadquarterCubit,
        supplier_hq_state.SupplierHeadquarterState>(
      listener: (context, state) {
        if (state is supplier_hq_state.HeadquarterDeleted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Sede eliminada correctamente')),
          );
          _loadHeadquarters();
          if (_selectedHqId != null &&
              _headquarters.every((h) => h.id != _selectedHqId)) {
            setState(() {
              _selectedHqId = _headquarters.isNotEmpty
                  ? _headquarters.first.id
                  : widget.headquarter.id;
            });
          }
          widget.onRefreshData();
        } else if (state is supplier_hq_state.HeadquarterError) {
          PonteSnackBar.show(
            context,
            message: state.failure.message,
            type: TypeAlert.error,
          );
        }
      },
      child: Column(
        children: [
          // Top Bar Fixed
          SizedBox(height: 85, child: _onScroll(0.0)),

          // Headquarters Fixed at top
          _HeadquartersSectionHeader(
            loading: _loadingHqs,
            headquarters: _headquarters,
            selectedHqId: _selectedHqId,
            onSelect: (id) => setState(() => _selectedHqId = id),
            onDelete: _confirmDeleteHeadquarter,
            onCreateService: (hq) async {
              await context.push(
                '/${HomePageSupplier.routeName}/${CreateServicePage.routeName}',
                extra: hq,
              );
              _loadHeadquarters();
              widget.onRefreshData();
            },
            onEdit: (hq) async {
              await Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => CreateHeadquarterPage(
                  companyId: hq.companyId ?? 0,
                  isEditing: true,
                  existingHeadquarter: hq,
                ),
              ));
              _loadHeadquarters();
              widget.onRefreshData();
            },
            onViewDetail: (hq) {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => HeadquarterDetailPage(headquarter: hq),
              ));
            },
          ),

          Expanded(
            child: CustomScrollView(
              controller: _scrollController,
              slivers: <Widget>[
                if (_loadingHqs)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: _headquarters.isEmpty
                          ? const SizedBox.shrink()
                          : const CircularProgressIndicator(),
                    ),
                  )
                else if (services.isEmpty)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "¡Bienvenido ${widget.headquarter.companyInfo?.name ?? ''} es hora de que crees tu primer servicio!",
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: h2Size,
                              fontWeight: FontWeight.bold,
                              fontFamily: fontFamilyMontserrat,
                              color: secondaryColorTheme,
                            ),
                          ),
                          const SizedBox(height: spaceBetween10 * 4),
                          ButtonMain(
                            width: width,
                            textButton: "Crear servicio",
                            onPressed: () async {
                              await context.push(
                                '/${HomePageSupplier.routeName}/${CreateServicePage.routeName}',
                                extra: widget.headquarter,
                              );
                              _loadHeadquarters();
                              widget.onRefreshData();
                            },
                          ),
                        ],
                      ),
                    ),
                  )
                else ...[
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 1,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.transparent,
                                    secondaryColorTheme.withValues(alpha: 0.3),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              children: [
                                Icon(Icons.auto_awesome_rounded,
                                    size: 18,
                                    color: secondaryColorTheme.withValues(
                                        alpha: 0.6)),
                                const SizedBox(width: 8),
                                Text(
                                  'SERVICIOS',
                                  style: TextStyle(
                                    fontSize: 13,
                                    letterSpacing: 2,
                                    fontWeight: FontWeight.w900,
                                    fontFamily: fontFamilyMontserrat,
                                    color: secondaryColorTheme.withValues(
                                        alpha: 0.8),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Container(
                              height: 1,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    secondaryColorTheme.withValues(alpha: 0.3),
                                    Colors.transparent,
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.only(top: 10),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final service = services[index];
                          return CardServiceUnique(
                            buildContext: context,
                            isLoading: false,
                            headquarter: _selectedHeadquarter,
                            service: service,
                            isSupplierMode: true,
                            onRefreshData: widget.onRefreshData,
                          );
                        },
                        childCount: services.length,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _onScroll(double percentage) {
    return Stack(
      children: [
        Positioned.fill(
          child: AnimatedAppBarCustomSearch(
              width: width,
              iconMenu: true,
              height: height,
              controllerMenu: widget.controllerMenu,
              companyName: widget.headquarter.companyInfo?.name ?? '',
              companyAddress: widget.headquarter.address ?? '',
              percentage: percentage),
        ),
      ],
    );
  }
}

class _HeadquartersSectionHeader extends StatelessWidget {
  const _HeadquartersSectionHeader({
    required this.loading,
    required this.headquarters,
    required this.selectedHqId,
    required this.onSelect,
    required this.onDelete,
    required this.onCreateService,
    required this.onEdit,
    required this.onViewDetail,
  });

  final bool loading;
  final List<HeadquarterModel> headquarters;
  final int? selectedHqId;
  final ValueChanged<int> onSelect;
  final ValueChanged<HeadquarterModel> onDelete;
  final ValueChanged<HeadquarterModel> onCreateService;
  final ValueChanged<HeadquarterModel> onEdit;
  final ValueChanged<HeadquarterModel> onViewDetail;

  @override
  Widget build(BuildContext context) {
    if (loading && headquarters.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 12),
        child: Center(child: CircularProgressIndicator()),
      );
    }
    if (headquarters.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  secondaryColorTheme,
                  secondaryColorTheme.withValues(alpha: 0.8),
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: secondaryColorTheme.withValues(alpha: 0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Icon(Icons.storefront_rounded, color: Colors.white, size: 20),
                SizedBox(width: 8),
                Text(
                  'Mis sedes',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: fontFamilyMontserrat,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
        LayoutBuilder(
          builder: (context, constraints) {
            final cardWidth = constraints.maxWidth * 0.9;
            return SizedBox(
              height: 165, // Increased height to prevent overflow
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: headquarters.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final hq = headquarters[index];
                  return _HeadquarterCard(
                    headquarter: hq,
                    cardWidth: cardWidth,
                    isSelected: hq.id == selectedHqId,
                    onSelect: () => onSelect(hq.id),
                    onDelete: () => onDelete(hq),
                    onCreateService: () => onCreateService(hq),
                    onEdit: () => onEdit(hq),
                    onViewDetail: () => onViewDetail(hq),
                  );
                },
              ),
            );
          },
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}

class _HeadquarterCard extends StatelessWidget {
  const _HeadquarterCard({
    required this.headquarter,
    required this.cardWidth,
    required this.isSelected,
    required this.onSelect,
    required this.onDelete,
    required this.onCreateService,
    required this.onEdit,
    required this.onViewDetail,
  });

  final HeadquarterModel headquarter;
  final double cardWidth;
  final bool isSelected;
  final VoidCallback onSelect;
  final VoidCallback onDelete;
  final VoidCallback onCreateService;
  final VoidCallback onEdit;
  final VoidCallback onViewDetail;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSelect,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: cardWidth,
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: whiteColorTheme,
          border: Border.all(
            color: isSelected
                ? primaryColorTheme
                : borderColorTheme.withValues(alpha: 0.5),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isSelected ? 0.08 : 0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Compact image on the left
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: headquarter.imageUrl != null &&
                          headquarter.imageUrl!.isNotEmpty
                      ? Image.network(
                          headquarter.imageUrl!,
                          height: 60,
                          width: 60,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            height: 60,
                            width: 60,
                            color: borderColorTheme.withValues(alpha: 0.3),
                            child: const Icon(Icons.storefront_rounded,
                                color: secondaryColorTheme, size: 24),
                          ),
                        )
                      : Container(
                          height: 60,
                          width: 60,
                          color: borderColorTheme.withValues(alpha: 0.3),
                          child: const Icon(Icons.storefront_rounded,
                              color: secondaryColorTheme, size: 24),
                        ),
                ),
                const SizedBox(width: 12),
                // Text content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        headquarter.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: secondaryColorTheme,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        headquarter.address ?? 'Sin dirección',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12,
                          color: grayTextColorTheme,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isSelected)
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: primaryColorTheme,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.check_rounded,
                        color: Colors.white, size: 12),
                  ),
              ],
            ),
            const Divider(height: 20, thickness: 0.5),
            // Tags/Actions
            SizedBox(
              height: 32,
              child: ListView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                children: [
                  _TagAction(
                    icon: Icons.add_rounded,
                    label: 'Servicio',
                    color: primaryColorTheme,
                    onTap: onCreateService,
                  ),
                  const SizedBox(width: 8),
                  _TagAction(
                    icon: Icons.edit_rounded,
                    label: 'Editar',
                    color: secondaryColorTheme,
                    onTap: onEdit,
                  ),
                  const SizedBox(width: 8),
                  _TagAction(
                    icon: Icons.info_outline_rounded,
                    label: 'Info',
                    color: Colors.blueGrey,
                    onTap: onViewDetail,
                  ),
                  const SizedBox(width: 8),
                  _TagAction(
                    icon: Icons.delete_outline_rounded,
                    label: 'Eliminar',
                    color: cancelColorTheme,
                    onTap: onDelete,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TagAction extends StatelessWidget {
  const _TagAction({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
