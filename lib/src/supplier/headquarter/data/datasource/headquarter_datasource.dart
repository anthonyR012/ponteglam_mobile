import 'package:ponte_glam/src/supplier/headquarter/domain/model/headquarter_form_model.dart';

abstract class SupplierHeadquarterDatasource {
  Future<void> deleteHeadquarter({
    required String authToken,
    required int headquarterId,
  });

  Future<void> updateHeadquarter({
    required String authToken,
    required int headquarterId,
    required HeadquarterFormModel form,
  });

  Future<Map<String, String>> getWeekConfiguration({
    required String authToken,
    required int headquarterId,
  });
}
