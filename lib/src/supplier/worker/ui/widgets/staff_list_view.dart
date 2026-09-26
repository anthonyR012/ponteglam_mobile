import 'package:flutter/material.dart';
import 'package:ponte_glam/src/supplier/worker/data/model/staff_member_model.dart';
import 'package:ponte_glam/core/utils/image_url_helper.dart';

class StaffListView extends StatelessWidget {
  final List<StaffMemberModel> staff;
  final int? selectedWorkerId;
  final Function(int) onWorkerTap;
  final Function(int) onRemoveWorker;

  const StaffListView({
    super.key,
    required this.staff,
    this.selectedWorkerId,
    required this.onWorkerTap,
    required this.onRemoveWorker,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: staff.length,
      itemBuilder: (context, index) {
        final worker = staff[index];
        final isSelected = worker.workerId == selectedWorkerId;

        return Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: Card(
            elevation: isSelected ? 4 : 1,
            shadowColor: isSelected ? Colors.purple.withValues(alpha: 0.3) : Colors.black12,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: isSelected 
                ? const BorderSide(color: Colors.purple, width: 2)
                : BorderSide(color: Colors.grey.shade200, width: 1),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () => onWorkerTap(worker.workerId),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    _buildAvatar(worker),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            worker.displayName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          _buildStatusChip(worker.status),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.person_remove_outlined, color: Colors.redAccent, size: 22),
                      onPressed: () => onRemoveWorker(worker.workerId),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAvatar(StaffMemberModel worker) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.purple.shade100, width: 2),
      ),
      child: CircleAvatar(
        radius: 26,
        backgroundColor: Colors.purple.shade50,
        backgroundImage: worker.displayPicture.isNotEmpty 
            ? NetworkImage(ImageUrlHelper.resolve(worker.displayPicture) ?? worker.displayPicture) 
            : null,
        child: worker.displayPicture.isEmpty 
            ? Icon(Icons.person, color: Colors.purple.shade300, size: 30) 
            : null,
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color color;
    String label;
    IconData icon;

    switch (status) {
      case 'active':
        color = Colors.green;
        label = 'Activo';
        icon = Icons.check_circle_outline;
        break;
      case 'pending_removal':
        color = Colors.orange;
        label = 'Pendiente de retiro';
        icon = Icons.timer_outlined;
        break;
      case 'invitation_pending':
        color = Colors.blue;
        label = 'Invitación enviada';
        icon = Icons.mail_outline;
        break;
      default:
        color = Colors.grey;
        label = 'Desconocido';
        icon = Icons.help_outline;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: color, 
              fontSize: 11, 
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
