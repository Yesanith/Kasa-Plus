# KASA+ 💰

**KASA+**, işletmeler ve bireyler için tasarlanmış modern, hızlı ve kullanıcı dostu bir para sayma ve kasa takip uygulamasıdır. Günlük kasa sayımlarınızı, banka yatırma işlemlerinizi ve kasa envanterinizi kolayca yönetmenizi sağlar.

> **Not:** Bu uygulama şu anda sadece **Türk Lirası (TRY)** ve **Türkçe** dil desteği sunmaktadır.

## ✨ Özellikler

*   **🧮 Akıllı Para Sayma:** Banknot ve madeni paralar için özel hazırlanmış arayüz ile hızlıca sayım yapın.
*   **🏦 Kasa Yönetimi:** Kasanızdaki parayı otomatik olarak takip edin. Sayımlar kasaya eklenir, banka yatırma işlemleri kasadan düşülür.
*   **📉 Mutabakat:** Sayılan tutar, kasa avansı ve olması gereken tutar arasındaki farkları anında görün.
*   **📜 Geçmiş Kayıtları:** Tüm sayım ve işlem geçmişinizi detaylı bir şekilde saklayın ve dilediğiniz zaman inceleyin.
*   **🏦 Banka Yatırma:** Bankaya yatırılan tutarları kaydedin ve kasanızdan otomatik olarak düşülmesini sağlayın.
*   **📊 İstatistikler:** Net toplam ve fark grafiklerinizi görsel olarak analiz edin.
*   **💾 Yedekleme ve Geri Yükleme:** Verilerinizi kaybetmemek için yedekleyin ve dilediğiniz zaman geri yükleyin.
*   **🎓 İnteraktif Rehber:** Uygulamayı ilk kez açtığınızda sizi karşılayan adım adım kullanım rehberi.
*   **🌙 Karanlık Mod:** Göz yormayan şık karanlık tema.

## 🚀 Kurulum

Kurulum dosyasını buradan indirip Android cihazınıza yükleyebilirsiniz:
👉 [**KasaPlusBeta.apk İndir**](https://github.com/Yesanith/Kasa-Plus/releases/download/Beta/KasaPlusBeta.apk)

Alternatif olarak, kaynak koddan derlemek isterseniz:

1.  **Projeyi indirin:**
    ```bash
    git clone https://github.com/kullaniciadiniz/kasa-plus.git
    cd kasa-plus
    ```

2.  **Gerekli paketleri yükleyin:**
    ```bash
    flutter pub get
    ```

3.  **Uygulamayı çalıştırın:**
    ```bash
    flutter run
    ```

## 📖 Kullanım Kılavuzu

### 0. İlk Başlangıç (Uygulamayı İlk Açış)
Uygulamayı ilk kez çalıştırdığınızda sizi **İnteraktif Rehber** karşılayacaktır. Bu rehber, uygulamanın temel özelliklerini hızlıca öğrenmenizi sağlar.
1.  **Başlangıç Bakiyesi:** Eğer kasanızda devreden bir bakiye varsa, sol menüden **Kasa** sayfasına giderek elinizdeki banknot ve madeni paraları ilgili kutucuklara girebilirsiniz. Bu işlem kasanızın açılış bakiyesini oluşturur.
2.  **Günlük Kullanım:** Artık **Ana Sayfa** üzerinden günlük sayımlarınızı yapmaya başlayabilirsiniz.

### 1. Ana Sayfa (Para Sayma)
Uygulamanın açılış ekranıdır. Günlük sayımlarınızı buradan yaparsınız.
*   **Adet Girme:** Her bir banknot veya madeni para biriminin yanındaki kutucuğa elinizdeki adedi girin.
*   **Kasa Avansı:** Eğer güne belirli bir miktar bozuk para veya nakit ile başladıysanız, "Kasa Avansı" bölümüne girin.
*   **Olması Gereken:** Z raporunuzdaki veya sisteminizdeki olması gereken tutarı girerek farkı (açık/fazla) görebilirsiniz.
*   **Kaydet:** İşlemi bitirdiğinizde sağ alttaki "Kaydet" butonuna basın. Bu işlem kaydı geçmişe ekler ve tutarı kasaya aktarmak isteyip istemediğinizi sorar.

### 2. Kasa (Envanter)
Sol menüden "Kasa" sayfasına ulaşabilirsiniz.
*   Burada kasanızda o an fiziksel olarak bulunması gereken toplam nakit miktarını, kupür detaylarıyla birlikte görebilirsiniz.
*   **Sıfırla:** Sağ üstteki yenileme ikonuna basarak kasayı tamamen sıfırlayabilirsiniz (Örn: Gün sonu devir işlemlerinde).

### 3. Geçmiş
Yapılan tüm sayım ve banka yatırma işlemleri burada listelenir.
*   Kayıtları silmek için ilgili kaydı sola kaydırmanız yeterlidir.
*   Tüm geçmişi temizlemek için sağ üstteki çöp kutusu ikonunu kullanabilirsiniz.

### 4. Bankaya Yatırma
Sol menüden "Bankaya Yatır" seçeneği ile kasadan bankaya para çıkışı yapabilirsiniz.
*   Yatırılan tutar, mevcut kasa bakiyesinden otomatik olarak düşülür.

### 5. Yedekleme ve Geri Yükleme
Verilerinizi güvende tutmak veya başka bir cihaza taşımak için:
1.  Sol menüden **Seçenekler** sayfasına gidin.
2.  **Verileri Yedekle** butonuna basın. Açılan dosya kaydetme penceresinde dosyanın kaydedileceği konumu (İndirilenler vb.) seçin ve kaydedin.
3.  Verileri geri getirmek için **Verileri Geri Yükle** butonuna basın ve daha önce kaydettiğiniz `.json` uzantılı yedek dosyasını seçin.

## 🛠️ Kullanılan Teknolojiler

*   **[Flutter](https://flutter.dev/)** - UI Framework
*   **[Provider](https://pub.dev/packages/provider)** - Durum Yönetimi (State Management)
*   **[Shared Preferences](https://pub.dev/packages/shared_preferences)** - Veri Saklama
*   **[FL Chart](https://pub.dev/packages/fl_chart)** - Grafikler

## 📄 Lisans

Bu proje MIT Lisansı ile lisanslanmıştır.

