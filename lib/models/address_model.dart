// ─────────────────────────────────────────────────────────────────────────────
// lib/models/address_model.dart
// Full structured address model
// ─────────────────────────────────────────────────────────────────────────────

class AddressModel {
  final String street;
  final String apt;
  final String city;
  final String state;
  final String zip;
  final String country;

  const AddressModel({
    required this.street,
    this.apt = '',
    required this.city,
    required this.state,
    required this.zip,
    required this.country,
  });

  /// One-line short summary for list tiles
  String get displayLine1 => apt.isNotEmpty ? '$street, $apt' : street;
  String get displayLine2 => '$city, $state $zip, $country';
  String get fullDisplay => '$displayLine1\n$displayLine2';

  Map<String, dynamic> toJson() => {
        'street': street,
        'apt': apt,
        'city': city,
        'state': state,
        'zip': zip,
        'country': country,
      };

  factory AddressModel.fromJson(Map<String, dynamic> json) => AddressModel(
        street: json['street'] ?? '',
        apt: json['apt'] ?? '',
        city: json['city'] ?? '',
        state: json['state'] ?? '',
        zip: json['zip'] ?? '',
        country: json['country'] ?? '',
      );

  /// Encode as single string for SharedPreferences (pipe-separated)
  String encode() => [street, apt, city, state, zip, country].join('|');

  factory AddressModel.decode(String encoded) {
    final parts = encoded.split('|');
    return AddressModel(
      street: parts.length > 0 ? parts[0] : '',
      apt: parts.length > 1 ? parts[1] : '',
      city: parts.length > 2 ? parts[2] : '',
      state: parts.length > 3 ? parts[3] : '',
      zip: parts.length > 4 ? parts[4] : '',
      country: parts.length > 5 ? parts[5] : '',
    );
  }
}
