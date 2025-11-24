# 👥 ŞEMMA - Görev Checklist'i (UI & User Experience)

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

## ✅ PHASE 3: Bottom Navigation & Ana Sayfa
- [x] Bottom Navigation Bar (4 tab)
- [x] Main Screen (Tab Controller)
- [x] Ana Sayfa Layout (AppBar, Banner, Kategoriler)
- [x] Ürünler Sayfası Skeleton
- [x] Product Card Widget
- [x] Profil Sayfası Skeleton
- [x] Menü Bottom Sheet

---

## ✅ PHASE 5: Ürün Detay Sayfası
- [x] Product Detail Screen
- [x] Fiyat Gösterimi Card
- [x] Miktar Seçici Widget
- [x] Sepete ekle butonu
- [x] Favorilere ekle icon
- [x] Ürün açıklaması bölümü

---

## ✅ PHASE 6: Sepet & Ödeme
- [x] Sepet Sayfası
- [x] Sepet Özeti Card (Sticky Bottom)
- [x] Checkout Screen (Sipariş Adımları)
- [x] Teslimat Adresi (Step 1)
- [x] Ödeme Yöntemi (Step 2)
- [x] Sipariş Özeti (Step 3)
- [x] Sipariş Başarılı Sayfası

---

## ✅ PHASE 7: Profil & Siparişler
- [x] Profil Düzenleme
- [x] Siparişlerim Sayfası
- [x] Sipariş Detay Sayfası
- [x] Favoriler Sayfası
- [x] Adreslerim Sayfası
- [x] Ayarlar Sayfası

---

## ✅ PHASE 9: UI/UX İyileştirmeleri
- [x] Animasyonlar (Hero, Page transitions, Button animations)
- [x] Empty States (Tüm listelerde)
- [x] Error States (Network, Server, 404)
- [x] Loading States (Shimmer, Progress indicators)
- [x] Success animations
- [x] Pull-to-refresh görsel feedback

---

## 🔄 YENİ REVİZYON - MÜŞTERİ TİPİ & ADMIN ONAY SİSTEMİ

### ✅ PHASE 12: Kayıt Ekranı Güncelleme
- [x] **Müşteri Tipi Dropdown Tasarımı**
  - [x] Dropdown container border & radius
  - [x] Emoji + isim birlikte gösterimi (🏫 Okul, 🍽️ Restoran, 🏨 Otel)
  - [x] Hover/Focus states
  - [x] Placeholder text ("İşletme türünü seçin")
- [x] **Form Layout Düzenleme**
  - [x] Müşteri tipi alanı en üste konumlandırma
  - [x] Zorunlu alan yıldızı (*) ekle
  - [x] Label typography düzenleme
  - [x] Spacing ayarları (16-24px arası)
- [x] **Validation Feedback**
  - [x] Seçim yapılmadıysa hata mesajı (SnackBar)
  - [x] Snackbar tasarımı (kırmızı background)
  - [x] Error state gösterimi

---

## ⏳ PHASE 13: Admin Onay Sistemi UI (PLANLANAN)

### 13.1 Onay Bekleyen Kullanıcı Ekranı
- [ ] `lib/presentation/screens/auth/pending_approval_screen.dart` oluştur
- [ ] AppBar ("Hesap Durumu")
- [ ] Center layout:
  - [ ] Bilgilendirme kartı tasarımı
    - [ ] Card widget (rounded, shadow)
    - [ ] Icon gösterimi (Icons.pending_actions, turuncu, büyük 80px)
    - [ ] "Hesabınız Onay Bekliyor" başlık (bold, 24px)
    - [ ] Açıklama text (16px, gri):
      - [ ] "Yöneticilerimiz başvurunuzu inceliyor"
      - [ ] "Onaylandığında email ile bilgilendirileceksiniz"
    - [ ] Divider
    - [ ] İletişim bilgisi section:
      - [ ] "Sorularınız için:" text (bold)
      - [ ] Email: info@kaptancatering.com (tıklanabilir)
      - [ ] Telefon: 0212 XXX XX XX (tıklanabilir)
    - [ ] Spacing: 24px between sections
- [ ] Alt kısım:
  - [ ] "Çıkış Yap" butonu (OutlinedButton, kırmızı border)
  - [ ] onPressed → Logout & Login sayfasına dön
- [ ] Background color: `AppColors.backgroundLight`
- [ ] Animasyon: Fade in + Slide from bottom

### 13.2 Profil Ekranında Durum Badge'i
- [ ] Profile screen'de kullanıcı bilgileri card'ına badge ekle
- [ ] Badge widget oluştur: `lib/presentation/widgets/status_badge.dart`
- [ ] Badge tasarımı:
  - [ ] Container (rounded 20px, padding: 8x16)
  - [ ] Row layout: Icon + Text
  - [ ] 3 durum:
    - [ ] **Aktif** (yeşil):
      - [ ] Background: `Color(0xFF28A745).withOpacity(0.1)`
      - [ ] Border: `Color(0xFF28A745)`
      - [ ] Icon: Icons.check_circle (yeşil)
      - [ ] Text: "Aktif Hesap" (yeşil, bold)
    - [ ] **Onay Bekliyor** (turuncu):
      - [ ] Background: `Color(0xFFFFC107).withOpacity(0.1)`
      - [ ] Border: `Color(0xFFFFC107)`
      - [ ] Icon: Icons.pending (turuncu)
      - [ ] Text: "Onay Bekliyor" (turuncu, bold)
    - [ ] **Deaktif** (kırmızı):
      - [ ] Background: `Color(0xFFDC3545).withOpacity(0.1)`
      - [ ] Border: `Color(0xFFDC3545)`
      - [ ] Icon: Icons.block (kırmızı)
      - [ ] Text: "Hesap Askıda" (kırmızı, bold)
