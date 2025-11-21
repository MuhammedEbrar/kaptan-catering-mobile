# 👥 SAMMA - Görev Checklist'i (UI & User Experience)

## 📅 Başlangıç: 10 Ekim 2025
**Rolün:** UI/UX & Frontend Geliştirme

---

## ✅ PHASE 0: Proje Kurulumu
- [x] Flutter SDK kurulumu (Windows 11)
- [x] Android Studio kurulumu
- [x] VS Code kurulumu ve eklentiler
- [x] Git kurulumu ve yapılandırma
- [x] Projeyi GitHub'dan clone'lama
- [x] `flutter pub get` çalıştırma
- [x] Emulator kurulumu (Pixel 4, API 30 önerilen)
- [x] İlk çalıştırma (`flutter run`)
- [x] Hot reload test (`r` tuşu)
- [x] Mevcut ekranları keşfet (Login, Register, Home)

---

## ✅ PHASE 1: Git Workflow Öğrenme
- [x] Git branch yapısını anlama
- [x] `feature/ui-screens` branch'i oluşturma
- [x] İlk commit yapma
- [x] GitHub'a push etme
- [x] Main'den pull alma
- [x] Merge işlemi yapma
- [x] Pull Request açma (deneme)
- [x] Conflict çözme pratiği

---

## 🔄 PHASE 3: Bottom Navigation & Ana Sayfa (ŞİMDİ)

### 3.1 Bottom Navigation Bar
- [x] `lib/presentation/widgets/custom_bottom_nav.dart` dosyasını aç
- [x] 4 tab yapısını güncelle:
- [x] Ana Sayfa (Icons.home_outlined / Icons.home)
- [x] Ürünler (Icons.shopping_bag_outlined / Icons.shopping_bag)
- [x] Profil (Icons.person_outline / Icons.person)
- [x] Menü (Icons.menu)
- [x] Aktif tab rengi: `AppColors.primary` (kırmızı)
- [x] İnaktif tab rengi: `AppColors.bottomNavInactive` (gri)
- [x] Selected/unselected icon ayrımı
- [x] Label'lar ekle
- [x] Smooth transition animasyonu

### 3.2 Main Screen (Tab Controller)
- [ ] `lib/presentation/screens/main_screen.dart` oluştur
- [ ] Scaffold yapısı
- [ ] Bottom nav entegrasyonu
- [ ] `currentIndex` state yönetimi
- [ ] IndexedStack ile 4 screen arası geçiş
- [ ] Menü (4. tab) tıklandığında bottom sheet aç
- [ ] Diğer tab'lar tıklandığında ekran değiştir

### 3.3 Ana Sayfa Layout
- [ ] `lib/presentation/screens/home/home_screen.dart` güncelle
- [ ] AppBar tasarımı:
  - [ ] Kırmızı background (`AppColors.primary`)
  - [ ] "Kaptan Catering" başlığı (centered)
  - [ ] Arama icon (sağda)
  - [ ] Bildirim icon (sağda)
- [ ] Hoş geldiniz banner:
  - [ ] Container (gradient veya solid background)
  - [ ] "Hoş Geldiniz, [Firma Adı]!" text
  - [ ] Icon veya illustration
  - [ ] Provider'dan firma adını çek
- [ ] Kategoriler horizontal scroll:
  - [ ] "Kategoriler" başlık
  - [ ] `CategoryCard` widget oluştur
  - [ ] ListView.builder horizontal
  - [ ] 8-10 kategori göster (sabit liste)
  - [ ] Her kart: Icon/Görsel + Kategori adı
  - [ ] Tıklandığında kategoriye göre ürünler sayfasına git
