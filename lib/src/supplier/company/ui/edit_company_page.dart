import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fancy_drawer/fancy_drawer.dart';
import 'package:ponte_glam/config/theme/theme.dart';
import 'package:ponte_glam/device/camera/take_photo_gallery.dart';
import 'package:ponte_glam/di/shared_imports.dart';
import 'package:ponte_glam/shared/widgets/button_main_widget.dart';
import 'package:ponte_glam/shared/widgets/modern_form_elements.dart';
import 'package:ponte_glam/src/supplier/company/ui/cubit/company_cubit.dart';
import 'package:ponte_glam/src/supplier/company/ui/cubit/company_state.dart';
import 'package:ponte_glam/shared/widgets/ponte_alert_dialog.dart';
import 'package:ponte_glam/src/client/home/ui/home_page.dart';
import 'package:ponte_glam/shared/model/company_model.dart';
import 'package:ponte_glam/src/supplier/company/ui/widgets/nequi_payment_method_widget.dart';

class EditCompanyPage extends StatelessWidget {
  const EditCompanyPage({
    super.key,
    required this.companyId,
    required this.initialName,
    this.initialDescription,
    this.imageUrl,
    this.initialNequiNumber,
    this.controllerMenu,
    this.onSuccess,
  });

  static const String routeName = 'edit_company';

  final int companyId;
  final String initialName;
  final String? initialDescription;
  final String? imageUrl;
  final String? initialNequiNumber;
  final FancyDrawerController? controllerMenu;
  final VoidCallback? onSuccess;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CompanyCubit>(
      create: (_) => getIt<CompanyCubit>(),
      child: _EditCompanyView(
        companyId: companyId,
        initialName: initialName,
        initialDescription: initialDescription,
        imageUrl: imageUrl,
        initialNequiNumber: initialNequiNumber,
        controllerMenu: controllerMenu,
        onSuccess: onSuccess,
      ),
    );
  }
}

class _EditCompanyView extends StatefulWidget {
  const _EditCompanyView({
    required this.companyId,
    required this.initialName,
    this.initialDescription,
    this.imageUrl,
    this.initialNequiNumber,
    this.controllerMenu,
    this.onSuccess,
  });

  final int companyId;
  final String initialName;
  final String? initialDescription;
  final String? imageUrl;
  final String? initialNequiNumber;
  final FancyDrawerController? controllerMenu;
  final VoidCallback? onSuccess;

  @override
  State<_EditCompanyView> createState() => _EditCompanyViewState();
}

