// ─────────────────────────────────────────────────────────────────────────────
// lib/data/mock_data.dart
// ─────────────────────────────────────────────────────────────────────────────
import '../models/product_model.dart';
import '../models/review_model.dart';

class MockData {
  MockData._();

  static final List<Product> products = [
    // p1 — air_max_1, air_max_2
    Product(
      id: 'p1',
      name: 'Nike Air Max 90',
      category: "Men's Shoe",
      price: 290.00,
      rating: 4.5,
      reviewCount: 128,
      description:
          'Lacing up in the Nike Air Max 90 keeps your look rooted in '
          'the past while it heads into the future. The iconic Waffle sole, '
          'bold colour blocking and classic TPU accents make it a must-have sneaker.',
      imageUrls: [
        'assets/images/air_max_1.png',
        'assets/images/air_max_2.png',
      ],
      sizes: {
        'US': ['5', '5.5', '6', '6.5', '7', '7.5', '8', '8.5', '9'],
        'UK': ['4', '4.5', '5', '5.5', '6', '6.5', '7', '7.5', '8'],
        'EU': ['37', '38', '39', '40', '41', '42', '43', '44', '45'],
      },
    ),
    // p2 — air_force_1, air_force_2, air_force_3
    Product(
      id: 'p2',
      name: "Nike Air Force 1 '07",
      category: "Women's Shoe",
      price: 110.00,
      rating: 4.7,
      reviewCount: 342,
      description:
          "The radiance lives on in the Nike Air Force 1 '07, the basketball "
          'original that puts a fresh spin on what you know best: durably '
          'stitched overlays, iconic foam midsole and the classic Swoosh.',
      imageUrls: [
        'assets/images/air_force_1.png',
        'assets/images/air_force_2.png',
        'assets/images/air_force_3.png',
      ],
      sizes: {
        'US': ['5', '5.5', '6', '6.5', '7', '7.5', '8'],
        'UK': ['3', '3.5', '4', '4.5', '5', '5.5', '6'],
        'EU': ['36', '37', '38', '39', '40', '41'],
      },
    ),
    // p3 — flyknit_1, flyknit_2
    Product(
      id: 'p3',
      name: 'Nike Flyknit Racer',
      category: 'Running Shoe',
      price: 250.00,
      rating: 4.3,
      reviewCount: 96,
      description:
          'The Nike Flyknit Racer combines an ultra-lightweight, form-fitting '
          'Flyknit upper with a Zoom Air unit and waffle outsole for a '
          'featherlight feel with solid grip and responsive cushioning on any terrain.',
      imageUrls: [
        'assets/images/flyknit_1.png',
        'assets/images/flyknit_2.png',
      ],
      sizes: {
        'US': ['6', '6.5', '7', '7.5', '8', '8.5', '9', '10'],
        'UK': ['5', '5.5', '6', '6.5', '7', '7.5', '8', '9'],
        'EU': ['39', '40', '41', '42', '43', '44', '45'],
      },
    ),
    // p4 — Women's Nike Dunk High — pegasus_1 + air_force_1 as placeholders
    Product(
      id: 'p4',
      name: "Women's Nike Dunk High",
      category: "Women's Shoe",
      price: 115.00,
      rating: 4.6,
      reviewCount: 214,
      description:
          "The Women's Nike Dunk High delivers a bold high-top silhouette "
          'with a premium leather upper and padded collar for superior ankle '
          'support. The classic rubber cupsole keeps every step grounded, '
          'making it as wearable on the street as it is iconic on the shelf.',
      imageUrls: [
        'assets/images/air_force_1.png',
      ],
      sizes: {
        'US': ['5', '5.5', '6', '6.5', '7', '7.5', '8', '8.5', '9'],
        'UK': ['3', '3.5', '4', '4.5', '5', '5.5', '6', '6.5', '7'],
        'EU': ['36', '37', '38', '39', '40', '41', '42'],
      },
    ),
  ];