- [ ] Öne çıkan ürünler bölümü:
  - [ ] "Öne Çıkan Ürünler" başlık
  - [ ] Horizontal scroll (ListView.builder)
  - [ ] `ProductCardSmall` widget oluştur
  - [ ] 5-6 ürün göster (mock data veya provider'dan)
  - [ ] Her kart: Resim, Ad, Fiyat, Sepete ekle butonu
- [ ] Pull-to-refresh (RefreshIndicator)
- [ ] Shimmer loading (ilk yüklemede)

### 3.4 Ürünler Sayfası Skeleton
- [ ] `lib/presentation/screens/products/products_screen.dart` oluştur
- [ ] AppBar ("Ürünler")
- [ ] Arama bar (TextField)
  - [ ] Arama icon
  - [ ] "Ürün ara..." hint
  - [ ] onChanged ile provider'a search query gönder
- [ ] Kategori filter chips (üstte, wrap ile):
  - [ ] "Tümü", "Pilav", "Sebze", vb.
  - [ ] Seçili chip farklı renk
  - [ ] Tıklandığında filtreleme
- [ ] Grid view (2 kolon) - şimdilik boş:
  - [ ] GridView.builder
  - [ ] `ProductCard` widget oluştur (büyük)
  - [ ] Şimdilik placeholder kartlar göster
  - [ ] "Ürünler yükleniyor..." mesajı
- [ ] Pagination scroll listener hazırlığı:
  - [ ] ScrollController ekle
  - [ ] onScroll event

### 3.5 Product Card Widget
- [ ] `lib/presentation/widgets/product_card.dart` oluştur
- [ ] Card tasarımı:
  - [ ] Ürün resmi (üstte, aspect ratio 1:1)
  - [ ] Stok adı (max 2 satır, overflow ellipsis)
  - [ ] Kategori chip (küçük)
  - [ ] Fiyat (büyük, bold)
  - [ ] Birim bilgisi (kg, adet)
  - [ ] Sepete ekle icon butonu (altta sağda)
- [ ] Tıklanabilir (onTap → Detay sayfasına git)
- [ ] Hero animation hazırlığı (resim için)

### 3.6 Profil Sayfası Skeleton
- [ ] `lib/presentation/screens/profile/profile_screen.dart` oluştur
- [ ] AppBar ("Profilim")
- [ ] Kullanıcı bilgileri card:
  - [ ] CircleAvatar (profil resmi placeholder)
  - [ ] Ad soyad (Provider'dan)
  - [ ] Firma adı (Provider'dan)
  - [ ] Email (Provider'dan)
  - [ ] Düzenle icon butonu
- [ ] Menu liste items (ListTile):
  - [ ] Siparişlerim (Icons.shopping_cart)
  - [ ] Favorilerim (Icons.favorite)
  - [ ] Adreslerim (Icons.location_on)
  - [ ] Ayarlar (Icons.settings)
  - [ ] Hakkımızda (Icons.info)
  - [ ] İletişim (Icons.contact_support)
  - [ ] Çıkış yap (Icons.logout, kırmızı)
- [ ] Her item tıklanabilir (Navigator.push hazırlık)

### 3.7 Menü Bottom Sheet
- [ ] `lib/presentation/widgets/menu_bottom_sheet.dart` dosyasını aç
- [ ] showModalBottomSheet ile açılış
- [ ] Animasyonlu açılış (slide up from bottom)
- [ ] Handle bar (üstte küçük gri çizgi)
- [ ] İçerik:
  - [ ] "Menü" başlığı
  - [ ] Hakkımızda ListTile (Icon + Text + chevron)
  - [ ] İletişim ListTile
- [ ] Hakkımızda sayfası oluştur:
  - [ ] `lib/presentation/screens/about/about_screen.dart`
  - [ ] Şirket bilgileri (mock text)
  - [ ] Logo
- [ ] İletişim sayfası oluştur:
  - [ ] `lib/presentation/screens/contact/contact_screen.dart`
  - [ ] Telefon, Email, Adres (mock)
  - [ ] "Ara" butonu (url_launcher ile)
  - [ ] "Email gönder" butonu
- [ ] Bottom sheet dışına tıklayınca kapansın

---

## 🔄 PHASE 5: Ürün Detay Sayfası

### 5.1 Product Detail Screen
- [ ] `lib/presentation/screens/products/product_detail_screen.dart` oluştur
- [ ] AppBar (transparent, back butonu)
- [ ] Hero animation (ürün resmi için)
- [ ] SingleChildScrollView (scroll yapılabilir)
- [ ] Ürün fotoğrafı:
  - [ ] Container (height 300)
  - [ ] CachedNetworkImage
  - [ ] Zoom özelliği (InteractiveViewer veya photo_view paketi)
  - [ ] PageView (çok resim varsa)
  - [ ] Page indicator (dots)
- [ ] Stok kodu badge:
  - [ ] Positioned (üst sol)
  - [ ] Container (rounded, background)
  - [ ] "SKU: 12345" formatı
- [ ] Ürün bilgileri card:
  - [ ] Stok adı (büyük başlık, 24px)
  - [ ] Kategori chip (tıklanabilir)
  - [ ] Birim badge (kg, adet, litre)

### 5.2 Fiyat Gösterimi Card
- [ ] Fiyat card (Card widget):
  - [ ] Büyük, bold fiyat (32px)
  - [ ] ₺ sembolü
  - [ ] Row layout
- [ ] KDV toggle switch:
  - [ ] "KDV Dahil" / "KDV Hariç" Switch
  - [ ] State değişince fiyat güncellenir
  - [ ] Provider'dan KDV oranı al
- [ ] Stok durumu indicator:
  - [ ] Container (rounded)
  - [ ] Yeşil: "Stokta var" (Icons.check_circle)
  - [ ] Kırmızı: "Stokta yok" (Icons.cancel)

### 5.3 Miktar Seçici Widget
- [ ] `lib/presentation/widgets/quantity_selector.dart` oluştur
- [ ] Row layout:
  - [ ] - butonu (IconButton, circle)
  - [ ] Miktar TextField (center aligned, number keyboard)
  - [ ] + butonu (IconButton, circle)
- [ ] Birim gösterimi yanında ("5 kg" formatı)
- [ ] Minimum miktar kontrolü:
  - [ ] Provider'dan minSiparisMiktari al
  - [ ] Altına düşmesin
  - [ ] SnackBar ile uyarı göster
- [ ] Maksimum miktar kontrolü (stok miktarı)
- [ ] Animasyon (ScaleTransition on tap)

### 5.4 Aksiyonlar
- [ ] Sepete ekle butonu:
  - [ ] ElevatedButton (full width)
  - [ ] Büyük (height 56)
  - [ ] Kırmızı background
  - [ ] "Sepete Ekle - [Fiyat]" text
  - [ ] onPressed → CartProvider.addToCart()
  - [ ] Loading state (CircularProgressIndicator)
  - [ ] Success animation (checkmark)
  - [ ] SnackBar "Sepete eklendi!"
- [ ] Favorilere ekle icon:
  - [ ] AppBar'da (sağ üst)
  - [ ] IconButton (favorite / favorite_border)
  - [ ] Dolu/boş kalp animasyonu
  - [ ] Tıklayınca favorilere ekle/çıkar
- [ ] Paylaş butonu (opsiyonel):
  - [ ] share_plus paketi
  - [ ] Ürün linkini paylaş

### 5.5 Ek Bilgiler
- [ ] Ürün açıklaması bölümü:
  - [ ] ExpansionTile ("Ürün Detayları")
  - [ ] Açıklama text (eğer varsa)
  - [ ] Genişletilebilir (expand/collapse)
- [ ] Benzer ürünler:
  - [ ] "Benzer Ürünler" başlık
  - [ ] Horizontal ListView
  - [ ] ProductCardSmall kullan
  - [ ] Aynı kategoriden 5-6 ürün
  - [ ] Provider'dan çek

---

## 🔄 PHASE 6: Sepet & Ödeme

### 6.1 Sepet Sayfası
- [ ] `lib/presentation/screens/cart/cart_screen.dart` oluştur
- [ ] AppBar ("Sepetim", "[X] Ürün" subtitle)
- [ ] Sepet ürün kartları:
  - [ ] `CartItemCard` widget oluştur
  - [ ] Dismissible (swipe-to-delete)
  - [ ] Row layout:
    - [ ] Ürün resmi (80x80, küçük)
    - [ ] Column (ürün bilgileri):
      - [ ] Ürün adı (max 2 satır)
      - [ ] Birim ve miktar ("5 kg")
      - [ ] Birim fiyat
    - [ ] Column (sağda):
      - [ ] Toplam fiyat (bold)
      - [ ] Miktar güncelleme (+/-)
      - [ ] Sil icon butonu
- [ ] Sepet boş durumu:
  - [ ] Center widget
  - [ ] Empty state illustration (asset veya Lottie)
  - [ ] "Sepetiniz boş" text
  - [ ] "Alışverişe başla" butonu → Ana sayfaya git
- [ ] Slide/Fade animasyonları (item eklenince/silinince)
- [ ] ListView.builder

### 6.2 Sepet Özeti Card (Sticky Bottom)
- [ ] Sticky bottom card (Positioned veya SliverPersistentHeader)
- [ ] Card içeriği:
  - [ ] Ara toplam row
  - [ ] KDV tutarı row (%18)
  - [ ] Kargo row (varsa, yoksa gösterme)
  - [ ] Divider
  - [ ] Toplam row (büyük, bold)
- [ ] "Siparişi Tamamla" butonu:
  - [ ] ElevatedButton (full width)
  - [ ] Kırmızı
  - [ ] onPressed → Checkout sayfasına git

### 6.3 Checkout Screen (Sipariş Adımları)
- [ ] `lib/presentation/screens/cart/checkout_screen.dart` oluştur
- [ ] AppBar ("Sipariş Özeti")
- [ ] Stepper widget (3 adım):
  - [ ] Step 1: Teslimat Adresi
  - [ ] Step 2: Ödeme Yöntemi
  - [ ] Step 3: Sipariş Özeti
- [ ] currentStep state yönetimi
- [ ] "İleri" ve "Geri" butonları

### 6.4 Teslimat Adresi (Step 1)
- [ ] Kayıtlı adresler listesi:
  - [ ] Radio button ile seçim
  - [ ] Adres kartları (Card):
    - [ ] Adres başlığı (bold)
    - [ ] Tam adres (2-3 satır)
    - [ ] Telefon
    - [ ] "Varsayılan" badge (eğer default ise)
    - [ ] Edit/Delete icon butonları
- [ ] "Yeni adres ekle" butonu (OutlinedButton)
- [ ] Adres formu modal (showModalBottomSheet):
  - [ ] Adres başlığı TextField
  - [ ] Tam adres TextField (maxLines: 3)
  - [ ] İl dropdown
  - [ ] İlçe dropdown
  - [ ] Telefon TextField
  - [ ] "Varsayılan adres yap" Checkbox
  - [ ] "Kaydet" butonu
- [ ] Form validasyonları (empty check)

### 6.5 Ödeme Yöntemi (Step 2)
- [ ] Radio button ile seçim (RadioListTile):
  - [ ] Ödeme 1: İyzico (Kredi/Banka Kartı)
    - [ ] Leading: Kart icon (Icons.credit_card)
    - [ ] Title: "Kredi/Banka Kartı"
    - [ ] Subtitle: "Güvenli ödeme"
    - [ ] Trailing: "Güvenli ödeme" badge (yeşil)
  - [ ] Ödeme 2: Kapıda Ödeme
    - [ ] Leading: Nakit icon (Icons.money)
    - [ ] Title: "Kapıda Ödeme"
    - [ ] Subtitle: "Teslimat sırasında nakit veya POS ile ödeyin"
- [ ] Seçili ödeme yöntemi state

### 6.6 İyzico Ödeme Entegrasyonu
- [ ] İyzico webview widget oluştur
- [ ] webview_flutter paketi ekle
- [ ] Checkout URL'i backend'den al (API call)
- [ ] WebView ile URL'i aç
- [ ] Loading indicator (CircularProgressIndicator)
- [ ] JavaScript channel ile callback yakalama:
  - [ ] Success callback → Sipariş oluştur
  - [ ] Error callback → Hata göster
- [ ] Close butonu (AppBar'da)
- [ ] Back navigation handling

### 6.7 Sipariş Özeti (Step 3)
- [ ] Sipariş bilgileri card:
  - [ ] "Sipariş Özeti" başlık
  - [ ] Ürün listesi (özet):
    - [ ] Her ürün: Ad, Miktar, Fiyat
    - [ ] Scrollable (max 3 ürün göster, "X ürün daha" text)
  - [ ] Teslimat adresi (özet):
    - [ ] Icon + Adres başlığı
    - [ ] Tam adres (1 satır, ellipsis)
    - [ ] "Değiştir" butonu
  - [ ] Ödeme yöntemi:
    - [ ] Icon + Yöntem adı
    - [ ] "Değiştir" butonu
  - [ ] Tutar özeti:
    - [ ] Ara toplam
    - [ ] KDV
    - [ ] Kargo (varsa)
    - [ ] Genel toplam (büyük, bold)
- [ ] Sipariş notu (opsiyonel):
  - [ ] TextField (multiline)
  - [ ] "Sipariş notunuz varsa yazabilirsiniz" hint
- [ ] Terms & Conditions:
  - [ ] CheckboxListTile
  - [ ] "Kullanım koşullarını kabul ediyorum" text
  - [ ] Tıklanabilir link (showDialog ile şartları göster)
- [ ] "Siparişi Onayla" butonu:
  - [ ] ElevatedButton (full width, büyük)
  - [ ] Kırmızı background
  - [ ] onPressed:
    - [ ] Terms kabul edilmemişse error göster
    - [ ] OrderProvider.createOrder() çağır
    - [ ] Loading state
    - [ ] Success → Success sayfasına git
    - [ ] Error → SnackBar ile hata göster

### 6.8 Sipariş Başarılı Sayfası
- [ ] `lib/presentation/screens/cart/order_success_screen.dart` oluştur
- [ ] AppBar (gizli, sadece back butonu yok)
- [ ] Center layout
- [ ] Success animasyonu:
  - [ ] Lottie animation (başarı checkmark) VEYA
  - [ ] Custom animasyon (ScaleTransition ile büyüyen checkmark icon)
  - [ ] Yeşil renk
- [ ] "Siparişiniz Alındı!" text (büyük, bold)
- [ ] Sipariş numarası:
  - [ ] Container (rounded, border)
  - [ ] "Sipariş No: #12345" formatı
- [ ] Bilgilendirme text:
  - [ ] "Siparişiniz hazırlanıyor"
  - [ ] "Sipariş durumunu takip edebilirsiniz"
- [ ] Aksiyon butonları:
  - [ ] "Siparişlerimi Görüntüle" (Primary button)
    - [ ] Siparişlerim sayfasına git
  - [ ] "Ana Sayfaya Dön" (Outlined button)
    - [ ] Ana sayfaya git
    - [ ] Sepeti temizle

---

## 🔄 PHASE 7: Profil & Siparişler

### 7.1 Profil Düzenleme
- [ ] `lib/presentation/screens/profile/edit_profile_screen.dart` oluştur
- [ ] AppBar ("Profili Düzenle")
- [ ] Form yapısı (Form widget + GlobalKey)
- [ ] Profil fotoğrafı seçimi:
  - [ ] CircleAvatar (büyük, 120px)
  - [ ] Overlay (kamera icon butonu)
  - [ ] image_picker paketi
  - [ ] Kamera/Galeri seçimi (showDialog)
- [ ] Form fields:
  - [ ] Ad soyad TextField
  - [ ] Email TextField (disabled, read-only)
  - [ ] Telefon TextField (mask: 0(555) 555-5555)
  - [ ] Firma adı TextField (disabled)
- [ ] Validasyonlar:
  - [ ] Empty check
  - [ ] Telefon formatı
- [ ] "Kaydet" butonu:
  - [ ] FloatingActionButton VEYA Bottom button
  - [ ] onPressed → Provider.updateProfile()
  - [ ] Loading state
  - [ ] Success → Pop back
  - [ ] SnackBar "Profil güncellendi"

### 7.2 Siparişlerim Sayfası
- [ ] `lib/presentation/screens/orders/orders_screen.dart` oluştur
- [ ] AppBar ("Siparişlerim")
- [ ] TabBar (duruma göre filtreleme):
  - [ ] Tab 1: "Tümü"
  - [ ] Tab 2: "Aktif" (Hazırlanıyor, Kargoda)
  - [ ] Tab 3: "Tamamlanan"
- [ ] TabBarView (3 liste)
- [ ] Sipariş kartları:
  - [ ] `OrderCard` widget oluştur
  - [ ] Card design:
    - [ ] Row layout
    - [ ] Sol: Sipariş icon (Icons.receipt_long)
    - [ ] Orta: Column:
      - [ ] Sipariş no (#12345)
      - [ ] Tarih (formatlanmış: 10 Eki 2025)
      - [ ] Ürün sayısı (5 ürün)
    - [ ] Sağ: Column:
      - [ ] Durum badge (renkli, rounded):
        - [ ] Ödeme Bekliyor (turuncu)
        - [ ] Hazırlanıyor (mavi)
        - [ ] Kargoda (mor)
        - [ ] Teslim Edildi (yeşil)
        - [ ] İptal Edildi (kırmızı)
      - [ ] Toplam tutar (bold)
  - [ ] onTap → Sipariş detay sayfasına git
- [ ] Pull-to-refresh (RefreshIndicator)
- [ ] Boş durum (her tab için):
  - [ ] Empty state illustration
  - [ ] "Henüz sipariş yok" text
  - [ ] "Alışverişe başla" butonu
- [ ] ListView.separated

### 7.3 Sipariş Detay Sayfası
- [ ] `lib/presentation/screens/orders/order_detail_screen.dart` oluştur
- [ ] AppBar ("Sipariş Detayı", subtitle: sipariş no)
- [ ] SingleChildScrollView
- [ ] Sipariş bilgileri card:
  - [ ] Sipariş no
  - [ ] Sipariş tarihi
  - [ ] Durum badge (büyük)
- [ ] Ürün listesi card:
  - [ ] "Sipariş Ürünleri" başlık
  - [ ] ExpansionTile (genişletilebilir)
  - [ ] Her ürün:
    - [ ] Row: Resim, Ad, Miktar, Fiyat
    - [ ] Divider
- [ ] Teslimat adresi card:
  - [ ] Icon + "Teslimat Adresi"
  - [ ] Adres bilgileri
  - [ ] Telefon
- [ ] Ödeme bilgisi card:
  - [ ] Ödeme yöntemi icon + text
  - [ ] Ara toplam, KDV, Genel toplam
- [ ] Sipariş durumu tracking:
  - [ ] Stepper/Timeline widget kullan VEYA
  - [ ] Custom vertical timeline:
    - [ ] Her adım: Icon, Başlık, Tarih
    - [ ] Renkli durumlar:
      - [ ] Sipariş Alındı (yeşil, completed)
      - [ ] Ödeme Onaylandı (yeşil/mavi, completed)
      - [ ] Hazırlanıyor (mavi, active)
      - [ ] Kargoya Verildi (gri, pending)
      - [ ] Teslim Edildi (gri, pending)
    - [ ] Aktif adım büyük, diğerleri küçük
- [ ] Aksiyon butonları:
  - [ ] "Tekrar Sipariş Ver" (Outlined button)
    - [ ] Sepeti temizle
    - [ ] Siparişteki ürünleri sepete ekle
    - [ ] Sepet sayfasına git
  - [ ] "Fatura İndir" (opsiyonel, IconButton)
    - [ ] PDF oluştur (pdf paketi)
    - [ ] Paylaş veya indir

### 7.4 Favoriler Sayfası
- [ ] `lib/presentation/screens/favorites/favorites_screen.dart` oluştur
- [ ] AppBar ("Favorilerim")
- [ ] GridView.builder (2 kolon)
- [ ] ProductCard widget kullan
- [ ] Her kartta:
  - [ ] Favori icon (dolu kalp, kırmızı)
  - [ ] Tıklayınca favoriden çıkar
  - [ ] Animasyon (scale out)
- [ ] Sepete ekle butonu (hızlı ekleme)
- [ ] Boş durum:
  - [ ] Center layout
  - [ ] Empty illustration (kalp icon)
  - [ ] "Henüz favori ürün yok" text
  - [ ] "Keşfet" butonu → Ürünler sayfasına git
- [ ] Pull-to-refresh

### 7.5 Adreslerim Sayfası
- [ ] `lib/presentation/screens/profile/addresses_screen.dart` oluştur
- [ ] AppBar ("Adreslerim")
- [ ] Adres kartları listesi (ListView.builder):
  - [ ] Card widget
  - [ ] Adres başlığı (bold, büyük)
  - [ ] Tam adres (2-3 satır)
  - [ ] Telefon
  - [ ] "Varsayılan" badge (eğer default ise, yeşil)
  - [ ] Row (altta):
    - [ ] Edit icon butonu → Adres düzenleme modal
    - [ ] Delete icon butonu → Silme onay dialog
- [ ] FloatingActionButton:
  - [ ] Icon: Icons.add
  - [ ] onPressed → Yeni adres formu modal
- [ ] Boş durum (adres yoksa):
  - [ ] "Henüz adres eklenmemiş"
  - [ ] "Adres ekle" butonu

### 7.6 Ayarlar Sayfası
- [ ] `lib/presentation/screens/settings/settings_screen.dart` oluştur
- [ ] AppBar ("Ayarlar")
- [ ] ListView (grouped settings):
  - [ ] **Bildirim Ayarları** (başlık):
    - [ ] SwitchListTile: "Sipariş bildirimleri"
    - [ ] SwitchListTile: "Kampanya bildirimleri"
    - [ ] SwitchListTile: "Ürün bildirimleri"
  - [ ] Divider
  - [ ] **Uygulama Ayarları** (başlık):
    - [ ] ListTile: "Dil" (trailing: "Türkçe", arrow)
      - [ ] onTap → Dil seçimi dialog (TR/EN)
    - [ ] ListTile: "Tema" (trailing: "Açık", arrow)
      - [ ] onTap → Tema seçimi dialog (Açık/Koyu)
  - [ ] Divider
  - [ ] **Bilgi** (başlık):
    - [ ] ListTile: "Hakkımızda"
      - [ ] onTap → Hakkımızda sayfası
    - [ ] ListTile: "Gizlilik Politikası"
      - [ ] onTap → Gizlilik sayfası (webview)
    - [ ] ListTile: "Kullanım Şartları"
      - [ ] onTap → Şartlar sayfası (webview)
    - [ ] ListTile: "İletişim"
      - [ ] onTap → İletişim sayfası
  - [ ] Divider
  - [ ] ListTile: "Çıkış Yap" (kırmızı text)
    - [ ] onTap → Onay dialog:
      - [ ] "Çıkış yapmak istediğinize emin misiniz?"
      - [ ] İptal / Çıkış yap butonları
      - [ ] Çıkış → Provider.logout()
      - [ ] Login sayfasına yönlendir

---

## 🔄 PHASE 8: Push Notifications

### 8.1 Firebase Project Setup
- [ ] Firebase Console'a git (console.firebase.google.com)
- [ ] Yeni proje oluştur: "Kaptan Catering"
- [ ] Android app ekle:
  - [ ] Package name: com.example.kaptancateringmobile (veya gerçek package)
  - [ ] App nickname: Kaptan Catering Android
  - [ ] SHA-1 certificate (opsiyonel)
- [ ] google-services.json indir
- [ ] `android/app/` klasörüne kopyala
- [ ] iOS app ekle (eğer yapılacaksa):
  - [ ] Bundle ID
  - [ ] GoogleService-Info.plist indir
  - [ ] `ios/Runner/` klasörüne kopyala

### 8.2 Firebase Packages
- [ ] pubspec.yaml'a ekle:
  - [ ] firebase_core
  - [ ] firebase_messaging
- [ ] `flutter pub get`
- [ ] `android/build.gradle` güncelle (classpath ekle)
- [ ] `android/app/build.gradle` güncelle (plugin ekle)

### 8.3 FCM Configuration
- [ ] `lib/core/services/notification_service.dart` oluştur
- [ ] Firebase initialize:
  - [ ] `Firebase.initializeApp()`
  - [ ] main.dart'ta çağır
- [ ] FCM token alma:
  - [ ] `FirebaseMessaging.instance.getToken()`
  - [ ] Token'ı console'da logla
  - [ ] Token'ı backend'e gönder (opsiyonel)
- [ ] Foreground notification handler:
  - [ ] `FirebaseMessaging.onMessage.listen()`
  - [ ] Local notification göster (flutter_local_notifications)
- [ ] Background notification handler:
  - [ ] `FirebaseMessaging.onBackgroundMessage()`
  - [ ] Top-level function oluştur
- [ ] Notification tıklandığında routing:
  - [ ] `FirebaseMessaging.onMessageOpenedApp.listen()`
  - [ ] Payload'dan sayfa belirle
  - [ ] Navigator ile ilgili sayfaya git

### 8.4 Local Notifications
- [ ] flutter_local_notifications paketi ekle
- [ ] Android notification channel oluştur
- [ ] Notification gösterme fonksiyonu:
  - [ ] Başlık, mesaj, icon
  - [ ] Payload (routing için)
- [ ] Foreground'da bildirim gelince göster

### 8.5 Bildirimler Sayfası
- [ ] `lib/presentation/screens/notifications/notifications_screen.dart` oluştur
- [ ] AppBar ("Bildirimler")
- [ ] Bildirim listesi (ListView.builder):
  - [ ] `NotificationCard` widget oluştur
  - [ ] Card design:
    - [ ] Leading: Icon (tip göre değişir):
      - [ ] Sipariş: Icons.shopping_cart
      - [ ] Kampanya: Icons.local_offer
      - [ ] Genel: Icons.notifications
    - [ ] Title: Bildirim başlığı (bold)
    - [ ] Subtitle: Bildirim mesajı (2 satır max)
    - [ ] Trailing: Tarih (küçük, gri)
    - [ ] Okunmadı indicator (mavi nokta, sol)
  - [ ] onTap → Bildirim detayı veya ilgili sayfaya git
  - [ ] Okundu/okunmadı state
- [ ] "Tümünü okundu işaretle" butonu (AppBar action)
- [ ] Boş durum:
  - [ ] "Henüz bildirim yok"
  - [ ] Bildirim icon
- [ ] Pull-to-refresh

---

## 🔄 PHASE 9: Polish & Final Touches

### 9.1 Animasyonlar
- [ ] Hero animations:
  - [ ] Product card → Product detail (resim için)
- [ ] Page transitions:
  - [ ] Custom PageRouteBuilder
  - [ ] Fade + Slide transition
- [ ] Button animations:
  - [ ] InkWell ripple effect
  - [ ] ScaleTransition on tap
- [ ] Success animations:
  - [ ] Checkmark (sepete eklendi)
  - [ ] Sipariş başarılı
- [ ] Loading animations:
  - [ ] Shimmer loading (ürün listesi)
  - [ ] Skeleton screens
- [ ] Swipe-to-delete animations:
  - [ ] Dismissible background (kırmızı, delete icon)
  - [ ] Slide out animation

### 9.2 Empty States (Tüm Listelerde)
- [ ] Ürünler sayfası (ürün bulunamadı)
- [ ] Sepet (sepet boş)
- [ ] Siparişler (sipariş yok)
- [ ] Favoriler (favori yok)
- [ ] Adresler (adres yok)
- [ ] Bildirimler (bildirim yok)
- [ ] Her biri için:
  - [ ] Illustration veya icon
  - [ ] Açıklayıcı text
  - [ ] Aksiyon butonu

### 9.3 Error States
- [ ] Network error:
  - [ ] "İnternet bağlantısı yok" illustration
  - [ ] "Tekrar dene" butonu
- [ ] Server error:
  - [ ] "Bir şeyler ters gitti" illustration
  - [ ] "Tekrar dene" butonu
- [ ] 404 (ürün bulunamadı):
  - [ ] "Ürün bulunamadı" text
  - [ ] "Ana sayfaya dön" butonu

### 9.4 Loading States
- [ ] Shimmer effect (shimmer paketi):
  - [ ] Product card skeleton
  - [ ] List item skeleton
- [ ] CircularProgressIndicator (merkezde)
- [ ] LinearProgressIndicator (üstte, AppBar altı)

### 9.5 Accessibility
- [ ] Semantics labels ekle (tüm interactive widgets)
- [ ] Contrast ratios kontrol et (WCAG 2.1)
- [ ] Touch targets minimum 48x48
- [ ] Font scaling test (büyük font)
- [ ] Screen reader test (TalkBack/VoiceOver)

### 9.6 Responsive Design
- [ ] Tablet layout kontrolü (MediaQuery)
- [ ] Landscape orientation desteği
- [ ] Safe area kontrolü (notch, home indicator)

### 9.7 Performance Optimization
- [ ] Image caching (CachedNetworkImage)
- [ ] List lazy loading
- [ ] Build optimizasyonu (const widgets)
- [ ] Unnecessary rebuilds önleme

---

## 📊 İlerleme

- **Toplam Görev:** ~75
- **Tamamlanan:** 0
- **Kalan:** 75

**Tahmini Süre:**
- Phase 3: 1 hafta
- Phase 5: 3-4 gün
- Phase 6: 5-6 gün
- Phase 7: 1 hafta
- Phase 8: 2-3 gün
- Phase 9: 3-4 gün

**Toplam:** ~4-5 hafta

---

## 🚨 ÖNEMLİ HATIRLATMALAR

1. ✅ **Her gün main'den pull et**
2. ✅ **Küçük, sık commit'ler yap**
3. ✅ **Data layer'a (models, datasources, repositories) dokunma**
4. ✅ **Provider'ları sadece consume et (watch/read), değiştirme**
5. ✅ **Mock data ile UI test et, backend hazır olunca entegre edilir**
6. ✅ **Conflict çıkarsa hemen haber ver**
7. ✅ **Commit mesajları açıklayıcı olsun:**
   - ✅ `feat: Product detail screen UI tamamlandı`
   - ✅ `style: Bottom navigation bar renkleri güncellendi`
   - ✅ `fix: Sepet boş durum gösterimi düzeltildi`
   - ❌ `update` veya `fix`

---

## 📞 Koordinasyon Notları

### Arkadaşından Beklemen Gerekenler:
- "ProductProvider hazır, `context.watch<ProductProvider>()` ile kullan"
- "products listesi `List<ProductModel>` formatında"
- "CartProvider'da `addToCart(product, quantity)` fonksiyonu var"
- "isLoading ve errorMessage state'lerini kontrol et"

### Arkadaşına Söylemen Gerekenler:
- "Bottom navigation tamamlandı, main_screen.dart kullan"
- "ProductCard widget'ı ProductModel bekliyor"
- "Sepete ekle butonuna `CartProvider.addToCart()` bağladım"
- "Arama çubuğunda `onChanged` ile `searchProducts()` çağrılıyor"

---

**Son Güncelleme:** 10 Ekim 2025
**Sıradaki Görev:** Phase 0 - Proje kurulumu (Windows 11)