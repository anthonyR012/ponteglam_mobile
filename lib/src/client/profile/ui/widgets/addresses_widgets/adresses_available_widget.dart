import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ponte_glam/config/constant/assets_constant.dart';
import 'package:ponte_glam/config/constant/values_constant.dart';
import 'package:ponte_glam/config/theme/theme.dart';
import 'package:ponte_glam/di/shared_imports.dart';
import 'package:ponte_glam/shared/model/address_model.dart';
import 'package:ponte_glam/shared/model/type_model.dart';
import 'package:ponte_glam/shared/widgets/title_banner_label_widget.dart';
import 'package:ponte_glam/shared/widgets/unavailable_widget.dart';
import 'package:ponte_glam/src/client/profile/ui/profile_page.dart';
import 'package:ponte_glam/src/client/profile/ui/widgets/addresses_widgets/create_address_widget.dart';
import 'package:ponte_glam/src/client/profile/ui/widgets/addresses_widgets/update_address_widget.dart';
import 'package:ponte_glam/src/client/profile/ui/widgets/bar_profile_widgets.dart';
import 'package:ponte_glam/shared/widgets/ponte_alert_dialog.dart';
import 'package:skeletonizer/skeletonizer.dart';

class AddressesPage extends StatefulWidget {
  const AddressesPage({super.key});
  static const routeName = 'addresses';

  @override
  State<AddressesPage> createState() => _AddressesPageState();
}

class _AddressesPageState extends State<AddressesPage> {
  List<TypeModel> addressesTypes = [];
  Map<int, IconData> iconsAddress = {};
  late final Future getAddresses;
  late final Future getCurrentPosition;
  Position? currentPosition;

