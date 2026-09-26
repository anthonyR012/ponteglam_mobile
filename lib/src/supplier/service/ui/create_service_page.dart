import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:ponte_glam/config/constant/assets_constant.dart';
import 'package:ponte_glam/config/theme/theme.dart';
import 'package:ponte_glam/config/constant/values_constant.dart';
import 'package:ponte_glam/di/shared_imports.dart';
import 'package:ponte_glam/shared/model/category_model.dart';
import 'package:ponte_glam/shared/model/headquarter_model.dart';
import 'package:ponte_glam/shared/model/type_model.dart';
import 'package:ponte_glam/shared/widgets/button_main_widget.dart';
import 'package:ponte_glam/src/supplier/service/domain/model/service_creation_form_model.dart';
import 'package:ponte_glam/src/supplier/service/ui/cubit/service_creation_cubit.dart';
import 'package:ponte_glam/src/supplier/service/ui/cubit/service_creation_state.dart';
import 'package:ponte_glam/shared/model/service_model.dart';
import 'package:ponte_glam/shared/widgets/snack_bar_simple_widget.dart';

class CurrencyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) return newValue;

    // Quitar todo lo que no sea número
    String newText = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (newText.isEmpty) return newValue.copyWith(text: '');

    // Formatear como moneda (COP)
    final number = int.parse(newText);
    final formatter =
        NumberFormat.currency(locale: 'es_CO', symbol: '', decimalDigits: 0);
    String formattedText = formatter.format(number).trim();

    return newValue.copyWith(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
}

class CreateServicePage extends StatelessWidget {
  const CreateServicePage({super.key, required this.headquarter, this.service});

  static const String routeName = 'create-service';

  final HeadquarterModel headquarter;
  final ServiceModel? service;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ServiceCreationCubit>()
        ..initMode(service)
        ..loadInitialData(),
      child: CreateServiceView(headquarter: headquarter, service: service),
    );
  }
}

class CreateServiceView extends StatefulWidget {
  const CreateServiceView({super.key, required this.headquarter, this.service});

  final HeadquarterModel headquarter;
  final ServiceModel? service;

  @override
  State<CreateServiceView> createState() => _CreateServiceViewState();
}

