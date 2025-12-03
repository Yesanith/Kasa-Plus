import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_tr.dart';

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
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('tr')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'KASA+'**
  String get appTitle;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @options.
  ///
  /// In en, this message translates to:
  /// **'Options'**
  String get options;

  /// No description provided for @currency.
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get currency;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @usd.
  ///
  /// In en, this message translates to:
  /// **'USD'**
  String get usd;

  /// No description provided for @eur.
  ///
  /// In en, this message translates to:
  /// **'EUR'**
  String get eur;

  /// No description provided for @tl.
  ///
  /// In en, this message translates to:
  /// **'TRY'**
  String get tl;

  /// No description provided for @quantity.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get quantity;

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @saved.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get saved;

  /// No description provided for @noHistory.
  ///
  /// In en, this message translates to:
  /// **'No history yet'**
  String get noHistory;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @clearAll.
  ///
  /// In en, this message translates to:
  /// **'Clear All'**
  String get clearAll;

  /// No description provided for @confirmDelete.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete all history?'**
  String get confirmDelete;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @initialCash.
  ///
  /// In en, this message translates to:
  /// **'Initial Cash'**
  String get initialCash;

  /// No description provided for @targetAmount.
  ///
  /// In en, this message translates to:
  /// **'Target Amount'**
  String get targetAmount;

  /// No description provided for @difference.
  ///
  /// In en, this message translates to:
  /// **'Difference'**
  String get difference;

  /// No description provided for @netTotal.
  ///
  /// In en, this message translates to:
  /// **'Net Total'**
  String get netTotal;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @turkish.
  ///
  /// In en, this message translates to:
  /// **'Turkish'**
  String get turkish;

  /// No description provided for @safe.
  ///
  /// In en, this message translates to:
  /// **'Safe'**
  String get safe;

  /// No description provided for @addToSafe.
  ///
  /// In en, this message translates to:
  /// **'Add to Safe?'**
  String get addToSafe;

  /// No description provided for @addToSafeContent.
  ///
  /// In en, this message translates to:
  /// **'Do you want to add these items to the safe inventory?'**
  String get addToSafeContent;

  /// No description provided for @addedToSafe.
  ///
  /// In en, this message translates to:
  /// **'Added to Safe'**
  String get addedToSafe;

  /// No description provided for @resetSafe.
  ///
  /// In en, this message translates to:
  /// **'Reset Safe'**
  String get resetSafe;

  /// No description provided for @confirmResetSafe.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to reset the safe for this currency?'**
  String get confirmResetSafe;

  /// No description provided for @safeDropTitle.
  ///
  /// In en, this message translates to:
  /// **'Safe Drop Calculation'**
  String get safeDropTitle;

  /// No description provided for @totalCounted.
  ///
  /// In en, this message translates to:
  /// **'Total Counted'**
  String get totalCounted;

  /// No description provided for @deductedInitial.
  ///
  /// In en, this message translates to:
  /// **'Initial Cash (Kept)'**
  String get deductedInitial;

  /// No description provided for @toBeAdded.
  ///
  /// In en, this message translates to:
  /// **'To Be Added'**
  String get toBeAdded;

  /// No description provided for @statistics.
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get statistics;

  /// No description provided for @lastRecords.
  ///
  /// In en, this message translates to:
  /// **'Last {count} Records'**
  String lastRecords(Object count);

  /// No description provided for @netTotalTrend.
  ///
  /// In en, this message translates to:
  /// **'Net Total Trend'**
  String get netTotalTrend;

  /// No description provided for @differenceTrend.
  ///
  /// In en, this message translates to:
  /// **'Difference Trend'**
  String get differenceTrend;

  /// No description provided for @surplus.
  ///
  /// In en, this message translates to:
  /// **'Surplus'**
  String get surplus;

  /// No description provided for @deficit.
  ///
  /// In en, this message translates to:
  /// **'Deficit'**
  String get deficit;

  /// No description provided for @safeEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Safe Status Unknown'**
  String get safeEmptyTitle;

  /// No description provided for @safeEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'Your safe appears to be empty. Please enter the current amount in your safe to start.'**
  String get safeEmptyMessage;

  /// No description provided for @later.
  ///
  /// In en, this message translates to:
  /// **'Later'**
  String get later;

  /// No description provided for @goToSafe.
  ///
  /// In en, this message translates to:
  /// **'Go to Safe'**
  String get goToSafe;

  /// No description provided for @bankDeposit.
  ///
  /// In en, this message translates to:
  /// **'Bank Deposit'**
  String get bankDeposit;

  /// No description provided for @deposit.
  ///
  /// In en, this message translates to:
  /// **'Deposit'**
  String get deposit;

  /// No description provided for @deposited.
  ///
  /// In en, this message translates to:
  /// **'Deposited'**
  String get deposited;

  /// No description provided for @cannotDeleteDeposit.
  ///
  /// In en, this message translates to:
  /// **'Bank deposits cannot be deleted'**
  String get cannotDeleteDeposit;

  /// No description provided for @insufficientFunds.
  ///
  /// In en, this message translates to:
  /// **'Insufficient funds in safe'**
  String get insufficientFunds;

  /// No description provided for @confirmDeposit.
  ///
  /// In en, this message translates to:
  /// **'Confirm Deposit'**
  String get confirmDeposit;

  /// No description provided for @confirmDepositContent.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to deposit this amount to the bank? This will be deducted from the safe.'**
  String get confirmDepositContent;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'tr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'tr': return AppLocalizationsTr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
