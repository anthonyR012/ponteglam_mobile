import 'package:fancy_drawer/fancy_drawer.dart';
import 'package:flutter/material.dart';
import 'package:ponte_glam/config/constant/assets_constant.dart';
import 'package:ponte_glam/config/theme/theme.dart';
import 'package:ponte_glam/core/utils/currency_utils.dart';
import 'package:ponte_glam/di/shared_imports.dart';
import 'package:ponte_glam/shared/widgets/circle_image_profile_widget.dart';
import 'package:ponte_glam/shared/widgets/custom_main_app_bar_widget.dart';
import 'package:ponte_glam/src/client/appointment/data/model/appointment_model.dart';
import 'package:ponte_glam/core/utils/date_utils.dart';
import 'package:ponte_glam/src/client/appointment/ui/appointment_detail_page.dart';
import 'package:ponte_glam/src/client/appointment/ui/cubit/appointment_cubit.dart';
import 'package:ponte_glam/src/client/appointment/ui/cubit/appointment_state.dart';

class AppointmentHistory extends StatefulWidget {
  /// [controllerMenu] es nullable: puede ser null cuando se navega desde
  /// una push notification (sin FancyDrawer disponible).
  const AppointmentHistory({super.key, this.controllerMenu});
  static const String routeName = 'history';
  final FancyDrawerController? controllerMenu;

  @override
  State<AppointmentHistory> createState() => _AppointmentHistoryState();
}

