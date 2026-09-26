import 'package:fancy_drawer/fancy_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ponte_glam/src/supplier/worker/ui/cubit/worker_management_cubit.dart';
import 'package:ponte_glam/src/supplier/worker/ui/cubit/worker_management_state.dart';
import 'package:ponte_glam/src/supplier/worker/ui/widgets/staff_list_view.dart';
import 'package:ponte_glam/src/supplier/worker/ui/widgets/worker_detail_panel.dart';
import 'package:ponte_glam/src/supplier/worker/ui/widgets/onboard_worker_dialog.dart';
import 'package:ponte_glam/config/theme/theme.dart';
import 'package:ponte_glam/shared/widgets/ponte_alert_dialog.dart';

class WorkerManagementPage extends StatefulWidget {
  final int headquarterId;
  final FancyDrawerController? controllerMenu;
  static const String routeName = 'manage_workers';

  const WorkerManagementPage({
    super.key,
    required this.headquarterId,
    this.controllerMenu,
  });

  @override
  State<WorkerManagementPage> createState() => _WorkerManagementPageState();
}

class _WorkerManagementPageState extends State<WorkerManagementPage> {
  @override
  void initState() {
    super.initState();
    context.read<WorkerManagementCubit>().loadStaff();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        leading: widget.controllerMenu != null
            ? IconButton(
                icon: const Icon(Icons.menu_rounded, color: whiteColorTheme),
                onPressed: () => widget.controllerMenu!.toggle(),
              )
            : null,
        title: const Text(
          'Gestión de Staff',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 8, top: 8, bottom: 8),
            decoration: BoxDecoration(
              color: primaryColorTheme.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: IconButton(
              icon: const Icon(Icons.person_add_alt_1, color: whiteColorTheme),
              onPressed: () => _showOnboardDialog(context),
              tooltip: 'Agregar Trabajador',
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: BlocConsumer<WorkerManagementCubit, WorkerManagementState>(
        listener: (context, state) {
          if (state.errorMessage != null) {
            final errorMsg = state.errorMessage!.replaceAll('Exception: ', '');
            PonteAlertDialog.show(
              context,
              title: 'Aviso',
              message: errorMsg,
              confirmText: 'Entendido',
              showCancel: false,
            );
          }
          if (state.successMessage != null) {
            PonteAlertDialog.show(
              context,
              title: 'Éxito',
              message: state.successMessage!,
              confirmText: 'Aceptar',
              showCancel: false,
            );
          }
        },
        builder: (context, state) {
          if (state.status == WorkerManagementStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.staff.isEmpty) {
            return _buildEmptyState();
          }

          return LayoutBuilder(
            builder: (context, constraints) {
              final bool isMobile = constraints.maxWidth < 600;

              if (isMobile) {
                return StaffListView(
                  staff: state.staff,
                  selectedWorkerId: state.selectedWorker?.workerId,
                  onWorkerTap: (workerId) {
                    context
                        .read<WorkerManagementCubit>()
                        .selectWorker(workerId);
                    _showWorkerDetailsBottomSheet(context);
                  },
                  onRemoveWorker: (workerId) =>
                      _confirmRemoveWorker(context, workerId),
                );
              }

              // Wide screen: Master-Detail
              return Row(
                children: [
                  // Left: List
                  Expanded(
                    flex: 2,
                    child: StaffListView(
                      staff: state.staff,
                      selectedWorkerId: state.selectedWorker?.workerId,
                      onWorkerTap: (workerId) => context
                          .read<WorkerManagementCubit>()
                          .selectWorker(workerId),
                      onRemoveWorker: (workerId) =>
                          _confirmRemoveWorker(context, workerId),
                    ),
                  ),

                  const VerticalDivider(width: 1),

                  // Right: Detail Panel
                  Expanded(
                    flex: 3,
                    child: state.selectedWorker != null
                        ? SingleChildScrollView(
                            child: WorkerDetailPanel(
                                worker: state.selectedWorker!))
                        : const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.touch_app_outlined,
                                    size: 64, color: Colors.grey),
                                SizedBox(height: 16),
                                Text(
                                  'Selecciona un trabajador\npara ver detalles',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.people_outline, size: 80, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          const Text(
            'No hay trabajadores vinculados',
            style: TextStyle(
                fontSize: 18, color: Colors.grey, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Comienza agregando uno nuevo.',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  void _showWorkerDetailsBottomSheet(BuildContext parentContext) {
    final cubit = parentContext.read<WorkerManagementCubit>();
    showModalBottomSheet(
      context: parentContext,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        return BlocProvider.value(
          value: cubit,
          child: BlocBuilder<WorkerManagementCubit, WorkerManagementState>(
            builder: (context, state) {
              if (state.selectedWorker == null) return const SizedBox.shrink();
              return DraggableScrollableSheet(
                initialChildSize: 0.6,
                minChildSize: 0.4,
                maxChildSize: 0.9,
                expand: false,
                builder: (_, scrollController) {
                  return Column(
                    children: [
                      const SizedBox(height: 12),
                      Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        child: SingleChildScrollView(
                          controller: scrollController,
                          child:
                              WorkerDetailPanel(worker: state.selectedWorker!),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        );
      },
    );
  }

  void _showOnboardDialog(BuildContext parentContext) {
    final cubit = parentContext.read<WorkerManagementCubit>();
    showDialog(
      context: parentContext,
      builder: (context) => BlocProvider.value(
        value: cubit,
        child: const OnboardWorkerDialog(),
      ),
    );
  }

  void _confirmRemoveWorker(BuildContext context, int workerId) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Eliminar Trabajador'),
        content: const Text(
            '¿Estás seguro de que quieres retirar a este trabajador de la sede? Esto también eliminará sus vínculos con los servicios.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancelar')),
          TextButton(
            onPressed: () {
              context
                  .read<WorkerManagementCubit>()
                  .removeWorkerFromHq(workerId);
              Navigator.pop(dialogContext);
            },
            child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
