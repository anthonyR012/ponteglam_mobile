import 'package:ponte_glam/src/supplier/service/domain/model/service_creation_form_model.dart';

abstract class ServiceCreationDatasource {
  Future<int> createService({
    required String authToken,
    required ServiceCreationFormModel form,
    required int headquarterId,
  });

  Future<int> updateService({
    required String authToken,
    required int serviceId,
    required ServiceCreationFormModel form,
    required int headquarterId,
  });

  Future<void> deleteService({
    required String authToken,
    required int serviceId,
  });
}
