enum CustomerType {
  okul('okul', 'Okul', '🏫'),
  restoran('restoran', 'Restoran', '🍽️'),
  otel('otel', 'Otel', '🏨');

  final String value;       // Backend'e gönderilecek
  final String displayName; // UI'da gösterilecek
  final String emoji;       // Icon olarak

  const CustomerType(this.value, this.displayName, this.emoji);

  // String'den enum'a dönüştür
  static CustomerType fromString(String value) {
    switch (value.toLowerCase()) {
      case 'okul':
        return CustomerType.okul;
      case 'restoran':
        return CustomerType.restoran;
      case 'otel':
        return CustomerType.otel;
      default:
        return CustomerType.restoran; // Default
    }
  }

  // Tüm tiplerin listesi (Dropdown için)
  static List<CustomerType> get all => CustomerType.values;
}