// ─────────────────────────────────────────────────────────────────────────────
// lib/providers/auth_provider.dart
// Authentication state, user settings, addresses, saved cards, and order history
// using Supabase and SharedPreferences
// ─────────────────────────────────────────────────────────────────────────────
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/order_model.dart';
import '../models/address_model.dart';
import '../models/credit_card_model.dart';

class AuthProvider extends ChangeNotifier {
  final _supabase = Supabase.instance.client;

  bool _isLoggedIn = false;
  String _userName = 'User';
  String _userEmail = '';
  String _avatarPath = '';          // Local file path to avatar image
  bool _isDarkMode = false;
  bool _notificationsEnabled = true;

  final List<AddressModel> _savedAddresses = [];
  final List<CreditCardModel> _savedCards = [];
  final List<OrderModel> _pastOrders = [];

  // ── Getters ────────────────────────────────────────────────────────────────
  bool get isLoggedIn => _isLoggedIn;
  String get userName => _userName;
  String get userEmail => _userEmail;
  String get avatarPath => _avatarPath;
  bool get isDarkMode => _isDarkMode;
  bool get notificationsEnabled => _notificationsEnabled;
  List<AddressModel> get savedAddresses => List.unmodifiable(_savedAddresses);
  List<CreditCardModel> get savedCards => List.unmodifiable(_savedCards);
  List<OrderModel> get pastOrders => List.unmodifiable(_pastOrders);

  int get totalOrders => _pastOrders.length;
  double get totalSpent =>
      _pastOrders.fold(0.0, (sum, o) => sum + o.total);

  AuthProvider() {
    _loadAuthData();
    _setupAuthListener();
  }

  // ── Auth listener ──────────────────────────────────────────────────────────
  void _setupAuthListener() {
    _supabase.auth.onAuthStateChange.listen((data) async {
      final session = data.session;
      if (session != null) {
        _isLoggedIn = true;
        _userEmail = session.user.email ?? '';
        await _fetchUserProfile(session.user.id);
        await _fetchPastOrders(session.user.id);
      } else {
        _isLoggedIn = false;
        _userName = 'User';
        _userEmail = '';
        _pastOrders.clear();
      }
      notifyListeners();
    });
  }

  // ── Load from SharedPreferences ───────────────────────────────────────────
  Future<void> _loadAuthData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _isDarkMode = prefs.getBool('isDarkMode') ?? false;
      _notificationsEnabled = prefs.getBool('notificationsEnabled') ?? true;
      _avatarPath = prefs.getString('avatarPath') ?? '';

      // Load saved addresses (encoded strings)
      final addrStrings = prefs.getStringList('savedAddresses') ?? [];
      _savedAddresses.clear();
      _savedAddresses.addAll(addrStrings.map((s) => AddressModel.decode(s)));

      // Load saved cards (encoded strings)
      final cardStrings = prefs.getStringList('savedCards') ?? [];
      _savedCards.clear();
      _savedCards.addAll(cardStrings.map((s) => CreditCardModel.decode(s)));

