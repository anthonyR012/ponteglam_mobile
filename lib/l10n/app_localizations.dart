import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es')
  ];

  /// No description provided for @app_title.
  ///
  /// In en, this message translates to:
  /// **'PonteGlam'**
  String get app_title;

  /// No description provided for @recoverPassword.
  ///
  /// In en, this message translates to:
  /// **'Recover password'**
  String get recoverPassword;

  /// No description provided for @titleHi.
  ///
  /// In en, this message translates to:
  /// **'Hi {user}'**
  String titleHi(Object user);

  /// No description provided for @titleTypes.
  ///
  /// In en, this message translates to:
  /// **'Types'**
  String get titleTypes;

  /// No description provided for @titleCategories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get titleCategories;

  /// No description provided for @titleNotIdentified.
  ///
  /// In en, this message translates to:
  /// **'Not Identified'**
  String get titleNotIdentified;

  /// No description provided for @titleSeeMore.
  ///
  /// In en, this message translates to:
  /// **'See More'**
  String get titleSeeMore;

  /// No description provided for @titleEnable.
  ///
  /// In en, this message translates to:
  /// **'Enable'**
  String get titleEnable;

  /// No description provided for @titleMin.
  ///
  /// In en, this message translates to:
  /// **'min'**
  String get titleMin;

  /// No description provided for @titleMinutes.
  ///
  /// In en, this message translates to:
  /// **'minutes'**
  String get titleMinutes;

  /// No description provided for @titleHr.
  ///
  /// In en, this message translates to:
  /// **'hr'**
  String get titleHr;

  /// No description provided for @titleHours.
  ///
  /// In en, this message translates to:
  /// **'hours'**
  String get titleHours;

  /// No description provided for @titleReviews.
  ///
  /// In en, this message translates to:
  /// **'Reviews'**
  String get titleReviews;

  /// No description provided for @titleProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get titleProfile;

  /// No description provided for @titleNotification.
  ///
  /// In en, this message translates to:
  /// **'Notification'**
  String get titleNotification;

  /// No description provided for @titleWork.
  ///
  /// In en, this message translates to:
  /// **'Work'**
  String get titleWork;

  /// No description provided for @titleHistory.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get titleHistory;

  /// No description provided for @titleHelp.
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get titleHelp;

  /// No description provided for @titleReport.
  ///
  /// In en, this message translates to:
  /// **'Report'**
  String get titleReport;

  /// No description provided for @titleAboutUs.
  ///
  /// In en, this message translates to:
  /// **'About Us'**
  String get titleAboutUs;

  /// No description provided for @titleLogout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get titleLogout;

  /// No description provided for @titleKilometerPreffix.
  ///
  /// In en, this message translates to:
  /// **'Kilometers'**
  String get titleKilometerPreffix;

  /// No description provided for @titleKilometerPreffixAcronym.
  ///
  /// In en, this message translates to:
  /// **'km'**
  String get titleKilometerPreffixAcronym;

  /// No description provided for @titleMeterPreffix.
  ///
  /// In en, this message translates to:
  /// **'Meters'**
  String get titleMeterPreffix;

  /// No description provided for @titleMeterPreffixAcronym.
  ///
  /// In en, this message translates to:
  /// **'m'**
  String get titleMeterPreffixAcronym;

  /// No description provided for @titleSignIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get titleSignIn;

  /// No description provided for @titleSendCodeAgain.
  ///
  /// In en, this message translates to:
  /// **'Resend Code'**
  String get titleSendCodeAgain;

  /// No description provided for @titleRecover.
  ///
  /// In en, this message translates to:
  /// **'Recover'**
  String get titleRecover;

  /// No description provided for @titleSend.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get titleSend;

  /// No description provided for @titleSignUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get titleSignUp;

  /// No description provided for @titleNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get titleNext;

  /// No description provided for @titleStart.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get titleStart;

  /// No description provided for @titleLetUsKnowYou.
  ///
  /// In en, this message translates to:
  /// **'Let Us Know You!'**
  String get titleLetUsKnowYou;

  /// No description provided for @titleWelcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome!'**
  String get titleWelcome;

  /// No description provided for @titleRequiredPhone.
  ///
  /// In en, this message translates to:
  /// **'Let us know your number'**
  String get titleRequiredPhone;

  /// No description provided for @titleKnown.
  ///
  /// In en, this message translates to:
  /// **'Known'**
  String get titleKnown;

  /// No description provided for @titleTry.
  ///
  /// In en, this message translates to:
  /// **'Try'**
  String get titleTry;

  /// No description provided for @titleChange.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get titleChange;

  /// No description provided for @titleSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get titleSkip;

  /// No description provided for @titleOk.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get titleOk;

  /// No description provided for @titleCheck.
  ///
  /// In en, this message translates to:
  /// **'Check'**
  String get titleCheck;

  /// No description provided for @titleReserveNow.
  ///
  /// In en, this message translates to:
  /// **'Reserve Now'**
  String get titleReserveNow;

  /// No description provided for @titleAmenities.
  ///
  /// In en, this message translates to:
  /// **'Amenities'**
  String get titleAmenities;

  /// No description provided for @titleKeyCaracteristics.
  ///
  /// In en, this message translates to:
  /// **'Key Characteristics'**
  String get titleKeyCaracteristics;

  /// No description provided for @titleAppointments.
  ///
  /// In en, this message translates to:
  /// **'Appointments'**
  String get titleAppointments;

  /// No description provided for @titleRelax.
  ///
  /// In en, this message translates to:
  /// **'Relax'**
  String get titleRelax;

  /// No description provided for @titleServices.
  ///
  /// In en, this message translates to:
  /// **'Services'**
  String get titleServices;

  /// No description provided for @titleRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get titleRetry;

  /// No description provided for @inputEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get inputEmail;

  /// No description provided for @inputPassword.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get inputPassword;

  /// No description provided for @inputVerifyPassword.
  ///
  /// In en, this message translates to:
  /// **'Verify Your Password'**
  String get inputVerifyPassword;

  /// No description provided for @inputName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get inputName;

  /// No description provided for @inputAddress.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get inputAddress;

  /// No description provided for @inputIndicative.
  ///
  /// In en, this message translates to:
  /// **'Indicative'**
  String get inputIndicative;

  /// No description provided for @inputPhone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get inputPhone;

  /// No description provided for @inputCountry.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get inputCountry;

  /// No description provided for @inputCity.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get inputCity;

  /// No description provided for @inputKindOfPlace.
  ///
  /// In en, this message translates to:
  /// **'Type of Place'**
  String get inputKindOfPlace;

  /// No description provided for @inputGender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get inputGender;

  /// No description provided for @inputBirthday.
  ///
  /// In en, this message translates to:
  /// **'Birthday'**
  String get inputBirthday;

  /// No description provided for @inputSearchCountry.
  ///
  /// In en, this message translates to:
  /// **'Search Country...'**
  String get inputSearchCountry;

  /// No description provided for @inputSearchCity.
  ///
  /// In en, this message translates to:
  /// **'Search City...'**
  String get inputSearchCity;

  /// No description provided for @inputSearchServices.
  ///
  /// In en, this message translates to:
  /// **'Search Services...'**
  String get inputSearchServices;

  /// No description provided for @inputGeographicPoint.
  ///
  /// In en, this message translates to:
  /// **'Geographic point'**
  String get inputGeographicPoint;

  /// No description provided for @questionHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'\'t have an account?'**
  String get questionHaveAccount;

  /// No description provided for @questionForgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot your password?'**
  String get questionForgotPassword;

  /// No description provided for @questionAlreadyRegistered.
  ///
  /// In en, this message translates to:
  /// **'Already registered?'**
  String get questionAlreadyRegistered;

  /// No description provided for @questionWhoAreWe.
  ///
  /// In en, this message translates to:
  /// **'Who are we?'**
  String get questionWhoAreWe;

  /// No description provided for @questionSendCodeAgain.
  ///
  /// In en, this message translates to:
  /// **'Send code again?'**
  String get questionSendCodeAgain;

  /// No description provided for @questionWhyRequired.
  ///
  /// In en, this message translates to:
  /// **'Why required?'**
  String get questionWhyRequired;

  /// No description provided for @questionTryWithOther.
  ///
  /// In en, this message translates to:
  /// **'Register with another email?'**
  String get questionTryWithOther;

  /// No description provided for @sentenceToProtectInformation.
  ///
  /// In en, this message translates to:
  /// **'We protect your information'**
  String get sentenceToProtectInformation;

  /// No description provided for @sentenceRequestInternet.
  ///
  /// In en, this message translates to:
  /// **'Please check your internet connection.'**
  String get sentenceRequestInternet;

  /// No description provided for @sentenceOrSignIn.
  ///
  /// In en, this message translates to:
  /// **'or sign in with'**
  String get sentenceOrSignIn;

  /// No description provided for @sentenceConfirmYourEmail.
  ///
  /// In en, this message translates to:
  /// **'Confirm your email, we have sent a code to '**
  String get sentenceConfirmYourEmail;

  /// No description provided for @sentenceDigitNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter your new password'**
  String get sentenceDigitNewPassword;

  /// No description provided for @sentenceDigitCodeSended.
  ///
  /// In en, this message translates to:
  /// **'Enter the verification code.'**
  String get sentenceDigitCodeSended;

  /// No description provided for @sentenceChoosePlace.
  ///
  /// In en, this message translates to:
  /// **'Select place'**
  String get sentenceChoosePlace;

  /// No description provided for @sentenceSetUpLocation.
  ///
  /// In en, this message translates to:
  /// **'To provide better service, enable location.'**
  String get sentenceSetUpLocation;

  /// No description provided for @sentenceGettingSplash.
  ///
  /// In en, this message translates to:
  /// **'Get ready to access amazing places and book them from the comfort of your home.'**
  String get sentenceGettingSplash;

  /// No description provided for @sentenceGettingRelax.
  ///
  /// In en, this message translates to:
  /// **'We make it easy to access a wide range of spa and pet care services.'**
  String get sentenceGettingRelax;

  /// No description provided for @sentenceGettingKeyCaracteristics.
  ///
  /// In en, this message translates to:
  /// **'🔑- Explore a wide range of services \n🔑- Simple and secure booking process. \n🔑- Custom profiles for a personalized experience.'**
  String get sentenceGettingKeyCaracteristics;

  /// No description provided for @sentenceGettingAppoinment.
  ///
  /// In en, this message translates to:
  /// **'✨ Easy booking in three steps: \n1. Choose: select the service you want and the preferred provider. \n2. Reserve: choose a convenient time and confirm your reservation. \n3. Payment: choose a payment method and confirm your reservation.'**
  String get sentenceGettingAppoinment;

  /// No description provided for @subtitleGettingWelcome.
  ///
  /// In en, this message translates to:
  /// **'🌟 Get ready to book! 🌟'**
  String get subtitleGettingWelcome;

  /// No description provided for @successCreateAddress.
  ///
  /// In en, this message translates to:
  /// **'Address added'**
  String get successCreateAddress;

  /// No description provided for @failureWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get failureWentWrong;

  /// No description provided for @failureMissingArgument.
  ///
  /// In en, this message translates to:
  /// **'Missing argument {argument}'**
  String failureMissingArgument(Object argument);

  /// No description provided for @failureCannotSave.
  ///
  /// In en, this message translates to:
  /// **'Failed to save the information'**
  String get failureCannotSave;

  /// No description provided for @failureEmptyField.
  ///
  /// In en, this message translates to:
  /// **'This field cannot be empty'**
  String get failureEmptyField;

  /// No description provided for @failureInvalidFormatInputEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get failureInvalidFormatInputEmail;

  /// No description provided for @failureInvalidFormatInputAddress.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid address'**
  String get failureInvalidFormatInputAddress;

  /// No description provided for @failureInvalidFormatInputPassword.
  ///
  /// In en, this message translates to:
  /// **'Check the password'**
  String get failureInvalidFormatInputPassword;

  /// No description provided for @failureInvalidNumberChar.
  ///
  /// In en, this message translates to:
  /// **'The minimum number of characters is: {count}'**
  String failureInvalidNumberChar(Object count);

  /// No description provided for @failureServerUndetected.
  ///
  /// In en, this message translates to:
  /// **'There was an error with the service'**
  String get failureServerUndetected;

  /// No description provided for @failureImageNoSelected.
  ///
  /// In en, this message translates to:
  /// **'No image selected'**
  String get failureImageNoSelected;

  /// No description provided for @failureMatchPassword.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get failureMatchPassword;

  /// No description provided for @failureConnectivity.
  ///
  /// In en, this message translates to:
  /// **'No internet connection'**
  String get failureConnectivity;

  /// No description provided for @failureInsufficientPermission.
  ///
  /// In en, this message translates to:
  /// **'Manually enable permissions for {permission}'**
  String failureInsufficientPermission(Object permission);

  /// No description provided for @failureNoFound.
  ///
  /// In en, this message translates to:
  /// **'No {item} found'**
  String failureNoFound(Object item);

  /// No description provided for @failureUpdateInformation.
  ///
  /// In en, this message translates to:
  /// **'Could not update the field {item}'**
  String failureUpdateInformation(Object item);

  /// No description provided for @failureUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Not available'**
  String get failureUnavailable;

  /// No description provided for @failureIncompleAddress.
  ///
  /// In en, this message translates to:
  /// **'Address incomplete. Please update'**
  String get failureIncompleAddress;

  /// No description provided for @titleLocation.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get titleLocation;

  /// No description provided for @titleStoreFeature.
  ///
  /// In en, this message translates to:
  /// **'Store feature'**
  String get titleStoreFeature;

  /// No description provided for @titlePrice.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get titlePrice;

  /// No description provided for @titleAvailableTime.
  ///
  /// In en, this message translates to:
  /// **'Available time'**
  String get titleAvailableTime;

  /// No description provided for @titleFrom.
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get titleFrom;

  /// No description provided for @titleFilterByItem.
  ///
  /// In en, this message translates to:
  /// **'Filter by {item}...'**
  String titleFilterByItem(Object item);

  /// No description provided for @titleOverThan.
  ///
  /// In en, this message translates to:
  /// **'Over than'**
  String get titleOverThan;

  /// No description provided for @titleServiceFor.
  ///
  /// In en, this message translates to:
  /// **'Service for'**
  String get titleServiceFor;

  /// No description provided for @titleOffers.
  ///
  /// In en, this message translates to:
  /// **'Offers'**
  String get titleOffers;

  /// No description provided for @titleVerified.
  ///
  /// In en, this message translates to:
  /// **'Verified'**
  String get titleVerified;

  /// No description provided for @titleNearsts.
  ///
  /// In en, this message translates to:
  /// **'Nearest'**
  String get titleNearsts;

  /// No description provided for @titleOnlyHomeService.
  ///
  /// In en, this message translates to:
  /// **'Only home service'**
  String get titleOnlyHomeService;

  /// No description provided for @titleRangePrice.
  ///
  /// In en, this message translates to:
  /// **'Range {minPrice} - {maxPrice}'**
  String titleRangePrice(Object minPrice, Object maxPrice);

  /// No description provided for @titleFilter.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get titleFilter;

  /// No description provided for @titleApply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get titleApply;

  /// No description provided for @titleReset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get titleReset;

  /// No description provided for @titleAnyTime.
  ///
  /// In en, this message translates to:
  /// **'Any time'**
  String get titleAnyTime;

  /// No description provided for @titleAnyRating.
  ///
  /// In en, this message translates to:
  /// **'Any rating'**
  String get titleAnyRating;

  /// No description provided for @titleAnyPrice.
  ///
  /// In en, this message translates to:
  /// **'Any price'**
  String get titleAnyPrice;

  /// No description provided for @titleMoreThan.
  ///
  /// In en, this message translates to:
  /// **'More than {minPrice}'**
  String titleMoreThan(Object minPrice);

  /// No description provided for @titleBonus.
  ///
  /// In en, this message translates to:
  /// **'My bonus'**
  String get titleBonus;

  /// No description provided for @titlePersonalInformation.
  ///
  /// In en, this message translates to:
  /// **'Personal information'**
  String get titlePersonalInformation;

  /// No description provided for @titleAddresses.
  ///
  /// In en, this message translates to:
  /// **'Addresses'**
  String get titleAddresses;

  /// No description provided for @titlePrivacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get titlePrivacy;

  /// No description provided for @titleCards.
  ///
  /// In en, this message translates to:
  /// **'Cards'**
  String get titleCards;

  /// No description provided for @titleDateOfBirth.
  ///
  /// In en, this message translates to:
  /// **'Date of Birth'**
  String get titleDateOfBirth;

  /// No description provided for @titleNoCoincidences.
  ///
  /// In en, this message translates to:
  /// **'No coincidences'**
  String get titleNoCoincidences;

  /// No description provided for @inputTypeMessage.
  ///
  /// In en, this message translates to:
  /// **'Type your message...'**
  String get inputTypeMessage;

  /// No description provided for @titleAddressType.
  ///
  /// In en, this message translates to:
  /// **'Address type'**
  String get titleAddressType;

  /// No description provided for @titleVirtualSupport.
  ///
  /// In en, this message translates to:
  /// **'My virtual Support'**
  String get titleVirtualSupport;

  /// No description provided for @titleToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get titleToday;

  /// No description provided for @titleYesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get titleYesterday;

  /// No description provided for @titleRecentAddresses.
  ///
  /// In en, this message translates to:
  /// **'Recent Addresses'**
  String get titleRecentAddresses;

  /// No description provided for @titleCurrentLocation.
  ///
  /// In en, this message translates to:
  /// **'Current Location'**
  String get titleCurrentLocation;

  /// No description provided for @titleWhoIam.
  ///
  /// In en, this message translates to:
  /// **'Hi, I am {user}'**
  String titleWhoIam(Object user);

  /// No description provided for @titleCreateAddress.
  ///
  /// In en, this message translates to:
  /// **'Create addresss'**
  String get titleCreateAddress;

  /// No description provided for @titleUpdateAddress.
  ///
  /// In en, this message translates to:
  /// **'Update addresss'**
  String get titleUpdateAddress;

  /// No description provided for @titleAppointment.
  ///
  /// In en, this message translates to:
  /// **'Appointment'**
  String get titleAppointment;

  /// No description provided for @titleCalendar.
  ///
  /// In en, this message translates to:
  /// **'Calendar'**
  String get titleCalendar;

  /// No description provided for @titleTermsAndConditions.
  ///
  /// In en, this message translates to:
  /// **'Terms and Conditions'**
  String get titleTermsAndConditions;

  /// No description provided for @titleTermsAndConditionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Terms and Conditions of Use'**
  String get titleTermsAndConditionsTitle;

  /// No description provided for @titlePrivacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get titlePrivacyPolicy;

  /// No description provided for @sentenceAcceptTerms.
  ///
  /// In en, this message translates to:
  /// **'I accept the'**
  String get sentenceAcceptTerms;

  /// No description provided for @sentenceAcceptPrivacy.
  ///
  /// In en, this message translates to:
  /// **'I authorize the processing of my personal data in accordance with the'**
  String get sentenceAcceptPrivacy;

  /// No description provided for @sentencePrivacyLink.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get sentencePrivacyLink;

  /// No description provided for @sentencePrivacySuffix.
  ///
  /// In en, this message translates to:
  /// **'of PonteGlam and Law 1581 of 2012'**
  String get sentencePrivacySuffix;

  /// No description provided for @sentenceSignInWelcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get sentenceSignInWelcome;

  /// No description provided for @sentenceSignUpCreate.
  ///
  /// In en, this message translates to:
  /// **'Create your account'**
  String get sentenceSignUpCreate;

  /// No description provided for @failureTermsRequired.
  ///
  /// In en, this message translates to:
  /// **'You must accept the Terms and Conditions to continue'**
  String get failureTermsRequired;

  /// No description provided for @failurePrivacyRequired.
  ///
  /// In en, this message translates to:
  /// **'You must authorize data processing to continue'**
  String get failurePrivacyRequired;

  /// No description provided for @titleSignInWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Sign in with Google'**
  String get titleSignInWithGoogle;

  /// No description provided for @titleSignUpWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Sign up with Google'**
  String get titleSignUpWithGoogle;

  /// No description provided for @sentenceAcceptTermsToContinue.
  ///
  /// In en, this message translates to:
  /// **'Please accept the terms and conditions to continue'**
  String get sentenceAcceptTermsToContinue;

  /// No description provided for @titleRatings.
  ///
  /// In en, this message translates to:
  /// **'Ratings'**
  String get titleRatings;

  /// No description provided for @titleViewRatings.
  ///
  /// In en, this message translates to:
  /// **'View reviews'**
  String get titleViewRatings;

  /// No description provided for @ratingEmpty.
  ///
  /// In en, this message translates to:
  /// **'No reviews yet for this service.'**
  String get ratingEmpty;

  /// No description provided for @ratingWriteTitle.
  ///
  /// In en, this message translates to:
  /// **'Write your review'**
  String get ratingWriteTitle;

  /// No description provided for @ratingComment.
  ///
  /// In en, this message translates to:
  /// **'Comment (optional)'**
  String get ratingComment;

  /// No description provided for @ratingSend.
  ///
  /// In en, this message translates to:
  /// **'Send rating'**
  String get ratingSend;

  /// No description provided for @ratingSuccess.
  ///
  /// In en, this message translates to:
  /// **'Thank you for your rating!'**
  String get ratingSuccess;

  /// No description provided for @titleReschedule.
  ///
  /// In en, this message translates to:
  /// **'Reschedule appointment'**
  String get titleReschedule;

  /// No description provided for @titleRescheduleConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm reschedule'**
  String get titleRescheduleConfirm;

  /// No description provided for @sentencePendingCashConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Your booking is pending confirmation.'**
  String get sentencePendingCashConfirmation;

  /// No description provided for @sentenceBookingCashCreated.
  ///
  /// In en, this message translates to:
  /// **'Booking created! Payment will be made in cash at the location.'**
  String get sentenceBookingCashCreated;

  /// No description provided for @sentenceBookingCardSuccess.
  ///
  /// In en, this message translates to:
  /// **'Payment successful! Your appointment has been confirmed.'**
  String get sentenceBookingCardSuccess;

  /// No description provided for @sentenceBookingCancelled.
  ///
  /// In en, this message translates to:
  /// **'Payment cancelled'**
  String get sentenceBookingCancelled;

  /// No description provided for @titleWallet.
  ///
  /// In en, this message translates to:
  /// **'Wallet'**
  String get titleWallet;

  /// No description provided for @titleAppointmentDetail.
  ///
  /// In en, this message translates to:
  /// **'Appointment Detail'**
  String get titleAppointmentDetail;

  /// No description provided for @titleCancelAppointment.
  ///
  /// In en, this message translates to:
  /// **'Cancel appointment'**
  String get titleCancelAppointment;

  /// No description provided for @titleRescheduleAppointment.
  ///
  /// In en, this message translates to:
  /// **'Reschedule'**
  String get titleRescheduleAppointment;

  /// No description provided for @titleRateService.
  ///
  /// In en, this message translates to:
  /// **'Rate Service'**
  String get titleRateService;

  /// No description provided for @sentenceConfirmCancelAppointment.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to cancel this appointment?'**
  String get sentenceConfirmCancelAppointment;

  /// No description provided for @inputCancelReason.
  ///
  /// In en, this message translates to:
  /// **'Reason (optional)'**
  String get inputCancelReason;

  /// No description provided for @titleNoCancelBack.
  ///
  /// In en, this message translates to:
  /// **'No, go back'**
  String get titleNoCancelBack;

  /// No description provided for @titleYesCancel.
  ///
  /// In en, this message translates to:
  /// **'Yes, cancel'**
  String get titleYesCancel;

  /// No description provided for @titleUpcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get titleUpcoming;

  /// No description provided for @titleCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get titleCompleted;

  /// No description provided for @titleCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get titleCancelled;

  /// No description provided for @titleNoAppointmentsInCategory.
  ///
  /// In en, this message translates to:
  /// **'No appointments in this category'**
  String get titleNoAppointmentsInCategory;

  /// No description provided for @sentenceRescheduleEndAfterStart.
  ///
  /// In en, this message translates to:
  /// **'End time must be after start time'**
  String get sentenceRescheduleEndAfterStart;

  /// No description provided for @noNotificationsYet.
  ///
  /// In en, this message translates to:
  /// **'You don\'t have any notifications yet'**
  String get noNotificationsYet;

  /// No description provided for @titleAddons.
  ///
  /// In en, this message translates to:
  /// **'Addons'**
  String get titleAddons;

  /// No description provided for @sentenceSaveServiceFirst.
  ///
  /// In en, this message translates to:
  /// **'Save the service first to add addons.'**
  String get sentenceSaveServiceFirst;

  /// No description provided for @titleLinkedAddons.
  ///
  /// In en, this message translates to:
  /// **'Linked to this service'**
  String get titleLinkedAddons;

  /// No description provided for @sentenceNoAddons.
  ///
  /// In en, this message translates to:
  /// **'No addons'**
  String get sentenceNoAddons;

  /// No description provided for @titleAvailableAddons.
  ///
  /// In en, this message translates to:
  /// **'Your available addons'**
  String get titleAvailableAddons;

  /// No description provided for @titleCreateNewAddon.
  ///
  /// In en, this message translates to:
  /// **'Create new addon'**
  String get titleCreateNewAddon;

  /// No description provided for @titleCreateAndLink.
  ///
  /// In en, this message translates to:
  /// **'Create and link'**
  String get titleCreateAndLink;

  /// No description provided for @inputPriceFree.
  ///
  /// In en, this message translates to:
  /// **'0 = free'**
  String get inputPriceFree;

  /// No description provided for @nequiSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Nequi Payment Method'**
  String get nequiSectionTitle;

  /// No description provided for @updateNequiButton.
  ///
  /// In en, this message translates to:
  /// **'Update Nequi Number'**
  String get updateNequiButton;

  /// No description provided for @otpNequiMessage.
  ///
  /// In en, this message translates to:
  /// **'Enter the verification code sent to your email to confirm the Nequi change.'**
  String get otpNequiMessage;

  /// No description provided for @nequiLabel.
  ///
  /// In en, this message translates to:
  /// **'Nequi Account Number'**
  String get nequiLabel;

  /// No description provided for @nequiNumberPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Enter Nequi number (e.g. 3001234567)'**
  String get nequiNumberPlaceholder;

  /// No description provided for @invalidNequiNumber.
  ///
  /// In en, this message translates to:
  /// **'Invalid Nequi number. Must be a valid phone number format.'**
  String get invalidNequiNumber;

  /// No description provided for @verificationCodeLabel.
  ///
  /// In en, this message translates to:
  /// **'Verification Code'**
  String get verificationCodeLabel;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
