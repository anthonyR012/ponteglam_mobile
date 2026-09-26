import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
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

class CreateAddressWidget extends StatefulWidget {
  const CreateAddressWidget({
    super.key,
    required this.currentPosition,
  });

  static const routeName = 'create_address';
  final Position? currentPosition;

  @override
  State<CreateAddressWidget> createState() => _CreateAddressWidgetState();
}

class _CreateAddressWidgetState extends State<CreateAddressWidget> {
  final FocusNode focusNodeAddress = FocusNode();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  LatLng? _locationSelected;
  bool _mapError = false;

  // Segmented Controllers
  String? _selectedViaType;
  final TextEditingController _viaNumController = TextEditingController();
  final TextEditingController _viaSuffixController = TextEditingController();
  final TextEditingController _genNumController = TextEditingController();
  final TextEditingController _placaController = TextEditingController();
  final TextEditingController _detailsController = TextEditingController();

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
    Size size = MediaQuery.of(context).size;
    double widthParent = size.width;
    double width = widthParent * 0.9;
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
                            hint: 'A',
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
                      inputFormatters: [LengthLimitingTextInputFormatter(30)],
                      validator: (v) => (v == null || v.isEmpty)
                          ? 'Requerido'
                          : v.length > 40
                              ? 'Máx. 40 car.'
                              : null,
                    ),
                  ],
                ),
                const SizedBox(height: spaceBetween10 * 2),
                Row(
                  children: [
                    const ModernSectionHeader(title: 'Punto en el Mapa'),
                    const SizedBox(width: 6),
                    const Text('*',
                        style: TextStyle(
                            color: cancelColorTheme,
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 4),
                const Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: Text(
                    'Toca el mapa para marcar la ubicación exacta de tu dirección',
                    style: TextStyle(color: grayTextColorTheme, fontSize: 12),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(rounded10),
                    border: Border.all(
                      color: _mapError ? cancelColorTheme : Colors.transparent,
                      width: _mapError ? 1.5 : 0,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(rounded10),
                    child: OpenMapMarker(
                        onTapMap: (LatLng point) {
                          setState(() {
                            _locationSelected = point;
                            _mapError = false;
                          });
                        },
                        width: double.infinity,
                        currentPosition: widget.currentPosition),
                  ),
                ),
                if (_mapError)
                  Padding(
                    padding: const EdgeInsets.only(top: 6, left: 4),
                    child: Row(
                      children: const [
                        Icon(Icons.location_off_outlined,
                            size: 14, color: cancelColorTheme),
                        SizedBox(width: 4),
                        Text(
                          'Debes marcar un punto en el mapa',
                          style:
                              TextStyle(color: cancelColorTheme, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: spaceBetween10 * 3),
                BlocListener<HomeBloc, HomeState>(
                    listener: (context, state) {
                      if (state is HomeError) {
                        PonteSnackBar.show(
                          context,
                          message: state.messageError,
                          type: TypeAlert.error,
                        );
                      } else if (state is AddressUserWasCreated) {
                        PonteSnackBar.show(
                          context,
                          message:
                              getIt<AppLocalizations>().successCreateAddress,
                          type: TypeAlert.success,
                        );
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
                            getIt<AppLocalizations>().titleCreateAddress,
                        actionButton: ActionButtonLog.confirm,
                        backgroundColor: primaryColorTheme,
                        actionDescription: runtimeType.toString(),
                        onPressed: () async {
                          final formValid = formKey.currentState!.validate();
                          final mapValid = _locationSelected != null;
                          if (!mapValid) {
                            setState(() => _mapError = true);
                          }
                          if (!formValid || !mapValid) return;
                          final constructed = _getConstructedAddress();
                          if (constructed.length > 100) {
                            PonteSnackBar.show(
                              context,
                              message:
                                  'La dirección supera los 100 caracteres permitidos',
                              type: TypeAlert.error,
                            );
                            return;
                          }
                          final address = AddressModel(
                            address: constructed,
                            latitude: _locationSelected!.latitude.toString(),
                            longitude: _locationSelected!.longitude.toString(),
                          );
                          context
                              .read<HomeBloc>()
                              .add(DoCreateUserAddressEvent(address));
                          await Future.delayed(Durations.medium3);
                        })),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
