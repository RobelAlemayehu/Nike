// ─────────────────────────────────────────────────────────────────────────────
// lib/models/order_model.dart
// Model representing a placed order for order history
// ─────────────────────────────────────────────────────────────────────────────

class OrderItemModel {
  final String productName;
  final String imageUrl;
  final String size;
  final int quantity;
  final double price;

  const OrderItemModel({
    required this.productName,
    required this.imageUrl,
    required this.size,
    required this.quantity,
    required this.price,
  });

  Map<String, dynamic> toJson() => {
        'productName': productName,
        'imageUrl': imageUrl,
        'size': size,
        'quantity': quantity,
        'price': price,
      };

  factory OrderItemModel.fromJson(Map<String, dynamic> json) => OrderItemModel(
        productName: json['productName'],
        imageUrl: json['imageUrl'],
        size: json['size'],
        quantity: json['quantity'],
        price: json['price'],
      );
}

class OrderModel {
  final String id;
  final String date;
  final List<OrderItemModel> items;
  final double subtotal;
  final double deliveryFee;
  final double total;
  final String customerName;
  final String address;
  final String city;
  final String phone;
  final String paymentMethod;
  final String status; // Pending, In Transit, Delivered

  const OrderModel({
    required this.id,
    required this.date,
    required this.items,
    required this.subtotal,
    required this.deliveryFee,
    required this.total,
    required this.customerName,
    required this.address,
    required this.city,
    required this.phone,
    required this.paymentMethod,
    this.status = 'Pending',
  });
}
