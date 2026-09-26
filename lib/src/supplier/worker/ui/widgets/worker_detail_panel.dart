import 'package:flutter/material.dart';
import 'package:ponte_glam/src/supplier/worker/data/model/staff_member_model.dart';
import 'package:ponte_glam/src/supplier/worker/ui/widgets/service_association_widget.dart';
import 'package:ponte_glam/src/supplier/worker/ui/widgets/time_block_widget.dart';
import 'package:ponte_glam/core/utils/image_url_helper.dart';

class WorkerDetailPanel extends StatelessWidget {
  final StaffMemberModel worker;

  const WorkerDetailPanel({super.key, required this.worker});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 24),

          // Panel de Servicios
          ServiceAssociationWidget(
            workerId: worker.workerId,
            linkedServices: worker.services,
          ),

          const SizedBox(height: 24),

          // Panel de Bloqueos
          const TimeBlockWidget(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.purple.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.purple.withValues(alpha: 0.1)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(3),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
            ),
            child: CircleAvatar(
              radius: 35,
              backgroundColor: Colors.purple.shade50,
              backgroundImage: worker.displayPicture.isNotEmpty
                  ? NetworkImage(
                      ImageUrlHelper.resolve(worker.displayPicture) ??
                          worker.displayPicture)
                  : null,
              child: worker.displayPicture.isEmpty
                  ? const Icon(Icons.person, size: 40, color: Colors.purple)
                  : null,
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  worker.displayName,
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                if (worker.userDetails?.email != null)
                  Row(
                    children: [
                      const Icon(Icons.email_outlined,
                          size: 14, color: Colors.grey),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          worker.userDetails!.email!,
                          style:
                              const TextStyle(color: Colors.grey, fontSize: 13),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.blue.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    worker.name != null
                        ? 'TRABAJADOR ANÓNIMO'
                        : 'USUARIO VINCULADO',
                    style: TextStyle(
                      color: Colors.blue.shade700,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
