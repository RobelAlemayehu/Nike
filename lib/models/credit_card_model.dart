// ─────────────────────────────────────────────────────────────────────────────
// lib/models/credit_card_model.dart
// Saved credit card model — only last 4 digits stored, never full number
// ─────────────────────────────────────────────────────────────────────────────

enum CardType { visa, mastercard, amex, discover, unknown }

class CreditCardModel {
  final String cardHolderName;
  final String lastFour;       // Only last 4 digits
  final String expiry;         // MM/YY
  final CardType cardType;

  const CreditCardModel({
    required this.cardHolderName,
    required this.lastFour,
    required this.expiry,
    this.cardType = CardType.unknown,
  });

  /// Auto-detect card type from the first digit of full card number
  static CardType detectType(String fullNumber) {
    final n = fullNumber.replaceAll(' ', '');
    if (n.startsWith('4')) return CardType.visa;
    if (n.startsWith('5') || n.startsWith('2')) return CardType.mastercard;
    if (n.startsWith('3')) return CardType.amex;
    if (n.startsWith('6')) return CardType.discover;
    return CardType.unknown;
  }

  String get cardTypeLabel {
    switch (cardType) {
      case CardType.visa:        return 'Visa';
      case CardType.mastercard:  return 'Mastercard';
      case CardType.amex:        return 'Amex';
      case CardType.discover:    return 'Discover';
      case CardType.unknown:     return 'Card';
    }
  }

  String get maskedDisplay => '•••• •••• •••• $lastFour';

  /// Encode as single string for SharedPreferences (pipe-separated)
  String encode() => [cardHolderName, lastFour, expiry, cardType.name].join('|');

  factory CreditCardModel.decode(String encoded) {
    final parts = encoded.split('|');
    CardType type = CardType.unknown;
    if (parts.length > 3) {
      type = CardType.values.firstWhere(
        (e) => e.name == parts[3],
        orElse: () => CardType.unknown,
      );
    }
    return CreditCardModel(
      cardHolderName: parts.length > 0 ? parts[0] : '',
      lastFour: parts.length > 1 ? parts[1] : '****',
      expiry: parts.length > 2 ? parts[2] : '',
      cardType: type,
    );
  }
}
