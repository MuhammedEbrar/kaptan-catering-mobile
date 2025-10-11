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

## 🔄 PHASE 4: Ürün Listeleme & API Entegrasyonu (TAMAMLANDI ✅)

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
- [x] Ürün sayısını kontrol et (~850)
- [x] Hata durumlarını test et

---

## 🔄 PHASE 4.5: Kategori & Filtreleme

### 4.7 Kategori Provider
- [ ] `lib/presentation/providers/category_provider.dart` oluştur
- [ ] Kategori listesi state (`List<String> categories`)
- [ ] Seçili kategori state (`String? selectedCategory`)
- [ ] `filterByCategory(String category)` fonksiyonu
- [ ] Product Provider ile koordinasyon

### 4.8 Arama Fonksiyonu
- [ ] Product Provider'a `searchProducts(String query)` ekle
- [ ] Stok kodu ile arama (case-insensitive)
- [ ] Stok adı ile arama (case-insensitive)
- [ ] Debounce mekanizması (500ms - Timer kullan)
- [ ] Arama sonuçları state

### 4.9 Pagination
- [ ] `page` ve `limit` parametreleri ekle
- [ ] Infinite scroll için `loadMore()` fonksiyonu
- [ ] `hasMore` boolean flag
- [ ] Loading more state (`isLoadingMore`)
- [ ] Scroll controller ile tetikleme hazırlığı

---

## 🔄 PHASE 6.5: Sepet & Sipariş Entegrasyonu

### 6.1 Cart Provider
- [ ] `lib/presentation/providers/cart_provider.dart` oluştur
- [ ] Cart items state (`List<CartItem>`)
- [ ] `addToCart(ProductModel product, int quantity)` fonksiyonu
- [ ] `removeFromCart(String productId)` fonksiyonu
- [ ] `updateQuantity(String productId, int quantity)` fonksiyonu
- [ ] `clearCart()` fonksiyonu
- [ ] `getTotalAmount()` fonksiyonu (ara toplam)
- [ ] `getKdvAmount()` fonksiyonu (KDV tutarı)
- [ ] `getGrandTotal()` fonksiyonu (genel toplam)
- [ ] SharedPreferences ile sepeti kaydet (persistence)
- [ ] Uygulama açılınca sepeti yükle

### 6.2 Order Model
- [ ] `lib/data/models/order_model.dart` oluştur
- [ ] Order fields:
  - [ ] `String id`
  - [ ] `String userId`
  - [ ] `List<OrderItem> items`
  - [ ] `double totalAmount`
  - [ ] `String status` (Ödeme Bekliyor, Hazırlanıyor, vb.)
  - [ ] `String paymentMethod` (iyzico, kapida_odeme)
  - [ ] `String deliveryAddress`
  - [ ] `DateTime createdAt`
- [ ] OrderItem model (productId, productName, quantity, price, unit)
- [ ] JSON serialization (fromJson, toJson)

### 6.3 Order DataSource
- [ ] `lib/data/datasources/order_datasource.dart` oluştur
- [ ] `createOrder(Map<String, dynamic> orderData)` - POST /api/siparisler
- [ ] `getOrders()` - GET /api/siparisler
- [ ] `getOrderById(String orderId)` - GET /api/siparisler/:id
- [ ] Error handling

### 6.4 Order Repository
- [ ] `lib/data/repositories/order_repository.dart` oluştur
- [ ] `createOrder()` fonksiyonu
- [ ] `fetchOrders()` fonksiyonu
- [ ] `fetchOrderById()` fonksiyonu
- [ ] Error handling

### 6.5 Order Provider
- [ ] `lib/presentation/providers/order_provider.dart` oluştur
- [ ] Order list state (`List<OrderModel> orders`)
- [ ] Loading states
- [ ] `createOrder(OrderModel order)` fonksiyonu
- [ ] `fetchOrders()` fonksiyonu
- [ ] `fetchOrderById(String id)` fonksiyonu
- [ ] Filter by status

### 6.6 Dependency Injection
- [ ] OrderDataSource register et
- [ ] OrderRepository register et
- [ ] CartProvider register et
- [ ] OrderProvider register et
- [ ] main.dart'ta Provider'ları ekle

---

## 🔄 PHASE 8.5: Offline Mode & Caching

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

## 🔄 PHASE 9: Testing & Bug Fixing

### 9.1 Unit Tests
- [ ] `test/models/product_model_test.dart` oluştur
  - [ ] JSON parsing test
  - [ ] KDV hesaplama test
- [ ] `test/repositories/product_repository_test.dart`
  - [ ] Mock data ile test
- [ ] `test/providers/product_provider_test.dart`
  - [ ] State değişimleri test
- [ ] `test/providers/cart_provider_test.dart`
  - [ ] Sepet işlemleri test
  - [ ] Toplam hesaplama test

### 9.2 Integration Tests
- [ ] `integration_test/app_test.dart` oluştur
- [ ] End-to-end flow test:
  - [ ] Login → Ürün listesi → Detay → Sepete ekle
- [ ] API entegrasyonu test

### 9.3 Bug Fixing & Optimization
- [ ] Memory leak kontrolü
- [ ] Null safety kontrolleri
- [ ] Performance profiling
- [ ] Code cleanup (unused imports, vb.)
- [ ] Arkadaşın bulduğu UI buglarını çöz

---

## 📊 İlerleme

- **Toplam Görev:** ~60
- **Tamamlanan:** ~25 (Phase 0-2)
- **Kalan:** ~35


---

**Son Güncelleme:** 10 Ekim 2025
**Sıradaki Görev:** Phase 4.1 - Product Model güncelleme