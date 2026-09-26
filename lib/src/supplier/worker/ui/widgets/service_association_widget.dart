import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ponte_glam/src/supplier/worker/data/model/staff_member_model.dart';
import 'package:ponte_glam/src/supplier/worker/ui/cubit/worker_management_cubit.dart';
import 'package:ponte_glam/shared/widgets/ponte_alert_dialog.dart';

class ServiceAssociationWidget extends StatelessWidget {
  final int workerId;
  final List<StaffServiceLinkModel> linkedServices;

  const ServiceAssociationWidget({
    super.key,
    required this.workerId,
    required this.linkedServices,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Servicios Vinculados',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                TextButton.icon(
                  onPressed: () => _showAddServiceDialog(context),
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Vincular'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (linkedServices.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text('No tiene servicios asignados',
                      style: TextStyle(color: Colors.grey, fontSize: 13)),
                ),
              ),
            ...linkedServices
                .map((service) => _buildServiceTile(context, service)),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceTile(
      BuildContext context, StaffServiceLinkModel service) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
        leading: const Icon(Icons.content_cut, size: 18, color: Colors.purple),
        title: Text(service.name,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
        subtitle: service.isPendingRemoval && service.removalDate != null
            ? Text(
                'Retiro: ${_formatRemovalDate(service.removalDate!.toLocal())}',
                style: const TextStyle(
                    color: Colors.orange,
                    fontSize: 10,
                    fontWeight: FontWeight.bold))
            : null,
        trailing: service.isPendingRemoval
            ? IconButton(
                icon: const Icon(Icons.restore, size: 20, color: Colors.green),
                onPressed: () => context
                    .read<WorkerManagementCubit>()
                    .linkService(service.id),
                tooltip: 'Cancelar retiro',
              )
            : IconButton(
                icon: const Icon(Icons.link_off,
                    size: 20, color: Colors.redAccent),
                onPressed: () => _confirmUnlink(context, service),
                tooltip: 'Desvincular',
              ),
      ),
    );
  }

  String _formatRemovalDate(DateTime date) {
    // Format: "12 Mayo, 01:30 PM"
    final months = [
      'Ene',
      'Feb',
      'Mar',
      'Abr',
      'May',
      'Jun',
      'Jul',
      'Ago',
      'Sep',
      'Oct',
      'Nov',
      'Dic'
    ];
    final day = date.day;
    final month = months[date.month - 1];
    final hour =
        date.hour > 12 ? date.hour - 12 : (date.hour == 0 ? 12 : date.hour);
    final minute = date.minute.toString().padLeft(2, '0');
    final period = date.hour >= 12 ? 'PM' : 'AM';

    return '$day $month, $hour:$minute $period';
  }

  void _confirmUnlink(BuildContext context, StaffServiceLinkModel service) {
    PonteAlertDialog.show(
      context,
      title: 'Desvincular Servicio',
      message:
          '¿Estás seguro de que quieres desvincular al trabajador del servicio "${service.name}"?',
      confirmText: 'Confirmar',
      isDanger: true,
      onConfirm: () {
        context.read<WorkerManagementCubit>().unlinkService(service.id);
      },
    );
  }

  void _showAddServiceDialog(BuildContext context) {
    final cubit = context.read<WorkerManagementCubit>();
    final state = cubit.state;
    final allServices = state.availableServices;

    // Filter out already linked services
    final availableServices = allServices
        .where((s) => !linkedServices.any((ls) => ls.id == s.id))
        .toList();

    showDialog(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: cubit,
        child: AlertDialog(
          title: const Text('Vincular a Servicio',
              style: TextStyle(fontWeight: FontWeight.bold)),
          content: availableServices.isEmpty
              ? const Text('No hay más servicios disponibles para vincular.')
              : SizedBox(
                  width: double.maxFinite,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: availableServices.length,
                    itemBuilder: (context, index) {
                      final s = availableServices[index];
                      return ListTile(
                        title: Text(s.name),
                        onTap: () {
                          context
                              .read<WorkerManagementCubit>()
                              .linkService(s.id);
                          Navigator.pop(dialogContext);
                        },
                      );
                    },
                  ),
                ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text('Cerrar')),
          ],
        ),
      ),
    );
  }
}
