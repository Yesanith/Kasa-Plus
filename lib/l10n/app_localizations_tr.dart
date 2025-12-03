// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appTitle => 'KASA+';

  @override
  String get total => 'Toplam';

  @override
  String get add => 'Ekle';

  @override
  String get options => 'Seçenekler';

  @override
  String get currency => 'Para Birimi';

  @override
  String get language => 'Dil';

  @override
  String get usd => 'USD';

  @override
  String get eur => 'EUR';

  @override
  String get tl => 'TRY';

  @override
  String get quantity => 'Miktar';

  @override
  String get reset => 'Sıfırla';

  @override
  String get save => 'Kaydet';

  @override
  String get history => 'Geçmiş';

  @override
  String get saved => 'Kaydedildi';

  @override
  String get noHistory => 'Henüz geçmiş yok';

  @override
  String get delete => 'Sil';

  @override
  String get clearAll => 'Tümünü Temizle';

  @override
  String get confirmDelete => 'Tüm geçmişi silmek istediğinize emin misiniz?';

  @override
  String get cancel => 'İptal';

  @override
  String get confirm => 'Onayla';

  @override
  String get initialCash => 'Kasa Avansı';

  @override
  String get targetAmount => 'Olması Gereken';

  @override
  String get difference => 'Fark';

  @override
  String get netTotal => 'Net Toplam';

  @override
  String get english => 'İngilizce';

  @override
  String get turkish => 'Türkçe';

  @override
  String get safe => 'Kasa';

  @override
  String get addToSafe => 'Kasaya Ekle?';

  @override
  String get addToSafeContent => 'Bu sayımı kasaya eklemek ister misiniz?';

  @override
  String get addedToSafe => 'Kasaya Eklendi';

  @override
  String get resetSafe => 'Kasayı Sıfırla';

  @override
  String get confirmResetSafe => 'Bu para birimi için kasayı sıfırlamak istediğinize emin misiniz?';

  @override
  String get safeDropTitle => 'Kasa Devir Hesabı';

  @override
  String get totalCounted => 'Sayılan Toplam';

  @override
  String get deductedInitial => 'Düşülen Avans (Kasada Kalan)';

  @override
  String get toBeAdded => 'Kasaya Eklenecek';

  @override
  String get statistics => 'İstatistikler';

  @override
  String lastRecords(Object count) {
    return 'Son $count Kayıt';
  }

  @override
  String get netTotalTrend => 'Net Toplam Grafiği';

  @override
  String get differenceTrend => 'Fark Grafiği';

  @override
  String get surplus => 'Fazla';

  @override
  String get deficit => 'Açık';

  @override
  String get safeEmptyTitle => 'Kasa Durumu Belirsiz';

  @override
  String get safeEmptyMessage => 'Kasanızda para görünmüyor. Başlamak için lütfen kasadaki mevcut tutarı girin.';

  @override
  String get later => 'Daha Sonra';

  @override
  String get goToSafe => 'Kasaya Git';

  @override
  String get bankDeposit => 'Bankaya Yatırılan';

  @override
  String get deposit => 'Yatır';

  @override
  String get deposited => 'Yatırıldı';

  @override
  String get cannotDeleteDeposit => 'Banka yatırma işlemleri silinemez';

  @override
  String get insufficientFunds => 'Kasada yeterli bakiye yok';

  @override
  String get confirmDeposit => 'Yatırmayı Onayla';

  @override
  String get confirmDepositContent => 'Bu tutarı bankaya yatırmak istediğinize emin misiniz? Bu işlem kasadan düşülecektir.';
}
