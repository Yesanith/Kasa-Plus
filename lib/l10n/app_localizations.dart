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
    Locale('tr'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In tr, this message translates to:
  /// **'KASA+'**
  String get appTitle;

  /// No description provided for @total.
  ///
  /// In tr, this message translates to:
  /// **'Toplam'**
  String get total;

  /// No description provided for @add.
  ///
  /// In tr, this message translates to:
  /// **'Ekle'**
  String get add;

  /// No description provided for @options.
  ///
  /// In tr, this message translates to:
  /// **'Seçenekler'**
  String get options;

  /// No description provided for @currency.
  ///
  /// In tr, this message translates to:
  /// **'Para Birimi'**
  String get currency;

  /// No description provided for @language.
  ///
  /// In tr, this message translates to:
  /// **'Dil'**
  String get language;

  /// No description provided for @usd.
  ///
  /// In tr, this message translates to:
  /// **'USD'**
  String get usd;

  /// No description provided for @eur.
  ///
  /// In tr, this message translates to:
  /// **'EUR'**
  String get eur;

  /// No description provided for @tl.
  ///
  /// In tr, this message translates to:
  /// **'TRY'**
  String get tl;

  /// No description provided for @quantity.
  ///
  /// In tr, this message translates to:
  /// **'Miktar'**
  String get quantity;

  /// No description provided for @reset.
  ///
  /// In tr, this message translates to:
  /// **'Sıfırla'**
  String get reset;

  /// No description provided for @save.
  ///
  /// In tr, this message translates to:
  /// **'Kaydet'**
  String get save;

  /// No description provided for @history.
  ///
  /// In tr, this message translates to:
  /// **'Geçmiş'**
  String get history;

  /// No description provided for @saved.
  ///
  /// In tr, this message translates to:
  /// **'Kaydedildi'**
  String get saved;

  /// No description provided for @noHistory.
  ///
  /// In tr, this message translates to:
  /// **'Henüz geçmiş yok'**
  String get noHistory;

  /// No description provided for @delete.
  ///
  /// In tr, this message translates to:
  /// **'Sil'**
  String get delete;

  /// No description provided for @clearAll.
  ///
  /// In tr, this message translates to:
  /// **'Tümünü Temizle'**
  String get clearAll;

  /// No description provided for @confirmDelete.
  ///
  /// In tr, this message translates to:
  /// **'Tüm geçmişi silmek istediğinize emin misiniz?'**
  String get confirmDelete;

  /// No description provided for @cancel.
  ///
  /// In tr, this message translates to:
  /// **'İptal'**
  String get cancel;

  /// No description provided for @confirm.
  ///
  /// In tr, this message translates to:
  /// **'Onayla'**
  String get confirm;

  /// No description provided for @initialCash.
  ///
  /// In tr, this message translates to:
  /// **'Kasa Avansı'**
  String get initialCash;

  /// No description provided for @targetAmount.
  ///
  /// In tr, this message translates to:
  /// **'Olması Gereken'**
  String get targetAmount;

  /// No description provided for @difference.
  ///
  /// In tr, this message translates to:
  /// **'Fark'**
  String get difference;

  /// No description provided for @netTotal.
  ///
  /// In tr, this message translates to:
  /// **'Net Toplam'**
  String get netTotal;

  /// No description provided for @english.
  ///
  /// In tr, this message translates to:
  /// **'İngilizce'**
  String get english;

  /// No description provided for @turkish.
  ///
  /// In tr, this message translates to:
  /// **'Türkçe'**
  String get turkish;

  /// No description provided for @safe.
  ///
  /// In tr, this message translates to:
  /// **'Kasa'**
  String get safe;

  /// No description provided for @addToSafe.
  ///
  /// In tr, this message translates to:
  /// **'Kasaya Ekle?'**
  String get addToSafe;

  /// No description provided for @addToSafeContent.
  ///
  /// In tr, this message translates to:
  /// **'Bu sayımı kasaya eklemek ister misiniz?'**
  String get addToSafeContent;

  /// No description provided for @addedToSafe.
  ///
  /// In tr, this message translates to:
  /// **'Kasaya Eklendi'**
  String get addedToSafe;

  /// No description provided for @resetSafe.
  ///
  /// In tr, this message translates to:
  /// **'Kasayı Sıfırla'**
  String get resetSafe;

  /// No description provided for @confirmResetSafe.
  ///
  /// In tr, this message translates to:
  /// **'Bu para birimi için kasayı sıfırlamak istediğinize emin misiniz?'**
  String get confirmResetSafe;

  /// No description provided for @safeDropTitle.
  ///
  /// In tr, this message translates to:
  /// **'Kasa Devir Hesabı'**
  String get safeDropTitle;

  /// No description provided for @totalCounted.
  ///
  /// In tr, this message translates to:
  /// **'Sayılan Toplam'**
  String get totalCounted;

  /// No description provided for @deductedInitial.
  ///
  /// In tr, this message translates to:
  /// **'Düşülen Avans (Kasada Kalan)'**
  String get deductedInitial;

  /// No description provided for @toBeAdded.
  ///
  /// In tr, this message translates to:
  /// **'Kasaya Eklenecek'**
  String get toBeAdded;

  /// No description provided for @statistics.
  ///
  /// In tr, this message translates to:
  /// **'İstatistikler'**
  String get statistics;

  /// No description provided for @lastRecords.
  ///
  /// In tr, this message translates to:
  /// **'Son {count} Kayıt'**
  String lastRecords(Object count);

  /// No description provided for @netTotalTrend.
  ///
  /// In tr, this message translates to:
  /// **'Net Toplam Grafiği'**
  String get netTotalTrend;

  /// No description provided for @differenceTrend.
  ///
  /// In tr, this message translates to:
  /// **'Fark Grafiği'**
  String get differenceTrend;

  /// No description provided for @surplus.
  ///
  /// In tr, this message translates to:
  /// **'Fazla'**
  String get surplus;

  /// No description provided for @deficit.
  ///
  /// In tr, this message translates to:
  /// **'Açık'**
  String get deficit;

  /// No description provided for @safeEmptyTitle.
  ///
  /// In tr, this message translates to:
  /// **'Kasa Durumu Belirsiz'**
  String get safeEmptyTitle;

  /// No description provided for @safeEmptyMessage.
  ///
  /// In tr, this message translates to:
  /// **'Kasanızda para görünmüyor. Başlamak için lütfen kasadaki mevcut tutarı girin.'**
  String get safeEmptyMessage;

  /// No description provided for @later.
  ///
  /// In tr, this message translates to:
  /// **'Daha Sonra'**
  String get later;

  /// No description provided for @goToSafe.
  ///
  /// In tr, this message translates to:
  /// **'Kasaya Git'**
  String get goToSafe;

  /// No description provided for @bankDeposit.
  ///
  /// In tr, this message translates to:
  /// **'Bankaya Yatırılan'**
  String get bankDeposit;

  /// No description provided for @deposit.
  ///
  /// In tr, this message translates to:
  /// **'Yatır'**
  String get deposit;

  /// No description provided for @deposited.
  ///
  /// In tr, this message translates to:
  /// **'Yatırıldı'**
  String get deposited;

  /// No description provided for @insufficientFunds.
  ///
  /// In tr, this message translates to:
  /// **'Kasada yeterli bakiye yok'**
  String get insufficientFunds;

  /// No description provided for @confirmDeposit.
  ///
  /// In tr, this message translates to:
  /// **'Yatırmayı Onayla'**
  String get confirmDeposit;

  /// No description provided for @confirmDepositContent.
  ///
  /// In tr, this message translates to:
  /// **'Bu tutarı bankaya yatırmak istediğinize emin misiniz? Bu işlem kasadan düşülecektir.'**
  String get confirmDepositContent;

  /// No description provided for @backupRestore.
  ///
  /// In tr, this message translates to:
  /// **'Yedekleme ve Geri Yükleme'**
  String get backupRestore;

  /// No description provided for @backupData.
  ///
  /// In tr, this message translates to:
  /// **'Verileri Yedekle'**
  String get backupData;

  /// No description provided for @restoreData.
  ///
  /// In tr, this message translates to:
  /// **'Verileri Geri Yükle'**
  String get restoreData;

  /// No description provided for @tutorialWelcomeTitle.
  ///
  /// In tr, this message translates to:
  /// **'Hoş Geldiniz!'**
  String get tutorialWelcomeTitle;

  /// No description provided for @tutorialWelcomeDesc.
  ///
  /// In tr, this message translates to:
  /// **'KASA+ ile para saymak artık çok kolay. Hızlı bir tura ne dersiniz?'**
  String get tutorialWelcomeDesc;

  /// No description provided for @tutorialTotalTitle.
  ///
  /// In tr, this message translates to:
  /// **'Toplam Tutar'**
  String get tutorialTotalTitle;

  /// No description provided for @tutorialTotalDesc.
  ///
  /// In tr, this message translates to:
  /// **'Saydığınız paraların toplamını burada görebilirsiniz.'**
  String get tutorialTotalDesc;

  /// No description provided for @tutorialInitialTitle.
  ///
  /// In tr, this message translates to:
  /// **'Kasa Avansı ve Hedef'**
  String get tutorialInitialTitle;

  /// No description provided for @tutorialInitialDesc.
  ///
  /// In tr, this message translates to:
  /// **'Güne başladığınız parayı (Avans) veya olması gereken tutarı buradan girebilirsiniz.'**
  String get tutorialInitialDesc;

  /// No description provided for @tutorialListTitle.
  ///
  /// In tr, this message translates to:
  /// **'Para Girişi'**
  String get tutorialListTitle;

  /// No description provided for @tutorialListDesc.
  ///
  /// In tr, this message translates to:
  /// **'Elinizdeki banknot ve madeni paraların adetlerini buraya girin.'**
  String get tutorialListDesc;

  /// No description provided for @tutorialSaveTitle.
  ///
  /// In tr, this message translates to:
  /// **'Kaydet ve Sıfırla'**
  String get tutorialSaveTitle;

  /// No description provided for @tutorialSaveDesc.
  ///
  /// In tr, this message translates to:
  /// **'İşleminizi kaydetmek veya ekranı temizlemek için bu butonları kullanın.'**
  String get tutorialSaveDesc;

  /// No description provided for @tutorialMenuTitle.
  ///
  /// In tr, this message translates to:
  /// **'Menü'**
  String get tutorialMenuTitle;

  /// No description provided for @tutorialMenuDesc.
  ///
  /// In tr, this message translates to:
  /// **'Geçmiş, Kasa Envanteri ve Ayarlara buradan ulaşabilirsiniz.'**
  String get tutorialMenuDesc;

  /// No description provided for @skip.
  ///
  /// In tr, this message translates to:
  /// **'Atla'**
  String get skip;

  /// No description provided for @next.
  ///
  /// In tr, this message translates to:
  /// **'İleri'**
  String get next;

  /// No description provided for @finish.
  ///
  /// In tr, this message translates to:
  /// **'Bitir'**
  String get finish;
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
      <String>['en', 'tr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'tr':
      return AppLocalizationsTr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