  // ---------------------------------------------------------------------------
  // Reviews — keyed by productId
  // ---------------------------------------------------------------------------
  static final Map<String, List<Review>> reviewsByProduct = {
    'p1': [
      Review(
        id: 'r1a',
        productId: 'p1',
        reviewerName: 'Royal Parvej',
        avatarUrl: 'https://i.pravatar.cc/100?img=11',
        rating: 5.0,
        text: "The most comfortable Air Max I've worn. The sole cushioning is "
            "unbelievable and I've had zero foot pain even after 12-hour shifts. "
            "Absolutely worth every penny.",
        date: '10.02.2024',
      ),
      Review(
        id: 'r1b',
        productId: 'p1',
        reviewerName: 'Prosing Rox',
        avatarUrl: 'https://i.pravatar.cc/100?img=32',
        rating: 3.5,
        text: "Great looking shoe but the width is a bit narrow for my feet. "
            "I sized up half a size and that fixed it. Comfort is solid for "
            "everyday wear — not ideal for serious running though.",
        date: '09.02.2024',
      ),
      Review(
        id: 'r1c',
        productId: 'p1',
        reviewerName: 'Sasha Mendes',
        avatarUrl: 'https://i.pravatar.cc/100?img=47',
        rating: 4.5,
        text: "Stylish and very comfortable. The Air Max unit under the heel "
            "gives great support. Wore these on a 10-hour walking day and "
            "my feet felt fine. Highly recommend!",
        date: '05.02.2024',
      ),
      Review(
        id: 'r1d',
        productId: 'p1',
        reviewerName: 'Tariq Hassan',
        avatarUrl: 'https://i.pravatar.cc/100?img=59',
        rating: 5.0,
        text: "These are my go-to shoes for everything. The material feels "
            "premium, the colourway is fire and they're true to size. "
            "Already on my third pair!",
        date: '01.02.2024',
      ),
    ],
    'p2': [
      Review(
        id: 'r2a',
        productId: 'p2',
        reviewerName: 'Lena Fischer',
        avatarUrl: 'https://i.pravatar.cc/100?img=5',
        rating: 5.0,
        text: "Classic white AF1s never go out of style! Super clean look, "
            "easy to dress up or down. The leather feels durable and "
            "they cleaned up really well after a muddy walk.",
        date: '14.03.2024',
      ),
      Review(
        id: 'r2b',
        productId: 'p2',
        reviewerName: 'Marcus Bell',
        avatarUrl: 'https://i.pravatar.cc/100?img=68',
        rating: 4.0,
        text: "I love the look but they run a bit stiff at first. After "
            "breaking them in for a week they softened up nicely. "
            "The sole provides great grip on wet surfaces too.",
        date: '11.03.2024',
      ),
      Review(
        id: 'r2c',
        productId: 'p2',
        reviewerName: 'Aisha Okonkwo',
        avatarUrl: 'https://i.pravatar.cc/100?img=25',
        rating: 4.5,
        text: "Bought these for my daughter and she hasn't taken them off. "
            "Sizing is accurate, delivery was fast and the box was pristine. "
            "Will definitely order again.",
        date: '08.03.2024',
      ),
    ],
    'p3': [
      Review(
        id: 'r3a',
        productId: 'p3',
        reviewerName: 'Kevin Oduya',
        avatarUrl: 'https://i.pravatar.cc/100?img=53',
        rating: 4.0,
        text: "Light as a feather! I shaved 2 minutes off my 5K personal "
            "best after switching to these. The Flyknit upper hugs your "
            "foot perfectly with no hotspots. Great for long runs.",
        date: '20.04.2024',
      ),
      Review(
        id: 'r3b',
        productId: 'p3',
        reviewerName: 'Yuki Tanaka',
        avatarUrl: 'https://i.pravatar.cc/100?img=10',
        rating: 3.5,
        text: "Good cushioning for road running. Not great for trails since "
            "the waffle sole lacks deep lugs. Sizing runs half a size small "
            "so order up. Overall solid daily trainer.",
        date: '18.04.2024',
      ),
      Review(
        id: 'r3c',
        productId: 'p3',
        reviewerName: 'Amara Diallo',
        avatarUrl: 'https://i.pravatar.cc/100?img=49',
        rating: 5.0,
        text: "Best running shoe I've ever owned. The responsiveness of the "
            "Zoom Air unit is incredible. I ran a half-marathon in these "
            "and had zero blisters. Perfect for race day!",
        date: '15.04.2024',
      ),
    ],
    'p4': [
      Review(
        id: 'r4a',
        productId: 'p4',
        reviewerName: 'Sofia Reyes',
        avatarUrl: 'https://i.pravatar.cc/100?img=9',
        rating: 5.0,
        text: "Obsessed with the Women's Dunk High! The ankle support is "
            "incredible and I wore them all day at a festival without any "
            "discomfort. The colourway is stunning — so many compliments.",
        date: '22.05.2024',
      ),
      Review(
        id: 'r4b',
        productId: 'p4',
        reviewerName: 'Priya Nair',
        avatarUrl: 'https://i.pravatar.cc/100?img=16',
        rating: 4.5,
        text: "Love the high-top silhouette on the Women's Dunk High. "
            "The leather quality is top-notch and they break in quickly. "
            "Sizing is true to size — no need to go up or down.",
        date: '19.05.2024',
      ),
      Review(
        id: 'r4c',
        productId: 'p4',
        reviewerName: 'Chloe Dubois',
        avatarUrl: 'https://i.pravatar.cc/100?img=23',
        rating: 4.0,
        text: "The Women's Dunk High is a classic for a reason. Great build "
            "quality and the padded collar makes them super comfortable. "
            "Only minor gripe is they can feel warm in summer.",
        date: '15.05.2024',
      ),
      Review(
        id: 'r4d',
        productId: 'p4',
        reviewerName: 'Zara Osei',
        avatarUrl: 'https://i.pravatar.cc/100?img=44',
        rating: 5.0,
        text: "They exceeded my expectations. The cupsole grip is solid, "
            "the leather is premium and they look even better in person. "
            "My new favourite pair without a doubt!",
        date: '10.05.2024',
      ),
    ],
  };

  /// Helper to get reviews for a specific product id
  static List<Review> reviewsFor(String productId) =>
      reviewsByProduct[productId] ?? [];
}
