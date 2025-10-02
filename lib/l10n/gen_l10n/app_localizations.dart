import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_sv.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen_l10n/app_localizations.dart';
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

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
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
    Locale('sv')
  ];

  /// No description provided for @bottomNavHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get bottomNavHome;

  /// No description provided for @bottomNavMyWallet.
  ///
  /// In en, this message translates to:
  /// **'MyWallet'**
  String get bottomNavMyWallet;

  /// No description provided for @bottomNavInsights.
  ///
  /// In en, this message translates to:
  /// **'Insights'**
  String get bottomNavInsights;

  /// No description provided for @bottomNavScanAndCheck.
  ///
  /// In en, this message translates to:
  /// **'Check'**
  String get bottomNavScanAndCheck;

  /// No description provided for @generalShareData.
  ///
  /// In en, this message translates to:
  /// **'Share Data'**
  String get generalShareData;

  /// No description provided for @homeMedication.
  ///
  /// In en, this message translates to:
  /// **'Medication'**
  String get homeMedication;

  /// No description provided for @homeActivities.
  ///
  /// In en, this message translates to:
  /// **'Activities'**
  String get homeActivities;

  /// No description provided for @homeFood.
  ///
  /// In en, this message translates to:
  /// **'Food'**
  String get homeFood;

  /// No description provided for @homeEnvironment.
  ///
  /// In en, this message translates to:
  /// **'Environment'**
  String get homeEnvironment;

  /// No description provided for @homeBiological.
  ///
  /// In en, this message translates to:
  /// **'Biological'**
  String get homeBiological;

  /// No description provided for @homeYourVirtualPancreas.
  ///
  /// In en, this message translates to:
  /// **'Your virtual pancreas'**
  String get homeYourVirtualPancreas;

  /// No description provided for @settingsLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// No description provided for @settingsEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get settingsEnglish;

  /// No description provided for @settingsSwedish.
  ///
  /// In en, this message translates to:
  /// **'Swedish'**
  String get settingsSwedish;

  /// No description provided for @settingsSecurity.
  ///
  /// In en, this message translates to:
  /// **'Security (Face ID)'**
  String get settingsSecurity;

  /// No description provided for @settingsMyWallet.
  ///
  /// In en, this message translates to:
  /// **'My Wallet'**
  String get settingsMyWallet;

  /// No description provided for @settingsConnections.
  ///
  /// In en, this message translates to:
  /// **'My Connections'**
  String get settingsConnections;

  /// No description provided for @settingsMySharedData.
  ///
  /// In en, this message translates to:
  /// **'My Shared Data'**
  String get settingsMySharedData;

  /// No description provided for @settingsPrivacyDashboard.
  ///
  /// In en, this message translates to:
  /// **'My Privacy Dashboard'**
  String get settingsPrivacyDashboard;

  /// No description provided for @settingsNotification.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get settingsNotification;

  /// No description provided for @settingsDexcom.
  ///
  /// In en, this message translates to:
  /// **'Dexcom Dashboard'**
  String get settingsDexcom;

  /// No description provided for @settingsAlert.
  ///
  /// In en, this message translates to:
  /// **'Alert'**
  String get settingsAlert;

  /// No description provided for @settingsDexcomAlert.
  ///
  /// In en, this message translates to:
  /// **'You are already logged in to Dexcom\nDo you want to Logout?'**
  String get settingsDexcomAlert;

  /// No description provided for @settingsDexcomLoginYes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get settingsDexcomLoginYes;

  /// No description provided for @settingsDexcomLoginNo.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get settingsDexcomLoginNo;

  /// No description provided for @settingsLogout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get settingsLogout;

  /// No description provided for @settingsSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsSettings;

  /// No description provided for @settingsDeleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Remove Account'**
  String get settingsDeleteAccount;

  /// No description provided for @settingsPrivacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get settingsPrivacyPolicy;

  /// No description provided for @settingsDeleteAccountSuccess.
  ///
  /// In en, this message translates to:
  /// **'Your account has been deleted successfully'**
  String get settingsDeleteAccountSuccess;

  /// No description provided for @settingsDeleteAccountFail.
  ///
  /// In en, this message translates to:
  /// **'User does not exist'**
  String get settingsDeleteAccountFail;

  /// No description provided for @settingsDeleteAccountContent.
  ///
  /// In en, this message translates to:
  /// **'Do you want to delete your account?'**
  String get settingsDeleteAccountContent;

  /// No description provided for @settingsDeleteAccountYes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get settingsDeleteAccountYes;

  /// No description provided for @settingsDeleteAccountNo.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get settingsDeleteAccountNo;

  /// No description provided for @scanAndCheckRejectAndChange.
  ///
  /// In en, this message translates to:
  /// **'Reject and change'**
  String get scanAndCheckRejectAndChange;

  /// No description provided for @scanAndCheckReject.
  ///
  /// In en, this message translates to:
  /// **'Reject'**
  String get scanAndCheckReject;

  /// No description provided for @scanAndCheckConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get scanAndCheckConfirm;

  /// No description provided for @scanAndCheckContentText.
  ///
  /// In en, this message translates to:
  /// **'Click confirm to add this medicine to your medication list.'**
  String get scanAndCheckContentText;

  /// No description provided for @scanAndCheckMedicineScanAndAdd.
  ///
  /// In en, this message translates to:
  /// **'Medicine: Scan and Add'**
  String get scanAndCheckMedicineScanAndAdd;

  /// No description provided for @loginEnterMobileNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter Mobile Number'**
  String get loginEnterMobileNumber;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @loginNotYetUser.
  ///
  /// In en, this message translates to:
  /// **'Not yet a user?'**
  String get loginNotYetUser;

  /// No description provided for @loginRegisterNow.
  ///
  /// In en, this message translates to:
  /// **'Register Now'**
  String get loginRegisterNow;

  /// No description provided for @loginPhoneNumberValidationText.
  ///
  /// In en, this message translates to:
  /// **'Please enter mobile number'**
  String get loginPhoneNumberValidationText;

  /// No description provided for @loginValidPhoneNumberValidationText.
  ///
  /// In en, this message translates to:
  /// **'Please enter valid mobile number'**
  String get loginValidPhoneNumberValidationText;

  /// No description provided for @otpEnterOtp.
  ///
  /// In en, this message translates to:
  /// **'Enter the OTP sent to'**
  String get otpEnterOtp;

  /// No description provided for @otpNotReceive.
  ///
  /// In en, this message translates to:
  /// **'Didn\'t receive the OTP?'**
  String get otpNotReceive;

  /// No description provided for @otpResend.
  ///
  /// In en, this message translates to:
  /// **'RESEND'**
  String get otpResend;

  /// No description provided for @otpConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get otpConfirm;

  /// No description provided for @otpCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get otpCancel;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Registration'**
  String get register;

  /// No description provided for @registerTrustContent.
  ///
  /// In en, this message translates to:
  /// **'You may be sharing sensitive info with this site or app. See the'**
  String get registerTrustContent;

  /// No description provided for @registerAnd.
  ///
  /// In en, this message translates to:
  /// **'and'**
  String get registerAnd;

  /// No description provided for @registerDataAgreementDetails.
  ///
  /// In en, this message translates to:
  /// **'data agreement details'**
  String get registerDataAgreementDetails;

  /// No description provided for @registerTermsOfService.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service.'**
  String get registerTermsOfService;

  /// No description provided for @registerTopContent.
  ///
  /// In en, this message translates to:
  /// **'Data4Diabetes needs the following data to register and use the application. Please enter the data.'**
  String get registerTopContent;

  /// No description provided for @registerData4DiabetesTrust.
  ///
  /// In en, this message translates to:
  /// **'Make sure that you trust Data4Diabetes'**
  String get registerData4DiabetesTrust;

  /// No description provided for @registerBottomContent.
  ///
  /// In en, this message translates to:
  /// **'You may be sharing sensitive info with this site or app. See the data agreement details and Terms of Service.'**
  String get registerBottomContent;

  /// No description provided for @registerCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get registerCancel;

  /// No description provided for @registerFirstName.
  ///
  /// In en, this message translates to:
  /// **'Name (First Name, Surname)'**
  String get registerFirstName;

  /// No description provided for @registerLastName.
  ///
  /// In en, this message translates to:
  /// **'Last name'**
  String get registerLastName;

  /// No description provided for @registerMobileNumber.
  ///
  /// In en, this message translates to:
  /// **'Mobile number'**
  String get registerMobileNumber;

  /// No description provided for @registerAge.
  ///
  /// In en, this message translates to:
  /// **'Age'**
  String get registerAge;

  /// No description provided for @registerCGM.
  ///
  /// In en, this message translates to:
  /// **'CGM Data (mmol)'**
  String get registerCGM;

  /// No description provided for @registerInsights.
  ///
  /// In en, this message translates to:
  /// **'Insights'**
  String get registerInsights;

  /// No description provided for @registerAgree.
  ///
  /// In en, this message translates to:
  /// **'Agree'**
  String get registerAgree;

  /// No description provided for @registerNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get registerNext;

  /// No description provided for @registerSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get registerSkip;

  /// No description provided for @registerFirstNameValidationText.
  ///
  /// In en, this message translates to:
  /// **'Please enter firstname'**
  String get registerFirstNameValidationText;

  /// No description provided for @registerPhoneNumberValidationText.
  ///
  /// In en, this message translates to:
  /// **'Please enter mobile number'**
  String get registerPhoneNumberValidationText;

  /// No description provided for @registerValidPhoneNumberValidationText.
  ///
  /// In en, this message translates to:
  /// **'Please enter valid mobile number'**
  String get registerValidPhoneNumberValidationText;

  /// No description provided for @registerAgreeFinish.
  ///
  /// In en, this message translates to:
  /// **'Agree & Finish'**
  String get registerAgreeFinish;

  /// No description provided for @registerScannedImages.
  ///
  /// In en, this message translates to:
  /// **'Scanned Images'**
  String get registerScannedImages;

  /// No description provided for @registerDonateData.
  ///
  /// In en, this message translates to:
  /// **'Donate your data!'**
  String get registerDonateData;

  /// No description provided for @registerBackupAndRestore.
  ///
  /// In en, this message translates to:
  /// **'Backup and Restore'**
  String get registerBackupAndRestore;

  /// No description provided for @registerBackupAndRestoreContent.
  ///
  /// In en, this message translates to:
  /// **'Data4Diabetes recommends you to save all your data in your own data pod, fully encrypted. You can revoke this decision later from your personal data dashboard.'**
  String get registerBackupAndRestoreContent;

  /// No description provided for @registerDonateDataContent.
  ///
  /// In en, this message translates to:
  /// **'Data4Diabetes recommends you to donate your diabetes data and insights towards researchers.This will be anonymously shared.'**
  String get registerDonateDataContent;

  /// No description provided for @registerExistingUser.
  ///
  /// In en, this message translates to:
  /// **'User already existing and is active'**
  String get registerExistingUser;

  /// No description provided for @registerNotExistingUser.
  ///
  /// In en, this message translates to:
  /// **'User is not existing'**
  String get registerNotExistingUser;

  /// No description provided for @insightsToday.
  ///
  /// In en, this message translates to:
  /// **'TODAY'**
  String get insightsToday;

  /// No description provided for @insightsLast7Days.
  ///
  /// In en, this message translates to:
  /// **'LAST 7 DAYS'**
  String get insightsLast7Days;

  /// No description provided for @insightsLast30Days.
  ///
  /// In en, this message translates to:
  /// **'LAST 30 DAYS'**
  String get insightsLast30Days;

  /// No description provided for @insightsGlucoseTIR.
  ///
  /// In en, this message translates to:
  /// **'Glucose - Time in range'**
  String get insightsGlucoseTIR;

  /// No description provided for @insightsVeryHighRange.
  ///
  /// In en, this message translates to:
  /// **'Very high > 13.9 mmol/l'**
  String get insightsVeryHighRange;

  /// No description provided for @insightsHighRange.
  ///
  /// In en, this message translates to:
  /// **'High 10.1 - 13.9 mmol/l'**
  String get insightsHighRange;

  /// No description provided for @insightsTargetRange.
  ///
  /// In en, this message translates to:
  /// **'Target range 3.9 - 10 mmol/l'**
  String get insightsTargetRange;

  /// No description provided for @insightsLowRange.
  ///
  /// In en, this message translates to:
  /// **'Low 3 - 3.8 mmol/l'**
  String get insightsLowRange;

  /// No description provided for @insightsVeryLow.
  ///
  /// In en, this message translates to:
  /// **'Very low < 3 mmol/l'**
  String get insightsVeryLow;

  /// No description provided for @insightsSummary.
  ///
  /// In en, this message translates to:
  /// **'Summary'**
  String get insightsSummary;

  /// No description provided for @insightsGMI.
  ///
  /// In en, this message translates to:
  /// **'GMI'**
  String get insightsGMI;

  /// No description provided for @insightsAvgValue.
  ///
  /// In en, this message translates to:
  /// **'Average Value'**
  String get insightsAvgValue;

  /// No description provided for @insightsActiveCGM.
  ///
  /// In en, this message translates to:
  /// **'% Active time with CGM'**
  String get insightsActiveCGM;

  /// No description provided for @insightsDexcomTitle.
  ///
  /// In en, this message translates to:
  /// **'Dexcom Login'**
  String get insightsDexcomTitle;

  /// No description provided for @insightsDexcomContent.
  ///
  /// In en, this message translates to:
  /// **'Please login to Dexcom to get your estimated glucose values'**
  String get insightsDexcomContent;

  /// No description provided for @insightsOk.
  ///
  /// In en, this message translates to:
  /// **'Ok'**
  String get insightsOk;

  /// No description provided for @insightsCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get insightsCancel;

  /// No description provided for @otpLimitExceeded.
  ///
  /// In en, this message translates to:
  /// **'OTP request limit exceeded. Please try again after sometime.'**
  String get otpLimitExceeded;
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
      <String>['en', 'sv'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'sv':
      return AppLocalizationsSv();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
