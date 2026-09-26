import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ponte_glam/shared/widgets/button_main_widget.dart';
import 'package:ponte_glam/shared/widgets/modern_form_elements.dart';
import 'package:ponte_glam/config/theme/theme.dart';
import 'package:ponte_glam/src/supplier/headquarter/domain/model/headquarter_form_model.dart';
import 'package:ponte_glam/src/supplier/headquarter/ui/cubit/headquarter_creation_cubit.dart';

class SupplierStepTimeConfig extends StatefulWidget {
  final HeadquarterFormModel form;
  const SupplierStepTimeConfig({super.key, required this.form});

  @override
  State<SupplierStepTimeConfig> createState() => _SupplierStepTimeConfigState();
}

class _SupplierStepTimeConfigState extends State<SupplierStepTimeConfig> {
  final List<String> _days = [
    'monday',
    'tuesday',
    'wednesday',
    'thursday',
    'friday',
    'saturday',
    'sunday',
  ];

  final Map<String, String> _dayNames = {
    'monday': 'Lunes',
    'tuesday': 'Martes',
    'wednesday': 'Miércoles',
    'thursday': 'Jueves',
    'friday': 'Viernes',
    'saturday': 'Sábado',
    'sunday': 'Domingo',
  };

  late Map<String, bool> _enabledDays;
  late Map<String, List<Map<String, String>>> _dayRanges;

  @override
  void initState() {
    super.initState();
    _applyWorkHours(widget.form.workHours);
  }

  @override
  void didUpdateWidget(covariant SupplierStepTimeConfig oldWidget) {
    super.didUpdateWidget(oldWidget);
    final oldHours = oldWidget.form.workHours;
    final newHours = widget.form.workHours;
    if (oldHours.isEmpty && newHours.isNotEmpty) {
      setState(() => _applyWorkHours(newHours));
    }
  }

  void _applyWorkHours(Map<String, String> workHours) {
    _enabledDays = {
      for (var d in _days) d: workHours.containsKey(d),
    };
    _dayRanges = {};
    for (var d in _days) {
      if (workHours.containsKey(d)) {
        final hoursStr = workHours[d]!;
        final rangeStrs = hoursStr.split(';');
        _dayRanges[d] = rangeStrs.map((rs) {
          final parts = rs.split('-');
          return {
            'start': parts.isNotEmpty ? parts[0] : '08:00:00',
            'end': parts.length > 1 ? parts[1] : '18:00:00',
          };
        }).toList();
      } else {
        _dayRanges[d] = [
          {'start': '08:00:00', 'end': '18:00:00'},
        ];
      }
    }
  }

  int _timeToMinutes(String time) {
    final parts = time.split(':');
    return int.parse(parts[0]) * 60 + int.parse(parts[1]);
  }

  String? _getRangeError(Map<String, String> range) {
    if (_timeToMinutes(range['start']!) >= _timeToMinutes(range['end']!)) {
      return 'La hora de inicio debe ser anterior al cierre.';
    }
    return null;
  }

  String? _getOverlapError(List<Map<String, String>> ranges) {
    if (ranges.length < 2) return null;
    if (ranges[0]['start'] == ranges[1]['start'] &&
        ranges[0]['end'] == ranges[1]['end']) {
      return 'No puedes agregar la misma franja dos veces.';
    }
    final sorted = List<Map<String, String>>.from(ranges)
      ..sort((a, b) => a['start']!.compareTo(b['start']!));
    if (_timeToMinutes(sorted[0]['end']!) >
        _timeToMinutes(sorted[1]['start']!)) {
      return 'Las franjas se solapan. Ajusta los horarios.';
    }
    return null;
  }

