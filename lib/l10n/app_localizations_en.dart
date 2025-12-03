// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'KASA+';

  @override
  String get total => 'Total';

  @override
  String get add => 'Add';

  @override
  String get options => 'Options';

  @override
  String get currency => 'Currency';

  @override
  String get language => 'Language';

  @override
  String get usd => 'USD';

  @override
  String get eur => 'EUR';

  @override
  String get tl => 'TRY';

  @override
  String get quantity => 'Quantity';

  @override
  String get reset => 'Reset';

  @override
  String get save => 'Save';

  @override
  String get history => 'History';

  @override
  String get saved => 'Saved';

  @override
  String get noHistory => 'No history yet';

  @override
  String get delete => 'Delete';

  @override
  String get clearAll => 'Clear All';

  @override
  String get confirmDelete => 'Are you sure you want to delete all history?';

  @override
  String get cancel => 'Cancel';

  @override
  String get confirm => 'Confirm';

  @override
  String get initialCash => 'Initial Cash';

  @override
  String get targetAmount => 'Target Amount';

  @override
  String get difference => 'Difference';

  @override
  String get netTotal => 'Net Total';

  @override
  String get english => 'English';

  @override
  String get turkish => 'Turkish';

  @override
  String get safe => 'Safe';

  @override
  String get addToSafe => 'Add to Safe?';

  @override
  String get addToSafeContent => 'Do you want to add these items to the safe inventory?';

  @override
  String get addedToSafe => 'Added to Safe';

  @override
  String get resetSafe => 'Reset Safe';

  @override
  String get confirmResetSafe => 'Are you sure you want to reset the safe for this currency?';

  @override
  String get safeDropTitle => 'Safe Drop Calculation';

  @override
  String get totalCounted => 'Total Counted';

  @override
  String get deductedInitial => 'Initial Cash (Kept)';

  @override
  String get toBeAdded => 'To Be Added';

  @override
  String get statistics => 'Statistics';

  @override
  String lastRecords(Object count) {
    return 'Last $count Records';
  }

  @override
  String get netTotalTrend => 'Net Total Trend';

  @override
  String get differenceTrend => 'Difference Trend';

  @override
  String get surplus => 'Surplus';

  @override
  String get deficit => 'Deficit';

  @override
  String get safeEmptyTitle => 'Safe Status Unknown';

  @override
  String get safeEmptyMessage => 'Your safe appears to be empty. Please enter the current amount in your safe to start.';

  @override
  String get later => 'Later';

  @override
  String get goToSafe => 'Go to Safe';

  @override
  String get bankDeposit => 'Bank Deposit';

  @override
  String get deposit => 'Deposit';

  @override
  String get deposited => 'Deposited';

  @override
  String get cannotDeleteDeposit => 'Bank deposits cannot be deleted';

  @override
  String get insufficientFunds => 'Insufficient funds in safe';

  @override
  String get confirmDeposit => 'Confirm Deposit';

  @override
  String get confirmDepositContent => 'Are you sure you want to deposit this amount to the bank? This will be deducted from the safe.';
}
