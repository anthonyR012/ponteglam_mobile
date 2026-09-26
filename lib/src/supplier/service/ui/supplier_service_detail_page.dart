import 'package:flutter/material.dart';
import 'package:ponte_glam/di/shared_imports.dart';
import 'package:ponte_glam/shared/model/headquarter_model.dart';
import 'package:ponte_glam/shared/model/service_model.dart';
import 'package:ponte_glam/src/supplier/service/ui/cubit/confirm_cash_payment_cubit.dart';
import 'package:ponte_glam/src/supplier/service/ui/cubit/supplier_service_appointments_cubit.dart';
import 'package:ponte_glam/src/supplier/service/ui/cubit/service_creation_cubit.dart';
import 'package:ponte_glam/src/supplier/service/ui/responsive/small_supplier_service_page.dart';

class SupplierServiceDetailPage extends StatelessWidget {
  const SupplierServiceDetailPage({
    required this.headquarter,
    required this.service,
    super.key,
  });

  final HeadquarterModel headquarter;
  final ServiceModel service;
  static const String routeName = 'SupplierServiceDetailPage';

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double width = size.width;
    final double height = size.height;
    return MultiBlocProvider(
      providers: [
        BlocProvider<SupplierServiceAppointmentsCubit>(
          create: (_) => getIt<SupplierServiceAppointmentsCubit>(),
        ),
        BlocProvider<ConfirmCashPaymentCubit>(
          create: (_) => getIt<ConfirmCashPaymentCubit>(),
        ),
        BlocProvider<ServiceCreationCubit>(
          create: (_) => getIt<ServiceCreationCubit>(),
        ),
      ],
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SmallSupplierServicePage(
            width: width,
            height: height,
            headquarter: headquarter,
            service: service,
          );
        },
      ),
    );
  }
}
