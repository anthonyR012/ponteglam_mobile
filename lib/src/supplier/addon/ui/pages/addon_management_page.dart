import 'package:fancy_drawer/fancy_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:ponte_glam/config/theme/theme.dart';
import 'package:ponte_glam/config/constant/values_constant.dart';
import 'package:ponte_glam/di/shared_imports.dart';
import 'package:ponte_glam/shared/model/addon_model.dart';
import 'package:ponte_glam/shared/model/headquarter_model.dart';
import 'package:ponte_glam/shared/widgets/button_main_widget.dart';
import 'package:ponte_glam/shared/widgets/modern_form_elements.dart';
import 'package:ponte_glam/shared/widgets/snack_bar_simple_widget.dart';
import 'package:ponte_glam/shared/widgets/ponte_alert_dialog.dart';
import 'package:ponte_glam/src/supplier/addon/ui/cubit/addon_cubit.dart';
import 'package:ponte_glam/src/supplier/addon/ui/cubit/addon_state.dart';

class AddonManagementPage extends StatefulWidget {
  final HeadquarterModel headquarter;
  final FancyDrawerController? controllerMenu;
  static const String routeName = 'manage_addons';

  const AddonManagementPage({
    super.key,
    required this.headquarter,
    this.controllerMenu,
  });

  @override
  State<AddonManagementPage> createState() => _AddonManagementPageState();
}

class _AddonManagementPageState extends State<AddonManagementPage> {
  int _selectedServiceId = 0;

  @override
  void initState() {
    super.initState();
    context.read<AddonCubit>().loadAddons(_selectedServiceId);
  }

