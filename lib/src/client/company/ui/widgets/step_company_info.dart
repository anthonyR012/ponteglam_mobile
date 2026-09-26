import 'package:flutter/material.dart';
import 'package:ponte_glam/di/shared_imports.dart';
import 'package:ponte_glam/device/camera/take_photo_gallery.dart';
import 'package:ponte_glam/shared/widgets/button_main_widget.dart';
import 'package:ponte_glam/shared/widgets/modern_form_elements.dart';
import 'package:ponte_glam/config/theme/theme.dart';
import 'package:ponte_glam/src/client/company/domain/model/company_form_model.dart';
import 'package:ponte_glam/src/client/company/ui/cubit/company_creation_cubit.dart';
import 'package:ponte_glam/src/supplier/company/ui/widgets/nequi_payment_method_widget.dart';

class StepCompanyInfo extends StatefulWidget {
  final CompanyFormModel form;
  const StepCompanyInfo({super.key, required this.form});

  @override
  State<StepCompanyInfo> createState() => _StepCompanyInfoState();
}

class _StepCompanyInfoState extends State<StepCompanyInfo> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _descController;
  late final TextEditingController _nequiController;
  bool _profileImageError = false;
  int _descLength = 0;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.form.companyName);
    _descController =
        TextEditingController(text: widget.form.companyDescription);
    _nequiController = TextEditingController(text: widget.form.nequiNumber ?? '');
    _descLength = widget.form.companyDescription.length;
    _nequiController.addListener(_updateForm);
  }

  @override
  void dispose() {
    _nequiController.removeListener(_updateForm);
    _nameController.dispose();
    _descController.dispose();
    _nequiController.dispose();
    super.dispose();
  }

  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'El nombre es obligatorio.';
    }
    if (value.trim().length < 3) return 'Mínimo 3 caracteres.';
    if (value.trim().length > 100) return 'Máximo 100 caracteres.';
    if (RegExp(r'[<>{}]').hasMatch(value)) {
      return 'El nombre contiene caracteres no permitidos.';
    }
    return null;
  }

  String? _validateDescription(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'La descripción es obligatoria.';
    }
    if (value.trim().length < 10) return 'Mínimo 10 caracteres.';
    if (value.trim().length > 500) return 'Máximo 500 caracteres.';
    if (RegExp(r'[<>{}]').hasMatch(value)) {
      return 'La descripción contiene caracteres no permitidos.';
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
            const ModernSectionHeader(title: 'Información de la Compañía'),
            const SizedBox(height: 15),
            ModernFormCard(
              children: [
                ModernTextField(
                  controller: _nameController,
                  label: 'Nombre de la compañía',
                  hint: 'Ej: Glamour S.A.S',
                  icon: Icons.business_rounded,
                  validator: _validateName,
                  onChanged: (_) => _updateForm(),
                ),
                const SizedBox(height: 15),
                ModernTextField(
                  controller: _descController,
                  label: 'Descripción',
                  hint: 'Describe brevemente tu compañía',
                  icon: Icons.description_rounded,
                  maxLines: 5,
                  validator: _validateDescription,
                  onChanged: (val) {
                    setState(() => _descLength = val.length);
                    _updateForm();
                  },
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 4, right: 4),
                    child: Text(
                      '$_descLength/500',
                      style: TextStyle(
                        fontSize: 12,
                        color: _descLength > 500
                            ? cancelColorTheme
                            : grayTextColorTheme,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                NequiPaymentMethodWidget(
                  isCreating: true,
                  creationController: _nequiController,
                ),
              ],
            ),
            const SizedBox(height: 20),
            const ModernSectionHeader(title: 'Imagen de Perfil'),
            const SizedBox(height: 15),
            ModernFormCard(
              children: [
                _ImagePickerSection(
                  label: 'Logo / Imagen de Perfil *',
                  path: widget.form.companyProfileImagePath,
                  hasError: _profileImageError,
                  onPick: () async {
                    try {
                      final cubit = context.read<CompanyCreationCubit>();
                      final path = await getImagePicker();
                      if (mounted) {
                        setState(() => _profileImageError = false);
                        cubit.updateForm(widget.form
                            .copyWith(companyProfileImagePath: path));
                      }
                    } catch (_) {}
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
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
    final hasProfileImage = widget.form.companyProfileImagePath != null;
    if (!hasProfileImage) setState(() => _profileImageError = true);
    if (!formValid || !hasProfileImage) return;
    context.read<CompanyCreationCubit>().createCompany();
  }

  void _updateForm() {
    context.read<CompanyCreationCubit>().updateForm(widget.form.copyWith(
          companyName: _nameController.text,
          companyDescription: _descController.text,
          nequiNumber: _nequiController.text,
        ));
  }
}

class _ImagePickerSection extends StatelessWidget {
  final String label;
  final String? path;
  final bool hasError;
  final VoidCallback onPick;

  const _ImagePickerSection({
    required this.label,
    this.path,
    required this.hasError,
    required this.onPick,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: secondaryColorTheme)),
        const SizedBox(height: 15),
        Center(
          child: Stack(
            children: [
              GestureDetector(
                onTap: onPick,
                child: Container(
                  width: 130,
                  height: 130,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                    border: Border.all(
                      color: hasError ? cancelColorTheme : borderColorTheme,
                      width: 2,
                    ),
                  ),
                  child: ClipOval(
                    child: path != null
                        ? ImageLoadWidget(
                            image: path!,
                            typeSourceImage: TypeSourceImage.file,
                            fit: BoxFit.cover,
                          )
                        : Container(
                            color: Colors.grey[50],
                            child: Icon(
                              Icons.business_rounded,
                              size: 50,
                              color: grayTextColorTheme.withValues(alpha: 0.5),
                            ),
                          ),
                  ),
                ),
              ),
              Positioned(
                bottom: 2,
                right: 2,
                child: GestureDetector(
                  onTap: onPick,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: secondaryColorTheme,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.camera_alt_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (hasError)
          const Padding(
            padding: EdgeInsets.only(top: 6, left: 4),
            child: Text(
              'La imagen de perfil es obligatoria.',
              style: TextStyle(color: cancelColorTheme, fontSize: 12),
            ),
          ),
      ],
    );
  }
}
