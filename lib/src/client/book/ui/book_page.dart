import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:ponte_glam/config/constant/assets_constant.dart';
import 'package:ponte_glam/config/theme/theme.dart';
import 'package:ponte_glam/core/utils/date_utils.dart';
import 'package:ponte_glam/di/shared_imports.dart';
import 'package:ponte_glam/core/utils/image_url_helper.dart';
import 'package:ponte_glam/shared/model/address_model.dart';
import 'package:ponte_glam/shared/model/available_date_model.dart';
import 'package:ponte_glam/shared/model/available_slot_model.dart';
import 'package:ponte_glam/shared/model/headquarter_model.dart';
import 'package:ponte_glam/shared/model/service_model.dart';
import 'package:ponte_glam/shared/model/addon_model.dart';
import 'package:ponte_glam/shared/widgets/button_main_widget.dart';
import 'package:ponte_glam/shared/widgets/snack_bar_simple_widget.dart';
import 'package:ponte_glam/shared/widgets/custom_main_app_bar_widget.dart';
import 'package:ponte_glam/shared/widgets/day_calendar_widget.dart';
import 'package:ponte_glam/src/client/book/ui/widgets/addon_selector_widget.dart';
import 'package:ponte_glam/src/client/book/ui/widgets/booking_summary_widget.dart';
import 'package:ponte_glam/src/client/book/ui/cubit/booking_cubit.dart';
import 'package:ponte_glam/src/client/book/ui/cubit/booking_state.dart';
import 'package:ponte_glam/src/client/profile/ui/profile_page.dart';
import 'package:ponte_glam/src/client/profile/ui/widgets/addresses_widgets/adresses_available_widget.dart';
import 'package:ponte_glam/src/client/profile/ui/widgets/addresses_widgets/create_address_widget.dart';
import 'package:ponte_glam/src/client/worker/ui/bloc/worker_event.dart';
import 'package:ponte_glam/src/client/worker/ui/bloc/worker_state.dart';

class BookPage extends StatefulWidget {
  const BookPage({
    super.key,
    required this.headquarterModel,
    required this.service,
  });
  static String routeName = 'book';
  final HeadquarterModel headquarterModel;
  final ServiceModel service;

  @override
  State<BookPage> createState() => _BookPageState();
}

class _BookPageState extends State<BookPage> {
  late final BookingCubit _bookingCubit;
  int? _selectedWorkerId;
  bool _isBookingInProgress = false;

  int get _activeServiceId => widget.service.id;

  @override
  void initState() {
    super.initState();
    _bookingCubit = getIt<BookingCubit>();
    _bookingCubit.reset();
    context.read<WorkerBloc>().add(DoGetWorkersEvent(
          headQuarterId: widget.headquarterModel.id,
          serviceId: _activeServiceId,
        ));
  }

