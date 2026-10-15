// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get app_title => 'PonteGlam';

  @override
  String get recoverPassword => 'Recover password';

  @override
  String titleHi(Object user) {
    return 'Hi $user';
  }

  @override
  String get titleTypes => 'Types';

  @override
  String get titleCategories => 'Categories';

  @override
  String get titleNotIdentified => 'Not Identified';

  @override
  String get titleSeeMore => 'See More';

  @override
  String get titleEnable => 'Enable';

  @override
  String get titleMin => 'min';

  @override
  String get titleMinutes => 'minutes';

  @override
  String get titleHr => 'hr';

  @override
  String get titleHours => 'hours';

  @override
  String get titleReviews => 'Reviews';

  @override
  String get titleProfile => 'Profile';

  @override
  String get titleNotification => 'Notification';

  @override
  String get titleWork => 'Work';

  @override
  String get titleHistory => 'History';

  @override
  String get titleHelp => 'Help';

  @override
  String get titleReport => 'Report';

  @override
  String get titleAboutUs => 'About Us';

  @override
  String get titleLogout => 'Logout';

  @override
  String get titleKilometerPreffix => 'Kilometers';

  @override
  String get titleKilometerPreffixAcronym => 'km';

  @override
  String get titleMeterPreffix => 'Meters';

  @override
  String get titleMeterPreffixAcronym => 'm';

  @override
  String get titleSignIn => 'Sign In';

  @override
  String get titleSendCodeAgain => 'Resend Code';

  @override
  String get titleRecover => 'Recover';

  @override
  String get titleSend => 'Send';

  @override
  String get titleSignUp => 'Sign Up';

  @override
  String get titleNext => 'Next';

  @override
  String get titleStart => 'Start';

  @override
  String get titleLetUsKnowYou => 'Let Us Know You!';

  @override
  String get titleWelcome => 'Welcome!';

  @override
  String get titleRequiredPhone => 'Let us know your number';

  @override
  String get titleKnown => 'Known';

  @override
  String get titleTry => 'Try';

  @override
  String get titleChange => 'Change';

  @override
  String get titleSkip => 'Skip';

  @override
  String get titleOk => 'OK';

  @override
  String get titleCheck => 'Check';

  @override
  String get titleReserveNow => 'Reserve Now';

  @override
  String get titleAmenities => 'Amenities';

  @override
  String get titleKeyCaracteristics => 'Key Characteristics';

  @override
  String get titleAppointments => 'Appointments';

  @override
  String get titleRelax => 'Relax';

  @override
  String get titleServices => 'Services';

  @override
  String get titleRetry => 'Retry';

  @override
  String get inputEmail => 'Email';

  @override
  String get inputPassword => 'Password';

  @override
  String get inputVerifyPassword => 'Verify Your Password';

  @override
  String get inputName => 'Name';

  @override
  String get inputAddress => 'Address';

  @override
  String get inputIndicative => 'Indicative';

  @override
  String get inputPhone => 'Phone';

  @override
  String get inputCountry => 'Country';

  @override
  String get inputCity => 'City';

  @override
  String get inputKindOfPlace => 'Type of Place';

  @override
  String get inputGender => 'Gender';

  @override
  String get inputBirthday => 'Birthday';

  @override
  String get inputSearchCountry => 'Search Country...';

  @override
  String get inputSearchCity => 'Search City...';

  @override
  String get inputSearchServices => 'Search Services...';

  @override
  String get inputGeographicPoint => 'Geographic point';

  @override
  String get questionHaveAccount => 'Don\'\'t have an account?';

  @override
  String get questionForgotPassword => 'Forgot your password?';

  @override
  String get questionAlreadyRegistered => 'Already registered?';

  @override
  String get questionWhoAreWe => 'Who are we?';

  @override
  String get questionSendCodeAgain => 'Send code again?';

  @override
  String get questionWhyRequired => 'Why required?';

  @override
  String get questionTryWithOther => 'Register with another email?';

  @override
  String get sentenceToProtectInformation => 'We protect your information';

  @override
  String get sentenceRequestInternet =>
      'Please check your internet connection.';

  @override
  String get sentenceOrSignIn => 'or sign in with';

  @override
  String get sentenceConfirmYourEmail =>
      'Confirm your email, we have sent a code to ';

  @override
  String get sentenceDigitNewPassword => 'Enter your new password';

  @override
  String get sentenceDigitCodeSended => 'Enter the verification code.';

  @override
  String get sentenceChoosePlace => 'Select place';

  @override
  String get sentenceSetUpLocation =>
      'To provide better service, enable location.';

  @override
  String get sentenceGettingSplash =>
      'Get ready to access amazing places and book them from the comfort of your home.';

  @override
  String get sentenceGettingRelax =>
      'We make it easy to access a wide range of spa and beauty services.';

  @override
  String get sentenceGettingKeyCaracteristics =>
      '🔑- Explore a wide range of services \n🔑- Simple and secure booking process. \n🔑- Custom profiles for a personalized experience.';

  @override
  String get sentenceGettingAppoinment =>
      '✨ Easy booking in three steps: \n1. Choose: select the service you want and the preferred provider. \n2. Reserve: choose a convenient time and confirm your reservation. \n3. Payment: choose a payment method and confirm your reservation.';

  @override
  String get subtitleGettingWelcome => '🌟 Get ready to book! 🌟';

  @override
  String get successCreateAddress => 'Address added';

  @override
  String get failureWentWrong => 'Something went wrong';

  @override
  String failureMissingArgument(Object argument) {
    return 'Missing argument $argument';
  }

  @override
  String get failureCannotSave => 'Failed to save the information';

  @override
  String get failureEmptyField => 'This field cannot be empty';

  @override
  String get failureInvalidFormatInputEmail => 'Please enter a valid email';

  @override
  String get failureInvalidFormatInputAddress => 'Please enter a valid address';

  @override
  String get failureInvalidFormatInputPassword => 'Check the password';

  @override
  String failureInvalidNumberChar(Object count) {
    return 'The minimum number of characters is: $count';
  }

  @override
  String get failureServerUndetected => 'There was an error with the service';

  @override
  String get failureImageNoSelected => 'No image selected';

  @override
  String get failureMatchPassword => 'Passwords do not match';

  @override
  String get failureConnectivity => 'No internet connection';

  @override
  String failureInsufficientPermission(Object permission) {
    return 'Manually enable permissions for $permission';
  }

  @override
  String failureNoFound(Object item) {
    return 'No $item found';
  }

  @override
  String failureUpdateInformation(Object item) {
    return 'Could not update the field $item';
  }

  @override
  String get failureUnavailable => 'Not available';

  @override
  String get failureIncompleAddress => 'Address incomplete. Please update';

  @override
  String get titleLocation => 'Location';

  @override
  String get titleStoreFeature => 'Store feature';

  @override
  String get titlePrice => 'Price';

  @override
  String get titleAvailableTime => 'Available time';

  @override
  String get titleFrom => 'From';

  @override
  String titleFilterByItem(Object item) {
    return 'Filter by $item...';
  }

  @override
  String get titleOverThan => 'Over than';

  @override
  String get titleServiceFor => 'Service for';

  @override
  String get titleOffers => 'Offers';

  @override
  String get titleVerified => 'Verified';

  @override
  String get titleNearsts => 'Nearest';

  @override
  String get titleOnlyHomeService => 'Only home service';

  @override
  String titleRangePrice(Object minPrice, Object maxPrice) {
    return 'Range $minPrice - $maxPrice';
  }

  @override
  String get titleFilter => 'Filter';

  @override
  String get titleApply => 'Apply';

  @override
  String get titleReset => 'Reset';

  @override
  String get titleAnyTime => 'Any time';

  @override
  String get titleAnyRating => 'Any rating';

  @override
  String get titleAnyPrice => 'Any price';

  @override
  String titleMoreThan(Object minPrice) {
    return 'More than $minPrice';
  }

  @override
  String get titleBonus => 'My bonus';

  @override
  String get titlePersonalInformation => 'Personal information';

  @override
  String get titleAddresses => 'Addresses';

  @override
  String get titlePrivacy => 'Privacy';

  @override
  String get titleCards => 'Cards';

  @override
  String get titleDateOfBirth => 'Date of Birth';

  @override
  String get titleNoCoincidences => 'No coincidences';

  @override
  String get inputTypeMessage => 'Type your message...';

  @override
  String get titleAddressType => 'Address type';

  @override
  String get titleVirtualSupport => 'My virtual Support';

  @override
  String get titleToday => 'Today';

  @override
  String get titleYesterday => 'Yesterday';

  @override
  String get titleRecentAddresses => 'Recent Addresses';

  @override
  String get titleCurrentLocation => 'Current Location';

  @override
  String titleWhoIam(Object user) {
    return 'Hi, I am $user';
  }

  @override
  String get titleCreateAddress => 'Create addresss';

  @override
  String get titleUpdateAddress => 'Update addresss';

  @override
  String get titleAppointment => 'Appointment';

  @override
  String get titleCalendar => 'My Bookings';

  @override
  String get titleTermsAndConditions => 'Terms and Conditions';

  @override
  String get titleTermsAndConditionsTitle => 'Terms and Conditions of Use';

  @override
  String get titlePrivacyPolicy => 'Privacy Policy';

  @override
  String get sentenceAcceptTerms => 'I accept the';

  @override
  String get sentenceAcceptPrivacy =>
      'I authorize the processing of my personal data in accordance with the';

  @override
  String get sentencePrivacyLink => 'Privacy Policy';

  @override
  String get sentencePrivacySuffix => 'of PonteGlam and Law 1581 of 2012';

  @override
  String get sentenceSignInWelcome => 'Welcome back';

  @override
  String get sentenceSignUpCreate => 'Create your account';

  @override
  String get failureTermsRequired =>
      'You must accept the Terms and Conditions to continue';

  @override
  String get failurePrivacyRequired =>
      'You must authorize data processing to continue';

  @override
  String get titleSignInWithGoogle => 'Sign in with Google';

  @override
  String get titleSignUpWithGoogle => 'Sign up with Google';

  @override
  String get sentenceAcceptTermsToContinue =>
      'Please accept the terms and conditions to continue';

  @override
  String get titleRatings => 'Ratings';

  @override
  String get titleViewRatings => 'View reviews';

  @override
  String get ratingEmpty => 'No reviews yet for this service.';

  @override
  String get ratingWriteTitle => 'Write your review';

  @override
  String get ratingComment => 'Comment (optional)';

  @override
  String get ratingSend => 'Send rating';

  @override
  String get ratingSuccess => 'Thank you for your rating!';

  @override
  String get titleReschedule => 'Reschedule appointment';

  @override
  String get titleRescheduleConfirm => 'Confirm reschedule';

  @override
  String get sentencePendingCashConfirmation =>
      'Your booking is pending confirmation.';

  @override
  String get sentenceBookingCashCreated =>
      'Booking created! Payment will be made in cash at the location.';

  @override
  String get sentenceBookingCardSuccess =>
      'Payment successful! Your appointment has been confirmed.';

  @override
  String get sentenceBookingCancelled => 'Payment cancelled';

  @override
  String get titleWallet => 'Wallet';

  @override
  String get titleAppointmentDetail => 'Appointment Detail';

  @override
  String get titleCancelAppointment => 'Cancel appointment';

  @override
  String get titleRescheduleAppointment => 'Reschedule';

  @override
  String get titleRateService => 'Rate Service';

  @override
  String get sentenceConfirmCancelAppointment =>
      'Are you sure you want to cancel this appointment?';

  @override
  String get inputCancelReason => 'Reason (optional)';

  @override
  String get titleNoCancelBack => 'No, go back';

  @override
  String get titleYesCancel => 'Yes, cancel';

  @override
  String get titleUpcoming => 'Upcoming';

  @override
  String get titleCompleted => 'Completed';

  @override
  String get titleCancelled => 'Cancelled';

  @override
  String get titleNoAppointmentsInCategory =>
      'No appointments in this category';

  @override
  String get sentenceRescheduleEndAfterStart =>
      'End time must be after start time';

  @override
  String get noNotificationsYet => 'You don\'t have any notifications yet';

  @override
  String get titleAddons => 'Addons';

  @override
  String get sentenceSaveServiceFirst =>
      'Save the service first to add addons.';

  @override
  String get titleLinkedAddons => 'Linked to this service';

  @override
  String get sentenceNoAddons => 'No addons';

  @override
  String get titleAvailableAddons => 'Your available addons';

  @override
  String get titleCreateNewAddon => 'Create new addon';

  @override
  String get titleCreateAndLink => 'Create and link';

  @override
  String get inputPriceFree => '0 = free';

  @override
  String get nequiSectionTitle => 'Nequi Payment Method';

  @override
  String get updateNequiButton => 'Update Nequi Number';

  @override
  String get otpNequiMessage =>
      'Enter the verification code sent to your email to confirm the Nequi change.';

  @override
  String get nequiLabel => 'Nequi Account Number';

  @override
  String get nequiNumberPlaceholder => 'Enter Nequi number (e.g. 3001234567)';

  @override
  String get invalidNequiNumber =>
      'Invalid Nequi number. Must be a valid phone number format.';

  @override
  String get verificationCodeLabel => 'Verification Code';
}