  @override
  Widget build(BuildContext context) {
    final servicesList = widget.headquarter.services;

    return Scaffold(
      backgroundColor: backgroundColorTheme,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: secondaryColorTheme,
        iconTheme: const IconThemeData(color: whiteColorTheme),
        leading: widget.controllerMenu != null
            ? IconButton(
                icon: const Icon(Icons.menu_rounded, color: whiteColorTheme),
                onPressed: () => widget.controllerMenu!.toggle(),
              )
            : null,
        title: const Text(
          'Gestión de Adicionales',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: whiteColorTheme,
            fontSize: h3Size,
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 12, top: 8, bottom: 8),
            decoration: BoxDecoration(
              color: whiteColorTheme.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(rounded10),
            ),
            child: IconButton(
              icon: const Icon(Icons.add_rounded, color: whiteColorTheme),
              onPressed: () => _showAddonChangeSheet(context),
              tooltip: 'Crear Adicional',
            ),
          ),
        ],
      ),
      body: BlocConsumer<AddonCubit, AddonState>(
        listener: (context, state) {
          if (state is AddonError) {
            PonteSnackBar.show(
              context,
              message: state.failure.message,
              type: TypeAlert.error,
            );
          }
        },
        builder: (context, state) {
          return Column(
            children: [
              // Top filter card
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: whiteColorTheme,
                    borderRadius: BorderRadius.circular(rounded10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Selecciona un servicio para vincular o desvincular adicionales. Selecciona "Todos" para editar o eliminar adicionales globales.',
                        style: TextStyle(
                          fontSize: 13,
                          color: grayTextColorTheme,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ModernDropdown<int>(
                        label: 'Servicio a Gestionar',
                        icon: Icons.design_services_rounded,
                        value: _selectedServiceId,
                        items: [0, ...servicesList.map((s) => s.id)],
                        itemLabel: (id) {
                          if (id == 0) return 'Todos los adicionales (Edición Global)';
                          final s = servicesList.firstWhere((item) => item.id == id);
                          return s.name;
                        },
                        onChanged: (val) {
                          if (val != null) {
                            setState(() {
                              _selectedServiceId = val;
                            });
                            context.read<AddonCubit>().loadAddons(val);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),

              // Addons List
              Expanded(
                child: state is AddonLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: secondaryColorTheme,
                        ),
                      )
                    : state is AddonLoaded
                        ? _buildAddonsContent(context, state)
                        : _buildEmptyState('Error al cargar adicionales'),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildAddonsContent(BuildContext context, AddonLoaded state) {
    if (_selectedServiceId == 0) {
      if (state.available.isEmpty) {
        return _buildEmptyState('No tienes adicionales creados aún.\n¡Presiona el botón + arriba para crear el primero!');
      }

      return ListView.builder(
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 24),
        itemCount: state.available.length,
        itemBuilder: (context, index) {
          final addon = state.available[index];
          return _buildAddonCard(context, addon, isLinkedMode: false);
        },
      );
    } else {
      if (state.linked.isEmpty && state.available.isEmpty) {
        return _buildEmptyState('No hay adicionales disponibles.');
      }

      return ListView(
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 24),
        children: [
          if (state.linked.isNotEmpty) ...[
            const Padding(
              padding: EdgeInsets.only(top: 8, bottom: 12),
              child: Text(
                'Adicionales Vinculados a este Servicio',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: secondaryColorTheme,
                ),
              ),
            ),
            ...state.linked.map((addon) => _buildAddonCard(
                  context,
                  addon,
                  isLinkedMode: true,
                  isCurrentlyLinked: true,
                  linkedCount: state.linked.length,
                )),
            const SizedBox(height: 16),
          ],
          if (state.available.isNotEmpty) ...[
            const Padding(
              padding: EdgeInsets.only(top: 8, bottom: 12),
              child: Text(
                'Adicionales Disponibles para Vincular',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: grayTextColorTheme,
                ),
              ),
            ),
            ...state.available.map((addon) => _buildAddonCard(
                  context,
                  addon,
                  isLinkedMode: true,
                  isCurrentlyLinked: false,
                  linkedCount: state.linked.length,
                )),
          ],
        ],
      );
    }
  }

  Widget _buildAddonCard(
    BuildContext context,
    AddonModel addon, {
    required bool isLinkedMode,
    bool isCurrentlyLinked = false,
    int linkedCount = 0,
  }) {
    final formatCurrency = NumberFormat.currency(
      locale: 'es_CO',
      symbol: '\$',
      decimalDigits: 0,
    );

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: whiteColorTheme,
        borderRadius: BorderRadius.circular(rounded10),
        border: Border.all(
          color: isCurrentlyLinked
              ? secondaryColorTheme.withValues(alpha: 0.3)
              : greyBlockColorTheme.withValues(alpha: 0.4),
          width: isCurrentlyLinked ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isCurrentlyLinked
                      ? secondaryColorTheme.withValues(alpha: 0.1)
                      : primaryColorTheme.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.extension_rounded,
                  color: isCurrentlyLinked ? secondaryColorTheme : primaryColorTheme,
                  size: 24,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      addon.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: appBarColorTheme,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    if (addon.description != null && addon.description!.isNotEmpty) ...[
                      Text(
                        addon.description!,
                        style: const TextStyle(
                          color: grayTextColorTheme,
                          fontSize: 12,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                    ],
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          formatCurrency.format(addon.price),
                          style: const TextStyle(
                            color: primaryColorTheme,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                        Container(
                          width: 4,
                          height: 4,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: grayTextColorTheme,
                          ),
                        ),
                        const Icon(
                          Icons.access_time_rounded,
                          size: 13,
                          color: grayTextColorTheme,
                        ),
                        Text(
                          '${addon.durationMinutes} min',
                          style: const TextStyle(
                            color: grayTextColorTheme,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Action buttons (Link/Unlink + Edit/Delete)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isLinkedMode) ...[
                    IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                      icon: Icon(
                        isCurrentlyLinked ? Icons.link_off_rounded : Icons.link_rounded,
                        color: isCurrentlyLinked ? cancelColorTheme : primaryColorTheme,
                        size: 22,
                      ),
                      onPressed: () {
                        if (isCurrentlyLinked) {
                          context.read<AddonCubit>().unlinkAddon(addon.id, _selectedServiceId);
                        } else {
                          if (linkedCount >= 5) {
                            PonteSnackBar.show(
                              context,
                              message: 'No puedes vincular más de 5 adicionales a un servicio',
                              type: TypeAlert.error,
                            );
                            return;
                          }
                          context.read<AddonCubit>().linkAddon(addon.id, _selectedServiceId);
                        }
                      },
                      tooltip: isCurrentlyLinked ? 'Desvincular' : 'Vincular',
                    ),
                  ],
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                    icon: const Icon(
                      Icons.edit_outlined,
                      color: Colors.grey,
                      size: 20,
                    ),
                    onPressed: () => _showAddonChangeSheet(context, addon: addon),
                    tooltip: 'Editar',
                  ),
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                    icon: const Icon(
                      Icons.delete_outline_rounded,
                      color: cancelColorTheme,
                      size: 20,
                    ),
                    onPressed: () => _confirmDeleteAddon(context, addon.id),
                    tooltip: 'Eliminar',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.extension_off_rounded,
              size: 72,
              color: Colors.grey.withValues(alpha: 0.3),
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 15,
                color: grayTextColorTheme,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddonChangeSheet(BuildContext parentContext, {AddonModel? addon}) {
    final cubit = parentContext.read<AddonCubit>();
    showModalBottomSheet(
      context: parentContext,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: cubit,
        child: _AddonChangeSheet(
          addon: addon,
          serviceId: _selectedServiceId,
        ),
      ),
    );
  }

  void _confirmDeleteAddon(BuildContext parentContext, int addonId) {
    final cubit = parentContext.read<AddonCubit>();
    PonteAlertDialog.show(
      context,
      title: 'Eliminar Adicional',
      message: '¿Estás seguro de que deseas eliminar este adicional permanentemente? Si está vinculado a servicios, se desvinculará de forma automática.',
      confirmText: 'Eliminar',
      cancelText: 'Cancelar',
      onConfirm: () {
        cubit.deleteAddon(addonId, _selectedServiceId);
      },
    );
  }
}

class _AddonChangeSheet extends StatefulWidget {
  final AddonModel? addon;
  final int serviceId;

  const _AddonChangeSheet({
    this.addon,
    required this.serviceId,
  });

  @override
  State<_AddonChangeSheet> createState() => _AddonChangeSheetState();
}

class _AddonChangeSheetState extends State<_AddonChangeSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _descController;
  late final TextEditingController _priceController;
  late final TextEditingController _durationController;

  bool get isEdit => widget.addon != null;

  @override
  void initState() {
    super.initState();
    final formatCurrency = NumberFormat.currency(
      locale: 'es_CO',
      symbol: '',
      decimalDigits: 0,
    );
    _nameController = TextEditingController(text: widget.addon?.name ?? '');
    _descController = TextEditingController(text: widget.addon?.description ?? '');
    _priceController = TextEditingController(
      text: widget.addon != null
          ? formatCurrency.format(widget.addon!.price).trim()
          : '',
    );
    _durationController = TextEditingController(
      text: widget.addon != null ? widget.addon!.durationMinutes.toString() : '15',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _priceController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: backgroundColorTheme,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    isEdit ? 'Editar Adicional' : 'Crear Adicional',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: appBarColorTheme,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, color: grayTextColorTheme),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ModernTextField(
                controller: _nameController,
                label: 'Nombre del Adicional',
                hint: 'Ej: Lavado especial',
                icon: Icons.title_rounded,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return 'El nombre es obligatorio';
                  }
                  if (v.trim().length < 3) {
                    return 'El nombre debe tener al menos 3 caracteres';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ModernTextField(
                controller: _descController,
                label: 'Descripción (Opcional)',
                hint: 'Describe brevemente de qué trata este adicional',
                icon: Icons.description_outlined,
                maxLines: 2,
              ),
              const SizedBox(height: 16),
              ModernTextField(
                controller: _priceController,
                label: 'Precio (COP)',
                hint: 'Ej: 15.000',
                icon: Icons.attach_money_rounded,
                keyboardType: TextInputType.number,
                inputFormatters: [CurrencyInputFormatter()],
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return 'El precio es obligatorio';
                  }
                  final cleanPrice = v.replaceAll(RegExp(r'[^0-9]'), '');
                  final price = double.tryParse(cleanPrice);
                  if (price == null || price < 0) {
                    return 'Ingresa un precio válido (0 o mayor)';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ModernTextField(
                controller: _durationController,
                label: 'Duración (Minutos)',
                hint: 'Ej: 15',
                icon: Icons.timer_outlined,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return 'La duración es obligatoria';
                  }
                  final duration = int.tryParse(v);
                  if (duration == null || duration <= 0) {
                    return 'Ingresa una duración válida (mayor a 0)';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),
              BlocBuilder<AddonCubit, AddonState>(
                builder: (context, state) {
                  if (state is AddonLoading) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: secondaryColorTheme,
                      ),
                    );
                  }

                  return ButtonMain(
                    width: double.infinity,
                    textButton: isEdit ? 'Guardar Cambios' : 'Crear Adicional',
                    backgroundColor: primaryColorTheme,
                    onPressed: () {
                      if (!_formKey.currentState!.validate()) return;

                      final cubit = context.read<AddonCubit>();
                      final name = _nameController.text.trim();
                      final desc = _descController.text.trim();
                      final cleanPrice = _priceController.text.replaceAll(RegExp(r'[^0-9]'), '');
                      final price = double.parse(cleanPrice);
                      final duration = int.parse(_durationController.text);

                      if (isEdit) {
                        cubit.updateAddon(
                          addonId: widget.addon!.id,
                          name: name,
                          description: desc,
                          price: price,
                          durationMinutes: duration,
                          serviceId: widget.serviceId,
                        );
                      } else {
                        cubit.createAddon(
                          name: name,
                          description: desc,
                          price: price,
                          durationMinutes: duration,
                          serviceId: widget.serviceId,
                        );
                      }
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CurrencyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    final newText = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
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
