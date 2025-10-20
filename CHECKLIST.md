# 👤 MEKZCGL - Görev Checklist'i (Backend Integration & Data)

## 📅 Başlangıç: 10 Ekim 2025
**Rolün:** Backend Entegrasyonu & Veri Yönetimi

---

## ✅ PHASE 0-2: Tamamlandı
- [x] Proje kurulumu
- [x] API altyapısı
- [x] Authentication
- [x] Login/Register test (Samsung S10 Lite)

---

## ✅ PHASE 4: Ürün Listeleme & API Entegrasyonu (TAMAMLANDI ✅)

### 4.1 Product Model Güncelleme
- [x] `lib/data/models/product_model.dart` dosyasını aç
- [x] KDV alanlarını kontrol et (kdvDahil, kdvOrani)
- [x] Birim alanını kontrol et (kg, adet, litre)
- [x] Minimum sipariş miktarı ekle (minSiparisMiktari)
- [x] JSON serialization test et

### 4.2 Product DataSource
- [x] `lib/data/datasources/product_datasource.dart` oluştur
- [x] `getProducts()` fonksiyonu yaz
- [x] `GET /api/products` endpoint'ini entegre et
- [x] Error handling ekle
- [x] Postman/curl ile API test et

### 4.3 Product Repository
- [x] `lib/data/repositories/product_repository.dart` oluştur
- [x] DataSource'u inject et
- [x] `fetchProducts()` fonksiyonu
- [x] Cache mekanizması (SharedPreferences)
- [x] Error handling

### 4.4 Product Provider
- [x] `lib/presentation/providers/product_provider.dart` oluştur
- [x] `ChangeNotifier` extend et
- [x] States tanımla
- [x] `loadProducts()` fonksiyonu
- [x] `notifyListeners()` ekle

### 4.5 Dependency Injection
- [x] `lib/core/di/injection.dart` aç
- [x] ProductDataSource register et
- [x] ProductRepository register et
- [x] Test et

### 4.6 API Test
- [x] Telefonda çalıştır
- [x] Console'da API response'u gör
- [x] Ürün sayısını kontrol et (~14)
- [x] Hata durumlarını test et

---

## ✅ PHASE 4.5: Kategori & Filtreleme (TAMAMLANDI ✅)

### 4.7 Kategori Provider
- [x] `lib/presentation/providers/category_provider.dart` oluştur
- [x] Kategori listesi state
- [x] Seçili kategori state
- [x] `filterByCategory()` fonksiyonu
- [x] Emoji iconlar
- [x] Home screen'de kategori chips
- [x] Test edildi

### 4.8 Arama Fonksiyonu
- [x] Arama bar UI (TextField + TextEditingController)
- [x] Local arama (client-side filtering)
- [x] Stok kodu ile arama
- [x] Stok adı ile arama
- [x] Kategori ile arama
- [x] Debounce mekanizması (500ms)
- [x] Arama temizleme (X butonu)
- [x] Klavye 'Ara' butonu
- [x] Test edildi

