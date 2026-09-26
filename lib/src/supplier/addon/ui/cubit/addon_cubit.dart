import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ponte_glam/src/supplier/addon/domain/use_case/do_create_addon.dart';
import 'package:ponte_glam/src/supplier/addon/domain/use_case/do_delete_addon.dart';
import 'package:ponte_glam/src/supplier/addon/domain/use_case/do_update_addon.dart';
import 'package:ponte_glam/src/supplier/addon/domain/use_case/do_get_service_addons.dart';
import 'package:ponte_glam/src/supplier/addon/domain/use_case/do_link_addon.dart';
import 'package:ponte_glam/src/supplier/addon/domain/use_case/do_unlink_addon.dart';
import 'package:ponte_glam/src/supplier/addon/ui/cubit/addon_state.dart';

class AddonCubit extends Cubit<AddonState> {
  final DoGetServiceAddons doGetServiceAddons;
  final DoCreateAddon doCreateAddon;
  final DoLinkAddon doLinkAddon;
  final DoUnlinkAddon doUnlinkAddon;
  final DoUpdateAddon doUpdateAddon;
  final DoDeleteAddon doDeleteAddon;

  AddonCubit({
    required this.doGetServiceAddons,
    required this.doCreateAddon,
    required this.doLinkAddon,
    required this.doUnlinkAddon,
    required this.doUpdateAddon,
    required this.doDeleteAddon,
  }) : super(AddonInitial());

  Future<void> loadAddons(int serviceId) async {
    emit(AddonLoading());
    final result = await doGetServiceAddons(serviceId);
    result.fold(
      (failure) => emit(AddonError(failure)),
      (data) {
        emit(AddonLoaded(data['linked'] ?? [], data['available'] ?? []));
      },
    );
  }

  Future<void> createAddon({
    required String name,
    String? description,
    required double price,
    required int durationMinutes,
    required int serviceId,
  }) async {
    emit(AddonLoading());
    final result = await doCreateAddon(
      name: name,
      description: description,
      price: price,
      durationMinutes: durationMinutes,
    );

    result.fold(
      (failure) => emit(AddonError(failure)),
      (addon) async {
        if (serviceId == 0) {
          loadAddons(0);
        } else {
          // Link automatically
          final linkResult = await doLinkAddon(
            addonId: addon.id,
            serviceId: serviceId,
          );
          
          linkResult.fold(
            (failure) => emit(AddonError(failure)),
            (_) => loadAddons(serviceId),
          );
        }
      },
    );
  }

  Future<void> updateAddon({
    required int addonId,
    required String name,
    String? description,
    required double price,
    required int durationMinutes,
    required int serviceId,
  }) async {
    emit(AddonLoading());
    final result = await doUpdateAddon(
      addonId: addonId,
      name: name,
      description: description,
      price: price,
      durationMinutes: durationMinutes,
    );

    result.fold(
      (failure) => emit(AddonError(failure)),
      (_) => loadAddons(serviceId),
    );
  }

  Future<void> deleteAddon(int addonId, int serviceId) async {
    emit(AddonLoading());
    final result = await doDeleteAddon(addonId);
    result.fold(
      (failure) => emit(AddonError(failure)),
      (_) => loadAddons(serviceId),
    );
  }

  Future<void> linkAddon(int addonId, int serviceId) async {
    emit(AddonLoading());
    final result = await doLinkAddon(addonId: addonId, serviceId: serviceId);
    result.fold(
      (failure) => emit(AddonError(failure)),
      (_) => loadAddons(serviceId),
    );
  }

  Future<void> unlinkAddon(int addonId, int serviceId) async {
    emit(AddonLoading());
    final result = await doUnlinkAddon(addonId: addonId, serviceId: serviceId);
    result.fold(
      (failure) => emit(AddonError(failure)),
      (_) => loadAddons(serviceId),
    );
  }
}
