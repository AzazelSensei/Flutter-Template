# 🎬 Flutter Architecture Template

Bu proje, **Flutter** ile geliştirilen modern Android ve iOS uygulamaları için sağlam bir **Başlangıç Şablonu (Boilerplate)** ve **Referans Mimarisi** niteliğindedir.

Uygulama, **Clean Architecture (Temiz Mimari)**, **Ölçeklenebilirlik** ve **Sürdürülebilirlik** ilkeleri üzerine inşa edilmiştir. Büyük ölçekli projelerde kullanılabilecek standartları ve en iyi pratikleri (Best Practices) barındırır.

---

## 🏗 Mimari ve Tasarım Desenleri

Proje, endüstri standartlarında kabul görmüş katı **Clean Architecture** prensiplerini takip eder.

-   **Mimari**: Clean Architecture (Data, Domain, Presentation Katmanları)
-   **State Management (Durum Yönetimi)**: Tahmin edilebilir durum yönetimi için [BLoC (Business Logic Component)](https://pub.dev/packages/flutter_bloc) deseni.
-   **Initialization System**: Uygulama açılış süreçlerini (Firebase, DI, Cache) öncelik ve hata toleransı ile yöneten **Adapter Pattern** tabanlı modüler başlatma sistemi.
-   **Dependency Injection (Bağımlılık Enjeksiyonu)**: Servislerin birbirinden ayrılması ve test edilebilirlik için [GetIt](https://pub.dev/packages/get_it).
-   **Fonksiyonel Programlama**: Hata yönetimi ve yan etkilerin kontrolü (`Either` türü) için [Dartz](https://pub.dev/packages/dartz).

## 🛠 Teknoloji Yığını

Bu şablonda, prodüksiyon seviyesindeki uygulamalar için gerekli güçlü kütüphaneler entegre edilmiştir:

### Çekirdek (Core)
-   **Flutter & Dart**: En son kararlı sürümler.
-   **Navigation Service**: GlobalKey tabanlı, context-bağımsız navigasyon yönetimi. (BLoC katmanından veya Interceptor'lardan sayfa yönetimi sağlar).
-   **Flutter ScreenUtil**: Tüm cihaz boyutlarında piksel mükemmelliği sağlayan responsive yapı.
-   **Centralized Error Handler**: Hata tiplerine göre (Network, Auth, Server) özel aksiyonlar alan ve kullanıcıyı bilgilendiren merkezi yapı.

### Veri ve Ağ (Data & Networking)
-   **Dio**: API iletişimi için interceptor destekli güçlü HTTP istemcisi.
-   **Freezed & JsonSerializable**: Boilerplate kodu azaltan Immutable (değişmez) veri modelleri.
-   **Flutter Secure Storage**: Token ve hassas veriler için güvenli saklama alanı.

### Backend Entegrasyonu
-   **Firebase Eco-system**: Analytics, Crashlytics ve Core entegrasyonları hazır.

### State Persistence (Durum Kalıcılığı)
-   **Theme & Locale Storage**: Kullanıcının tema ve dil tercihleri güvenli bir şekilde saklanır ve uygulama yeniden başlatıldığında hatırlanır.

### UI/UX
-   **Lottie**: Zengin animasyon desteği.
-   **Cached Network Image**: Akıllı resim önbellekleme mekanizması.
-   **Flutter SVG**: Ölçeklenebilir vektör grafikler.

---

## 🚀 Kullanım ve Kurulum

Bu projeyi yeni bir uygulamanın temeli olarak kullanmak için:

### Önkoşullar
-   Flutter SDK
-   Dart SDK
-   VS Code veya Android Studio

### Kurulum

1.  **Repoyu klonlayın**
    ```bash
    git clone <repository_url>
    cd flutter_template
    ```

2.  **Bağımlılıkları yükleyin**
    ```bash
    flutter pub get
    ```

3.  **Kod Üretimini Çalıştırın** (Freezed model üretimleri için)
    ```bash
    dart run build_runner build --delete-conflicting-outputs
    ```

4.  **Uygulamayı Çalıştırın**
    ```bash
    flutter run
    ```

---

## 🔐 Konfigürasyon ve Güvenlik

Bu proje güvenlik nedeniyle bazı konfigürasyon dosyalarını (API Key'leri, Secrets vb.) içermez. Projeyi kendi ortamınızda çalıştırmak için aşağıdaki adımları tamamlamanız gerekir.

### 1. Environment Variables (.env)
Proje kök dizininde `.env` dosyası oluşturun ve gerekli değişkenleri tanımlayın. Örnek dosya `.env.example`'dan yararlanabilirsiniz:

```bash
cp .env.example .env
```
`.env` dosyasının içeriğini kendi API adresinize göre düzenleyin:
```ini
BASE_URL=https://api.example.com
```

### 2. Firebase Kurulumu
Projedeki Firebase konfigürasyon dosyaları (google-services.json vb.) güvenlik nedeniyle repoya dahil edilmemiştir. Kendi Firebase projenizi bağlamak için:

1.  [Firebase Console](https://console.firebase.google.com/)'dan yeni proje oluşturun.
2.  **FlutterFire CLI** kullanarak projenizi yapılandırın:
    ```bash
    flutterfire configure
    ```
    *(Bu işlem otomatik olarak `lib/firebase_options.dart` ve platform özelindeki config dosyalarını oluşturacaktır.)*

Alternatif olarak (Manuel):
*   **Android**: `google-services.json` dosyasını `android/app/` dizinine ekleyin.
*   **iOS**: `GoogleService-Info.plist` dosyasını `ios/Runner/` dizinine ekleyin (ve Xcode üzerinden projeye dahil edin).

---

## 👨‍💻 Geliştirici

**[Abdullah Gökmen]**  
*Yazılım Mühendisi*  
