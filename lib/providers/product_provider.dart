// ─────────────────────────────────────────────────────────────────────────────
// lib/providers/product_provider.dart
// Product state: selected size, size unit, carousel index, favourite toggle
// ─────────────────────────────────────────────────────────────────────────────
import 'package:flutter/foundation.dart';
import '../models/product_model.dart';
import '../data/mock_data.dart';

class ProductProvider extends ChangeNotifier {
  int _carouselIndex = 0;          // current product index
  String _selectedSizeUnit = 'US'; // US | UK | EU
  String _selectedSize = '5.5';    // default selected size
  bool _isFavourite = false;       // bookmark/favourite state

  // ── Getters ────────────────────────────────────────────────────────────────
  List<Product> get products => MockData.products;
  Product get product => products[_carouselIndex];
  
  String get selectedSizeUnit => _selectedSizeUnit;
  String get selectedSize => _selectedSize;
  int get carouselIndex => _carouselIndex;
  bool get isFavourite => _isFavourite;

  List<String> get currentSizes =>
      product.sizes[_selectedSizeUnit] ?? [];

  // ── Setters / Actions ──────────────────────────────────────────────────────

  void setCarouselIndex(int index) {
    if (_carouselIndex == index) return;
    _carouselIndex = index;
    // Reset selected size when product changes
    final sizes = product.sizes[_selectedSizeUnit];
    if (sizes != null && sizes.isNotEmpty) {
      _selectedSize = sizes.length > 1 ? sizes[1] : sizes[0];
    }
    notifyListeners();
  }

  void selectSizeUnit(String unit) {
    if (_selectedSizeUnit == unit) return;
    _selectedSizeUnit = unit;
    // Reset selected size to first option in new unit
    final sizes = product.sizes[unit];
    if (sizes != null && sizes.isNotEmpty) {
      _selectedSize = sizes.length > 1 ? sizes[1] : sizes[0];
    }
    notifyListeners();
  }

  void selectSize(String size) {
    _selectedSize = size;
    notifyListeners();
  }

  void toggleFavourite() {
    _isFavourite = !_isFavourite;
    notifyListeners();
  }
}