  @override
  void initState() {
    getCurrentPosition = _getPositionUserAddress();
    getAddresses = _getAddressesTypes();
    context.read<HomeBloc>().add(DoGetUserAddressesEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBarProfileWidget(
            title: getIt<AppLocalizations>().titleAddresses),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder(
          future: getAddresses,
          builder: (context, snapshot) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildCurrentLocationCard(),
                const SizedBox(height: 20),
                BlocListener<HomeBloc, HomeState>(
                  listener: (context, state) {
                    if (state is AddressDeleted) {
                      context.read<HomeBloc>().add(DoGetUserAddressesEvent());
                    }
                  },
                  child: const SizedBox.shrink(),
                ),
                BlocBuilder<HomeBloc, HomeState>(
                  builder: (context, state) {
                    final int count = state is GetUserAddressesLoaded
                        ? state.addresses.length
                        : 0;
                    final bool atLimit = count >= 3;
                    return GetBannerTitleLabel(
                      title: getIt<AppLocalizations>().titleRecentAddresses,
                      icon: atLimit
                          ? Row(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Icon(Icons.info_outline_rounded,
                                    color: grayTextColorTheme, size: 16),
                                SizedBox(width: 4),
                                Text(
                                  'Máx. 3 direcciones',
                                  style: TextStyle(
                                    color: grayTextColorTheme,
                                    fontSize: bodySize - 2,
                                  ),
                                ),
                              ],
                            )
                          : TextButton.icon(
                              onPressed: _openCreateAddress,
                              icon: const Icon(Icons.add_circle_outline_rounded,
                                  color: secondaryColorTheme, size: 20),
                              label: Text(
                                getIt<AppLocalizations>().titleCreateAddress,
                                style: const TextStyle(
                                  color: secondaryColorTheme,
                                  fontWeight: FontWeight.bold,
                                  fontSize: bodySize - 2,
                                ),
                              ),
                              style: TextButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                minimumSize: Size.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                            ),
                    );
                  },
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: BlocBuilder<HomeBloc, HomeState>(
                    builder: (context, state) {
                      bool isLoading = state is HomeIsLoading;
                      final List<AddressModel> addresses =
                          state is GetUserAddressesLoaded
                              ? state.addresses
                              : [];

                      if (state is HomeError) {
                        return UnavailableWidget(
                          textDescription: state.messageError,
                          image: imageNoLocation,
                          context: context,
                          retryTap: () => context
                              .read<HomeBloc>()
                              .add(DoGetUserAddressesEvent()),
                        );
                      }

                      if (!isLoading &&
                          addresses.isEmpty &&
                          state is GetUserAddressesLoaded) {
                        return Center(
                          child: SingleChildScrollView(
                            child: UnavailableWidget(
                              textDescription:
                                  getIt<AppLocalizations>().titleNoCoincidences,
                              image: imageNoLocation,
                              context: context,
                              textButton:
                                  getIt<AppLocalizations>().titleCreateAddress,
                              retryTap: _openCreateAddress,
                            ),
                          ),
                        );
                      }

                      return Skeletonizer(
                        enabled: isLoading,
                        child: ListView.builder(
                          itemCount: isLoading ? 10 : addresses.length,
                          itemBuilder: (context, index) {
                            final AddressModel address = isLoading
                                ? AddressModel.empty()
                                : addresses[index];
                            return _BuildAddressCard(
                                address: address,
                                isLoading: isLoading,
                                isError: false,
                                iconsAddress: iconsAddress,
                                addressesTypes: addressesTypes,
                                idCurrentType: 0);
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _openCreateAddress() {
    String path =
        "/${ProfilePage.routeName}/${AddressesPage.routeName}/${CreateAddressWidget.routeName}";
    context.push(path, extra: currentPosition);
  }

  Widget _buildCurrentLocationCard() {
    return Container(
      decoration: BoxDecoration(
        color: whiteColorTheme,
        borderRadius: BorderRadius.circular(rounded10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: primaryColorTheme.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.my_location_rounded,
              color: primaryColorTheme, size: 20),
        ),
        title: Text(
          getIt<AppLocalizations>().titleCurrentLocation,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: h4Size,
            color: secondaryColorTheme,
          ),
        ),
        subtitle: FutureBuilder(
            future: getCurrentPosition,
            builder: (context, snapshot) {
              final currentLocation =
                  snapshot.connectionState == ConnectionState.done
                      ? snapshot.data as List<Placemark>
                      : [];
              return Text(
                currentLocation.isNotEmpty &&
                        currentLocation.first.street != null
                    ? '${currentLocation.first.street!}, ${currentLocation.first.locality ?? ""}'
                    : getIt<AppLocalizations>().titleNotIdentified,
                style: const TextStyle(
                    color: grayTextColorTheme, fontSize: bodySize),
              );
            }),
      ),
    );
  }

  Future<List<Placemark>> _getPositionUserAddress() async {
    try {
      currentPosition = await getIt<GeoDevice>().getCurrentPosition();
      return getIt<GeoDevice>().getAddressFromPosition(currentPosition!);
    } catch (e) {
      return [];
    }
  }

  Future<void> _getAddressesTypes() async {
    final state = await getIt<SettingBloc>()
        .doGetTypesByCategory(category: classAddressUser);
    addressesTypes = state.fold((l) => [], (r) => r);
    for (TypeModel type in addressesTypes) {
      if (type.code.contains("home") || type.code.contains("house")) {
        iconsAddress[type.id] = Icons.home;
      } else if (type.code.contains("work") || type.code.contains("job")) {
        iconsAddress[type.id] = Icons.work;
      } else if (type.code.contains("other")) {
        iconsAddress[type.id] = Icons.location_on;
      }
    }
  }
}

class _BuildAddressCard extends StatefulWidget {
  const _BuildAddressCard({
    required this.address,
    required this.idCurrentType,
    this.isError = false,
    required this.addressesTypes,
    required this.iconsAddress,
    this.isLoading = false,
  });
  final AddressModel address;
  final bool isError;
  final bool isLoading;
  final int idCurrentType;
  final List<TypeModel> addressesTypes;
  final Map<int, IconData> iconsAddress;

  @override
  State<_BuildAddressCard> createState() => _BuildAddressCardState();
}

class _BuildAddressCardState extends State<_BuildAddressCard> {
  List<TypeModel> addressesTypes = [];
  Map<int, IconData> iconsAddress = {};

  @override
  void initState() {
    addressesTypes = widget.addressesTypes;
    iconsAddress = widget.iconsAddress;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TypeModel? typeAddress;
    if (!widget.isLoading && widget.addressesTypes.isNotEmpty) {
      typeAddress = widget.addressesTypes.firstWhere(
          (element) => element.id == widget.idCurrentType,
          orElse: () => widget.addressesTypes.first);
    }
    return Skeleton.shade(
      shade: widget.isLoading,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: whiteColorTheme,
          borderRadius: BorderRadius.circular(rounded10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: InkWell(
          onTap: () {
            String path =
                "/${ProfilePage.routeName}/${AddressesPage.routeName}/${UpdateAddressWidget.routeName}";
            context.push(path, extra: widget.address.toJson());
          },
          borderRadius: BorderRadius.circular(rounded10),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: backgroundColorTheme,
                    borderRadius: BorderRadius.circular(rounded10),
                  ),
                  child: Icon(
                    iconsAddress[widget.idCurrentType] ??
                        Icons.location_on_rounded,
                    color: primaryColorTheme,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.address.address,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: h4Size,
                          color: secondaryColorTheme,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        typeAddress?.description ?? "",
                        style: const TextStyle(
                          color: grayTextColorTheme,
                          fontSize: bodySize,
                        ),
                      ),
                      if (widget.isError)
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Text(
                            getIt<AppLocalizations>().failureIncompleAddress,
                            style: const TextStyle(
                              color: cancelColorTheme,
                              fontSize: bodySize - 2,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: greyBlockColorTheme,
                ),
                if (!widget.isLoading)
                  IconButton(
                    onPressed: () => _confirmDelete(context),
                    icon: const Icon(Icons.delete_outline_rounded,
                        color: cancelColorTheme, size: 20),
                    tooltip: 'Eliminar dirección',
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    PonteAlertDialog.show(
      context,
      title: 'Eliminar dirección',
      message:
          '¿Estás seguro de que deseas eliminar esta dirección?\n\n"${widget.address.address}"',
      confirmText: 'Eliminar',
      isDanger: true,
      onConfirm: () {
        if (widget.address.id != null) {
          context
              .read<HomeBloc>()
              .add(DoDeleteUserAddressEvent(widget.address.id!));
        }
      },
    );
  }
}
