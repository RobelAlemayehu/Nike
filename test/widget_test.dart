// ─────────────────────────────────────────────────────────────────────────────
// test/widget_test.dart
// Basic smoke test for the Nike Shop app
// ─────────────────────────────────────────────────────────────────────────────
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:nike_shop/main.dart';
import 'package:nike_shop/providers/cart_provider.dart';
import 'package:nike_shop/providers/product_provider.dart';

void main() {
  testWidgets('App smoke test — renders without crashing', (tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => CartProvider()),
          ChangeNotifierProvider(create: (_) => ProductProvider()),
        ],
        child: const NikeShopApp(),
      ),
    );
    // Verify the root widget tree renders
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
