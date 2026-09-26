import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ponte_glam/config/theme/theme.dart';
import 'package:ponte_glam/di/shared_imports.dart';
import 'package:ponte_glam/shared/model/user_model.dart';
import 'package:ponte_glam/shared/widgets/button_main_widget.dart';
import 'package:ponte_glam/shared/widgets/modern_form_elements.dart';
import 'package:ponte_glam/src/client/profile/ui/widgets/bar_profile_widgets.dart';
import 'package:ponte_glam/src/client/profile/ui/widgets/personal_information_widgets/update_password_dialog.dart';
import 'package:ponte_glam/shared/widgets/snack_bar_simple_widget.dart';

class PersonalInformationPage extends StatefulWidget {
  const PersonalInformationPage({super.key});
  static const String routeName = 'personal_information';

  @override
  State<PersonalInformationPage> createState() =>
      _PersonalInformationPageState();
}

class _PersonalInformationPageState extends State<PersonalInformationPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isEditing = false;

  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _dateOfBirthController;

  @override
  void initState() {
    super.initState();
    final user = getIt<SettingBloc>().user ?? UserModel.empty();
    _nameController = TextEditingController(text: user.fullName ?? '');
    _emailController = TextEditingController(text: user.email ?? '');
    _phoneController = TextEditingController(text: user.phone ?? '');
    _dateOfBirthController =
        TextEditingController(text: user.dateOfBirth ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _dateOfBirthController.dispose();
    super.dispose();
  }

  void _saveChanges() {
    if (!_formKey.currentState!.validate()) return;

    final user = getIt<SettingBloc>().user;
    if (user != null) {
      context.read<ProfileCubit>().updateInformation(
        {
          'full_name': _nameController.text,
          'phone': _phoneController.text,
          'date_of_birth': _dateOfBirthController.text,
        },
      );
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? initialDate;
    if (_dateOfBirthController.text.isNotEmpty) {
      try {
        initialDate =
            DateFormat('dd/MM/yyyy').parse(_dateOfBirthController.text);
      } catch (_) {
        initialDate = DateTime.now().subtract(const Duration(days: 365 * 20));
      }
    } else {
      initialDate = DateTime.now().subtract(const Duration(days: 365 * 20));
    }

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: primaryColorTheme,
              onPrimary: whiteColorTheme,
              onSurface: appBarColorTheme,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _dateOfBirthController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  void _showPasswordDialog(UserModel user) {
    showDialog(
      context: context,
      builder: (context) => UpdatePasswordDialog(
        isOauth: user.loginCode == 'by_gmail',
        hasPassword: user.hasPassword ?? false,
        email: user.email ?? '',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = getIt<SettingBloc>().user ?? UserModel.empty();

    return SafeArea(
      child: Scaffold(
        backgroundColor: backgroundColorTheme,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: AppBarProfileWidget(
              title: getIt<AppLocalizations>().titlePersonalInformation),
        ),
        body: BlocConsumer<ProfileCubit, ProfileState>(
          listener: (context, state) {
            if (state.action == ProfileAction.updateInfo) {
              if (state.status == ProfileStatus.failure) {
                PonteSnackBar.show(
                  context,
                  message: 'Error: ${state.errorMessage}',
                  type: TypeAlert.error,
                );
              } else if (state.status == ProfileStatus.success &&
                  state.updatedUser != null) {
                final user = getIt<SettingBloc>().user!;
                final mergedUser = user.copyWith(
                  fullName: state.updatedUser!.fullName,
                  phone: state.updatedUser!.phone,
                  dateOfBirth: state.updatedUser!.dateOfBirth,
                  picture: state.updatedUser!.picture,
                );
                getIt<SettingBloc>().add(DoUpdateUserInfoEvent(mergedUser));

                setState(() => _isEditing = false);
                PonteSnackBar.show(
                  context,
                  message: 'Información actualizada exitosamente',
                  type: TypeAlert.success,
                );
              }
            }
          },
          builder: (context, state) {
            final isLoading = state.status == ProfileStatus.loading &&
                state.action == ProfileAction.updateInfo;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const ModernSectionHeader(title: 'Datos Personales'),
                        if (!_isEditing)
                          TextButton.icon(
                            onPressed: () => setState(() => _isEditing = true),
                            icon: const Icon(Icons.edit_rounded,
                                color: primaryColorTheme, size: 18),
                            label: const Text('Editar',
                                style: TextStyle(color: primaryColorTheme)),
                          ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    ModernFormCard(
                      children: [
                        ModernTextField(
                          controller: _nameController,
                          label: getIt<AppLocalizations>().inputName,
                          icon: Icons.person_outline_rounded,
                          enabled: _isEditing,
                          validator: (v) {
                            if (v == null || v.isEmpty) return 'Requerido';
                            if (v.length < 3) return 'Mínimo 3 caracteres';
                            if (v.length > 50) return 'Máximo 50 caracteres';
                            return null;
                          },
                        ),
                        const SizedBox(height: 15),
                        ModernTextField(
                          controller: _emailController,
                          label: getIt<AppLocalizations>().inputEmail,
                          icon: Icons.email_outlined,
                          enabled: false, // Email is never editable
                        ),
                        const SizedBox(height: 15),
                        ModernTextField(
                          controller: _phoneController,
                          label: 'Teléfono',
                          icon: Icons.phone_outlined,
                          enabled: _isEditing,
                          keyboardType: TextInputType.phone,
                          validator: (v) {
                            if (v == null || v.isEmpty) return null; // Opcional
                            if (!RegExp(r'^\d+$').hasMatch(v)) {
                              return 'Solo números';
                            }
                            if (v.length < 7) return 'Mínimo 7 números';
                            if (v.length > 15) return 'Máximo 15 números';
                            return null;
                          },
                        ),
                        const SizedBox(height: 15),
                        ModernTextField(
                          controller: _dateOfBirthController,
                          label: getIt<AppLocalizations>().titleDateOfBirth,
                          icon: Icons.calendar_today_outlined,
                          enabled: _isEditing,
                          readOnly: true,
                          hint: 'DD/MM/YYYY',
                          onTap: _isEditing ? () => _selectDate(context) : null,
                          validator: (v) {
                            if (v == null || v.isEmpty) return null; // Opcional
                            try {
                              DateFormat('dd/MM/yyyy').parse(v);
                              return null;
                            } catch (_) {
                              return 'Formato inválido';
                            }
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    const ModernSectionHeader(title: 'Seguridad'),
                    const SizedBox(height: 15),
                    if ((user.loginCode == 'by_gmail' &&
                            user.hasPassword == false) ||
                        user.loginCode == 'by_credentials' ||
                        (user.loginCode == 'by_gmail' &&
                            user.hasPassword == true))
                      ModernFormCard(
                        children: [
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color:
                                    secondaryColorTheme.withValues(alpha: 0.1),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.lock_outline_rounded,
                                  color: secondaryColorTheme),
                            ),
                            title: Text(
                              (user.loginCode == 'by_gmail' &&
                                      user.hasPassword == false)
                                  ? 'Crear contraseña alterna'
                                  : 'Actualizar contraseña',
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: secondaryColorTheme),
                            ),
                            subtitle: Text(
                              (user.loginCode == 'by_gmail' &&
                                      user.hasPassword == false)
                                  ? 'Para iniciar sesión sin Google/Apple'
                                  : 'Cambia tu contraseña actual',
                              style: const TextStyle(
                                  fontSize: 12, color: grayTextColorTheme),
                            ),
                            trailing: const Icon(Icons.chevron_right_rounded,
                                color: grayTextColorTheme),
                            onTap: () => _showPasswordDialog(user),
                          ),
                        ],
                      ),
                    const SizedBox(height: 40),
                    if (_isEditing)
                      isLoading
                          ? const Center(
                              child: CircularProgressIndicator(
                                  color: primaryColorTheme))
                          : Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton(
                                    onPressed: () {
                                      setState(() {
                                        _isEditing = false;
                                        // Reset values
                                        _nameController.text =
                                            user.fullName ?? '';
                                        _phoneController.text =
                                            user.phone ?? '';
                                        _dateOfBirthController.text =
                                            user.dateOfBirth ?? '';
                                      });
                                    },
                                    style: OutlinedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 14),
                                      side: const BorderSide(
                                          color: cancelColorTheme),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                    ),
                                    child: const Text('Cancelar',
                                        style:
                                            TextStyle(color: cancelColorTheme)),
                                  ),
                                ),
                                const SizedBox(width: 15),
                                Expanded(
                                  flex: 2,
                                  child: ButtonMain(
                                    width: double.infinity,
                                    textButton: 'Guardar',
                                    onPressed: _saveChanges,
                                  ),
                                ),
                              ],
                            ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
