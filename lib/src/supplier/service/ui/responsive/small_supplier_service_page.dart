import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ponte_glam/config/theme/theme.dart';
import 'package:ponte_glam/config/constant/values_constant.dart';
import 'package:ponte_glam/config/constant/assets_constant.dart';
import 'package:ponte_glam/shared/model/headquarter_model.dart';
import 'package:ponte_glam/shared/model/service_model.dart';
import 'package:ponte_glam/shared/widgets/modern_form_elements.dart';
import 'package:ponte_glam/shared/widgets/rating_bar_widget.dart';
import 'package:ponte_glam/src/supplier/service/ui/cubit/supplier_service_appointments_cubit.dart';
import 'package:ponte_glam/src/supplier/service/ui/cubit/confirm_cash_payment_cubit.dart';
import 'package:ponte_glam/src/supplier/service/ui/create_service_page.dart';
import 'package:ponte_glam/di/shared_imports.dart';
import 'package:ponte_glam/shared/widgets/ponte_alert_dialog.dart';
import 'package:ponte_glam/src/supplier/service/ui/cubit/service_creation_cubit.dart';
import 'package:ponte_glam/src/supplier/service/ui/cubit/service_creation_state.dart';
import 'package:ponte_glam/shared/widgets/snack_bar_simple_widget.dart';
import 'package:ponte_glam/core/utils/image_url_helper.dart';
import 'package:ponte_glam/src/client/appointment/ui/cubit/appointment_cubit.dart';
import 'package:ponte_glam/src/client/appointment/ui/cubit/appointment_state.dart';
import 'package:ponte_glam/src/client/appointment/ui/widgets/reschedule_appointment_sheet.dart';
import 'package:ponte_glam/shared/widgets/traceability_timeline_widget.dart';
import 'package:ponte_glam/src/client/appointment/data/model/appointment_model.dart';
import 'package:ponte_glam/src/client/rate/ui/ratings_page.dart';
import 'package:ponte_glam/shared/widgets/addon_detail_section.dart';

class SmallSupplierServicePage extends StatefulWidget {
  const SmallSupplierServicePage({
    super.key,
    required this.width,
    required this.height,
    required this.headquarter,
    required this.service,
  });
  final double width;
  final double height;
  final HeadquarterModel headquarter;
  final ServiceModel service;

  @override
  State<SmallSupplierServicePage> createState() =>
      _SmallSupplierServicePageState();
}

