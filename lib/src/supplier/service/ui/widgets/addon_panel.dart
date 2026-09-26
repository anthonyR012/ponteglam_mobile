import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ponte_glam/config/theme/theme.dart';
import 'package:ponte_glam/di/shared_imports.dart';
import 'package:ponte_glam/shared/model/addon_model.dart';
import 'package:ponte_glam/shared/widgets/button_main_widget.dart';
import 'package:ponte_glam/shared/widgets/modern_form_elements.dart';
import 'package:ponte_glam/shared/widgets/snack_bar_simple_widget.dart';
import 'package:ponte_glam/src/supplier/addon/ui/cubit/addon_cubit.dart';
import 'package:ponte_glam/src/supplier/addon/ui/cubit/addon_state.dart';

class AddonPanelWidget extends StatelessWidget {
  final int serviceId;

  const AddonPanelWidget({super.key, required this.serviceId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AddonCubit>()..loadAddons(serviceId),
      child: BlocConsumer<AddonCubit, AddonState>(
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ModernSectionHeader(title: getIt<AppLocalizations>().titleAddons),
              const SizedBox(height: 16),
              if (state is AddonLoading || state is AddonInitial)
                const Center(child: CircularProgressIndicator())
              else if (state is AddonLoaded) ...[
                _buildSection(
                  context,
                  getIt<AppLocalizations>().titleLinkedAddons,
                  state.linked,
                  true,
                ),
                const SizedBox(height: 16),
                if (state.available.isNotEmpty) ...[
                  _buildSection(
                    context,
                    getIt<AppLocalizations>().titleAvailableAddons,
                    state.available,
                    false,
                  ),
                  const SizedBox(height: 16),
                ],
                ButtonMain(
                  width: double.infinity,
                  textButton: getIt<AppLocalizations>().titleCreateNewAddon,
                  backgroundColor: secondaryColorTheme,
                  iconCustom: const Icon(Icons.add, color: whiteColorTheme),
                  onPressed: () async {
                    if (state.linked.length >= 5) {
                      PonteSnackBar.show(
                        context,
                        message: 'No puedes vincular más de 5 adicionales a un servicio',
                        type: TypeAlert.error,
                      );
                      return;
                    }
                    _showCreateSheet(context, serviceId);
                  },
                ),
              ],
            ],
          );
        },
      ),
    );
  }

  Widget _buildSection(
    BuildContext context,
    String title,
    List<AddonModel> addons,
    bool isLinked,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: grayTextColorTheme,
          ),
        ),
        const SizedBox(height: 8),
        if (addons.isEmpty && isLinked)
          Text(getIt<AppLocalizations>().sentenceNoAddons)
        else
          ...addons.map((addon) => _AddonChip(
                addon: addon,
                isLinked: isLinked,
                serviceId: serviceId,
              )),
      ],
    );
  }

  void _showCreateSheet(BuildContext context, int serviceId) {
    final cubit = context.read<AddonCubit>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: cubit,
        child: _CreateAddonSheet(serviceId: serviceId),
      ),
    );
  }
}

class _AddonChip extends StatelessWidget {
  final AddonModel addon;
  final bool isLinked;
  final int serviceId;

  const _AddonChip({
    required this.addon,
    required this.isLinked,
    required this.serviceId,
  });

  @override
  Widget build(BuildContext context) {
    final formatCurrency = NumberFormat.currency(
      locale: 'es_CO',
      symbol: '\$',
      decimalDigits: 0,
    );

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: backgroundColorTheme,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: greyBlockColorTheme),
      ),
      child: Row(
        children: [
          const Icon(Icons.extension, color: primaryColorTheme),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  addon.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  '${formatCurrency.format(addon.price)} • ${addon.durationMinutes} min',
                  style: const TextStyle(
                    color: grayTextColorTheme,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              isLinked ? Icons.close : Icons.add,
              color: isLinked ? secondaryColorTheme : primaryColorTheme,
            ),
            onPressed: () {
              if (isLinked) {
                context.read<AddonCubit>().unlinkAddon(addon.id, serviceId);
              } else {
                final addonState = context.read<AddonCubit>().state;
                if (addonState is AddonLoaded && addonState.linked.length >= 5) {
                  PonteSnackBar.show(
                    context,
                    message: 'No puedes vincular más de 5 adicionales a un servicio',
                    type: TypeAlert.error,
                  );
                  return;
                }
                context.read<AddonCubit>().linkAddon(addon.id, serviceId);
              }
            },
          ),
        ],
      ),
    );
  }
}

class _CreateAddonSheet extends StatefulWidget {
  final int serviceId;

  const _CreateAddonSheet({required this.serviceId});

  @override
  State<_CreateAddonSheet> createState() => _CreateAddonSheetState();
}

class _CreateAddonSheetState extends State<_CreateAddonSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  final _priceController = TextEditingController(text: '0');
  final _durationController = TextEditingController(text: '10');

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
    return BlocListener<AddonCubit, AddonState>(
      listener: (context, state) {
        if (state is AddonLoaded) {
          Navigator.pop(context);
        }
      },
      child: Container(
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
                Text(
                  getIt<AppLocalizations>().titleCreateNewAddon,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: appBarColorTheme,
                  ),
                ),
                const SizedBox(height: 24),
                ModernTextField(
                  controller: _nameController,
                  label: getIt<AppLocalizations>().inputName,
                  icon: Icons.title,
                  validator: (v) {
                    if (v == null || v.trim().length < 2) {
                      return getIt<AppLocalizations>().failureEmptyField;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                ModernTextField(
                  controller: _descController,
                  label: getIt<AppLocalizations>().ratingComment,
                  icon: Icons.description,
                ),
                const SizedBox(height: 16),
                ModernTextField(
                  controller: _priceController,
                  label:
                      '${getIt<AppLocalizations>().titlePrice} (${getIt<AppLocalizations>().inputPriceFree})',
                  icon: Icons.attach_money,
                  keyboardType: TextInputType.number,
                  validator: (v) {
                    if (v == null || double.tryParse(v) == null) {
                      return getIt<AppLocalizations>().failureEmptyField;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                ModernTextField(
                  controller: _durationController,
                  label: getIt<AppLocalizations>().titleMinutes,
                  icon: Icons.timer,
                  keyboardType: TextInputType.number,
                  validator: (v) {
                    if (v == null || int.tryParse(v) == null) {
                      return getIt<AppLocalizations>().failureEmptyField;
                    }
                    if (int.parse(v) < 10) {
                      return 'Min 10';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),
                BlocBuilder<AddonCubit, AddonState>(
                  builder: (context, state) {
                    if (state is AddonLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return ButtonMain(
                      width: double.infinity,
                      textButton: getIt<AppLocalizations>().titleCreateAndLink,
                      backgroundColor: primaryColorTheme,
                      onPressed: () async {
                        final addonCubit = context.read<AddonCubit>();
                        final addonState = addonCubit.state;
                        if (addonState is AddonLoaded && addonState.linked.length >= 5) {
                          PonteSnackBar.show(
                            context,
                            message: 'No puedes vincular más de 5 adicionales a un servicio',
                            type: TypeAlert.error,
                          );
                          return;
                        }
                        if (_formKey.currentState!.validate()) {
                          addonCubit.createAddon(
                                name: _nameController.text.trim(),
                                description: _descController.text.trim(),
                                price: double.parse(_priceController.text),
                                durationMinutes:
                                    int.parse(_durationController.text),
                                serviceId: widget.serviceId,
                              );
                        }
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