- [ ] Müşteri tipi gösterimi:
  - [ ] Container (rounded, gri background)
  - [ ] Row: Emoji (24px) + DisplayName (16px)
  - [ ] Örnek: "🍽️ Restoran", "🏫 Okul", "🏨 Otel"
  - [ ] Profil card'ının altına ekle

### 13.3 Login Sonrası Onay Kontrolü (Backend ile birlikte)
- [ ] Login başarılı sonrası `isActive` kontrolü ekle
- [ ] Eğer `isActive == false`:
  - [ ] Pending approval screen'e yönlendir
  - [ ] Main screen'e girişi engelle
- [ ] Eğer `isActive == true`:
  - [ ] Normal akış (Main screen'e git)

---

## ⏳ PHASE 14: İyileştirmeler (PLANLANAN)

### 14.1 Dark Mode Desteği
- [ ] ThemeData oluştur (light & dark)
- [ ] `lib/core/constants/app_theme.dart` dosyası
- [ ] Light theme:
  - [ ] Primary: AppColors.primary
  - [ ] Background: Colors.white
  - [ ] Surface: Colors.white
- [ ] Dark theme:
  - [ ] Primary: AppColors.primary
  - [ ] Background: Color(0xFF121212)
  - [ ] Surface: Color(0xFF1E1E1E)
- [ ] Settings'te theme seçimi (Switch)
- [ ] SharedPreferences ile kaydet
- [ ] App başlangıcında yükle

### 14.2 Animasyon Optimizasyonları
- [ ] AnimationController'ları dispose et
- [ ] Unnecessary animations kaldır
- [ ] 60 FPS hedefle
- [ ] Performance profiling (Flutter DevTools)

### 14.3 Responsive Design İyileştirmeleri
- [ ] Tablet layout (MediaQuery width > 600)
- [ ] Landscape orientation handling
- [ ] Grid column count adaptive (2-3-4)
- [ ] Font size scaling
- [ ] Safe area kontrolü tüm ekranlarda

### 14.4 Accessibility (a11y)
- [ ] Semantics labels tüm interactive widgets'a
- [ ] Contrast ratios (WCAG 2.1 AA standardı)
- [ ] Touch targets minimum 48x48
- [ ] Font scaling test (küçük-normal-büyük)
- [ ] Screen reader test:
  - [ ] Android: TalkBack
  - [ ] iOS: VoiceOver

### 14.5 Keyboard Navigation
- [ ] Tab navigation support
- [ ] Focus nodes ekle
- [ ] Enter key ile submit
- [ ] Escape ile cancel/close

---

## 📊 İLERLEME DURUMU

- **Toplam Görev:** ~95
- **Tamamlanan:** ~70
- **Devam Eden:** 0
- **Planlanan:** ~25

**Tamamlanma Oranı:** ~74% ✅

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

### MEKZCGL'den Beklemen Gerekenler:
- ✅ "CustomerType enum hazır, kullan"
- ✅ "UserModel güncellendi: isActive ve customerType alanları var"
- ✅ "AuthProvider'da signup metoduna customerType parametresi eklendi"
- ⏳ "Backend'de customer_type alanı eklenecek"
- ⏳ "Login sonrası isActive kontrolü eklenecek"

### MEKZCGL'ye Söylemen Gerekenler:
- ✅ "Signup screen'de müşteri tipi dropdown'ı tamamlandı"
- ✅ "3 seçenek var: Okul 🏫, Restoran 🍽️, Otel 🏨"
- ✅ "Form validation eklendi (seçilmeli)"
- ⏳ "Pending approval screen tasarımı hazırlanacak"
- ⏳ "Profile screen'de durum badge'i eklenecek"

---

## 🔥 ÖNCELİKLİ GÖREVLER (BİRLİKTE)

### 1. Backend Entegrasyonu Tamamlanması Bekle
- **MEKZCGL:** Backend'de `customer_type` alanını ekleyecek
- **ŞEMMA:** Test ve feedback verecek

### 2. Admin Onay Sistemi UI
- **ŞEMMA:** Pending approval screen tasarımı yapacak
- **ŞEMMA:** Profil ekranına durum badge'i ekleyecek
- **MEKZCGL:** Login sonrası kontrol ekleyecek

### 3. Final Test & Polish
- **İkisi birlikte:** End-to-end test
- **İkisi birlikte:** UI/UX iyileştirmeleri
- **İkisi birlikte:** Production deployment hazırlığı

---

## 📅 SON GÜNCELLEME

**Tarih:** 24 Kasım 2025  
**Sıradaki Görev:** Pending approval screen tasarımı (Backend hazır olduktan sonra)

**Notlar:**
- Signup screen güncellemesi tamamlandı ✅
- Backend entegrasyonu bekleniyor ⏳
- Admin onay sistemi UI hazırlanacak 🎨

---

## 📈 TAHMINI SÜRELER

- **Phase 13:** Admin Onay Sistemi UI → 2-3 gün
- **Phase 14:** İyileştirmeler → 4-5 gün

**Toplam Kalan Süre:** ~1 hafta

---

**🎯 Hedef:** Admin onay sistemi UI tamamlandığında, MEKZCGL ile birlikte production'a hazır! 🚀