class _EditCompanyViewState extends State<_EditCompanyView> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _descController;
  File? _newProfileImage;
  int _descLength = 0;
  bool _isDeleting = false;
  late CompanyModel _company;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName);
    _descController =
        TextEditingController(text: widget.initialDescription ?? '');
    _descLength = _descController.text.length;
    _company = CompanyModel(
      id: widget.companyId,
      name: widget.initialName,
      description: widget.initialDescription ?? '',
      imageUrl: widget.imageUrl,
      nequiNumber: widget.initialNequiNumber,
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    super.dispose();
  }

  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'El nombre es obligatorio.';
    }
    if (value.trim().length < 3) {
      return 'Mínimo 3 caracteres.';
    }
    if (value.trim().length > 100) {
      return 'Máximo 100 caracteres.';
    }
    if (RegExp(r'[<>{}]').hasMatch(value)) {
      return 'El nombre contiene caracteres no permitidos.';
    }
    return null;
  }

  String? _validateDescription(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'La descripción es obligatoria.';
    }
    if (value.trim().length < 10) {
      return 'Mínimo 10 caracteres.';
    }
    if (value.trim().length > 500) {
      return 'Máximo 500 caracteres.';
    }
    if (RegExp(r'[<>{}]').hasMatch(value)) {
      return 'La descripción contiene caracteres no permitidos.';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CompanyCubit, CompanyState>(
      listener: (ctx, state) {
        if (state is CompanySuccess) {
          ScaffoldMessenger.of(ctx).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: successColorTheme,
            ),
          );
          if (_isDeleting) {
            getIt<SharedPreferences>().remove(keyPlace).then((_) {
              if (ctx.mounted) ctx.goNamed(HomePage.routeName);
            });
          } else {
            if (widget.onSuccess != null) {
              widget.onSuccess!();
            } else {
              Navigator.of(ctx).pop();
            }
          }
        } else if (state is CompanyError) {
          if (mounted && _isDeleting) setState(() => _isDeleting = false);
          ScaffoldMessenger.of(ctx).showSnackBar(
            SnackBar(
              content: Text(state.failure.message),
              backgroundColor: cancelColorTheme,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: backgroundColorTheme,
        appBar: AppBar(
          backgroundColor: whiteColorTheme,
          elevation: 0,
          leading: widget.controllerMenu != null
              ? IconButton(
                  icon: const Icon(Icons.menu_rounded,
                      color: secondaryColorTheme),
                  onPressed: () => widget.controllerMenu!.toggle(),
                )
              : null,
          title: const Text(
            'Editar empresa',
            style: TextStyle(
                color: secondaryColorTheme, fontWeight: FontWeight.bold),
          ),
          iconTheme: const IconThemeData(color: secondaryColorTheme),
        ),
        body: BlocBuilder<CompanyCubit, CompanyState>(
          builder: (ctx, state) {
            final isLoading = state is CompanyLoading;
            return Stack(
              children: [
                Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const ModernSectionHeader(
                            title: 'Información de la Empresa'),
                        const SizedBox(height: 15),
                        ModernFormCard(
                          children: [
                            ModernTextField(
                              controller: _nameController,
                              label: 'Nombre de la empresa',
                              hint: 'Ej: Glamour S.A.S',
                              icon: Icons.business_rounded,
                              validator: _validateName,
                            ),
                            const SizedBox(height: 15),
                            ModernTextField(
                              controller: _descController,
                              label: 'Descripción *',
                              hint: 'Describe brevemente tu empresa',
                              icon: Icons.description_rounded,
                              maxLines: 5,
                              validator: _validateDescription,
                              onChanged: (val) =>
                                  setState(() => _descLength = val.length),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(top: 4, right: 4),
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
                          ],
                        ),
                        const SizedBox(height: 20),
                        const ModernSectionHeader(title: 'Imagen de Perfil'),
                        const SizedBox(height: 15),
                        ModernFormCard(
                          children: [
                            _buildImagePicker(ctx),
                          ],
                        ),
                        const SizedBox(height: 20),
                        NequiPaymentMethodWidget(
                          company: _company,
                          onUpdateSuccess: (updatedCompany) {
                            setState(() {
                              _company = updatedCompany;
                            });
                          },
                        ),
                        const SizedBox(height: 30),
                        ButtonMain(
                          width: double.infinity,
                          textButton: 'Guardar cambios',
                          onPressed: isLoading ? () {} : () => _onSubmit(ctx),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: TextButton.icon(
                            onPressed:
                                isLoading ? null : () => _showDeleteDialog(ctx),
                            icon: const Icon(Icons.delete_outline_rounded,
                                color: cancelColorTheme),
                            label: const Text(
                              'Eliminar empresa',
                              style: TextStyle(
                                color: cancelColorTheme,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (isLoading)
                  Container(
                    color: Colors.black26,
                    child: const Center(
                      child:
                          CircularProgressIndicator(color: secondaryColorTheme),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildImagePicker(BuildContext ctx) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Logo / Imagen de Perfil *',
            style: TextStyle(
                fontWeight: FontWeight.bold, color: secondaryColorTheme)),
        const SizedBox(height: 15),
        Center(
          child: Stack(
            children: [
              GestureDetector(
                onTap: () => _pickImage(ctx),
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
                      color: borderColorTheme,
                      width: 2,
                    ),
                  ),
                  child: ClipOval(
                    child: _buildImageContent(),
                  ),
                ),
              ),
              Positioned(
                bottom: 2,
                right: 2,
                child: GestureDetector(
                  onTap: () => _pickImage(ctx),
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
      ],
    );
  }

  Widget _buildImageContent() {
    if (_newProfileImage != null) {
      return Image.file(_newProfileImage!,
          fit: BoxFit.cover, width: double.infinity, height: double.infinity);
    }
    if (widget.imageUrl != null && widget.imageUrl!.isNotEmpty) {
      return ImageLoadWidget(
        image: widget.imageUrl!,
        typeSourceImage: TypeSourceImage.network,
        fit: BoxFit.cover,
      );
    }
    return Container(
      color: Colors.grey[50],
      child: Icon(
        Icons.business_rounded,
        size: 50,
        color: grayTextColorTheme.withValues(alpha: 0.5),
      ),
    );
  }

  Future<void> _pickImage(BuildContext ctx) async {
    try {
      final path = await getImagePicker();
      if (mounted) setState(() => _newProfileImage = File(path));
    } catch (_) {}
  }

  void _onSubmit(BuildContext ctx) {
    if (!_formKey.currentState!.validate()) return;
    ctx.read<CompanyCubit>().updateCompany(
          companyId: widget.companyId,
          name: _nameController.text.trim(),
          description: _descController.text.trim(),
          profileImage: _newProfileImage,
        );
  }

  void _showDeleteDialog(BuildContext ctx) {
    PonteAlertDialog.show(
      context,
      title: 'Eliminar empresa',
      message:
          '¿Estás seguro de que deseas eliminar "${widget.initialName}"? Se eliminarán todas sus sedes y servicios despues de 5 dias. Esta acción no se puede deshacer.',
      confirmText: 'Eliminar',
      isDanger: true,
      onConfirm: () {
        if (mounted) setState(() => _isDeleting = true);
        ctx.read<CompanyCubit>().deleteCompany(companyId: widget.companyId);
      },
    );
  }
}
