import 'package:flutter/material.dart';
import 'package:fancy_drawer/fancy_drawer.dart';
import 'package:ponte_glam/config/constant/values_constant.dart';
import 'package:ponte_glam/shared/widgets/snack_bar_simple_widget.dart';
import 'package:ponte_glam/config/theme/theme.dart';
import 'package:ponte_glam/di/shared_imports.dart';
import 'package:ponte_glam/shared/model/headquarter_model.dart';
import 'package:ponte_glam/src/supplier/headquarter/domain/model/headquarter_form_model.dart';
import 'package:ponte_glam/src/supplier/headquarter/ui/cubit/headquarter_creation_cubit.dart';
import 'package:ponte_glam/src/supplier/headquarter/ui/cubit/headquarter_creation_state.dart';
import 'package:ponte_glam/src/supplier/headquarter/ui/widgets/supplier_step_hq_info.dart';
import 'package:ponte_glam/src/supplier/headquarter/ui/widgets/supplier_step_time_config.dart';

class CreateHeadquarterPage extends StatelessWidget {
  final int companyId;
  final bool isEditing;
  final HeadquarterModel? existingHeadquarter;
  final FancyDrawerController? controllerMenu;
  final VoidCallback? onSuccess;

  const CreateHeadquarterPage({
    super.key,
    required this.companyId,
    this.isEditing = false,
    this.existingHeadquarter,
    this.controllerMenu,
    this.onSuccess,
  });

  static const String routeName = 'create_headquarter';

  HeadquarterFormModel _buildInitialForm() {
    final hq = existingHeadquarter;
    if (!isEditing || hq == null) {
      return HeadquarterFormModel(companyId: companyId);
    }
    return HeadquarterFormModel(
      companyId: companyId,
      headquarterId: hq.id,
      headquarterName: hq.name,
      headquarterPhone: hq.phoneNumber ?? '',
      headquarterAddress: hq.address ?? '',
      headquarterLatitude: hq.latitude,
      headquarterLongitude: hq.longitude,
      cityId: hq.cityId,
      existingImageUrl: hq.imageUrl,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HeadquarterCreationCubit>(
      create: (_) => getIt<HeadquarterCreationCubit>(
        param1: companyId,
        param2: isEditing ? _buildInitialForm() : null,
      ),
      child: _CreateHeadquarterView(
        isEditing: isEditing,
        controllerMenu: controllerMenu,
        onSuccess: onSuccess,
      ),
    );
  }
}

class _CreateHeadquarterView extends StatefulWidget {
  final bool isEditing;
  final FancyDrawerController? controllerMenu;
  final VoidCallback? onSuccess;

  const _CreateHeadquarterView({
    required this.isEditing,
    this.controllerMenu,
    this.onSuccess,
  });

  @override
  State<_CreateHeadquarterView> createState() => _CreateHeadquarterViewState();
}

class _CreateHeadquarterViewState extends State<_CreateHeadquarterView> {
  @override
  void initState() {
    super.initState();
    if (widget.isEditing) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<HeadquarterCreationCubit>().loadWeekConfiguration();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<HeadquarterCreationCubit, HeadquarterCreationState>(
      listener: (context, state) {
        if (state is HeadquarterCreationSuccess) {
          PonteSnackBar.show(
            context,
            message: widget.isEditing
                ? '¡Sede actualizada exitosamente!'
                : '¡Sede creada exitosamente!',
            type: TypeAlert.success,
          );
          if (widget.onSuccess != null) {
            widget.onSuccess!();
          } else {
            context.pop();
          }
        } else if (state is HeadquarterCreationError) {
          PonteSnackBar.show(
            context,
            message: state.message,
            type: TypeAlert.error,
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
              : IconButton(
                  icon: const Icon(Icons.arrow_back_rounded,
                      color: secondaryColorTheme),
                  onPressed: () => context.pop(),
                ),
          title: Text(
            widget.isEditing ? 'Editar sede' : 'Crear nueva sede',
            style: const TextStyle(
              color: secondaryColorTheme,
              fontWeight: FontWeight.bold,
              fontSize: h3Size,
            ),
          ),
          actions: [
            if (!widget.isEditing)
              TextButton(
                onPressed: () {
                  context.read<HeadquarterCreationCubit>().resetDraft();
                },
                child: const Text('Limpiar',
                    style: TextStyle(color: cancelColorTheme)),
              ),
          ],
        ),
        body: BlocBuilder<HeadquarterCreationCubit, HeadquarterCreationState>(
          builder: (context, state) {
            final isLoading = state is HeadquarterCreationLoading;

            return Stack(
              children: [
                Column(
                  children: [
                    _buildStepperIndicator(state.form.currentStep),
                    Expanded(
                      child: IndexedStack(
                        index: state.form.currentStep,
                        children: [
                          SupplierStepHeadquarterInfo(form: state.form),
                          SupplierStepTimeConfig(form: state.form),
                        ],
                      ),
                    ),
                  ],
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

  Widget _buildStepperIndicator(int currentStep) {
    return Container(
      color: whiteColorTheme,
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      child: Row(
        children: [
          _buildStepDot(isActive: currentStep >= 0, title: 'Sede'),
          Expanded(
            child: Container(
              height: 2,
              color: currentStep >= 1 ? secondaryColorTheme : borderColorTheme,
            ),
          ),
          _buildStepDot(isActive: currentStep >= 1, title: 'Horarios'),
        ],
      ),
    );
  }

  Widget _buildStepDot({required bool isActive, required String title}) {
    return Column(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? secondaryColorTheme : whiteColorTheme,
            border: Border.all(
              color: isActive ? secondaryColorTheme : borderColorTheme,
              width: 2,
            ),
          ),
          child: isActive
              ? const Icon(Icons.check, size: 14, color: whiteColorTheme)
              : null,
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: TextStyle(
            fontSize: 10,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            color: isActive ? secondaryColorTheme : grayTextColorTheme,
          ),
        ),
      ],
    );
  }
}
