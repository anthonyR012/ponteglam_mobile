import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:latlong2/latlong.dart';
import 'package:ponte_glam/config/constant/values_constant.dart';
import 'package:ponte_glam/config/theme/theme.dart';
import 'package:ponte_glam/di/shared_imports.dart';
import 'package:ponte_glam/shared/model/address_model.dart';
import 'package:ponte_glam/shared/widgets/button_main_widget.dart';
import 'package:ponte_glam/shared/widgets/snack_bar_simple_widget.dart';
import 'package:ponte_glam/src/client/profile/ui/widgets/addresses_widgets/openmap_marker_widget.dart';
import 'package:ponte_glam/src/client/profile/ui/widgets/bar_profile_widgets.dart';
import 'package:ponte_glam/shared/widgets/modern_form_elements.dart';

class UpdateAddressWidget extends StatefulWidget {
  const UpdateAddressWidget({
    super.key,
    required this.addressModel,
  });
  static const routeName = 'update_address';

  final AddressModel addressModel;

  @override
  State<UpdateAddressWidget> createState() => _UpdateAddressWidgetState();
}

class _UpdateAddressWidgetState extends State<UpdateAddressWidget> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // Segmented Controllers
  String? _selectedViaType;
  final TextEditingController _viaNumController = TextEditingController();
  final TextEditingController _viaSuffixController = TextEditingController();
  final TextEditingController _genNumController = TextEditingController();
  final TextEditingController _placaController = TextEditingController();
  final TextEditingController _detailsController = TextEditingController();

  late LatLng _locationSelected;

  final List<String> _viaTypes = [
    'Calle',
    'Carrera',
    'Avenida',
    'Avenida Calle',
    'Avenida Carrera',
    'Diagonal',
    'Transversal',
    'Circular',
  ];

  @override
  void initState() {
    super.initState();
    _locationSelected = LatLng(
      double.parse(widget.addressModel.latitude),
      double.parse(widget.addressModel.longitude),
    );
    _deconstructAddress(widget.addressModel.address);
  }

  void _deconstructAddress(String address) {
    final regex = RegExp(
      r'^(Calle|Carrera|Avenida|Avenida Calle|Avenida Carrera|Diagonal|Transversal|Circular)\s+([^#\s]+)\s*(?:([^#\s]+)\s*)?#\s*([^-\s,]+)\s*(?:-\s*([^,\s]+))?(?:,\s*(.*))?$',
      caseSensitive: false,
    );

    final match = regex.firstMatch(address.trim());
    if (match != null) {
      setState(() {
        _selectedViaType = _viaTypes.firstWhere(
          (v) => v.toLowerCase() == match.group(1)?.toLowerCase(),
          orElse: () => _viaTypes.first,
        );
        _viaNumController.text = match.group(2) ?? "";
        _viaSuffixController.text = match.group(3) ?? "";
        _genNumController.text = match.group(4) ?? "";
        _placaController.text = match.group(5) ?? "";
        _detailsController.text = match.group(6) ?? "";
      });
    } else {
      // Fallback if regex fails, put everything in details
      _detailsController.text = address;
    }
  }

  @override
  void dispose() {
    _viaNumController.dispose();
    _viaSuffixController.dispose();
    _genNumController.dispose();
    _placaController.dispose();
    _detailsController.dispose();
    super.dispose();
  }

  String _getConstructedAddress() {
    String addr = '${_selectedViaType ?? ""} ${_viaNumController.text}';
    if (_viaSuffixController.text.isNotEmpty) {
      addr += ' ${_viaSuffixController.text}';
    }
    addr += ' # ${_genNumController.text}';
    if (_placaController.text.isNotEmpty) {
      addr += ' - ${_placaController.text}';
    }
    if (_detailsController.text.isNotEmpty) {
      addr += ', ${_detailsController.text}';
    }
    return addr.trim();
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final AlertManageUtil alertManage = getIt<AlertManageUtil>();
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: AppBarProfileWidget(
              title: getIt<AppLocalizations>().titleAddresses),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const ModernSectionHeader(title: 'Estructura de Dirección'),
                const SizedBox(height: spaceBetween10),
                ModernFormCard(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 3,
                          child: ModernDropdown<String>(
                            label: 'Vía *',
                            value: _selectedViaType,
                            items: _viaTypes,
                            itemLabel: (v) => v,
                            onChanged: (v) =>
                                setState(() => _selectedViaType = v),
                            validator: (v) => v == null ? 'Requerido' : null,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          flex: 2,
                          child: ModernTextField(
                            controller: _viaNumController,
                            label: 'N°',
                            hint: '5',
                            keyboardType: TextInputType.text,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(4)
                            ],
                            validator: (v) => (v == null || v.isEmpty)
                                ? 'Requerido'
                                : v.length > 4
                                    ? 'Máx. 4'
                                    : null,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          flex: 2,
                          child: ModernTextField(
                            controller: _viaSuffixController,
                            label: 'Letra',
                            hint: 'A/Oeste',
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(5)
                            ],
                            validator: (v) =>
                                (v != null && v.length > 5) ? 'Máx. 5' : null,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 15, right: 8),
                          child: Text('#',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: secondaryColorTheme)),
                        ),
                        Expanded(
                          child: ModernTextField(
                            controller: _genNumController,
                            label: 'Generador',
                            hint: '10',
                            keyboardType: TextInputType.text,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(4)
                            ],
                            validator: (v) => (v == null || v.isEmpty)
                                ? 'Requerido'
                                : v.length > 4
                                    ? 'Máx. 4'
                                    : null,
                          ),
                        ),
                        const Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 15),
                          child: Text('-',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: secondaryColorTheme)),
                        ),
                        Expanded(
                          child: ModernTextField(
                            controller: _placaController,
                            label: 'Placa',
                            hint: '20',
                            keyboardType: TextInputType.text,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(4)
                            ],
                            validator: (v) => (v == null || v.isEmpty)
                                ? 'Requerido'
                                : v.length > 4
                                    ? 'Máx. 4'
                                    : null,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    ModernTextField(
                      controller: _detailsController,
                      label: 'Referencia / Barrio',
                      hint: 'Apto, Edificio, Barrio',
                      icon: Icons.info_outline_rounded,
                      inputFormatters: [LengthLimitingTextInputFormatter(40)],
                      validator: (v) => (v == null || v.isEmpty)
                          ? 'Requerido'
                          : v.length > 40
                              ? 'Máx. 40 car.'
                              : null,
                    ),
                  ],
                ),
                const SizedBox(height: spaceBetween10 * 2),
                const ModernSectionHeader(title: 'Punto en el Mapa'),
                const SizedBox(height: spaceBetween10),
                ModernFormCard(
                  padding: EdgeInsets.zero,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(rounded10),
                      child: OpenMapMarker(
                          onTapMap: (LatLng point) {
                            _locationSelected = point;
                          },
                          width: double.infinity,
                          initialPoint: _locationSelected),
                    ),
                  ],
                ),
                const SizedBox(height: spaceBetween10 * 3),
                BlocListener<HomeBloc, HomeState>(
                    listener: (context, state) {
                      if (state is HomeError) {
                        context.read<AlertManageCubit>().snackParamaters =
                            ParameterSnackBarCustom(
                                message: state.messageError,
                                typeAlert: TypeAlert.error);
                        alertManage.showFor(
                            seconds: 1, type: OverlayAlertType.snackbar);
                      } else if (state is UpdatedUserAddress) {
                        context.read<AlertManageCubit>().snackParamaters =
                            ParameterSnackBarCustom(
                                message: getIt<AppLocalizations>()
                                    .successCreateAddress,
                                typeAlert: TypeAlert.success);
                        alertManage.showFor(
                            seconds: 1, type: OverlayAlertType.snackbar);
                        if (context.canPop()) {
                          context.pop();
                          context
                              .read<HomeBloc>()
                              .add(DoGetUserAddressesEvent());
                        }
                      }
                    },
                    bloc: context.read<HomeBloc>(),
                    child: ButtonMain(
                        width: width,
                        textButton:
                            getIt<AppLocalizations>().titleUpdateAddress,
                        actionButton: ActionButtonLog.confirm,
                        backgroundColor: primaryColorTheme,
                        actionDescription: runtimeType.toString(),
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            final constructed = _getConstructedAddress();
                            if (constructed.length > 100) {
                              context.read<AlertManageCubit>().snackParamaters =
                                  ParameterSnackBarCustom(
                                      message:
                                          'La dirección supera los 100 caracteres permitidos',
                                      typeAlert: TypeAlert.error);
                              alertManage.showFor(
                                  seconds: 2, type: OverlayAlertType.snackbar);
                              return;
                            }
                            final address = widget.addressModel.copyWith(
                                address: constructed,
                                latitude: _locationSelected.latitude.toString(),
                                longitude:
                                    _locationSelected.longitude.toString());
                            context
                                .read<HomeBloc>()
                                .add(DoUpdateUserAddressesEvent(address));
                            await Future.delayed(Durations.extralong3);
                          }
                        })),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
