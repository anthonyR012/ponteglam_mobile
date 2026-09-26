import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ponte_glam/config/constant/assets_constant.dart';
import 'package:ponte_glam/config/theme/theme.dart';
import 'package:ponte_glam/di/shared_imports.dart';
import 'package:ponte_glam/shared/model/headquarter_model.dart';

class LikeInteraction extends StatefulWidget {
  const LikeInteraction(
      {super.key,
      required this.headquarter,
      required this.isLoading,
      this.size = 23,
      this.color = primaryColorTheme,
      this.padding,
      this.withContainer = false});
  final bool isLoading;
  final double size;
  final Color color;
  final EdgeInsetsGeometry? padding;
  final bool withContainer;
  final HeadquarterModel? headquarter;

  @override
  State<LikeInteraction> createState() => _LikeInteractionState();
}

class _LikeInteractionState extends State<LikeInteraction> {
  late String icon;
  late bool like;
  late HeadquarterModel? headquarter;
  bool isPressed = false;

  @override
  void initState() {
    initData();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant LikeInteraction oldWidget) {
    initData();
    super.didUpdateWidget(oldWidget);
  }

  void initData() {
    headquarter = widget.headquarter;
    like = headquarter?.like ?? false;
    icon = like ? iconFavComplete : iconFavEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: widget.padding ?? EdgeInsets.zero,
        child: InkWell(
          splashFactory: NoSplash.splashFactory,
          borderRadius: const BorderRadius.all(
            Radius.circular(32.0),
          ),
          onTap: _onPressedLike,
          child: widget.withContainer ? _buildWithContainer() : _buildIcon(),
        ));
  }

  void _onPressedLike() async {
    if (isPressed) return;
    isPressed = true;
    like = !like;
    icon = like ? iconFavComplete : iconFavEmpty;
    int headquarterId = headquarter?.id ?? 0;
    final state = await getIt<HeadquarterCubit>().doInteract(
        interaction: like ? Interaction.like : Interaction.dislike,
        headquarterCompanyId: headquarterId);
    if (state is InteractiveLoaded) {
      if (mounted) {
        final currentList = getIt<HeadquarterCubit>().headquarters;
        var filter = getIt<ServiceBloc>().filterService;
        filter = filter.copyWith(isRefresh: true);
        context.read<HomeBloc>().add(DoGetServicesEvent(
            filterService: filter, headquarters: currentList));
        filter = filter.copyWith(isRefresh: false);
      }
    }
    setState(() {
      isPressed = false;
    });
  }

  SvgPicture _buildIcon() {
    return SvgPicture.asset(
      '$pathManagementIcons$icon',
      width: widget.size,
      height: widget.size,
      colorFilter: ColorFilter.mode(widget.color, BlendMode.srcIn),
    );
  }

  Container _buildWithContainer() {
    return Container(
      width: 33,
      height: 33,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.black12,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ]),
      child: SvgPicture.asset(
        '$pathManagementIcons$icon',
        width: widget.size,
        height: widget.size,
        colorFilter: ColorFilter.mode(widget.color, BlendMode.srcIn),
      ),
    );
  }
}