class _AppointmentHistoryState extends State<AppointmentHistory>
    with SingleTickerProviderStateMixin {
  DateTime now = AppDateUtils.now();
  late TabController _tabController;
  late AppointmentCubit _cubit;

  static const List<String> _filters = ['upcoming', 'completed', 'cancelled'];
  static const List<String> _filterLabels = [
    'Próximas',
    'Completadas',
    'Canceladas'
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _cubit = getIt<AppointmentCubit>();
    _cubit.loadAppointments(filter: 'upcoming');
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        _cubit.loadAppointments(filter: _filters[_tabController.index]);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(100.0),
          child: CustomMainAppBar(
            iconMenu: widget.controllerMenu != null,
            controllerMenu: widget.controllerMenu,
            leftContent: 40,
            top: 20,
            textAppBar: getIt<AppLocalizations>().titleCalendar,
            subtitleAppBar: getIt<AppLocalizations>().titleHistory,
          ),
        ),
        body: BlocListener<AppointmentCubit, AppointmentState>(
          listener: (context, state) {
            if (state.actionStatus == AppointmentActionStatus.success) {
              _cubit.loadAppointments(filter: _filters[_tabController.index]);
            }
          },
          child: Column(
            children: [
              const SizedBox(height: 4),
              TabBar(
                controller: _tabController,
                labelColor: primaryColorTheme,
                unselectedLabelColor: grayTextColorTheme,
                indicatorColor: primaryColorTheme,
                tabs: _filterLabels.map((l) => Tab(text: l)).toList(),
              ),
              Expanded(
                child: BlocBuilder<AppointmentCubit, AppointmentState>(
                  builder: (context, state) {
                    if (state.status == AppointmentStatus.loading ||
                        state.status == AppointmentStatus.initial) {
                      return const Center(
                        child:
                            CircularProgressIndicator(color: primaryColorTheme),
                      );
                    }
                    if (state.status == AppointmentStatus.failure) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.error_outline,
                                color: cancelColorTheme, size: 40),
                            const SizedBox(height: 12),
                            Text(
                              state.errorMessage ?? 'Error al cargar citas',
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: grayTextColorTheme),
                            ),
                            const SizedBox(height: 12),
                            ElevatedButton(
                              onPressed: () => _cubit.loadAppointments(
                                  filter: _filters[_tabController.index]),
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: primaryColorTheme),
                              child: const Text('Reintentar',
                                  style: TextStyle(color: whiteColorTheme)),
                            ),
                          ],
                        ),
                      );
                    }
                    if (state.appointments.isEmpty) {
                      return const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.calendar_today,
                                size: 48, color: grayTextColorTheme),
                            SizedBox(height: 12),
                            Text(
                              'No hay citas en esta categoría',
                              style: TextStyle(color: grayTextColorTheme),
                            ),
                          ],
                        ),
                      );
                    }
                    return ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: state.appointments.length,
                      itemBuilder: (context, index) {
                        final appointment = state.appointments[index];
                        return _AppointmentListCard(
                          appointment: appointment,
                          onTap: () async {
                            await Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => AppointmentDetailPage(
                                  appointmentId: appointment.id,
                                ),
                              ),
                            );
                            _cubit.loadAppointments(
                                filter: _filters[_tabController.index]);
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AppointmentListCard extends StatelessWidget {
  const _AppointmentListCard({required this.appointment, required this.onTap});
  final AppointmentModel appointment;
  final VoidCallback onTap;

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

  String get _timeLabel {
    final services = appointment.appointmentServices;
    if (services.isEmpty) return '';
    final first = services.first;
    if (first.startTime == null) return '';
    final h = first.startTime!.hour.toString().padLeft(2, '0');
    final m = first.startTime!.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  String get _dateLabel {
    final services = appointment.appointmentServices;
    if (services.isEmpty) return '';
    final first = services.first;
    if (first.startTime == null) return '';
    final dt = first.startTime!;
    return '${dt.day}/${dt.month}/${dt.year}';
  }

  @override
  Widget build(BuildContext context) {
    final String serviceName = appointment.appointmentServices.isNotEmpty
        ? appointment.appointmentServices.first.serviceName
        : 'Servicio';
    final String workerName = appointment.appointmentServices.isNotEmpty
        ? (appointment.appointmentServices.first.workerName ?? '')
        : '';

    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleImageProfile(
                size: 50,
                showSubIcon: false,
                typeSourceImage: appointment.appointmentServices.isNotEmpty && 
                                 appointment.appointmentServices.first.serviceImage != null && 
                                 appointment.appointmentServices.first.serviceImage!.isNotEmpty
                    ? TypeSourceImage.network
                    : TypeSourceImage.asset,
                imageMain: appointment.appointmentServices.isNotEmpty && 
                           appointment.appointmentServices.first.serviceImage != null && 
                           appointment.appointmentServices.first.serviceImage!.isNotEmpty
                    ? appointment.appointmentServices.first.serviceImage
                    : pathManagementImages + imagePonteGradient,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      serviceName,
                      style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: blackColorTheme),
                    ),
                    if (workerName.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(workerName,
                          style: const TextStyle(
                              fontSize: 13, color: grayTextColorTheme)),
                    ],
                    const SizedBox(height: 6),
                    if (_dateLabel.isNotEmpty)
                      Row(children: [
                        Icon(Icons.calendar_today,
                            size: 14, color: Colors.grey.shade500),
                        const SizedBox(width: 4),
                        Text(_dateLabel,
                            style: TextStyle(
                                fontSize: 12, color: Colors.grey.shade600)),
                        if (_timeLabel.isNotEmpty) ...[
                          const SizedBox(width: 8),
                          Icon(Icons.schedule,
                              size: 14, color: Colors.grey.shade500),
                          const SizedBox(width: 4),
                          Text(_timeLabel,
                              style: TextStyle(
                                  fontSize: 12, color: Colors.grey.shade600)),
                        ],
                      ]),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: _statusColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        appointment.statusLabel,
                        style: TextStyle(
                            fontSize: 11,
                            color: _statusColor,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(CurrencyUtils.formatCOP(appointment.price),
                      style: const TextStyle(
                          color: primaryColorTheme,
                          fontWeight: FontWeight.bold,
                          fontSize: 15)),
                  const SizedBox(height: 8),
                  const Icon(Icons.chevron_right,
                      color: grayTextColorTheme, size: 20),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