  bool _hasErrors() {
    for (var day in _days) {
      if (!_enabledDays[day]!) continue;
      final ranges = _dayRanges[day]!;
      for (var range in ranges) {
        if (_getRangeError(range) != null) return true;
      }
      if (_getOverlapError(ranges) != null) return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ModernSectionHeader(title: 'Horarios de Trabajo'),
          const SizedBox(height: 15),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: primaryColorTheme.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: primaryColorTheme.withValues(alpha: 0.1)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    Icon(Icons.lightbulb_outline_rounded,
                        color: primaryColorTheme, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Tip: Horarios Divididos',
                      style: TextStyle(
                        color: primaryColorTheme,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'Si cierras al mediodía, puedes crear dos franjas horarias en un mismo día.',
                  style: TextStyle(
                    color: secondaryColorTheme,
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'Ej: 08:00 - 12:00 / 02:00 - 06:00',
                    style: TextStyle(
                      color: grayTextColorTheme,
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          ModernFormCard(
            children: _days.map((day) {
              final ranges = _dayRanges[day]!;
              final rangeErrors =
                  ranges.map((r) => _getRangeError(r)).toList();
              final overlapError = _getOverlapError(ranges);
              return _DayTimeRow(
                dayCode: day,
                dayName: _dayNames[day]!,
                isEnabled: _enabledDays[day]!,
                ranges: ranges,
                rangeErrors: rangeErrors,
                overlapError: overlapError,
                onToggle: (val) {
                  setState(() => _enabledDays[day] = val);
                  _updateForm();
                },
                onStartTimePick: (i) => _selectTime(day, i, true),
                onEndTimePick: (i) => _selectTime(day, i, false),
                onAddRange: () => _addRange(day),
                onDeleteRange: (i) => _deleteRange(day, i),
              );
            }).toList(),
          ),
          const SizedBox(height: 30),
          ButtonMain(
            width: double.infinity,
            textButton: 'Finalizar y Crear',
            onPressed: _onSubmit,
          ),
        ],
      ),
    );
  }

  Future<void> _selectTime(
      String day, int rangeIndex, bool isStart) async {
    final range = _dayRanges[day]![rangeIndex];
    final timeStr = isStart ? range['start']! : range['end']!;
    final initialTime = TimeOfDay(
      hour: int.parse(timeStr.split(':')[0]),
      minute: int.parse(timeStr.split(':')[1]),
    );

    final picked =
        await showTimePicker(context: context, initialTime: initialTime);
    if (picked != null) {
      final formatted =
          '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}:00';
      setState(() {
        final newRange = Map<String, String>.from(range);
        if (isStart) {
          newRange['start'] = formatted;
        } else {
          newRange['end'] = formatted;
        }
        _dayRanges[day]![rangeIndex] = newRange;
      });
      _updateForm();
    }
  }

  void _addRange(String day) {
    if ((_dayRanges[day]?.length ?? 0) >= 2) return;
    setState(() {
      _dayRanges[day]!.add({'start': '08:00:00', 'end': '18:00:00'});
    });
    _updateForm();
  }

  void _deleteRange(String day, int rangeIndex) {
    if ((_dayRanges[day]?.length ?? 0) <= 1) return;
    setState(() {
      _dayRanges[day]!.removeAt(rangeIndex);
    });
    _updateForm();
  }

  void _updateForm() {
    final Map<String, String> workHours = {};
    for (var day in _days) {
      if (_enabledDays[day]!) {
        final ranges = List<Map<String, String>>.from(_dayRanges[day]!)
          ..sort((a, b) => a['start']!.compareTo(b['start']!));
        if (ranges.length == 1) {
          workHours[day] = '${ranges[0]['start']}-${ranges[0]['end']}';
        } else {
          workHours[day] =
              '${ranges[0]['start']}-${ranges[0]['end']};${ranges[1]['start']}-${ranges[1]['end']}';
        }
      }
    }
    context
        .read<HeadquarterCreationCubit>()
        .updateForm(widget.form.copyWith(workHours: workHours));
  }

  void _onSubmit() {
    final hasEnabledDay = _days.any((d) => _enabledDays[d]!);
    if (!hasEnabledDay) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Debes configurar al menos un día de trabajo.'),
          backgroundColor: cancelColorTheme,
        ),
      );
      return;
    }
    if (_hasErrors()) {
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text('Corrige los errores de horario antes de continuar.'),
          backgroundColor: cancelColorTheme,
        ),
      );
      return;
    }
    context.read<HeadquarterCreationCubit>().createTimeConfig();
  }
}

class _DayTimeRow extends StatelessWidget {
  final String dayCode;
  final String dayName;
  final bool isEnabled;
  final List<Map<String, String>> ranges;
  final Function(bool) onToggle;
  final Function(int) onStartTimePick;
  final Function(int) onEndTimePick;
  final VoidCallback onAddRange;
  final Function(int) onDeleteRange;
  final List<String?> rangeErrors;
  final String? overlapError;

  const _DayTimeRow({
    required this.dayCode,
    required this.dayName,
    required this.isEnabled,
    required this.ranges,
    required this.onToggle,
    required this.onStartTimePick,
    required this.onEndTimePick,
    required this.onAddRange,
    required this.onDeleteRange,
    required this.rangeErrors,
    this.overlapError,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Checkbox(
                value: isEnabled,
                onChanged: (val) => onToggle(val ?? false),
                activeColor: secondaryColorTheme,
              ),
              SizedBox(
                width: 80,
                child: Text(dayName,
                    style: const TextStyle(color: secondaryColorTheme)),
              ),
              if (!isEnabled)
                const Padding(
                  padding: EdgeInsets.only(left: 8),
                  child: Text('Cerrado',
                      style: TextStyle(color: grayTextColorTheme)),
                ),
            ],
          ),
          if (isEnabled) ...[
            ...List.generate(ranges.length, (i) {
              final range = ranges[i];
              final error =
                  i < rangeErrors.length ? rangeErrors[i] : null;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const SizedBox(width: 40),
                      TextButton(
                        onPressed: () => onStartTimePick(i),
                        child: Text(
                          range['start']!.substring(0, 5),
                          style: const TextStyle(color: primaryColorTheme),
                        ),
                      ),
                      const Text('-',
                          style: TextStyle(color: secondaryColorTheme)),
                      TextButton(
                        onPressed: () => onEndTimePick(i),
                        child: Text(
                          range['end']!.substring(0, 5),
                          style: const TextStyle(color: primaryColorTheme),
                        ),
                      ),
                      if (ranges.length > 1)
                        IconButton(
                          onPressed: () => onDeleteRange(i),
                          icon: const Icon(
                            Icons.delete_outline_rounded,
                            color: cancelColorTheme,
                            size: 20,
                          ),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                    ],
                  ),
                  if (error != null)
                    Padding(
                      padding: const EdgeInsets.only(left: 40, bottom: 4),
                      child: Text(
                        error,
                        style: const TextStyle(
                            color: cancelColorTheme, fontSize: 11),
                      ),
                    ),
                ],
              );
            }),
            if (overlapError != null)
              Padding(
                padding: const EdgeInsets.only(left: 40, bottom: 4),
                child: Text(
                  overlapError!,
                  style: const TextStyle(
                      color: cancelColorTheme, fontSize: 11),
                ),
              ),
            if (ranges.length < 2)
              Padding(
                padding: const EdgeInsets.only(left: 32),
                child: TextButton.icon(
                  onPressed: onAddRange,
                  icon: const Icon(
                    Icons.add_circle_outline,
                    size: 16,
                    color: secondaryColorTheme,
                  ),
                  label: const Text(
                    'Agregar franja',
                    style: TextStyle(
                        color: secondaryColorTheme, fontSize: 12),
                  ),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
              ),
          ],
        ],
      ),
    );
  }
}
