class EndPoints {
  final String baseUrl = "http://192.168.1.15:8000";
  EndPoints();

  // Auth
  String get authTokenUrl => "$baseUrl/api-token-auth/";
  String get creatUserOauthUrl => "$baseUrl/users/api/register-oauth/";
  String get createUserAlternateUrl => "$baseUrl/users/api/register-alternate/";

  // Verification
  String get verifyEmailUrl => "$baseUrl/users/api/verify-email/";
  String get forwardVerifimationEmailUrl =>
      "$baseUrl/users/api/forward-verification-email/";

  // Recovery
  String get requestRecoveryUrl => "$baseUrl/users/api/request-recover-user/";
  String get verifyEmailRecoverUrl =>
      "$baseUrl/users/api/verify-email-recover-user/";
  String get requestCreatePasswordUrl =>
      "$baseUrl/users/api/request-create-password/";
  String get confirmCreatePasswordUrl =>
      "$baseUrl/users/api/confirm-create-password/";
  String get updateUserPasswordUrl => "$baseUrl/users/api/update-password/";

  // User profile
  String get updateUserInformationUrl =>
      "$baseUrl/users/api/update-information/";
  String get listAddressesUserUrl => "$baseUrl/users/api/list-user-address/";
  String get createUserAddressUrl => "$baseUrl/users/api/create-user-address/";
  String get updateUserAddressUrl => "$baseUrl/users/api/update-user-address/";
  String deleteUserAddressUrl(int id) =>
      "$baseUrl/users/api/delete-user-address/$id/";

  // Terms and conditions
  String get termsAndConditionsUrl =>
      "$baseUrl/users/api/terms-and-conditions/";

  // Core config
  String get listTypesUrl => "$baseUrl/core/api/list-types";
  String get listCountriesUrl => "$baseUrl/core/api/list-countries";
  String get listAmenitiesUrl => "$baseUrl/core/api/list-amenities";
  String get listCitiesUrl => "$baseUrl/core/api/list-cities/";
  String get listLegalContentUrl => "$baseUrl/core/api/list-legal-content/";
  String get createMobileAppLogUrl =>
      "$baseUrl/core/api/create-mobile-app-log/";

  // Services
  String get listServicesUrl => "$baseUrl/services/api/list-services/";
  String get listCategoriesServicesUrl =>
      "$baseUrl/services/api/list-categories-services/";
  String get createServiceUrl => "$baseUrl/services/api/create-service/";
  String get updateServiceUrl => "$baseUrl/services/api/update-service/";
  String deleteServiceUrl(int id) =>
      "$baseUrl/services/api/delete-service/$id/";

  // Addons
  String get listServiceAddonsUrl => "$baseUrl/addons/api/list-service-addons/";
  String get createServiceAddonUrl =>
      "$baseUrl/addons/api/create-service-addon/";
  String get linkAddonToServiceUrl =>
      "$baseUrl/addons/api/link-addon-to-service/";
  String get unlinkAddonFromServiceUrl =>
      "$baseUrl/addons/api/unlink-addon-from-service/";
  String updateServiceAddonUrl(int id) =>
      "$baseUrl/addons/api/update-service-addon/$id/";
  String deleteServiceAddonUrl(int id) =>
      "$baseUrl/addons/api/delete-service-addon/$id/";

  // Companies
  String get createCompanyUrl => "$baseUrl/companies/api/create-company/";
  String updateCompanyUrl(int id) =>
      "$baseUrl/companies/api/update-company/$id/";
  String deleteCompanyUrl(int id) =>
      "$baseUrl/companies/api/delete-company/$id/";
  String requestNequiUpdateUrl(int id) =>
      "$baseUrl/companies/api/nequi/$id/request-nequi-update/";
  String updateNequiUrl(int id) =>
      "$baseUrl/companies/api/nequi/$id/update-nequi/";

  // Headquarters
  String get createHeadquarterUrl =>
      "$baseUrl/headquarters/api/create-headquarter/";
  String get createHeadquarterWeekdayTimeConfigurationUrl =>
      "$baseUrl/headquarters/api/create-week-day-time-configuration/";
  String get likeHeadquarterUrl =>
      "$baseUrl/headquarters/api/headquarter-like/";
  String get dislikeHeadquarterUrl =>
      "$baseUrl/headquarters/api/headquarter-dislike/";
  String deleteHeadquarterUrl(int id) =>
      "$baseUrl/headquarters/api/delete-headquarter/$id/";
  String updateHeadquarterUrl(int id) =>
      "$baseUrl/headquarters/api/update-headquarter/$id/";
  String getWeekConfigurationHeadquarterUrl(int id) =>
      "$baseUrl/headquarters/api/get-week-configuration-headquarter/$id/";

  // Ratings
  String get createRatingHeadquarterServiceUrl =>
      "$baseUrl/ratings/api/create-rating-headquarter-service/";
  String get listRatingsHeadquarterServiceUrl =>
      "$baseUrl/ratings/api/list-ratings-headquarter-service/";
  String get replyRatingUrl => "$baseUrl/ratings/api/reply-rating/";

  // Workers
  String get listWorkersUrl => "$baseUrl/workers/api/list-workers/";
  String get listAvailableWorkersUrl =>
      "$baseUrl/workers/api/list-available-workers/";

  // Staff management
  String listStaffUrl(int headquarterId) =>
      "$baseUrl/workers/api/manage-staff/list-staff/$headquarterId/";
  String get onboardWorkerUrl => "$baseUrl/workers/api/manage-staff/onboard/";
  String linkWorkerServiceUrl(int workerId) =>
      "$baseUrl/workers/api/manage-staff/$workerId/link-service/";
  String unlinkWorkerServiceUrl(int workerId) =>
      "$baseUrl/workers/api/manage-staff/$workerId/unlink-service/";
  String addWorkerBlockUrl(int workerId) =>
      "$baseUrl/workers/api/manage-staff/$workerId/add-block/";
  String removeWorkerFromHqUrl(int workerId) =>
      "$baseUrl/workers/api/manage-staff/$workerId/remove-from-hq/";

  // Appointments
  String get createAppointmentUrl =>
      "$baseUrl/services/api/create-appointment/";
  String get listAppointmentsUrl => "$baseUrl/services/api/list-appointments/";
  String get supplierAppointmentsUrl =>
      "$baseUrl/services/api/supplier-appointments/";
  String get appointmentDetailUrl =>
      "$baseUrl/services/api/appointment-detail/";
  String get cancelAppointmentUrl =>
      "$baseUrl/services/api/cancel-appointment/";
  String get rescheduleAppointmentUrl =>
      "$baseUrl/services/api/reschedule-appointment/";
  String get confirmCashAppointmentUrl =>
      "$baseUrl/services/api/confirm-cash-appointment/";

  // Notifications
  String get listNotificationsUrl =>
      "$baseUrl/notifications/api/list-user-notifications/";
  String get unreadNotificationsCountUrl =>
      "$baseUrl/notifications/api/unread-count/";
  String get registerDeviceUrl => "$baseUrl/notifications/api/register-device/";

  // Wallet
  String get walletUrl => "$baseUrl/transactions/api/wallet/";

  // PQRS
  String get createPQRSUrl => "$baseUrl/pqrs/crear/";
}