      // Check current Supabase session
      final session = _supabase.auth.currentSession;
      if (session != null) {
        _isLoggedIn = true;
        _userEmail = session.user.email ?? '';
        await _fetchUserProfile(session.user.id);
        await _fetchPastOrders(session.user.id);
      } else {
        _isLoggedIn = false;
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading auth data: $e');
    }
  }

  // ── Supabase: Fetch user profile ───────────────────────────────────────────
  Future<void> _fetchUserProfile(String userId) async {
    try {
      final data = await _supabase
          .from('profiles')
          .select('full_name, avatar_url')
          .eq('id', userId)
          .maybeSingle();
      if (data != null) {
        _userName = data['full_name'] ?? 'User';
        // Only use remote avatar if no local one set
        if (_avatarPath.isEmpty && data['avatar_url'] != null) {
          _avatarPath = data['avatar_url'];
        }
      }
    } catch (e) {
      debugPrint('Error fetching user profile: $e');
    }
  }

  // ── Supabase: Fetch past orders ────────────────────────────────────────────
  Future<void> _fetchPastOrders(String userId) async {
    try {
      final ordersData = await _supabase
          .from('orders')
          .select('*, order_items(*)')
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      _pastOrders.clear();
      for (var orderMap in ordersData) {
        final itemsList = (orderMap['order_items'] as List).map((i) {
          return OrderItemModel(
            productName: i['name'] ?? '',
            imageUrl: i['image_url'] ?? '',
            size: i['size'] ?? '',
            quantity: i['quantity'] ?? 1,
            price: (i['price'] as num).toDouble(),
          );
        }).toList();

        _pastOrders.add(
          OrderModel(
            id: orderMap['id'] ?? '',
            date: orderMap['created_at'] ?? '',
            items: itemsList,
            subtotal: (orderMap['subtotal'] as num).toDouble(),
            deliveryFee: (orderMap['delivery_fee'] as num).toDouble(),
            total: (orderMap['total'] as num).toDouble(),
            customerName: orderMap['customer_name'] ?? '',
            address: orderMap['address'] ?? '',
            city: orderMap['city'] ?? '',
            phone: orderMap['phone'] ?? '',
            paymentMethod: orderMap['payment_method'] ?? '',
            status: orderMap['status'] ?? 'Pending',
          ),
        );
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Error fetching past orders: $e');
    }
  }

  // ── Auth methods ───────────────────────────────────────────────────────────

  Future<bool> signUp(String name, String email, String password) async {
    try {
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
        data: {'full_name': name},
      );
      return response.user != null;
    } catch (e) {
      debugPrint('Error signing up: $e');
      return false;
    }
  }

  Future<bool> login(String email, String password) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      return response.user != null;
    } catch (e) {
      debugPrint('Error logging in: $e');
      return false;
    }
  }

  Future<void> logout() async {
    try {
      await _supabase.auth.signOut();
      // Clear local avatar path on logout
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('avatarPath');
      _avatarPath = '';
    } catch (e) {
      debugPrint('Error logging out: $e');
    }
  }

  // ── Profile update ─────────────────────────────────────────────────────────

  Future<void> updateProfile(String name, {String? avatarPath}) async {
    _userName = name;
    if (avatarPath != null) _avatarPath = avatarPath;

    final prefs = await SharedPreferences.getInstance();
    if (avatarPath != null) await prefs.setString('avatarPath', _avatarPath);

    // Update Supabase profile if logged in
    final user = _supabase.auth.currentUser;
    if (user != null) {
      try {
        await _supabase.from('profiles').upsert({
          'id': user.id,
          'full_name': name,
        });
      } catch (e) {
        debugPrint('Error updating profile in Supabase: $e');
      }
    }
    notifyListeners();
  }

  // ── Settings ───────────────────────────────────────────────────────────────

  Future<void> toggleDarkMode() async {
    _isDarkMode = !_isDarkMode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', _isDarkMode);
    notifyListeners();
  }

  Future<void> toggleNotifications() async {
    _notificationsEnabled = !_notificationsEnabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notificationsEnabled', _notificationsEnabled);
    notifyListeners();
  }

  // ── Addresses ──────────────────────────────────────────────────────────────

  Future<void> addAddress(AddressModel address) async {
    _savedAddresses.add(address);
    await _persistAddresses();
    notifyListeners();
  }

  Future<void> removeAddress(int index) async {
    if (index < 0 || index >= _savedAddresses.length) return;
    _savedAddresses.removeAt(index);
    await _persistAddresses();
    notifyListeners();
  }

  Future<void> _persistAddresses() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      'savedAddresses',
      _savedAddresses.map((a) => a.encode()).toList(),
    );
  }

  // ── Credit Cards ───────────────────────────────────────────────────────────

  Future<void> addCard(CreditCardModel card) async {
    _savedCards.add(card);
    await _persistCards();
    notifyListeners();
  }

  Future<void> removeCard(int index) async {
    if (index < 0 || index >= _savedCards.length) return;
    _savedCards.removeAt(index);
    await _persistCards();
    notifyListeners();
  }

  Future<void> _persistCards() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      'savedCards',
      _savedCards.map((c) => c.encode()).toList(),
    );
  }

  // ── Orders ─────────────────────────────────────────────────────────────────

  Future<void> placeOrder(OrderModel order) async {
    final user = _supabase.auth.currentUser;
    if (user == null) {
      _pastOrders.insert(0, order);
      notifyListeners();
      return;
    }

    try {
      final orderResult = await _supabase.from('orders').insert({
        'user_id': user.id,
        'status': order.status,
        'subtotal': order.subtotal,
        'delivery_fee': order.deliveryFee,
        'total': order.total,
        'customer_name': order.customerName,
        'address': order.address,
        'city': order.city,
        'phone': order.phone,
        'payment_method': order.paymentMethod,
      }).select().single();

      final newOrderId = orderResult['id'];

      final itemsToInsert = order.items.map((item) => {
        'order_id': newOrderId,
        'product_id': item.productName,
        'name': item.productName,
        'price': item.price,
        'size': item.size,
        'image_url': item.imageUrl,
        'quantity': item.quantity,
      }).toList();

      await _supabase.from('order_items').insert(itemsToInsert);
      await _fetchPastOrders(user.id);
    } catch (e) {
      debugPrint('Error inserting order to Supabase: $e');
      _pastOrders.insert(0, order);
      notifyListeners();
    }
  }
}
