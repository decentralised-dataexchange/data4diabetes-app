// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get bottomNavHome => 'Home';

  @override
  String get bottomNavMyWallet => 'MyWallet';

  @override
  String get bottomNavInsights => 'Insights';

  @override
  String get bottomNavScanAndCheck => 'Check';

  @override
  String get generalShareData => 'Share Data';

  @override
  String get homeMedication => 'Medication';

  @override
  String get homeActivities => 'Activities';

  @override
  String get homeFood => 'Food';

  @override
  String get homeEnvironment => 'Environment';

  @override
  String get homeBiological => 'Biological';

  @override
  String get homeYourVirtualPancreas => 'Your virtual pancreas';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsEnglish => 'English';

  @override
  String get settingsSwedish => 'Swedish';

  @override
  String get settingsSecurity => 'Security (Face ID)';

  @override
  String get settingsMyWallet => 'My Wallet';

  @override
  String get settingsConnections => 'My Connections';

  @override
  String get settingsMySharedData => 'My Shared Data';

  @override
  String get settingsPrivacyDashboard => 'My Privacy Dashboard';

  @override
  String get settingsNotification => 'Notifications';

  @override
  String get settingsDexcom => 'Dexcom Dashboard';

  @override
  String get settingsAlert => 'Alert';

  @override
  String get settingsDexcomAlert =>
      'You are already logged in to Dexcom\nDo you want to Logout?';

  @override
  String get settingsDexcomLoginYes => 'Yes';

  @override
  String get settingsDexcomLoginNo => 'No';

  @override
  String get settingsLogout => 'Logout';

  @override
  String get settingsSettings => 'Settings';

  @override
  String get settingsDeleteAccount => 'Remove Account';

  @override
  String get settingsPrivacyPolicy => 'Privacy Policy';

  @override
  String get settingsDeleteAccountSuccess =>
      'Your account has been deleted successfully';

  @override
  String get settingsDeleteAccountFail => 'User does not exist';

  @override
  String get settingsDeleteAccountContent =>
      'Do you want to delete your account?';

  @override
  String get settingsDeleteAccountYes => 'Yes';

  @override
  String get settingsDeleteAccountNo => 'No';

  @override
  String get scanAndCheckRejectAndChange => 'Reject and change';

  @override
  String get scanAndCheckReject => 'Reject';

  @override
  String get scanAndCheckConfirm => 'Confirm';

  @override
  String get scanAndCheckContentText =>
      'Click confirm to add this medicine to your medication list.';

  @override
  String get scanAndCheckMedicineScanAndAdd => 'Medicine: Scan and Add';

  @override
  String get loginEnterMobileNumber => 'Enter Mobile Number';

  @override
  String get login => 'Login';

  @override
  String get loginNotYetUser => 'Not yet a user?';

  @override
  String get loginRegisterNow => 'Register Now';

  @override
  String get loginPhoneNumberValidationText => 'Please enter mobile number';

  @override
  String get loginValidPhoneNumberValidationText =>
      'Please enter valid mobile number';

  @override
  String get otpEnterOtp => 'Enter the OTP sent to';

  @override
  String get otpNotReceive => 'Didn\'t receive the OTP?';

  @override
  String get otpResend => 'RESEND';

  @override
  String get otpConfirm => 'Confirm';

  @override
  String get otpCancel => 'Cancel';

  @override
  String get register => 'Registration';

  @override
  String get registerTrustContent =>
      'You may be sharing sensitive info with this site or app. See the';

  @override
  String get registerAnd => 'and';

  @override
  String get registerDataAgreementDetails => 'data agreement details';

  @override
  String get registerTermsOfService => 'Terms of Service.';

  @override
  String get registerTopContent =>
      'Data4Diabetes needs the following data to register and use the application. Please enter the data.';

  @override
  String get registerData4DiabetesTrust =>
      'Make sure that you trust Data4Diabetes';

  @override
  String get registerBottomContent =>
      'You may be sharing sensitive info with this site or app. See the data agreement details and Terms of Service.';

  @override
  String get registerCancel => 'Cancel';

  @override
  String get registerFirstName => 'Name (First Name, Surname)';

  @override
  String get registerLastName => 'Last name';

  @override
  String get registerMobileNumber => 'Mobile number';

  @override
  String get registerAge => 'Age';

  @override
  String get registerCGM => 'CGM Data (mmol)';

  @override
  String get registerInsights => 'Insights';

  @override
  String get registerAgree => 'Agree';

  @override
  String get registerNext => 'Next';

  @override
  String get registerSkip => 'Skip';

  @override
  String get registerFirstNameValidationText => 'Please enter firstname';

  @override
  String get registerPhoneNumberValidationText => 'Please enter mobile number';

  @override
  String get registerValidPhoneNumberValidationText =>
      'Please enter valid mobile number';

  @override
  String get registerAgreeFinish => 'Agree & Finish';

  @override
  String get registerScannedImages => 'Scanned Images';

  @override
  String get registerDonateData => 'Donate your data!';

  @override
  String get registerBackupAndRestore => 'Backup and Restore';

  @override
  String get registerBackupAndRestoreContent =>
      'Data4Diabetes recommends you to save all your data in your own data pod, fully encrypted. You can revoke this decision later from your personal data dashboard.';

  @override
  String get registerDonateDataContent =>
      'Data4Diabetes recommends you to donate your diabetes data and insights towards researchers.This will be anonymously shared.';

  @override
  String get registerExistingUser => 'User already existing and is active';

  @override
  String get registerNotExistingUser => 'User is not existing';

  @override
  String get insightsToday => 'TODAY';

  @override
  String get insightsLast7Days => 'LAST 7 DAYS';

  @override
  String get insightsLast30Days => 'LAST 30 DAYS';

  @override
  String get insightsGlucoseTIR => 'Glucose - Time in range';

  @override
  String get insightsVeryHighRange => 'Very high > 13.9 mmol/l';

  @override
  String get insightsHighRange => 'High 10.1 - 13.9 mmol/l';

  @override
  String get insightsTargetRange => 'Target range 3.9 - 10 mmol/l';

  @override
  String get insightsLowRange => 'Low 3 - 3.8 mmol/l';

  @override
  String get insightsVeryLow => 'Very low < 3 mmol/l';

  @override
  String get insightsSummary => 'Summary';

  @override
  String get insightsGMI => 'GMI';

  @override
  String get insightsAvgValue => 'Average Value';

  @override
  String get insightsActiveCGM => '% Active time with CGM';

  @override
  String get insightsDexcomTitle => 'Dexcom Login';

  @override
  String get insightsDexcomContent =>
      'Please login to Dexcom to get your estimated glucose values';

  @override
  String get insightsOk => 'Ok';

  @override
  String get insightsCancel => 'Cancel';

  @override
  String get otpLimitExceeded =>
      'OTP request limit exceeded. Please try again after sometime.';
}
