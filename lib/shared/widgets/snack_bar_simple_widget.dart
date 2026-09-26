import 'package:flutter/material.dart';
import 'package:ponte_glam/config/constant/enum_constant.dart';
import 'package:ponte_glam/config/theme/theme.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ponte_glam/shared/blocs/cubit_alert_manage/alert_manage_cubit.dart';

class PonteSnackBar {
  static void show(
    BuildContext context, {
    required String message,
    String? title,
    TypeAlert type = TypeAlert.success,
  }) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 4),
        content: SnackBarContentWidget(
          title: title,
          message: message,
          type: type,
        ),
      ),
    );
  }
}

class SnackBarContentWidget extends StatelessWidget {
  final String? title;
  final String message;
  final TypeAlert type;
  final Color? textColor;

  const SnackBarContentWidget({
    super.key,
    this.title,
    required this.message,
    required this.type,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final Color color = _getColor();
    final IconData icon = _getIcon();
    final String displayTitle = title ?? _getDefaultTitle();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: appBarColorTheme.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  displayTitle,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  message,
                  style: TextStyle(
                    color: textColor ?? Colors.white.withValues(alpha: 0.8),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getColor() {
    switch (type) {
      case TypeAlert.success:
        return successColorTheme;
      case TypeAlert.error:
        return cancelColorTheme;
      case TypeAlert.warning:
        return Colors.amber;
      case TypeAlert.info:
      case TypeAlert.notification:
        return secondaryColorTheme;
    }
  }

  IconData _getIcon() {
    switch (type) {
      case TypeAlert.success:
        return Icons.check_circle;
      case TypeAlert.error:
        return Icons.cancel;
      case TypeAlert.warning:
        return Icons.warning_rounded;
      case TypeAlert.info:
      case TypeAlert.notification:
        return Icons.info_rounded;
    }
  }

  String _getDefaultTitle() {
    switch (type) {
      case TypeAlert.success:
        return '¡Éxito!';
      case TypeAlert.error:
        return 'Error';
      case TypeAlert.warning:
        return 'Atención';
      case TypeAlert.info:
      case TypeAlert.notification:
        return 'Información';
    }
  }
}

class SnackBarWidget extends StatelessWidget {
  const SnackBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final parameter = context.read<AlertManageCubit>().snackParamaters;
    return Positioned(
      bottom: 20,
      left: 20,
      right: 20,
      child: Material(
        color: Colors.transparent,
        child: SnackBarContentWidget(
          message: parameter.message,
          type: parameter.typeAlert,
          textColor: parameter.textColor,
        ),
      ),
    );
  }
}

class ParameterSnackBarCustom {
  final String message;
  final TypeAlert typeAlert;
  final Color? textColor;

  const ParameterSnackBarCustom({
    this.message = '',
    this.typeAlert = TypeAlert.info,
    this.textColor,
  });
}


