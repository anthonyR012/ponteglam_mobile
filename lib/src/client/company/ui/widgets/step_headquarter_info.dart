import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:ponte_glam/config/constant/values_constant.dart';
import 'package:ponte_glam/device/camera/take_photo_gallery.dart';
import 'package:ponte_glam/di/shared_imports.dart';
import 'package:ponte_glam/shared/model/city_model.dart';
import 'package:ponte_glam/shared/widgets/button_main_widget.dart';
import 'package:ponte_glam/shared/widgets/modern_form_elements.dart';
import 'package:ponte_glam/shared/widgets/open_map_marker.dart';
import 'package:ponte_glam/config/theme/theme.dart';
import 'package:ponte_glam/src/client/company/domain/model/company_form_model.dart';
import 'package:ponte_glam/src/client/company/ui/cubit/company_creation_cubit.dart';
import 'package:ponte_glam/src/client/setting/domain/use_case/do_get_cities.dart';

class StepHeadquarterInfo extends StatefulWidget {
  final CompanyFormModel form;
  const StepHeadquarterInfo({super.key, required this.form});

  @override
  State<StepHeadquarterInfo> createState() => _StepHeadquarterInfoState();
}

class _StepHeadquarterInfoState extends State<StepHeadquarterInfo> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  bool _photoError = false;

  // Segmented address fields
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

  // Map location
  LatLng? _locationSelected;
  bool _locationError = false;
  Position? _currentPosition;

  List<CityModel> _cities = [];
  bool _loadingCities = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.form.headquarterName);
    _phoneController =
        TextEditingController(text: widget.form.headquarterPhone);
    _fetchCities();
    _loadCurrentPosition();
    if (widget.form.headquarterLatitude.isNotEmpty &&
        widget.form.headquarterLongitude.isNotEmpty) {
      final lat = double.tryParse(widget.form.headquarterLatitude);
      final lng = double.tryParse(widget.form.headquarterLongitude);
      if (lat != null && lng != null) {
        _locationSelected = LatLng(lat, lng);
      }
    }
  }

  Future<void> _loadCurrentPosition() async {
    try {
      final pos = await getIt<GeoDevice>().getCurrentPosition();
      if (mounted) setState(() => _currentPosition = pos);
    } catch (_) {}
  }

  Future<void> _fetchCities() async {
    setState(() => _loadingCities = true);
    final result = await getIt<DoGetCities>()(countryId: 1);
    result.fold(
      (failure) => null,
      (cities) => setState(() => _cities = cities),
    );
    setState(() => _loadingCities = false);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _viaNumController.dispose();
    _viaSuffixController.dispose();
    _genNumController.dispose();
    _placaController.dispose();
    _detailsController.dispose();
    super.dispose();
  }

  String _getConstructedAddress() {
    String addr = '${_selectedViaType ?? ''} ${_viaNumController.text}';
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

  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'El nombre es obligatorio.';
    }
    if (value.trim().length < 3) {
      return 'Mínimo 3 caracteres.';
    }
    if (value.trim().length > 200) {
      return 'Máximo 200 caracteres.';
    }
    if (RegExp(r'[<>{}]').hasMatch(value)) {
      return 'El nombre contiene caracteres no permitidos.';
    }
    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) return null;
    if (!RegExp(r'^[\d\s+\-]+$').hasMatch(value)) {
      return 'El teléfono solo puede contener números, espacios, + y -';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ModernSectionHeader(title: 'Información de la Sede'),
            const SizedBox(height: 15),
            ModernFormCard(
              children: [
                ModernTextField(
                  controller: _nameController,
                  label: 'Nombre de la sede',
                  hint: 'Ej: Sede Principal',
                  icon: Icons.store_mall_directory_rounded,
                  validator: _validateName,
                  onChanged: (_) => _updateForm(),
                ),
                const SizedBox(height: 15),
                ModernTextField(
                  controller: _phoneController,
                  label: 'Teléfono (opcional)',
                  hint: 'Ej: 3001234567',
                  icon: Icons.phone_rounded,
                  keyboardType: TextInputType.phone,
                  validator: _validatePhone,
                  onChanged: (_) => _updateForm(),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const ModernSectionHeader(title: 'Dirección'),
            const SizedBox(height: 15),
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
                        onChanged: (v) {
                          setState(() => _selectedViaType = v);
                          _updateForm();
                        },
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
                          LengthLimitingTextInputFormatter(4),
                        ],
                        validator: (v) => (v == null || v.isEmpty)
                            ? 'Requerido'
                            : v.length > 4
                                ? 'Máx. 4'
                                : null,
                        onChanged: (_) => _updateForm(),
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
                          LengthLimitingTextInputFormatter(5),
                        ],
                        validator: (v) =>
                            (v != null && v.length > 5) ? 'Máx. 5' : null,
                        onChanged: (_) => _updateForm(),
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
                      child: Text(
                        '#',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: secondaryColorTheme),
                      ),
                    ),
                    Expanded(
                      child: ModernTextField(
                        controller: _genNumController,
                        label: 'Generador',
                        hint: '10',
                        keyboardType: TextInputType.text,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(4),
                        ],
                        validator: (v) => (v == null || v.isEmpty)
                            ? 'Requerido'
                            : v.length > 4
                                ? 'Máx. 4'
                                : null,
                        onChanged: (_) => _updateForm(),
                      ),
                    ),
                    const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 8, vertical: 15),
                      child: Text(
                        '-',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: secondaryColorTheme),
                      ),
                    ),
                    Expanded(
                      child: ModernTextField(
                        controller: _placaController,
                        label: 'Placa',
                        hint: '20',
                        keyboardType: TextInputType.text,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(4),
                        ],
                        validator: (v) => (v == null || v.isEmpty)
                            ? 'Requerido'
                            : v.length > 4
                                ? 'Máx. 4'
                                : null,
                        onChanged: (_) => _updateForm(),
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
                  onChanged: (_) => _updateForm(),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const ModernSectionHeader(title: 'Ciudad'),
            const SizedBox(height: 15),
            ModernFormCard(
              children: [
                _loadingCities
                    ? const CircularProgressIndicator(
                        color: secondaryColorTheme)
                    : ModernDropdown<int>(
                        label: 'Ciudad de la sede',
                        icon: Icons.location_city_rounded,
                        value: widget.form.cityId,
                        items: _cities.map((city) => city.id).toList(),
                        itemLabel: (id) =>
                            _cities.firstWhere((c) => c.id == id).name,
                        onChanged: (val) => context
                            .read<CompanyCreationCubit>()
                            .updateForm(widget.form.copyWith(cityId: val)),
                        validator: (v) =>
                            v == null ? 'La ciudad es obligatoria.' : null,
                      ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: const [
                ModernSectionHeader(title: 'Ubicación en el Mapa'),
                SizedBox(width: 6),
                Text(
                  '*',
                  style: TextStyle(
                      color: cancelColorTheme,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 4),
            const Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: Text(
                'Toca el mapa para marcar la ubicación exacta de la sede',
                style: TextStyle(color: grayTextColorTheme, fontSize: 12),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(rounded10),
                border: Border.all(
                  color: _locationError ? cancelColorTheme : Colors.transparent,
                  width: _locationError ? 1.5 : 0,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(rounded10),
                child: OpenMapMarker(
                  onTapMap: (LatLng point) {
                    setState(() {
                      _locationSelected = point;
                      _locationError = false;
                    });
                    _updateForm();
                  },
                  width: double.infinity,
                  currentPosition: _currentPosition,
                  initialPoint: _locationSelected,
                ),
              ),
            ),
            if (_locationError)
              Padding(
                padding: const EdgeInsets.only(top: 6, left: 4),
                child: Row(
                  children: const [
                    Icon(Icons.location_off_outlined,
                        size: 14, color: cancelColorTheme),
                    SizedBox(width: 4),
                    Text(
                      'Selecciona la ubicación en el mapa.',
                      style: TextStyle(color: cancelColorTheme, fontSize: 12),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 20),
            const ModernSectionHeader(title: 'Foto del Lugar *'),
            const SizedBox(height: 15),
            ModernFormCard(
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      ...widget.form.additionalImagesPaths
                          .map((path) => Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius:
                                          BorderRadius.circular(rounded10),
                                      child: ImageLoadWidget(
                                        image: path,
                                        typeSourceImage: TypeSourceImage.file,
                                        width: 100,
                                        height: 100,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Positioned(
                                      right: 4,
                                      top: 4,
                                      child: GestureDetector(
                                        onTap: () {
                                          final newList = List<String>.from(
                                              widget.form.additionalImagesPaths)
                                            ..remove(path);
                                          context
                                              .read<CompanyCreationCubit>()
                                              .updateForm(widget.form.copyWith(
                                                  additionalImagesPaths:
                                                      newList));
                                        },
                                        child: Container(
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: cancelColorTheme,
                                          ),
                                          padding: const EdgeInsets.all(4),
                                          child: const Icon(Icons.close,
                                              color: whiteColorTheme, size: 14),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                      InkWell(
                        onTap: () async {
                          try {
                            final cubit = context.read<CompanyCreationCubit>();
                            final path = await getImagePicker();
                            if (mounted) {
                              setState(() => _photoError = false);
                              final newList = List<String>.from(
                                  widget.form.additionalImagesPaths)
                                ..add(path);
                              cubit.updateForm(widget.form
                                  .copyWith(additionalImagesPaths: newList));
                            }
                          } catch (_) {}
                        },
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: _photoError
                                    ? cancelColorTheme
                                    : secondaryColorTheme.withValues(
                                        alpha: 0.4)),
                            borderRadius: BorderRadius.circular(rounded10),
                            color: secondaryColorTheme.withValues(alpha: 0.04),
                          ),
                          child: Icon(Icons.add_a_photo_rounded,
                              color: _photoError
                                  ? cancelColorTheme
                                  : secondaryColorTheme.withValues(alpha: 0.7),
                              size: 32),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (_photoError)
              const Padding(
                padding: EdgeInsets.only(top: 6, left: 4),
                child: Text(
                  'Debes agregar al menos una foto del lugar.',
                  style: TextStyle(color: cancelColorTheme, fontSize: 12),
                ),
              ),
            const SizedBox(height: 30),
            ButtonMain(
              width: double.infinity,
              textButton: 'Siguiente',
              onPressed: _onNext,
            ),
          ],
        ),
      ),
    );
  }

  void _onNext() {
    final formValid = _formKey.currentState!.validate();
    final hasLocation = _locationSelected != null;
    final hasPhoto = widget.form.additionalImagesPaths.isNotEmpty;

    if (!hasLocation) setState(() => _locationError = true);
    if (!hasPhoto) setState(() => _photoError = true);

    if (!formValid || !hasLocation || !hasPhoto) return;
    context.read<CompanyCreationCubit>().createHeadquarter();
  }

  void _updateForm() {
    context.read<CompanyCreationCubit>().updateForm(widget.form.copyWith(
          headquarterName: _nameController.text,
          headquarterPhone: _phoneController.text,
          headquarterAddress: _getConstructedAddress(),
          headquarterLatitude: _locationSelected?.latitude.toString() ?? '',
          headquarterLongitude: _locationSelected?.longitude.toString() ?? '',
        ));
  }
}
