import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ponte_glam/config/theme/theme.dart';
import 'package:ponte_glam/src/client/appointment/data/model/appointment_model.dart';

class TraceabilityTimelineWidget extends StatelessWidget {
  final List<TraceabilityModel> traceability;
  final bool showTitle;

  const TraceabilityTimelineWidget({
    super.key,
    required this.traceability,
    this.showTitle = true,
  });

  @override
  Widget build(BuildContext context) {
    if (traceability.isEmpty) {
      return const SizedBox.shrink();
    }

    final sortedTraceability = List<TraceabilityModel>.from(traceability)
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showTitle)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: Text(
              'Historial de la cita',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1D1B20),
              ),
            ),
          ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: sortedTraceability.length,
          itemBuilder: (context, index) {
            final item = sortedTraceability[index];
            final isFirst = index == 0;
            final isLast = index == sortedTraceability.length - 1;

            final stateColor = _getStateColor(item.newState);
            final stateIcon = _getStateIcon(item.newState);

            return IntrinsicHeight(
              child: Row(
                children: [
                  Column(
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: isFirst ? stateColor.withValues(alpha: 0.1) : Colors.transparent,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isFirst ? stateColor : Colors.grey[300]!,
                            width: 2,
                          ),
                        ),
                        child: Center(
                          child: Icon(
                            stateIcon,
                            size: 14,
                            color: isFirst ? stateColor : Colors.grey[400],
                          ),
                        ),
                      ),
                      if (!isLast)
                        Expanded(
                          child: Container(
                            width: 2,
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            color: Colors.grey[200],
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                item.newStateLabel,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: isFirst ? stateColor : Colors.black87,
                                ),
                              ),
                              Text(
                                DateFormat('dd MMM, hh:mm a').format(item.createdAt),
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey[500],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          if (item.changeReason != null && item.changeReason!.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 6.0),
                              child: Text(
                                item.changeReason!,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey[700],
                                  height: 1.4,
                                ),
                              ),
                            ),
                          Row(
                            children: [
                              Icon(Icons.person_outline, size: 14, color: Colors.grey[400]),
                              const SizedBox(width: 4),
                              Text(
                                item.userName,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey[400],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Color _getStateColor(String state) {
    switch (state) {
      case 'active':
        return inProgressColorTheme;
      case 'pending':
      case 'pending_payment':
        return const Color(0xFFE2D34B); // seenColorTheme
      case 'completed':
        return successColorTheme;
      case 'cancelled':
        return cancelColorTheme;
      case 'rescheduled':
        return primaryColorTheme;
      case 'in_progress':
        return inProgressColorTheme;
      default:
        return Colors.grey;
    }
  }

  IconData _getStateIcon(String state) {
    switch (state) {
      case 'active':
        return Icons.check_circle_outline;
      case 'pending':
      case 'pending_payment':
        return Icons.hourglass_empty;
      case 'completed':
        return Icons.task_alt;
      case 'cancelled':
        return Icons.cancel_outlined;
      case 'rescheduled':
        return Icons.update;
      case 'in_progress':
        return Icons.play_circle_outline;
      default:
        return Icons.radio_button_checked;
    }
  }
}