class _SmallSupplierServicePageState extends State<SmallSupplierServicePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SupplierServiceAppointmentsCubit>().loadAppointments(
            serviceId: widget.service.id,
          );
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<ConfirmCashPaymentCubit, ConfirmCashPaymentState>(
          listener: (context, state) {
            if (state.status == ConfirmCashStatus.success) {
              PonteSnackBar.show(
                context,
                message: "Pago confirmado. La cita está ahora activa.",
                type: TypeAlert.success,
              );
              context.read<ConfirmCashPaymentCubit>().reset();
              context.read<SupplierServiceAppointmentsCubit>().loadAppointments(
                    serviceId: widget.service.id,
                    status: context
                        .read<SupplierServiceAppointmentsCubit>()
                        .state
                        .activeStatus,
                  );
            }
            if (state.status == ConfirmCashStatus.failure) {
              PonteSnackBar.show(
                context,
                message: "Error: ${state.errorMessage}",
                type: TypeAlert.error,
              );
              context.read<ConfirmCashPaymentCubit>().reset();
            }
          },
        ),
        BlocListener<ServiceCreationCubit, ServiceCreationState>(
          listener: (context, state) {
            if (state is ServiceDeletionSuccess) {
              PonteSnackBar.show(
                context,
                message: 'El servicio ha sido programado para eliminación.',
                type: TypeAlert.success,
              );
              Navigator.pop(context, true);
            } else if (state is ServiceCreationError) {
              PonteSnackBar.show(
                context,
                message: state.message,
                type: TypeAlert.error,
              );
            }
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: backgroundColorTheme,
        appBar: AppBar(
          title: Text(
            widget.service.name,
            style: const TextStyle(
              color: blackColorTheme,
              fontFamily: fontFamilyMontserrat,
              fontWeight: FontWeight.bold,
              fontSize: h3Size,
            ),
          ),
          backgroundColor: backgroundColorTheme,
          elevation: 0,
          iconTheme: const IconThemeData(color: blackColorTheme),
          actions: [
            IconButton(
              icon: const Icon(Icons.edit, color: primaryColorTheme),
              onPressed: () async {
                final result = await context.pushNamed(
                  CreateServicePage.routeName,
                  extra: {
                    "headquarter": widget.headquarter,
                    "service": widget.service,
                  },
                );
                if (result == true && mounted) {
                  // ignore: use_build_context_synchronously
                  context.pop(true);
                }
              },
            ),
            BlocBuilder<ServiceCreationCubit, ServiceCreationState>(
              builder: (context, state) {
                if (state is ServiceCreationLoading) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.0),
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: cancelColorTheme),
                    ),
                  );
                }
                return IconButton(
                  icon: const Icon(Icons.delete_outline_rounded, color: cancelColorTheme),
                  onPressed: () => _showDeleteServiceDialog(context),
                );
              },
            ),
          ],
          bottom: TabBar(
            controller: _tabController,
            labelColor: primaryColorTheme,
            unselectedLabelColor: grayTextColorTheme,
            indicatorColor: primaryColorTheme,
            labelStyle: const TextStyle(
              fontFamily: fontFamilyMontserrat,
              fontWeight: FontWeight.bold,
            ),
            tabs: const [
              Tab(text: "Información"),
              Tab(text: "Reservas"),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildInfoTab(context),
            _buildAppointmentsTab(context),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTab(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.service.images.isNotEmpty)
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(rounded10),
                image: DecorationImage(
                  image: NetworkImage(
                      ImageUrlHelper.resolve(widget.service.images.first) ??
                          widget.service.images.first),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          const SizedBox(height: 20),
          const ModernSectionHeader(title: "Detalles del Servicio"),
          const SizedBox(height: 10),
          ModernFormCard(
            children: [
              _buildInfoRow(
                "Precio",
                "\$ ${NumberFormat.currency(locale: 'es_CO', symbol: '', decimalDigits: 0).format(widget.service.price).trim()}",
              ),
              const SizedBox(height: 10),
              _buildInfoRow(
                  "Duración", "${widget.service.serviceDuration} min"),
              if (widget.service.onlyHomeService) ...[
                const SizedBox(height: 10),
                _buildInfoRow(
                  "Modalidad",
                  Row(
                    children: const [
                      Icon(Icons.home_outlined,
                          size: 16, color: primaryColorTheme),
                      SizedBox(width: 4),
                      Text(
                        "Servicio a domicilio",
                        style: TextStyle(
                          color: primaryColorTheme,
                          fontWeight: FontWeight.bold,
                          fontFamily: fontFamilyMontserrat,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 10),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => RatingsPage(
                        serviceId: widget.service.id,
                        serviceName: widget.service.name,
                        isSupplierMode: true,
                      ),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: _buildInfoRow(
                    "Calificación",
                    Row(
                      children: [
                        RatingBarWidget(
                            isLoading: false, rating: widget.service.rating),
                        const SizedBox(width: 5),
                        Text(
                          "(${widget.service.ratingCount})",
                          style: const TextStyle(
                            color: grayTextColorTheme,
                            fontFamily: fontFamilyMontserrat,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 5),
                        const Icon(Icons.arrow_forward_ios,
                            size: 12, color: grayTextColorTheme),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const ModernSectionHeader(title: "Descripción"),
          const SizedBox(height: 10),
          Text(
            widget.service.description,
            style: const TextStyle(
              fontSize: messageSize,
              fontFamily: fontFamilyHind,
              color: grayTextColorTheme,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, dynamic value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: fontFamilyMontserrat,
            color: grayTextColorTheme,
            fontWeight: FontWeight.w600,
          ),
        ),
        value is Widget
            ? value
            : Text(
                value.toString(),
                style: const TextStyle(
                  fontFamily: fontFamilyMontserrat,
                  color: blackColorTheme,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ],
    );
  }

  Widget _buildAppointmentsTab(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AppointmentCubit>(),
      child: BlocListener<AppointmentCubit, AppointmentState>(
        listener: (context, state) {
          if (state.actionStatus == AppointmentActionStatus.success) {
            PonteSnackBar.show(
              context,
              message: 'Operación realizada con éxito',
              type: TypeAlert.success,
            );
            context.read<SupplierServiceAppointmentsCubit>().loadAppointments(
                  serviceId: widget.service.id,
                  status: context
                      .read<SupplierServiceAppointmentsCubit>()
                      .state
                      .activeStatus,
                );
            context.read<AppointmentCubit>().resetActionStatus();
          } else if (state.actionStatus == AppointmentActionStatus.failure) {
            PonteSnackBar.show(
              context,
              message: state.actionErrorMessage ?? 'Error al realizar acción',
              type: TypeAlert.error,
            );
            context.read<AppointmentCubit>().resetActionStatus();
          }
        },
        child: BlocBuilder<SupplierServiceAppointmentsCubit,
            SupplierServiceAppointmentsState>(
          builder: (context, state) {
            if (state.status == SupplierServiceAppointmentsStatus.initial ||
                state.status == SupplierServiceAppointmentsStatus.loading) {
              return const Center(
                  child: CircularProgressIndicator(color: primaryColorTheme));
            }

            if (state.status == SupplierServiceAppointmentsStatus.failure) {
              return Center(
                child: Text(
                  state.errorMessage ?? "Error al cargar reservas",
                  style: const TextStyle(
                    fontFamily: fontFamilyMontserrat,
                    color: cancelColorTheme,
                  ),
                ),
              );
            }

            return Column(
              children: [
                _StatusFilterRow(
                  activeStatus: state.activeStatus,
                  onFilterChange: (newStatus) {
                    context
                        .read<SupplierServiceAppointmentsCubit>()
                        .loadAppointments(
                          serviceId: widget.service.id,
                          status: newStatus,
                        );
                  },
                ),
                if (state.appointments.isEmpty)
                  const Expanded(
                    child: Center(
                      child: Text(
                        "No hay reservas para este servicio",
                        style: TextStyle(
                          fontFamily: fontFamilyMontserrat,
                          color: grayTextColorTheme,
                        ),
                      ),
                    ),
                  )
                else
                  Expanded(
                    child: BlocBuilder<ConfirmCashPaymentCubit,
                        ConfirmCashPaymentState>(
                      builder: (context, confirmState) {
                        return BlocBuilder<AppointmentCubit, AppointmentState>(
                          builder: (context, actionState) {
                            return _AppointmentsList(
                              appointments: state.appointments,
                              confirmState: confirmState,
                              actionState: actionState,
                              onConfirm: (id) => context
                                  .read<ConfirmCashPaymentCubit>()
                                  .confirm(id),
                              onCancel: (appt) =>
                                  _showCancelDialog(context, appt),
                              onReschedule: (appt) => showRescheduleSheet(
                                context: context,
                                appointment: appt,
                                cubit: context.read<AppointmentCubit>(),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _showCancelDialog(BuildContext context, AppointmentModel appointment) {
    final TextEditingController reasonController = TextEditingController();
    final cubit = context.read<AppointmentCubit>();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Cancelar cita'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('¿Estás seguro de que deseas cancelar esta cita?'),
            const SizedBox(height: 16),
            ModernTextField(
                controller: reasonController,
                label: 'Motivo (opcional)',
                maxLines: 2),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('No, volver',
                style: TextStyle(color: grayTextColorTheme)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: cancelColorTheme),
            onPressed: () {
              Navigator.pop(ctx);
              cubit.cancelAppointment(
                appointment.id,
                reason: reasonController.text.trim(),
              );
            },
            child: const Text('Sí, cancelar',
                style: TextStyle(color: whiteColorTheme)),
          ),
        ],
      ),
    );
  }

  void _showDeleteServiceDialog(BuildContext ctx) {
    PonteAlertDialog.show(
      context,
      title: 'Eliminar servicio',
      message:
          '¿Estás seguro de que deseas eliminar "${widget.service.name}"? Se eliminará completamente en los siguientes 5 días. Esta acción no se puede deshacer.',
      confirmText: 'Eliminar',
      isDanger: true,
      onConfirm: () {
        ctx.read<ServiceCreationCubit>().deleteService(widget.service.id);
      },
    );
  }
}

class _AppointmentsList extends StatelessWidget {
  final List<AppointmentModel> appointments;
  final ConfirmCashPaymentState confirmState;
  final AppointmentState actionState;
  final Function(int) onConfirm;
  final Function(AppointmentModel) onCancel;
  final Function(AppointmentModel) onReschedule;

  const _AppointmentsList({
    required this.appointments,
    required this.confirmState,
    required this.actionState,
    required this.onConfirm,
    required this.onCancel,
    required this.onReschedule,
  });

  @override
  Widget build(BuildContext context) {
    final isActionLoading =
        actionState.actionStatus == AppointmentActionStatus.loading;
    final isConfirming =
        confirmState.status == ConfirmCashStatus.loading || isActionLoading;

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: appointments.length,
      itemBuilder: (context, index) {
        return _AppointmentCard(
          appointment: appointments[index],
          isConfirming: isConfirming,
          onConfirm: () => onConfirm(appointments[index].id),
          onCancel: () => onCancel(appointments[index]),
          onReschedule: () => onReschedule(appointments[index]),
        );
      },
    );
  }
}

class _AppointmentCard extends StatelessWidget {
  final AppointmentModel appointment;
  final bool isConfirming;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;
  final VoidCallback onReschedule;

  const _AppointmentCard({
    required this.appointment,
    required this.isConfirming,
    required this.onConfirm,
    required this.onCancel,
    required this.onReschedule,
  });

  @override
  Widget build(BuildContext context) {
    final appointmentService = appointment.appointmentServices.isNotEmpty
        ? appointment.appointmentServices.first
        : null;

    final isCashPending =
        appointment.paymentMethod == 'cash' && appointment.status == 'pending';

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(rounded10),
        side: isCashPending
            ? const BorderSide(color: Colors.orange, width: 1.5)
            : BorderSide.none,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 8),
            _buildStatusAndPrice(),
            if (appointment.addons.isNotEmpty) ...[
              const SizedBox(height: 4),
              AddonDetailSection(addons: appointment.addons),
            ],
            if (appointmentService?.startTime != null) ...[
              const SizedBox(height: 6),
              _buildTimeRow(appointmentService!.startTime!),
            ],
            if (isCashPending) ...[
              const SizedBox(height: 12),
              _buildConfirmButton(),
            ],
            if (appointment.canCancel ||
                appointment.status == 'active' ||
                appointment.status == 'pending') ...[
              const SizedBox(height: 12),
              _buildActionsRow(),
            ],
            const Divider(height: 24),
            _buildHistoryTile(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Reserva #${appointment.id}",
          style: const TextStyle(
            fontFamily: fontFamilyMontserrat,
            fontWeight: FontWeight.bold,
            fontSize: h4Size,
            color: blackColorTheme,
          ),
        ),
        _PaymentMethodBadge(paymentMethod: appointment.paymentMethod),
      ],
    );
  }

  Widget _buildStatusAndPrice() {
    return Row(
      children: [
        _StatusChip(status: appointment.status),
        const SizedBox(width: 8),
        Text(
          "\$ ${NumberFormat.currency(locale: 'es_CO', symbol: '', decimalDigits: 0).format(double.tryParse(appointment.price) ?? 0).trim()}",
          style: const TextStyle(
            fontFamily: fontFamilyMontserrat,
            fontWeight: FontWeight.bold,
            color: secondaryColorTheme,
            fontSize: h4Size,
          ),
        ),
      ],
    );
  }

  Widget _buildTimeRow(DateTime startTime) {
    return Row(
      children: [
        const Icon(Icons.access_time, size: 14, color: grayTextColorTheme),
        const SizedBox(width: 4),
        Text(
          _formatDateTime(startTime),
          style: const TextStyle(
            fontFamily: fontFamilyHind,
            color: grayTextColorTheme,
            fontSize: 13,
          ),
        ),
      ],
    );
  }

  Widget _buildConfirmButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        icon: isConfirming
            ? const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                    color: Colors.white, strokeWidth: 2),
              )
            : const Icon(Icons.check_circle_outline, color: Colors.white),
        label: Text(
          isConfirming ? "Procesando..." : "Confirmar pago en efectivo",
          style: const TextStyle(
              color: Colors.white,
              fontFamily: fontFamilyMontserrat,
              fontWeight: FontWeight.bold),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green.shade600,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
        onPressed: isConfirming ? null : onConfirm,
      ),
    );
  }

  Widget _buildActionsRow() {
    final bool canReschedule =
        appointment.status == 'active' || appointment.status == 'pending';

    return Row(
      children: [
        if (canReschedule)
          Expanded(
            child: ElevatedButton.icon(
              icon: Icon(Icons.schedule,
                  size: 16,
                  color: appointment.canReschedule
                      ? whiteColorTheme
                      : grayTextColorTheme),
              label: Text("Reagendar",
                  style: TextStyle(
                      fontSize: 12,
                      color: appointment.canReschedule
                          ? whiteColorTheme
                          : grayTextColorTheme)),
              style: ElevatedButton.styleFrom(
                backgroundColor: appointment.canReschedule
                    ? primaryColorTheme
                    : grayTextColorTheme.withValues(alpha: 0.2),
                padding: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: isConfirming || !appointment.canReschedule
                  ? null
                  : onReschedule,
            ),
          ),
        if (canReschedule && appointment.canCancel) const SizedBox(width: 8),
        if (appointment.canCancel)
          Expanded(
            child: OutlinedButton.icon(
              icon: const Icon(Icons.cancel_outlined,
                  size: 16, color: cancelColorTheme),
              label: const Text("Cancelar",
                  style: TextStyle(fontSize: 12, color: cancelColorTheme)),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: cancelColorTheme),
                padding: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: isConfirming ? null : onCancel,
            ),
          ),
      ],
    );
  }

  Widget _buildHistoryTile(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        title: const Text(
          "Ver Historial de Cita",
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: primaryColorTheme,
            fontFamily: fontFamilyMontserrat,
          ),
        ),
        tilePadding: EdgeInsets.zero,
        children: [
          TraceabilityTimelineWidget(
            traceability: appointment.traceability,
            showTitle: false,
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dt) {
    final local = dt.toLocal();
    return "${local.day}/${local.month}/${local.year} ${local.hour.toString().padLeft(2, '0')}:${local.minute.toString().padLeft(2, '0')}";
  }
}

class _StatusFilterRow extends StatelessWidget {
  const _StatusFilterRow({
    required this.activeStatus,
    required this.onFilterChange,
  });

  final String activeStatus;
  final void Function(String) onFilterChange;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          _FilterChip(
            label: "Próximas",
            isActive: activeStatus == 'upcoming',
            onTap: () => onFilterChange('upcoming'),
          ),
          const SizedBox(width: 8),
          _FilterChip(
            label: "Pasadas",
            isActive: activeStatus == 'past',
            onTap: () => onFilterChange('past'),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? primaryColorTheme : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isActive ? primaryColorTheme : grayTextColorTheme,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.white : grayTextColorTheme,
            fontFamily: fontFamilyMontserrat,
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}

class _PaymentMethodBadge extends StatelessWidget {
  const _PaymentMethodBadge({required this.paymentMethod});
  final String paymentMethod;

  @override
  Widget build(BuildContext context) {
    final isCash = paymentMethod == 'cash';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isCash ? Colors.green.shade50 : Colors.blue.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isCash ? Colors.green.shade300 : Colors.blue.shade300,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isCash ? Icons.payments_outlined : Icons.credit_card,
            size: 14,
            color: isCash ? Colors.green.shade700 : Colors.blue.shade700,
          ),
          const SizedBox(width: 4),
          Text(
            isCash ? "Efectivo" : "Tarjeta",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: isCash ? Colors.green.shade700 : Colors.blue.shade700,
              fontFamily: fontFamilyMontserrat,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});
  final String status;

  @override
  Widget build(BuildContext context) {
    Color color;
    String label;
    switch (status) {
      case 'active':
        color = Colors.green;
        label = "Activa";
        break;
      case 'pending':
        color = Colors.orange;
        label = "Pendiente";
        break;
      case 'cancelled':
        color = Colors.red;
        label = "Cancelada";
        break;
      case 'completed':
        color = Colors.blue;
        label = "Completada";
        break;
      default:
        color = Colors.grey;
        label = status;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 12,
          fontFamily: fontFamilyMontserrat,
        ),
      ),
    );
  }
}
