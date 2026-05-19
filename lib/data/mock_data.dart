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
      name: 'Nike Air Pegasus+ 30 ',
      category: "Men's Shoe",
      price: 290.00,
      rating: 4.5,
      reviewCount: 128,
      description:
          'Lacing up in the Nike Air Pegasus+ 30  keeps your look rooted in '
          'the past while it heads into the future. The iconic Waffle sole, '
          'bold colour blocking and classic TPU accents make it a must-have sneaker.',
      imageUrls: [
        'assets/images/air_max_1.png',
      ],
      sizes: {
        'US': ['5', '5.5', '6', '6.5', '7', '7.5', '8', '8.5', '9'],
        'UK': ['4', '4.5', '5', '5.5', '6', '6.5', '7', '7.5', '8'],
        'EU': ['37', '38', '39', '40', '41', '42', '43', '44', '45'],
      },
    ),
    Product(
      id: 'p2',
      name: "Nike Kobe 4",
      category: "Men's Shoe",
      price: 110.00,
      rating: 4.7,
      reviewCount: 342,
      description: "The radiance lives on in theNike Kobe 4, the basketball "
          'original that puts a fresh spin on what you know best: durably '
          'stitched overlays, iconic foam midsole and the classic Swoosh.',
      imageUrls: [
        'assets/images/air_force_1.png',
      ],
      sizes: {
        'US': ['5', '5.5', '6', '6.5', '7', '7.5', '8'],
        'UK': ['3', '3.5', '4', '4.5', '5', '5.5', '6'],
        'EU': ['36', '37', '38', '39', '40', '41'],
      },
    ),
    Product(
      id: 'p3',
      name: 'Nike SB Dunk High',
      category: "Men's Shoe",
      price: 250.00,
      rating: 4.3,
      reviewCount: 96,
      description:
          'Nike SB Dunk High combines an ultra-lightweight, form-fitting '
          'SB Dunk High upper with a Zoom Air unit and waffle outsole for a '
          'featherlight feel with solid grip and responsive cushioning on any terrain.',
      imageUrls: [
        'assets/images/flyknit_1.png',
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
      name: "Nike Air Max Thea",
      category: "Women's Shoe",
      price: 115.00,
      rating: 4.6,
      reviewCount: 214,
      description:
          "The Women's Nike Air Max Thea delivers a bold high-top silhouette "
          'with a premium leather upper and padded collar for superior ankle '
          'support. The classic rubber cupsole keeps every step grounded, '
          'making it as wearable on the street as it is iconic on the shelf.',
      imageUrls: [
        'assets/images/pegasus_1.png',
      ],
      sizes: {
        'US': ['5', '5.5', '6', '6.5', '7', '7.5', '8', '8.5', '9'],
        'UK': ['3', '3.5', '4', '4.5', '5', '5.5', '6', '6.5', '7'],
        'EU': ['36', '37', '38', '39', '40', '41', '42'],
      },
    ),
    Product(
      id: 'p5',
      name: "Nike Free Run 2",
      category: "Running Shoe",
      price: 120.00,
      rating: 4.4,
      reviewCount: 256,
      description:
          "The Nike Free Run 2 running shoes feature a lightweight, flexible design "
          "that provides a barefoot-like feel for a natural stride. The breathable "
          "mesh upper and Phylon midsole deliver exceptional comfort and support.",
      imageUrls: [
        'assets/images/air_force_2.png',
      ],
      sizes: {
        'US': ['7', '7.5', '8', '8.5', '9', '9.5', '10', '10.5', '11'],
        'UK': ['6', '6.5', '7', '7.5', '8', '8.5', '9', '9.5', '10'],
        'EU': ['40', '41', '42', '43', '44', '45'],
      },
    ),
    Product(
      id: 'p6',
      name: "Nike Dual Fusion Run",
      category: "Running Shoe",
      price: 95.00,
      rating: 4.8,
      reviewCount: 312,
      description:
          "The Nike Dual Fusion Run women's running shoes offer a dual-density "
          "midsole for superior cushioning and support. The breathable mesh upper "
          "and durable rubber outsole provide a comfortable and stable ride.",
      imageUrls: [
        'assets/images/air_force_3.png',
      ],
      sizes: {
        'US': ['5', '5.5', '6', '6.5', '7', '7.5', '8', '8.5', '9'],
        'UK': ['3', '3.5', '4', '4.5', '5', '5.5', '6', '6.5', '7'],
        'EU': ['36', '37', '38', '39', '40', '41', '42'],
      },
    ),
    Product(
      id: 'p7',
      name: "Nike Lunar Ascend",
      category: "Golf Shoes",
      price: 130.00,
      rating: 4.6,
      reviewCount: 184,
      description:
          "The Nike Lunar Ascend Golf Shoes feature lightweight Lunarlon cushioning "
          "and a durable, spikeless outsole for exceptional comfort and traction on "
          "the course. The sleek design ensures you look sharp while playing.",
      imageUrls: [
        'assets/images/air_max_2.png',
      ],
      sizes: {
        'US': ['8', '8.5', '9', '9.5', '10', '10.5', '11', '11.5', '12'],
        'UK': ['7', '7.5', '8', '8.5', '9', '9.5', '10', '10.5', '11'],
        'EU': ['41', '42', '43', '44', '45', '46'],
      },
    ),
    Product(
      id: 'p8',
      name: "Air Force 1",
      category: "Men's Shoe",
      price: 110.00,
      rating: 4.5,
      reviewCount: 150,
      description:
          "The Air Force 1 is a classic shoe that never goes out of style. "
          "It features a durable leather upper and a comfortable air-cushioned sole.",
      imageUrls: [
        'assets/images/air_force1.png',
      ],
      sizes: {
        'US': ['7', '7.5', '8', '8.5', '9', '9.5', '10', '10.5', '11'],
        'UK': ['6', '6.5', '7', '7.5', '8', '8.5', '9', '9.5', '10'],
        'EU': ['40', '41', '42', '43', '44', '45'],
      },
    ),
    Product(
      id: 'p9',
      name: "Nike Air Max Plus OG",
      category: "Men's Shoe",
      price: 160.00,
      rating: 4.7,
      reviewCount: 210,
      description:
          "The Nike Air Max Plus OG brings back the iconic design with modern comfort. "
          "It features the signature Tuned Air technology for optimal stability and cushioning.",
      imageUrls: [
        'assets/images/nike_air_max_plus_og.webp',
      ],
      sizes: {
        'US': ['7', '7.5', '8', '8.5', '9', '9.5', '10', '10.5', '11'],
        'UK': ['6', '6.5', '7', '7.5', '8', '8.5', '9', '9.5', '10'],
        'EU': ['40', '41', '42', '43', '44', '45'],
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
        text:
            "The most comfortable Nike Air Pegasus+ 30  I've worn. The sole cushioning is "
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
        text:
            "Stylish and very comfortable. The Nike Air Pegasus unit under the heel "
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
            "best after switching to these. The Nike SB Dunk High hugs your "
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
        text:
            "Obsessed with the Women's Nike Air Max Thea! The ankle support is "
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
        text: "Love the high-top silhouette on the Nike Air Max Thea. "
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
        text: "The Nike Air Max Thea is a classic for a reason. Great build "
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
    'p5': [
      Review(
        id: 'r5a',
        productId: 'p5',
        reviewerName: 'John Doe',
        avatarUrl: 'https://i.pravatar.cc/100?img=12',
        rating: 5.0,
        text:
            "Very comfortable for everyday running. They feel incredibly light "
            "and natural on the feet. Highly recommend the Free Run 2.",
        date: '10.05.2024',
      ),
      Review(
        id: 'r5b',
        productId: 'p5',
        reviewerName: 'Mike Smith',
        avatarUrl: 'https://i.pravatar.cc/100?img=13',
        rating: 4.0,
        text:
            "Good flexibility, but the sole wears out a bit faster than expected. "
            "Still a solid running shoe overall.",
        date: '08.05.2024',
      ),
    ],
    'p6': [
      Review(
        id: 'r6a',
        productId: 'p6',
        reviewerName: 'Sarah Jenkins',
        avatarUrl: 'https://i.pravatar.cc/100?img=14',
        rating: 5.0,
        text:
            "The Dual Fusion cushioning is amazing. Perfect for my morning jogs. "
            "They fit true to size and look great too.",
        date: '12.05.2024',
      ),
      Review(
        id: 'r6b',
        productId: 'p6',
        reviewerName: 'Emily Clark',
        avatarUrl: 'https://i.pravatar.cc/100?img=15',
        rating: 4.5,
        text: "Great support and comfort. Took a little time to break in, but "
            "now they are my go-to running shoes.",
        date: '05.05.2024',
      ),
    ],
    'p7': [
      Review(
        id: 'r7a',
        productId: 'p7',
        reviewerName: 'David Lee',
        avatarUrl: 'https://i.pravatar.cc/100?img=17',
        rating: 5.0,
        text:
            "Excellent grip on the course without the need for traditional spikes. "
            "The Lunarlon foam keeps my feet fresh through 18 holes.",
        date: '15.05.2024',
      ),
      Review(
        id: 'r7b',
        productId: 'p7',
        reviewerName: 'Chris Evans',
        avatarUrl: 'https://i.pravatar.cc/100?img=18',
        rating: 4.0,
        text:
            "Very comfortable golf shoes. They look like regular sneakers which "
            "is nice. Just make sure to get the right size.",
        date: '11.05.2024',
      ),
    ],
    'p8': [
      Review(
        id: 'r8a',
        productId: 'p8',
        reviewerName: 'Alex Johnson',
        avatarUrl: 'https://i.pravatar.cc/100?img=20',
        rating: 5.0,
        text:
            "You can never go wrong with a classic pair. Perfect fit and style.",
        date: '18.05.2024',
      ),
    ],
    'p9': [
      Review(
        id: 'r9a',
        productId: 'p9',
        reviewerName: 'Sam Riley',
        avatarUrl: 'https://i.pravatar.cc/100?img=21',
        rating: 4.5,
        text: "Love the retro look and the Tuned Air cushioning is superb.",
        date: '19.05.2024',
      ),
    ],
  };

  /// Helper to get reviews for a specific product id
  static List<Review> reviewsFor(String productId) =>
      reviewsByProduct[productId] ?? [];
}