class _CreateServiceViewState extends State<CreateServiceView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _confirmationController = TextEditingController(text: '30');
  final _rememberController = TextEditingController(text: '60');
  final _homePriceController = TextEditingController();
  final _picker = ImagePicker();

  List<String> _imagePaths = [];
  List<int> _selectedAmenityIds = [];
  bool _onlyHomeService = false;
  int? _selectedCategoryId;
  int? _selectedGenderId;
  int? _selectedStateId;

  @override
  void initState() {
    super.initState();
    if (widget.service != null) {
      final s = widget.service!;
      _nameController.text = s.name;
      _descriptionController.text = s.description;

      final currencyFormatter =
          NumberFormat.currency(locale: 'es_CO', symbol: '', decimalDigits: 0);

      _priceController.text = currencyFormatter.format(s.price).trim();

      _confirmationController.text = s.confirmationIn.toString();
      _rememberController.text = s.rememberIn.toString();
      _onlyHomeService = s.onlyHomeService;
      if (s.homeServicePrice != null) {
        _homePriceController.text =
            currencyFormatter.format(s.homeServicePrice).trim();
      }
      _imagePaths = List.from(s.images);

      _selectedCategoryId = s.categoryServiceId;
      _selectedGenderId = s.genderId;
      _selectedStateId = s.stateId;
      _selectedAmenityIds = List.from(s.amenities);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _confirmationController.dispose();
    _rememberController.dispose();
    _homePriceController.dispose();
    super.dispose();
  }

  Future<void> _pickImages() async {
    final List<XFile> files =
        await _picker.pickMultiImage(imageQuality: imageQuality);
    if (files.isNotEmpty) {
      setState(() {
        _imagePaths = files.map((f) => f.path).toList();
      });
    }
  }

  void _submit(BuildContext context, ServiceCreationCubit cubit) {
    if (!_formKey.currentState!.validate()) return;

    if (_imagePaths.length < 3) {
      PonteSnackBar.show(
        context,
        message: 'Debes añadir al menos 3 imágenes del servicio',
        type: TypeAlert.error,
      );
      return;
    }

    if (_selectedAmenityIds.isEmpty) {
      PonteSnackBar.show(
        context,
        message: 'Debes seleccionar al menos 1 comodidad (amenity)',
        type: TypeAlert.error,
      );
      return;
    }

    if (_selectedAmenityIds.length > 7) {
      PonteSnackBar.show(
        context,
        message: 'Puedes seleccionar máximo 7 comodidades (amenities)',
        type: TypeAlert.error,
      );
      return;
    }

    final priceClean = _priceController.text.replaceAll(RegExp(r'[^0-9]'), '');
    final homePriceClean =
        _homePriceController.text.replaceAll(RegExp(r'[^0-9]'), '');

    final form = ServiceCreationFormModel(
      name: _nameController.text.trim(),
      description: _descriptionController.text.trim(),
      price: double.tryParse(priceClean) ?? 0,
      confirmationIn: 10,
      rememberIn: 30,
      onlyHomeService: _onlyHomeService,
      homeServicePrice: _onlyHomeService && homePriceClean.isNotEmpty
          ? double.tryParse(homePriceClean)
          : null,
      serviceCategoryId: _selectedCategoryId,
      genderId: _selectedGenderId,
      stateId: _selectedStateId,
      imagePaths: _imagePaths,
      amenityIds: _selectedAmenityIds,
    );

    cubit.updateForm(form);
    cubit.submit(widget.headquarter.id);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ServiceCreationCubit, ServiceCreationState>(
      listener: (context, state) {
        if (state is ServiceCreationSuccess) {
          final isEdit = widget.service != null;
          PonteSnackBar.show(
            context,
            message: isEdit
                ? '¡Servicio actualizado exitosamente!'
                : '¡Servicio creado exitosamente!',
            type: TypeAlert.success,
          );
          context.pop(true);
        }
        if (state is ServiceCreationError) {
          PonteSnackBar.show(
            context,
            message: state.message,
            type: TypeAlert.error,
          );
        }
      },
      builder: (context, state) {
        final cubit = context.read<ServiceCreationCubit>();

        return Scaffold(
          backgroundColor: backgroundColorTheme,
          appBar: AppBar(
            backgroundColor: secondaryColorTheme,
            elevation: 0,
            iconTheme: const IconThemeData(color: whiteColorTheme),
            title: Text(
              widget.service != null ? 'Editar Servicio' : 'Crear Servicio',
              style: const TextStyle(
                color: whiteColorTheme,
                fontWeight: FontWeight.bold,
                fontSize: h3Size,
              ),
            ),
          ),
          body: Stack(
            children: [
              _buildForm(context, cubit, state),
              if (state is ServiceCreationLoading)
                Container(
                  color: Colors.black26,
                  child: const Center(
                    child:
                        CircularProgressIndicator(color: secondaryColorTheme),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildForm(
    BuildContext context,
    ServiceCreationCubit cubit,
    ServiceCreationState state,
  ) {
    if (widget.service == null &&
        _selectedStateId == null &&
        cubit.stateTypes.isNotEmpty) {
      _selectedStateId = cubit.stateTypes
          .firstWhere((t) => t.code == 'available',
              orElse: () => cubit.stateTypes.first)
          .id;
    }

    final width = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionHeader('Información básica'),
            const SizedBox(height: spaceBetween10),
            _buildCard(
              children: [
                _buildTextField(
                  controller: _nameController,
                  label: 'Nombre del servicio',
                  hint: 'Ej: Corte de cabello',
                  icon: Icons.content_cut_rounded,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return 'El nombre es obligatorio';
                    }
                    if (v.length < 10) {
                      return 'El nombre debe tener al menos 10 caracteres';
                    }
                    if (!RegExp(r'[a-zA-Z]').hasMatch(v)) {
                      return 'Debe contener letras, no solo números';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: spaceBetween10),
                _buildTextField(
                  controller: _descriptionController,
                  label: 'Descripción',
                  hint: 'Describe brevemente el servicio',
                  icon: Icons.description_rounded,
                  maxLines: 3,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return 'La descripción es obligatoria';
                    }
                    if (v.length < 30) {
                      return 'La descripción debe tener al menos 30 caracteres';
                    }
                    return null;
                  },
                ),
              ],
            ),
            const SizedBox(height: spaceBetween10 * 2),
            _sectionHeader('Precio y configuración'),
            const SizedBox(height: spaceBetween10),
            _buildCard(
              children: [
                _buildTextField(
                  controller: _priceController,
                  label: 'Precio (COP)',
                  hint: 'Ej: 50.000',
                  icon: Icons.attach_money_rounded,
                  keyboardType: TextInputType.number,
                  inputFormatters: [CurrencyInputFormatter()],
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return 'El precio es obligatorio';
                    }
                    final val =
                        double.tryParse(v.replaceAll(RegExp(r'[^0-9]'), ''));
                    if (val == null || val <= 0) {
                      return 'Precio inválido';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: spaceBetween10),
                _buildSwitchTile(
                  title: 'Servicio a domicilio',
                  subtitle: 'El profesional se desplaza hacia el cliente',
                  value: _onlyHomeService,
                  onChanged: (val) => setState(() {
                    _onlyHomeService = val;
                    if (!val) _homePriceController.clear();
                  }),
                ),
                if (_onlyHomeService) ...[
                  const SizedBox(height: spaceBetween10),
                  _buildTextField(
                    controller: _homePriceController,
                    label: 'Precio adicional por domicilio (COP)',
                    hint: 'Déjalo vacío si el domicilio es gratis',
                    icon: Icons.home_outlined,
                    keyboardType: TextInputType.number,
                    inputFormatters: [CurrencyInputFormatter()],
                    validator: (v) {
                      if (v == null || v.isEmpty) return null;
                      final val =
                          double.tryParse(v.replaceAll(RegExp(r'[^0-9]'), ''));
                      if (val == null || val < 0) {
                        return 'Ingresa un valor válido (0 o mayor)';
                      }
                      return null;
                    },
                  ),
                ],
              ],
            ),
            const SizedBox(height: spaceBetween10 * 2),
            _sectionHeader('Clasificación'),
            const SizedBox(height: spaceBetween10),
            _buildCard(
              children: [
                _buildDropdown<CategoryModel>(
                  label: 'Categoría del servicio',
                  icon: Icons.category_rounded,
                  value:
                      _selectedCategoryId != null && cubit.categories.isNotEmpty
                          ? cubit.categories.cast<CategoryModel?>().firstWhere(
                                (c) => c?.id == _selectedCategoryId,
                                orElse: () => null,
                              )
                          : null,
                  items: cubit.categories,
                  itemLabel: (c) => c.description,
                  onChanged: (c) => setState(() => _selectedCategoryId = c?.id),
                ),
                const SizedBox(height: spaceBetween10),
                _buildDropdown<TypeModel>(
                  label: 'Género objetivo',
                  icon: Icons.people_rounded,
                  value:
                      _selectedGenderId != null && cubit.genderTypes.isNotEmpty
                          ? cubit.genderTypes.cast<TypeModel?>().firstWhere(
                                (t) => t?.id == _selectedGenderId,
                                orElse: () => null,
                              )
                          : null,
                  items: cubit.genderTypes,
                  itemLabel: (t) => t.description,
                  onChanged: (t) => setState(() => _selectedGenderId = t?.id),
                ),
                const SizedBox(height: spaceBetween10),
                _buildDropdown<TypeModel>(
                  label: 'Estado del servicio',
                  icon: Icons.toggle_on_rounded,
                  value: _selectedStateId != null && cubit.stateTypes.isNotEmpty
                      ? cubit.stateTypes.cast<TypeModel?>().firstWhere(
                            (t) => t?.id == _selectedStateId,
                            orElse: () => null,
                          )
                      : null,
                  items: cubit.stateTypes,
                  itemLabel: (t) => t.description,
                  onChanged: (t) => setState(() => _selectedStateId = t?.id),
                ),
              ],
            ),
            const SizedBox(height: spaceBetween10 * 2),
            _buildCard(children: [_buildImagePicker()]),
            const SizedBox(height: spaceBetween10 * 2),
            _sectionHeader('Comodidades (Mínimo 1, Máximo 7)'),
            const SizedBox(height: spaceBetween10),
            _buildCard(children: [_buildAmenitiesSelector(cubit)]),
            const SizedBox(height: spaceBetween10 * 3),

            ButtonMain(
              width: width,
              textButton:
                  widget.service != null ? 'Guardar cambios' : 'Crear servicio',
              onPressed: () => _submit(context, cubit),
            ),
            const SizedBox(height: spaceBetween10 * 2),
          ],
        ),
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: h4Size,
        fontWeight: FontWeight.bold,
        color: secondaryColorTheme,
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildCard({required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: whiteColorTheme,
        borderRadius: BorderRadius.circular(rounded10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(children: children),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      maxLines: maxLines,
      validator: validator,
      style: const TextStyle(fontSize: h4Size, color: appBarColorTheme),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: secondaryColorTheme, size: 20),
        labelStyle:
            const TextStyle(color: grayTextColorTheme, fontSize: bodySize),
        hintStyle:
            const TextStyle(color: greyBlockColorTheme, fontSize: bodySize),
        filled: true,
        fillColor: backgroundColorTheme,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(rounded10),
          borderSide:
              BorderSide(color: greyBlockColorTheme.withValues(alpha: 0.5)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(rounded10),
          borderSide: const BorderSide(color: secondaryColorTheme, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(rounded10),
          borderSide: const BorderSide(color: cancelColorTheme),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(rounded10),
          borderSide: const BorderSide(color: cancelColorTheme, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(
            horizontal: 16, vertical: paddingInput15),
      ),
    );
  }

  Widget _buildDropdown<T>({
    required String label,
    required IconData icon,
    required T? value,
    required List<T> items,
    required String Function(T) itemLabel,
    required void Function(T?) onChanged,
  }) {
    return DropdownButtonFormField<T>(
      initialValue: value,
      isExpanded: true,
      icon: const Icon(Icons.keyboard_arrow_down_rounded,
          color: secondaryColorTheme),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: secondaryColorTheme, size: 20),
        labelStyle:
            const TextStyle(color: grayTextColorTheme, fontSize: bodySize),
        filled: true,
        fillColor: backgroundColorTheme,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(rounded10),
          borderSide:
              BorderSide(color: greyBlockColorTheme.withValues(alpha: 0.5)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(rounded10),
          borderSide: const BorderSide(color: secondaryColorTheme, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(
            horizontal: 16, vertical: paddingInput15),
      ),
      items: items.map((item) {
        return DropdownMenuItem<T>(
          value: item,
          child: Text(
            itemLabel(item),
            style: const TextStyle(fontSize: h4Size, color: appBarColorTheme),
            overflow: TextOverflow.ellipsis,
          ),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required void Function(bool) onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: secondaryColorTheme.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(rounded10),
        border: Border.all(color: secondaryColorTheme.withValues(alpha: 0.15)),
      ),
      child: SwitchListTile(
        title: Text(
          title,
          style: const TextStyle(
            fontSize: h4Size,
            fontWeight: FontWeight.w600,
            color: appBarColorTheme,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(fontSize: bodySize, color: grayTextColorTheme),
        ),
        value: value,
        onChanged: onChanged,
        activeThumbColor: secondaryColorTheme,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      ),
    );
  }

  Widget _buildImagePicker() {
    return Column(
      children: [
        if (_imagePaths.isNotEmpty) ...[
          SizedBox(
            height: 100,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _imagePaths.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                return Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(rounded10),
                      child: _imagePaths[index].startsWith('http')
                          ? Image.network(
                              _imagePaths[index],
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) =>
                                  _errorImagePlaceholder(),
                            )
                          : Image.file(
                              File(_imagePaths[index]),
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) =>
                                  _errorImagePlaceholder(),
                            ),
                    ),
                    Positioned(
                      top: 4,
                      right: 4,
                      child: GestureDetector(
                        onTap: () =>
                            setState(() => _imagePaths.removeAt(index)),
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
                );
              },
            ),
          ),
          const SizedBox(height: spaceBetween10),
        ],
        GestureDetector(
          onTap: _pickImages,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(rounded10),
              border: Border.all(
                color: secondaryColorTheme.withValues(alpha: 0.4),
              ),
              color: secondaryColorTheme.withValues(alpha: 0.04),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.add_photo_alternate_rounded,
                  color: secondaryColorTheme.withValues(alpha: 0.7),
                  size: 32,
                ),
                const SizedBox(height: 6),
                Text(
                  _imagePaths.isEmpty
                      ? 'Añadir imágenes del servicio'
                      : (widget.service != null
                          ? 'Reemplazar todas las imágenes (${_imagePaths.length} selec.)'
                          : 'Cambiar imágenes (${_imagePaths.length} seleccionadas)'),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: bodySize,
                    color: secondaryColorTheme.withValues(alpha: 0.8),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (widget.service != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      '(Si subes nuevas imágenes, reemplazarán las actuales)',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: minimalMonserratSize,
                        color: grayTextColorTheme.withValues(alpha: 0.8),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _errorImagePlaceholder() {
    return Container(
      width: 100,
      height: 100,
      color: greyBlockColorTheme.withValues(alpha: 0.3),
      child: const Icon(Icons.image_rounded, color: grayTextColorTheme),
    );
  }

  Widget _buildAmenitiesSelector(ServiceCreationCubit cubit) {
    if (cubit.allAmenities.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text('Cargando comodidades...',
              style: TextStyle(color: grayTextColorTheme)),
        ),
      );
    }

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: cubit.allAmenities.map((amenity) {
        final isSelected = _selectedAmenityIds.contains(amenity.id);
        return GestureDetector(
          onTap: () {
            setState(() {
              if (isSelected) {
                _selectedAmenityIds.remove(amenity.id);
              } else {
                if (_selectedAmenityIds.length < 7) {
                  _selectedAmenityIds.add(amenity.id);
                } else {
                  PonteSnackBar.show(
                    context,
                    message: 'Máximo 7 comodidades permitidas',
                    type: TypeAlert.warning,
                  );
                }
              }
            });
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: isSelected
                  ? secondaryColorTheme.withValues(alpha: 0.1)
                  : whiteColorTheme,
              borderRadius: BorderRadius.circular(rounded10),
              border: Border.all(
                color: isSelected ? secondaryColorTheme : greyBlockColorTheme,
                width: isSelected ? 2 : 1,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: secondaryColorTheme.withValues(alpha: 0.2),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      )
                    ]
                  : [],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  '$pathManagementIcons${amenity.iconName}',
                  width: 24,
                  height: 24,
                  colorFilter: ColorFilter.mode(
                    isSelected ? secondaryColorTheme : grayTextColorTheme,
                    BlendMode.srcIn,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  amenity.description,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                    color:
                        isSelected ? secondaryColorTheme : grayTextColorTheme,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