### 4.9 Pagination
- [x] ScrollController eklendi
- [x] Infinite scroll mekanizması (80% scroll'da tetikle)
- [x] `loadMore()` fonksiyonu
- [x] Loading indicator (liste altında)
- [x] `hasMore` flag kontrolü
- [x] "Tüm ürünler yüklendi" mesajı
- [x] Filtreleme sırasında pagination devre dışı
- [x] Test edildi

---

## ✅ PHASE 6: Sepet & Sipariş Entegrasyonu (TAMAMLANDI ✅)

### 6.1 Cart Provider
- [x] `lib/data/models/cart_item_model.dart` oluştur
- [x] `lib/presentation/providers/cart_provider.dart` oluştur
- [x] Cart items list state
- [x] `addToCart()` fonksiyonu
- [x] `removeFromCart()` fonksiyonu
- [x] `updateQuantity()` fonksiyonu
- [x] `clearCart()` fonksiyonu
- [x] `getTotalAmount()` fonksiyonu (ara toplam)
- [x] `getKdvAmount()` fonksiyonu (KDV tutarı)
- [x] `getGrandTotal()` fonksiyonu (genel toplam)
- [x] `getShippingCost()` fonksiyonu (kargo)
- [x] Local storage ile sepeti kaydet (SharedPreferences)
- [x] Uygulama açılınca sepeti yükle
- [x] Sepet validasyonu (minimum miktar, stok)
- [x] Home screen entegrasyonu
- [x] Sepet ikonu + badge
- [x] Test edildi

### 6.2 Order Model
- [x] `lib/data/models/order_model.dart` oluştur
- [x] Order fields (id, userId, items, totalAmount, status, paymentMethod, deliveryAddress, etc.)
- [x] OrderItem model (productId, productName, quantity, price, unit)
- [x] JSON serialization (fromJson, toJson)
- [x] Sipariş durumları (pending, paid, preparing, shipped, delivered, cancelled)
- [x] Display name fonksiyonları
- [x] CartItem'dan OrderItem dönüşümü

### 6.3 Order DataSource
- [x] `lib/data/datasources/order_datasource.dart` oluştur
- [x] `createOrder(Map<String, dynamic> orderData)` - POST /api/siparisler
- [x] `getOrders()` - GET /api/siparisler
- [x] `getOrderById(String orderId)` - GET /api/siparisler/:id
- [x] `getOrdersByStatus(String status)` - Duruma göre filtrele
- [x] `cancelOrder(String orderId)` - PATCH /api/siparisler/:id
- [x] Error handling
- [x] Flexible JSON parsing (farklı backend formatları için)

### 6.4 Order Repository
- [x] `lib/data/repositories/order_repository.dart` oluştur
- [x] `createOrder()` fonksiyonu
- [x] `fetchOrders()` fonksiyonu
- [x] `fetchOrderById()` fonksiyonu
- [x] `fetchOrdersByStatus()` fonksiyonu
- [x] `cancelOrder()` fonksiyonu
- [x] `fetchActiveOrders()` - Aktif siparişler
- [x] `fetchCompletedOrders()` - Tamamlanan siparişler
- [x] `fetchCancelledOrders()` - İptal edilen siparişler
- [x] Error handling

### 6.5 Order Provider
- [x] `lib/presentation/providers/order_provider.dart` oluştur
- [x] Order list state (`List<OrderModel> orders`)
- [x] Loading states (isLoading, isCreatingOrder)
- [x] `createOrder(OrderModel order)` fonksiyonu
- [x] `loadOrders()` fonksiyonu
- [x] `loadOrderById(String id)` fonksiyonu
- [x] `getOrdersByStatus()` - Duruma göre filtrele
- [x] `activeOrders`, `completedOrders`, `cancelledOrders` getters
- [x] `cancelOrder()` fonksiyonu
- [x] Error handling

### 6.6 Dependency Injection
- [x] OrderDataSource register et
- [x] OrderRepository register et
- [x] CartProvider register et
- [x] OrderProvider register et
- [x] main.dart'ta Provider'ları ekle
- [x] ApiClient'e `patch` metodu ekle

### 6.7 Cart Screen (Geçici)
- [x] `lib/presentation/screens/cart/cart_screen.dart` oluştur
- [x] Sepet ürün listesi
- [x] Miktar artır/azalt
- [x] Ürün silme
- [x] Ara toplam, KDV, Toplam gösterimi
- [x] Sipariş notu (opsiyonel)
- [x] "Sipariş Talebi Gönder" butonu
- [x] Sepeti temizle butonu
- [x] Backend'e sipariş gönderme
- [x] Test edildi

### 6.8 UI Entegrasyonu
- [x] Ana sayfa landing page'e çevrildi
- [x] Bottom navigation bar (Ana Sayfa, Ürünler, Sepet, Profil)
- [x] Ürünler sayfası grid layout
- [x] Sepet badge (ürün sayısı gösterimi)
- [x] Test edildi (Samsung S10 Lite)

---

## 📝 ÖNEMLİ NOTLAR

### ⚠️ Backend Durumu:
- **Backend'den gelen ürünlerde FİYAT YOK** (price: 0.0)
- **Sipariş API'si 500 hatası veriyor** ama sipariş oluşuyor (DB'ye kaydediliyor)
- Backend düzeltilene kadar geçici çözümlerle devam ediyoruz

### ✅ Tamamlanan:
- Phase 0-2: Authentication ✅
- Phase 4: Ürün listeleme & API ✅
- Phase 4.5: Kategori & Filtreleme ✅
- Phase 6: Sepet & Sipariş entegrasyonu ✅

### 🔄 Sırada:
- **Phase 8: Offline Mode & Caching**

---

## 🔄 PHASE 8: Offline Mode & Caching (SONRAKİ HEDEF)

### 8.1 Shared Preferences Setup
- [ ] Product cache için key tanımla (`cached_products`)
- [ ] Cache timestamp key (`products_cache_time`)
- [ ] Cache süresi belirle (24 saat)
- [ ] `saveProductsToCache(List<ProductModel>)` fonksiyonu
- [ ] `loadProductsFromCache()` fonksiyonu
- [ ] Cache validation (expired mı?)

### 8.2 Network Check
- [ ] `lib/core/utils/network_checker.dart` oluştur
- [ ] Internet bağlantı kontrolü (connectivity_plus paketi)
- [ ] Offline durumu provider'da yönet
- [ ] Online olunca otomatik sync

### 8.3 Offline Product Access
- [ ] İnternet yoksa cache'den yükle
- [ ] "Offline moddasınız" bildirimi göster
- [ ] Sepet offline da çalışsın (local)

---

## 📊 İlerleme

- **Toplam Görev:** ~65
- **Tamamlanan:** ~50
- **Kalan:** ~15

---

**Son Güncelleme:** 15 Ekim 2025
**Sıradaki Görev:** Phase 8.1 - Offline Mode & Caching