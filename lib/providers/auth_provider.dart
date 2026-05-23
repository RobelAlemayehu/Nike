// ─────────────────────────────────────────────────────────────────────────────
// lib/providers/auth_provider.dart
// Authentication state, user settings, addresses, and order history using Supabase and SharedPreferences
// ─────────────────────────────────────────────────────────────────────────────
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/order_model.dart';

class AuthProvider extends ChangeNotifier {
  final _supabase = Supabase.instance.client;

  bool _isLoggedIn = false;
  String _userName = 'User';
  String _userEmail = '';
  bool _isDarkMode = false;
  bool _notificationsEnabled = true;

  final List<String> _savedAddresses = [];
  final List<OrderModel> _pastOrders = [];

  // Getters
  bool get isLoggedIn => _isLoggedIn;
  String get userName => _userName;
  String get userEmail => _userEmail;
  bool get isDarkMode => _isDarkMode;
  bool get notificationsEnabled => _notificationsEnabled;
  List<String> get savedAddresses => List.unmodifiable(_savedAddresses);
  List<OrderModel> get pastOrders => List.unmodifiable(_pastOrders);

  AuthProvider() {
    _loadAuthData();
    _setupAuthListener();
  }

  // Set up auth state change listener to sync login status and fetch database values dynamically
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

  // Load configuration settings from SharedPreferences
  Future<void> _loadAuthData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _isDarkMode = prefs.getBool('isDarkMode') ?? false;
      _notificationsEnabled = prefs.getBool('notificationsEnabled') ?? true;

      // Load saved addresses
      final addresses = prefs.getStringList('savedAddresses');
      if (addresses != null) {
        _savedAddresses.clear();
        _savedAddresses.addAll(addresses);
      }

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

  // Fetch the custom user profile from public.profiles table
  Future<void> _fetchUserProfile(String userId) async {
    try {
      final data = await _supabase
          .from('profiles')
          .select('full_name')
          .eq('id', userId)
          .maybeSingle();
      if (data != null) {
        _userName = data['full_name'] ?? 'User';
      }
    } catch (e) {
      debugPrint('Error fetching user profile: $e');
    }
  }

  // Fetch past orders from Supabase order tables
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

  // Supabase Sign Up
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

  // Supabase Login
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

  // Supabase Logout
  Future<void> logout() async {
    try {
      await _supabase.auth.signOut();
    } catch (e) {
      debugPrint('Error logging out: $e');
    }
  }

  // Toggle Dark Mode
  Future<void> toggleDarkMode() async {
    _isDarkMode = !_isDarkMode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', _isDarkMode);
    notifyListeners();
  }

  // Toggle Notifications
  Future<void> toggleNotifications() async {
    _notificationsEnabled = !_notificationsEnabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notificationsEnabled', _notificationsEnabled);
    notifyListeners();
  }

  // Add saved address
  Future<void> addAddress(String address) async {
    if (address.trim().isEmpty) return;
    _savedAddresses.add(address);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('savedAddresses', _savedAddresses);
    notifyListeners();
  }

  // Place order and save to history in Supabase
  Future<void> placeOrder(OrderModel order) async {
    final user = _supabase.auth.currentUser;
    if (user == null) {
      // Fallback locally if user is not authenticated for some reason
      _pastOrders.insert(0, order);
      notifyListeners();
      return;
    }

    try {
      // 1. Insert into orders table
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

      // 2. Insert items
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

      // Reload orders to get database synchronized state
      await _fetchPastOrders(user.id);
    } catch (e) {
      debugPrint('Error inserting order to Supabase: $e');
      // Fallback locally
      _pastOrders.insert(0, order);
      notifyListeners();
    }
  }
}