  void _showPaymentMethodSheet(
      BuildContext context, AvailableSlotModel slot, int serviceId) {
    final currentState = _bookingCubit.state;
    final isHomeService = currentState is BookingSlotSelected
        ? currentState.isHomeService
        : false;
    final selectedAddress = currentState is BookingSlotSelected
        ? currentState.selectedHomeAddress
        : null;

    if (isHomeService && selectedAddress == null) {
      PonteSnackBar.show(
        context,
        message: 'Debes seleccionar una dirección para el servicio a domicilio',
        type: TypeAlert.warning,
      );
      return;
    }

    final selectedAddons = currentState is BookingSlotSelected
        ? currentState.selectedAddons
        : <AddonModel>[];

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Selecciona método de pago',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: fontFamilyMontserrat,
              ),
            ),
            const SizedBox(height: 24),
            _PaymentOption(
              icon: Icons.payments_outlined,
              title: 'Efectivo',
              subtitle: 'Paga en el local al momento del servicio',
              color: Colors.green,
              onTap: () {
                Navigator.pop(ctx);
                setState(() => _isBookingInProgress = true);
                _bookingCubit.createBooking(
                  serviceId: serviceId,
                  workerId: slot.workerId,
                  startTime: slot.startTime,
                  endTime: slot.endTime,
                  paymentMethod: 'cash',
                  isHomeService: isHomeService,
                  homeAddressId: selectedAddress?.id,
                  selectedAddons: selectedAddons,
                );
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final activeService = widget.service;

    return BlocProvider<BookingCubit>.value(
      value: _bookingCubit,
      child: BlocListener<BookingCubit, BookingState>(
        listener: (ctx, state) {
          if (state is BookingConfirmed) {
            setState(() => _isBookingInProgress = false);
            PonteSnackBar.show(
              ctx,
              message:
                  '¡Reserva creada! El pago se realizará en efectivo en el local.',
              type: TypeAlert.success,
            );
            context.pop();
            _bookingCubit.refreshAfterBooking();
          }
          if (state is BookingError && _isBookingInProgress) {
            setState(() => _isBookingInProgress = false);
            PonteSnackBar.show(
              ctx,
              message: state.failure.message,
              type: TypeAlert.error,
            );
          }
        },
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(80),
            child: CustomMainAppBar(
              iconMenu: true,
              leftContent: 40,
              top: 20,
              textAppBar: getIt<AppLocalizations>().titleAppointment,
              subtitleAppBar: widget.headquarterModel.companyInfo?.name,
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.service.images.length == 1)
                    Container(
                      height: 180,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            ImageLoadWidget(
                              image: widget.service.images.first,
                              typeSourceImage: TypeSourceImage.network,
                              fit: BoxFit.cover,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.transparent,
                                    Colors.black.withValues(alpha: 0.7),
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 16,
                              left: 16,
                              right: 16,
                              child: Text(
                                widget.service.name,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: fontFamilyMontserrat,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  else ...[
                    Text(
                      widget.service.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: fontFamilyMontserrat,
                        color: primaryColorTheme,
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (widget.service.images.isNotEmpty)
                      SizedBox(
                        height: 110,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: widget.service.images.length,
                          separatorBuilder: (context, index) =>
                              const SizedBox(width: 10),
                          itemBuilder: (context, index) {
                            return Container(
                              width: MediaQuery.of(context).size.width * 0.35,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.08),
                                    blurRadius: 8,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: ImageLoadWidget(
                                  image: widget.service.images[index],
                                  typeSourceImage: TypeSourceImage.network,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                  ],
                  if (widget.service.images.isNotEmpty)
                    const SizedBox(height: 16),
                  const SizedBox(height: 4),
                  const SizedBox(height: 20),
                  const _TextTitleLabel(
                      description: 'Trabajadores disponibles'),
                  const SizedBox(height: 10),
                  _AvailableWorkers(
                    serviceId: activeService.id,
                    headQuarterId: widget.headquarterModel.id,
                    selectedWorkerId: _selectedWorkerId,
                    onWorkerSelected: (workerId) {
                      setState(() => _selectedWorkerId = workerId);
                      if (workerId != null) {
                        _bookingCubit.loadDates(
                          serviceId: activeService.id,
                          workerId: workerId,
                          headQuarterId: widget.headquarterModel.id,
                        );
                      } else {
                        _bookingCubit.reset();
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  if (_selectedWorkerId == null)
                    const _LockedStepHint(
                      stepNumber: 2,
                      label: 'Selecciona una fecha',
                      message:
                          'Primero selecciona un trabajador para ver las fechas disponibles',
                    )
                  else ...[
                    const _TextTitleLabel(description: 'Selecciona una fecha'),
                    const SizedBox(height: 10),
                    const _DateSelector(),
                  ],
                  const SizedBox(height: 20),
                  BlocBuilder<BookingCubit, BookingState>(
                    builder: (context, state) {
                      final hasDate = _getSelectedDate(state) != null;
                      if (!hasDate) {
                        return _LockedStepHint(
                          stepNumber: 3,
                          label: 'Horarios disponibles',
                          message: _selectedWorkerId == null
                              ? 'Primero selecciona un trabajador y una fecha'
                              : 'Selecciona una fecha para ver los horarios disponibles',
                        );
                      }
                      return const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _TextTitleLabel(description: 'Horarios disponibles'),
                          SizedBox(height: 10),
                          _SlotSelector(),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  BlocBuilder<BookingCubit, BookingState>(
                    builder: (context, state) {
                      final slot = _getSelectedSlot(state);
                      if (slot == null) return const SizedBox.shrink();
                      final isHomeService = state is BookingSlotSelected
                          ? state.isHomeService
                          : false;
                      final selectedHomeAddress = state is BookingSlotSelected
                          ? state.selectedHomeAddress
                          : null;
                      return Column(
                        children: [
                          _HomeServiceSwitch(
                            slot: slot,
                            isHomeService: isHomeService,
                          ),
                          if (isHomeService && slot.onlyHomeService) ...[
                            const SizedBox(height: 12),
                            _HomeAddressSelector(
                              selectedAddress: selectedHomeAddress,
                            ),
                          ],
                          if (state is BookingSlotSelected) ...[
                            const SizedBox(height: 12),
                            AddonSelectorWidget(state: state),
                          ],
                          const SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 20.0),
                            child: BookingSummaryWidget(
                              slot: slot,
                              serviceName: activeService.name,
                              price: activeService.price,
                              isHomeService: isHomeService,
                              homeServicePrice: slot.homeServicePrice,
                              headquarterName: widget.headquarterModel.name,
                              address: widget.headquarterModel.address ?? "",
                              selectedHomeAddress: selectedHomeAddress,
                              selectedAddons: state is BookingSlotSelected
                                  ? state.selectedAddons
                                  : const [],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  BlocBuilder<BookingCubit, BookingState>(
                    builder: (context, state) {
                      final slot = _getSelectedSlot(state);
                      final isReady = slot != null && !_isBookingInProgress;
                      final isHomeService = state is BookingSlotSelected
                          ? state.isHomeService
                          : false;
                      final homePrice =
                          (isHomeService && (slot?.homeServicePrice ?? 0) > 0)
                              ? slot!.homeServicePrice!
                              : 0.0;

                      final addonsPrice = state is BookingSlotSelected
                          ? state.selectedAddons
                              .fold<double>(0, (sum, a) => sum + a.price)
                          : 0.0;

                      final formattedPrice = NumberFormat.currency(
                              locale: 'es_CO', symbol: '\$', decimalDigits: 0)
                          .format(activeService.price + homePrice + addonsPrice);

                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('TOTAL'),
                                Text(
                                  formattedPrice,
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            _isBookingInProgress
                                ? const Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 16),
                                    child: CircularProgressIndicator(
                                        color: primaryColorTheme),
                                  )
                                : ButtonMain(
                                    width:
                                        MediaQuery.of(context).size.width * 0.2,
                                    textButton: 'Reservar',
                                    backgroundColor: isReady
                                        ? primaryColorTheme
                                        : Colors.grey,
                                    iconCustom: SvgPicture.asset(
                                      '$pathManagementIcons$iconForwardArrow',
                                      colorFilter: const ColorFilter.mode(
                                          Colors.white, BlendMode.srcIn),
                                    ),
                                    onPressed: () {
                                      if (!isReady) {
                                        PonteSnackBar.show(
                                          context,
                                          message: 'Por favor selecciona un horario primero',
                                          type: TypeAlert.error,
                                        );
                                        return;
                                      }
                                      _showPaymentMethodSheet(
                                          context, slot, activeService.id);
                                    },
                                  ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── helpers ────────────────────────────────────────────────────────────────

List<AvailableDateModel>? _getDates(BookingState state) {
  if (state is BookingDatesLoaded) return state.availableDates;
  if (state is BookingDateChanged) return state.availableDates;
  if (state is BookingSlotSelected) return state.availableDates;
  return null;
}

AvailableDateModel? _getSelectedDate(BookingState state) {
  if (state is BookingDatesLoaded) return state.selectedDate;
  if (state is BookingDateChanged) return state.selectedDate;
  if (state is BookingSlotSelected) return state.selectedDate;
  return null;
}

AvailableSlotModel? _getSelectedSlot(BookingState state) {
  if (state is BookingSlotSelected) return state.selectedSlot;
  return null;
}

// ─── widgets ─────────────────────────────────────────────────────────────────

class _DateSelector extends StatelessWidget {
  const _DateSelector();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookingCubit, BookingState>(
      builder: (context, state) {
        if (state is BookingLoadingDates) {
          return _DateSkeleton();
        }

        if (state is BookingNoAvailability) {
          return const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: Text(
              'No hay fechas disponibles para este servicio.',
              style: TextStyle(color: Colors.grey),
            ),
          );
        }

        final dates = _getDates(state);
        final selectedDate = _getSelectedDate(state);

        if (dates == null || dates.isEmpty) {
          return const SizedBox.shrink();
        }

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            children: dates.map((dateModel) {
              final dt = DateTime.parse(dateModel.date);
              final dayNumber = dt.day.toString();
              final weekday = DateFormat('EEE', 'es_CO').format(dt);
              final isSelected = dateModel.date == selectedDate?.date;

              return DayCalendarCard(
                width: MediaQuery.of(context).size.width,
                numberDay: dayNumber,
                day: weekday,
                isSelected: isSelected,
                isLoading: false,
                onTap: () => context.read<BookingCubit>().selectDate(dateModel),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}

class _DateSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: List.generate(
          6,
          (i) => Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Container(
              width: 52,
              height: 68,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SlotSelector extends StatelessWidget {
  const _SlotSelector();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookingCubit, BookingState>(
      builder: (context, state) {
        if (state is BookingLoadingDates) {
          return const Center(child: CircularProgressIndicator());
        }

        final selectedDate = _getSelectedDate(state);
        final selectedSlot = _getSelectedSlot(state);

        if (selectedDate == null) {
          return const SizedBox.shrink();
        }

        if (selectedDate.slots.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(8),
            child: Text(
              'No hay horarios disponibles.',
              style: TextStyle(color: Colors.grey),
            ),
          );
        }

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            children: selectedDate.slots.map((slot) {
              final startDt =
                  AppDateUtils.fromUtc(DateTime.parse(slot.startTime));
              final timeStr = DateFormat('hh:mm a').format(startDt);
              final isSelected = selectedSlot == slot;

              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ElevatedButton(
                  onPressed: () =>
                      context.read<BookingCubit>().selectSlot(slot),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        isSelected ? primaryColorTheme : Colors.white,
                    foregroundColor: isSelected ? Colors.white : Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: const BorderSide(color: primaryColorTheme),
                    ),
                  ),
                  child: Text(timeStr),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}

class _AvailableWorkers extends StatelessWidget {
  const _AvailableWorkers({
    required this.serviceId,
    required this.headQuarterId,
    required this.selectedWorkerId,
    required this.onWorkerSelected,
  });

  final int serviceId;
  final int headQuarterId;
  final int? selectedWorkerId;
  final void Function(int? workerId) onWorkerSelected;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WorkerBloc, WorkerState>(
      builder: (context, workerState) {
        if (workerState is WorkerLoading || workerState is WorkerInitial) {
          return const Center(child: CircularProgressIndicator());
        }
        if (workerState is WorkerError) {
          return Center(child: Text('Error: ${workerState.message}'));
        }
        if (workerState is WorkerLoaded) {
          if (workerState.workers.isEmpty) {
            return const Padding(
              padding: EdgeInsets.all(8),
              child: Text('No hay trabajadores disponibles',
                  style: TextStyle(color: Colors.grey)),
            );
          }
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: workerState.workers.map((worker) {
                final targetWorkerId = worker.workerId ?? worker.id;
                final isSelected = selectedWorkerId == targetWorkerId;

                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: GestureDetector(
                    onTap: () {
                      final newId = isSelected ? null : targetWorkerId;
                      onWorkerSelected(newId);
                    },
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSelected
                                  ? primaryColorTheme
                                  : Colors.transparent,
                              width: 3,
                            ),
                          ),
                          child: CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.grey.shade300,
                            backgroundImage: worker.picture.isNotEmpty
                                ? NetworkImage(
                                    ImageUrlHelper.resolve(worker.picture) ??
                                        worker.picture)
                                : null,
                            child: worker.picture.isEmpty
                                ? Text(worker.fullName.substring(0, 1))
                                : null,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          worker.fullName.split(' ').first,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}

class _HomeServiceSwitch extends StatelessWidget {
  const _HomeServiceSwitch({
    required this.slot,
    required this.isHomeService,
  });

  final AvailableSlotModel slot;
  final bool isHomeService;

  @override
  Widget build(BuildContext context) {
    final available = slot.onlyHomeService;
    final price = slot.homeServicePrice ?? 0.0;
    final hasCost = available && price > 0;

    final priceStr = NumberFormat.currency(
      locale: 'es_CO',
      symbol: '\$',
      decimalDigits: 0,
    ).format(price);

    String subtitle;
    if (!available) {
      subtitle = 'No disponible a domicilio';
    } else if (hasCost) {
      subtitle = isHomeService
          ? 'Domicilio activado: +$priceStr al total'
          : 'Costo adicional: +$priceStr';
    } else {
      subtitle = isHomeService
          ? 'Domicilio activado'
          : 'Disponible sin costo adicional';
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        decoration: BoxDecoration(
          color: available && isHomeService
              ? primaryColorTheme.withValues(alpha: 0.05)
              : greyBlockColorTheme.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: available && isHomeService
                ? primaryColorTheme.withValues(alpha: 0.4)
                : greyBlockColorTheme,
          ),
        ),
        child: SwitchListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          secondary: Icon(
            Icons.home_outlined,
            color: available ? primaryColorTheme : grayTextColorTheme,
          ),
          title: Text(
            'Servicio a domicilio',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: available ? Colors.black87 : grayTextColorTheme,
            ),
          ),
          subtitle: Text(
            subtitle,
            style: TextStyle(
              fontSize: 12,
              color: available && isHomeService
                  ? primaryColorTheme
                  : grayTextColorTheme,
            ),
          ),
          value: isHomeService,
          onChanged: available
              ? (val) => context.read<BookingCubit>().toggleHomeService(val)
              : null,
          activeThumbColor: primaryColorTheme,
        ),
      ),
    );
  }
}
// Removed _BookingSummary and _SummaryRow, now imported as BookingSummaryWidget

class _PaymentOption extends StatelessWidget {
  const _PaymentOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: color.withValues(alpha: 0.4)),
          borderRadius: BorderRadius.circular(12),
          color: color.withValues(alpha: 0.05),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: color)),
                  const SizedBox(height: 2),
                  Text(subtitle,
                      style:
                          const TextStyle(fontSize: 12, color: Colors.black54)),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: color),
          ],
        ),
      ),
    );
  }
}

class _LockedStepHint extends StatelessWidget {
  const _LockedStepHint({
    required this.stepNumber,
    required this.label,
    required this.message,
  });

  final int stepNumber;
  final String label;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 22,
                height: 22,
                decoration: const BoxDecoration(
                  color: greyBlockColorTheme,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '$stepNumber',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: grayTextColorTheme,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 18,
                  color: grayTextColorTheme,
                  fontWeight: FontWeight.bold,
                  fontFamily: fontFamilyMontserrat,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: greyBlockColorTheme.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: greyBlockColorTheme),
            ),
            child: Row(
              children: [
                const Icon(Icons.lock_outline,
                    size: 15, color: grayTextColorTheme),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    message,
                    style: const TextStyle(
                      color: grayTextColorTheme,
                      fontSize: 13,
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

class _TextTitleLabel extends StatelessWidget {
  const _TextTitleLabel({required this.description});
  final String description;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Text(
        description,
        style: const TextStyle(
          fontSize: 18,
          color: secondaryColorTheme,
          fontWeight: FontWeight.bold,
          fontFamily: fontFamilyMontserrat,
        ),
      ),
    );
  }
}

class _HomeAddressSelector extends StatefulWidget {
  const _HomeAddressSelector({required this.selectedAddress});
  final AddressModel? selectedAddress;

  @override
  State<_HomeAddressSelector> createState() => _HomeAddressSelectorState();
}

class _HomeAddressSelectorState extends State<_HomeAddressSelector> {
  Position? _currentPosition;
  bool _didAutoSelect = false;

  @override
  void initState() {
    super.initState();
    context.read<HomeBloc>().add(DoGetUserAddressesEvent());
    _fetchPosition();
  }

  Future<void> _fetchPosition() async {
    try {
      final pos = await getIt<GeoDevice>().getCurrentPosition();
      if (mounted) setState(() => _currentPosition = pos);
    } catch (_) {}
  }

  void _autoSelectNearest(List<AddressModel> addresses) {
    if (_didAutoSelect || addresses.isEmpty || widget.selectedAddress != null) {
      return;
    }
    _didAutoSelect = true;
    if (_currentPosition == null) {
      context.read<BookingCubit>().selectHomeAddress(addresses.first);
      return;
    }
    AddressModel nearest = addresses.first;
    double minDist = double.infinity;
    for (final addr in addresses) {
      final lat = double.tryParse(addr.latitude) ?? 0;
      final lng = double.tryParse(addr.longitude) ?? 0;
      final dist = Geolocator.distanceBetween(
        _currentPosition!.latitude,
        _currentPosition!.longitude,
        lat,
        lng,
      );
      if (dist < minDist) {
        minDist = dist;
        nearest = addr;
      }
    }
    context.read<BookingCubit>().selectHomeAddress(nearest);
  }

  Future<void> _openCreateAddress() async {
    try {
      final pos =
          _currentPosition ?? await getIt<GeoDevice>().getCurrentPosition();
      if (!mounted) return;
      context.push(
        '/${ProfilePage.routeName}/${AddressesPage.routeName}/${CreateAddressWidget.routeName}',
        extra: pos,
      );
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeBloc, HomeState>(
      listener: (context, state) {
        if (state is GetUserAddressesLoaded) {
          _autoSelectNearest(state.addresses);
        }
      },
      builder: (context, state) {
        if (state is HomeIsLoading) {
          return const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Center(
                child: CircularProgressIndicator(color: primaryColorTheme)),
          );
        }

        final addresses = state is GetUserAddressesLoaded
            ? state.addresses
            : <AddressModel>[];

        if (addresses.isEmpty) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: greyBlockColorTheme.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: greyBlockColorTheme),
              ),
              child: Column(
                children: [
                  const Icon(Icons.home_outlined,
                      color: grayTextColorTheme, size: 32),
                  const SizedBox(height: 8),
                  const Text('No tienes direcciones guardadas',
                      style: TextStyle(color: grayTextColorTheme)),
                  const SizedBox(height: 12),
                  TextButton.icon(
                    onPressed: _openCreateAddress,
                    icon: const Icon(Icons.add_circle_outline,
                        color: primaryColorTheme),
                    label: const Text('Agregar dirección',
                        style: TextStyle(color: primaryColorTheme)),
                  ),
                ],
              ),
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Mi dirección',
                    style: TextStyle(fontSize: 14, color: grayTextColorTheme),
                  ),
                  if (addresses.length >= 3)
                    const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.info_outline_rounded,
                            color: grayTextColorTheme, size: 14),
                        SizedBox(width: 4),
                        Text(
                          'Máx. 3 direcciones',
                          style: TextStyle(
                              color: grayTextColorTheme, fontSize: 12),
                        ),
                      ],
                    )
                  else
                    TextButton.icon(
                      onPressed: _openCreateAddress,
                      icon: const Icon(Icons.add,
                          color: primaryColorTheme, size: 16),
                      label: const Text('Nueva',
                          style: TextStyle(
                              color: primaryColorTheme, fontSize: 13)),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 6),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: addresses.map((addr) {
                  final isSelected = widget.selectedAddress?.id == addr.id;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () =>
                          context.read<BookingCubit>().selectHomeAddress(addr),
                      child: Container(
                        width: 180,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? primaryColorTheme.withValues(alpha: 0.08)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: isSelected
                                ? primaryColorTheme
                                : greyBlockColorTheme,
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.home_outlined,
                              color: isSelected
                                  ? primaryColorTheme
                                  : grayTextColorTheme,
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                addr.address,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: isSelected
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                                  color: isSelected
                                      ? primaryColorTheme
                                      : Colors.black87,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        );
      },
    );
  }
}
