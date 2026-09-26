import 'package:flutter/material.dart';
import 'package:ponte_glam/config/constant/assets_constant.dart';
import 'package:ponte_glam/config/theme/theme.dart';
import 'package:ponte_glam/core/utils/currency_utils.dart';
import 'package:ponte_glam/di/shared_imports.dart';
import 'package:ponte_glam/shared/widgets/circle_image_profile_widget.dart';
import 'package:ponte_glam/shared/widgets/modern_form_elements.dart';
import 'package:ponte_glam/src/client/appointment/data/model/appointment_model.dart';
import 'package:ponte_glam/src/client/appointment/ui/cubit/appointment_cubit.dart';
import 'package:ponte_glam/src/client/appointment/ui/cubit/appointment_state.dart';
import 'package:ponte_glam/src/client/appointment/ui/widgets/reschedule_appointment_sheet.dart';
import 'package:ponte_glam/src/client/rate/ui/ratings_page.dart';
import 'package:ponte_glam/shared/widgets/traceability_timeline_widget.dart';
import 'package:ponte_glam/shared/widgets/ponte_alert_dialog.dart';
import 'package:ponte_glam/shared/widgets/snack_bar_simple_widget.dart';
import 'package:ponte_glam/shared/widgets/addon_detail_section.dart';

class AppointmentDetailPage extends StatefulWidget {
  const AppointmentDetailPage({
    super.key,
    required this.appointmentId,
    this.autoOpenRating = false,
  });

  static const String routeName = 'appointment-detail';

  final int appointmentId;

  /// Cuando es [true] (enviado desde una push notification con prompt_rating)
  /// el formulario de calificación se abre automáticamente tras cargar el detalle.
  final bool autoOpenRating;

  @override
  State<AppointmentDetailPage> createState() => _AppointmentDetailPageState();
}

class _AppointmentDetailPageState extends State<AppointmentDetailPage> {
  late AppointmentCubit _cubit;

  /// Evita abrir el formulario de calificación más de una vez por sesión
  bool _ratingOpened = false;

  @override
  void initState() {
    super.initState();
    _cubit = getIt<AppointmentCubit>();
    _cubit.loadAppointmentDetail(widget.appointmentId);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: BlocConsumer<AppointmentCubit, AppointmentState>(
        listener: (context, state) {
          // Auto-abrir ratings cuando viene de push con prompt_rating=true
          if (widget.autoOpenRating &&
              !_ratingOpened &&
              state.status == AppointmentStatus.success &&
              state.selectedAppointment != null) {
            _ratingOpened = true;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                _navigateToRatings(context, state.selectedAppointment!);
              }
            });
          }

