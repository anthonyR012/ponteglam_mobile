import 'package:ponte_glam/src/supplier/service/domain/model/service_creation_form_model.dart';

abstract class ServiceCreationState {
  final ServiceCreationFormModel form;
  const ServiceCreationState(this.form);
}

class ServiceCreationInitial extends ServiceCreationState {
  const ServiceCreationInitial(super.form);
}

class ServiceCreationLoading extends ServiceCreationState {
  const ServiceCreationLoading(super.form);
}

class ServiceCreationSuccess extends ServiceCreationState {
  final int serviceId;
  const ServiceCreationSuccess(super.form, this.serviceId);
}

class ServiceCreationError extends ServiceCreationState {
  final String message;
  const ServiceCreationError(super.form, this.message);
}

class ServiceDeletionSuccess extends ServiceCreationState {
  const ServiceDeletionSuccess(super.form);
}
