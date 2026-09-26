import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ponte_glam/src/supplier/worker/ui/cubit/worker_management_cubit.dart';
import 'package:ponte_glam/shared/widgets/modern_form_elements.dart';
import 'package:ponte_glam/config/theme/theme.dart';

class OnboardWorkerDialog extends StatefulWidget {
  const OnboardWorkerDialog({super.key});

  @override
  State<OnboardWorkerDialog> createState() => _OnboardWorkerDialogState();
}

class _OnboardWorkerDialogState extends State<OnboardWorkerDialog> {
  bool _isAnonymous = false;
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Agregar Trabajador', style: TextStyle(fontWeight: FontWeight.bold, color: primaryColorTheme)),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SwitchListTile(
              title: const Text('Trabajador Anónimo'),
              subtitle: const Text('No requiere vinculación de usuario'),
              value: _isAnonymous,
              onChanged: (val) => setState(() => _isAnonymous = val),
            ),
            const SizedBox(height: 16),
            if (_isAnonymous)
              ModernTextField(
                controller: _nameController,
                label: 'Nombre del Trabajador',
                icon: Icons.person_outline,
              )
            else ...[
              ModernTextField(
                controller: _emailController,
                label: 'Correo Electrónico',
                keyboardType: TextInputType.emailAddress,
                icon: Icons.email_outlined,
              ),
              const SizedBox(height: 12),
              ModernTextField(
                controller: _phoneController,
                label: 'Teléfono',
                keyboardType: TextInputType.phone,
                icon: Icons.phone_outlined,
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context), 
          child: const Text('Cancelar', style: TextStyle(color: grayTextColorTheme)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColorTheme,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          ),
          onPressed: _submit,
          child: const Text('Agregar', style: TextStyle(color: whiteColorTheme)),
        ),
      ],
    );
  }

  void _submit() {
    if (_isAnonymous && _nameController.text.isEmpty) return;
    if (!_isAnonymous && _emailController.text.isEmpty && _phoneController.text.isEmpty) return;

    context.read<WorkerManagementCubit>().onboardWorker(
      isAnonymous: _isAnonymous,
      name: _isAnonymous ? _nameController.text : null,
      email: !_isAnonymous ? _emailController.text : null,
      phone: !_isAnonymous ? _phoneController.text : null,
    );
    Navigator.pop(context);
  }
}