          if (state.actionStatus == AppointmentActionStatus.success) {
            PonteSnackBar.show(
              context,
              message: 'Operación realizada con éxito',
              type: TypeAlert.success,
            );
            _cubit.resetActionStatus();
            _cubit.loadAppointmentDetail(widget.appointmentId);
          } else if (state.actionStatus == AppointmentActionStatus.failure) {
            PonteSnackBar.show(
              context,
              message: state.actionErrorMessage ?? 'Ocurrió un error',
              type: TypeAlert.error,
            );
            _cubit.resetActionStatus();
          }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: backgroundColorTheme,
            appBar: AppBar(
              backgroundColor: appBarColorTheme,
              title: const Text(
                'Detalle de Cita',
                style: TextStyle(color: whiteColorTheme),
              ),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: whiteColorTheme),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            body: _buildBody(context, state),
          );
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context, AppointmentState state) {
    if (state.status == AppointmentStatus.loading &&
        state.selectedAppointment == null) {
      return const Center(
        child: CircularProgressIndicator(color: primaryColorTheme),
      );
    }

    if (state.status == AppointmentStatus.failure &&
        state.selectedAppointment == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: cancelColorTheme, size: 48),
            const SizedBox(height: 16),
            Text(
              state.errorMessage ?? 'Error al cargar la cita',
              textAlign: TextAlign.center,
              style: const TextStyle(color: grayTextColorTheme),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () =>
                  _cubit.loadAppointmentDetail(widget.appointmentId),
              style:
                  ElevatedButton.styleFrom(backgroundColor: primaryColorTheme),
              child: const Text('Reintentar',
                  style: TextStyle(color: whiteColorTheme)),
            ),
          ],
        ),
      );
    }

    final appointment = state.selectedAppointment;
    if (appointment == null) return const SizedBox.shrink();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _StatusBanner(appointment: appointment),
          const SizedBox(height: 20),
          _SectionCard(
            title: 'Servicios',
            child: Column(
              children: appointment.appointmentServices
                  .map((s) => _ServiceRow(service: s))
                  .toList(),
            ),
          ),
          const SizedBox(height: 16),
          _SectionCard(
            title: 'Resumen',
            child: Column(
              children: [
                _InfoRow(
                    icon: Icons.home_work,
                    label: 'Tipo',
                    value:
                        appointment.isHomeService ? 'A domicilio' : 'En sede'),
                if (appointment.isHomeService &&
                    appointment.homeAddress != null)
                  _InfoRow(
                      icon: Icons.location_on,
                      label: 'Dirección',
                      value: appointment.homeAddress!.address),
                _InfoRow(
                    icon: Icons.payment,
                    label: 'Método de pago',
                    value: appointment.paymentMethod == 'cash'
                        ? 'Efectivo'
                        : 'Tarjeta'),
                _InfoRow(
                    icon: Icons.attach_money,
                    label: 'Total',
                    value: CurrencyUtils.formatCOP(appointment.price)),
                AddonDetailSection(addons: appointment.addons),
                if (appointment.cancellationReason != null)
                  _InfoRow(
                      icon: Icons.info_outline,
                      label: 'Motivo cancelación',
                      value: appointment.cancellationReason!),
                if (appointment.refundPending)
                  const _InfoRow(
                      icon: Icons.monetization_on_outlined,
                      label: 'Reembolso',
                      value: 'Pendiente'),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _SectionCard(
            title: 'Seguimiento',
            child: TraceabilityTimelineWidget(
              traceability: appointment.traceability,
            ),
          ),
          const SizedBox(height: 24),
          if (state.actionStatus == AppointmentActionStatus.loading)
            const Center(
                child: CircularProgressIndicator(color: primaryColorTheme))
          else
            _ActionButtons(
              appointment: appointment,
              cubit: _cubit,
            ),
        ],
      ),
    );
  }

  void _navigateToRatings(BuildContext context, AppointmentModel appointment) {
    if (appointment.appointmentServices.isEmpty) return;
    final service = appointment.appointmentServices.first;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => RatingsPage(
          serviceId: service.serviceId,
          serviceName: service.serviceName,
          appointmentId: appointment.id,
          canReview: true,
        ),
      ),
    );
  }
}

// ─────────────────────────── Subwidgets ───────────────────────────

class _StatusBanner extends StatelessWidget {
  const _StatusBanner({required this.appointment});
  final AppointmentModel appointment;

  Color get _statusColor {
    switch (appointment.status) {
      case 'active':
        return successColorTheme;
      case 'pending':
        return inProgressColorTheme;
      case 'cancelled':
        return cancelColorTheme;
      case 'completed':
        return secondaryColorTheme;
      default:
        return grayTextColorTheme;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      decoration: BoxDecoration(
        color: _statusColor.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _statusColor.withValues(alpha: 0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            appointment.statusLabel,
            style: TextStyle(
              color: _statusColor,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (appointment.stateDescription != null) ...[
            const SizedBox(height: 4),
            Text(
              appointment.stateDescription!,
              style:
                  TextStyle(color: _statusColor.withValues(alpha: 0.8), fontSize: 13),
            ),
          ],
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, required this.child});
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: whiteColorTheme,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: blackColorTheme.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: blackColorTheme)),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _ServiceRow extends StatelessWidget {
  const _ServiceRow({required this.service});
  final AppointmentServiceModel service;

  @override
  Widget build(BuildContext context) {
    final String timeText = service.startTime != null && service.endTime != null
        ? '${_fmt(service.startTime!)} – ${_fmt(service.endTime!)}'
        : 'Hora por definir';

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          CircleImageProfile(
            size: 40,
            showSubIcon: false,
            typeSourceImage:
                service.serviceImage != null && service.serviceImage!.isNotEmpty
                    ? TypeSourceImage.network
                    : TypeSourceImage.asset,
            imageMain:
                service.serviceImage != null && service.serviceImage!.isNotEmpty
                    ? service.serviceImage
                    : pathManagementImages + imagePonteGradient,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(service.serviceName,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 14)),
                if (service.workerName != null)
                  Text(service.workerName!,
                      style: const TextStyle(
                          color: grayTextColorTheme, fontSize: 12)),
                Text(timeText,
                    style: const TextStyle(
                        color: grayTextColorTheme, fontSize: 12)),
              ],
            ),
          ),
          Text(CurrencyUtils.formatCOP(service.servicePrice),
              style: const TextStyle(
                  color: primaryColorTheme,
                  fontWeight: FontWeight.bold,
                  fontSize: 14)),
        ],
      ),
    );
  }

  String _fmt(DateTime dt) =>
      '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
}

class _InfoRow extends StatelessWidget {
  const _InfoRow(
      {required this.icon, required this.label, required this.value});
  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Icon(icon, color: primaryColorTheme, size: 18),
          const SizedBox(width: 10),
          Text('$label: ',
              style: const TextStyle(
                  color: grayTextColorTheme,
                  fontSize: 13,
                  fontWeight: FontWeight.w500)),
          Expanded(
            child: Text(value,
                style:
                    const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}

class _ActionButtons extends StatelessWidget {
  const _ActionButtons({required this.appointment, required this.cubit});
  final AppointmentModel appointment;
  final AppointmentCubit cubit;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (appointment.canCancel)
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              icon: const Icon(Icons.cancel_outlined, color: cancelColorTheme),
              label: const Text('Cancelar cita',
                  style: TextStyle(color: cancelColorTheme)),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: cancelColorTheme),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () => _showCancelDialog(context),
            ),
          ),
        if (appointment.canCancel &&
            (appointment.status == 'active' || appointment.status == 'pending'))
          const SizedBox(height: 12),
        if (appointment.status == 'active' || appointment.status == 'pending')
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: Icon(Icons.schedule,
                  color: appointment.canReschedule
                      ? whiteColorTheme
                      : grayTextColorTheme),
              label: Text('Reagendar',
                  style: TextStyle(
                      color: appointment.canReschedule
                          ? whiteColorTheme
                          : grayTextColorTheme)),
              style: ElevatedButton.styleFrom(
                backgroundColor: appointment.canReschedule
                    ? primaryColorTheme
                    : grayTextColorTheme.withValues(alpha: 0.2),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: appointment.canReschedule
                  ? () => showRescheduleSheet(
                        context: context,
                        appointment: appointment,
                        cubit: cubit,
                      )
                  : null,
            ),
          ),
        if (appointment.rescheduleMessage != null)
          Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 4),
            child: Row(
              children: [
                const Icon(Icons.info_outline,
                    size: 16, color: cancelColorTheme),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    appointment.rescheduleMessage!,
                    style: const TextStyle(
                      color: cancelColorTheme,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        if ((appointment.canCancel || appointment.canReschedule) &&
            appointment.canReview)
          const SizedBox(height: 12),
        if (appointment.canReview)
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.star_border, color: whiteColorTheme),
              label: const Text('Calificar Servicio',
                  style: TextStyle(color: whiteColorTheme)),
              style: ElevatedButton.styleFrom(
                backgroundColor: secondaryColorTheme,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () => _navigateToRatings(context),
            ),
          ),
      ],
    );
  }

  void _showCancelDialog(BuildContext context) {
    final TextEditingController reasonController = TextEditingController();
    final feeInfo = appointment.cancellationFeeInfo;

    PonteAlertDialog.show(
      context,
      title: 'Cancelar cita',
      confirmText: 'Sí, cancelar',
      isDanger: true,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '¿Estás seguro de que deseas cancelar esta cita?',
            style: TextStyle(color: Colors.white70),
          ),
          if (feeInfo != null && feeInfo.message != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: feeInfo.feeAmount > 0
                    ? cancelColorTheme.withValues(alpha: 0.1)
                    : successColorTheme.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    feeInfo.feeAmount > 0
                        ? Icons.warning_amber_rounded
                        : Icons.info_outline,
                    color: feeInfo.feeAmount > 0
                        ? cancelColorTheme
                        : successColorTheme,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      feeInfo.message!,
                      style: TextStyle(
                        color: feeInfo.feeAmount > 0
                            ? cancelColorTheme
                            : successColorTheme,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 16),
          ModernTextField(
            controller: reasonController,
            label: 'Motivo (opcional)',
            maxLines: 2,
          ),
        ],
      ),
      onConfirm: () {
        cubit.cancelAppointment(
          appointment.id,
          reason: reasonController.text.trim(),
        );
      },
    );
  }

  void _navigateToRatings(BuildContext context) {
    if (appointment.appointmentServices.isEmpty) return;
    final service = appointment.appointmentServices.first;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => RatingsPage(
          serviceId: service.serviceId,
          serviceName: service.serviceName,
          appointmentId: appointment.id,
          canReview: true,
        ),
      ),
    );
  }
}
