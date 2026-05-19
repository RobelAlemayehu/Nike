# 👟 Nike Shop — Flutter Mobile App

A premium Nike e-commerce mobile app UI built with Flutter, inspired by the Dribbble design. Features 3 fully functional, animated screens with clean architecture and Material 3.

---

## 📱 Screens

| Screen | Description |
|--------|-------------|
| **Product Detail** | Shoe image carousel, size picker (US/UK/EU), expandable sections, add to cart |
| **Reviews** | Customer reviews with dynamic star ratings, staggered animations |
| **My Bag / Cart** | Quantity controls, dismissible items, live total, checkout dialog, bookmark sheet |

---

## 🏗️ Project Structure

```
lib/
├── constants/
│   ├── app_colors.dart        # Orange accent + neutral palette
│   ├── app_text_styles.dart   # Poppins typography system
│   └── app_dimensions.dart    # Spacing, radius, size tokens
├── models/
│   ├── product_model.dart     # Product data model
│   ├── review_model.dart      # Review data model
│   └── cart_item_model.dart   # Cart item (product + qty + bookmark)
├── providers/
│   ├── cart_provider.dart     # Global cart state (ChangeNotifier)
│   └── product_provider.dart  # Size selection, carousel, favourite
├── screens/
│   ├── product_detail_screen.dart
│   ├── reviews_screen.dart
│   └── cart_screen.dart
├── widgets/
│   ├── app_header.dart        # Shared header with cart badge
│   ├── rating_widget.dart     # Dynamic star rating (full/half/empty)
│   ├── quantity_selector.dart # Animated +/- qty controls
│   ├── expandable_tile.dart   # Custom animated expandable section
│   ├── cart_item_widget.dart  # Dismissible cart card
│   └── add_to_cart_bar.dart   # Bottom bookmark + add-to-cart bar
├── data/
│   └── mock_data.dart         # 3 products + 4 reviews (Unsplash images)
└── main.dart                  # App entry point + MultiProvider + theme
```

---

## 🚀 Getting Started

### Prerequisites
- Flutter **3.x** (stable channel)
- Dart **3.x**
- Android Studio / VS Code with Flutter plugin
- A connected device or emulator

### Setup

```bash
# 1. Clone / open the project
cd "Shoe Shopping App"

# 2. Install dependencies
flutter pub get

# 3. Run on a connected device or emulator
flutter run

# 4. Run static analysis
flutter analyze

# 5. Run tests
flutter test
```

---

## 📦 Dependencies

| Package | Purpose |
|---------|---------|
| `provider ^6.1.2` | State management |
| `smooth_page_indicator ^1.2.0+3` | Carousel dot indicators |
| `google_fonts ^6.2.1` | Poppins font |
| `animate_do ^3.3.4` | FadeInUp stagger animations |

---

## ✨ Features

- **Image Carousel** — PageView with smooth swipe + dot indicators
- **Hero Animations** — Shoe image shared-element transition
- **Size Picker** — US / UK / EU tabs with animated chip selection
- **Expandable Sections** — Custom animated tiles with chevron rotation
- **Cart State** — Provider shared across all 3 screens; badge updates instantly
- **Quantity Controls** — Animated +/− with live total recalculation
- **Dismissible Cart Items** — Swipe-to-delete with orange reveal background
- **Bookmark System** — Toggle per cart item; visible in bottom sheet
- **Checkout Dialog** — Order success modal that clears cart and navigates back
- **Empty Cart State** — Illustrated empty state with CTA button
- **Material 3** — Full M3 color system with orange seed color
- **Dark Mode** — Dark theme defined (set `themeMode: ThemeMode.dark` to enable)
- **Null Safety** — 100% sound null safety throughout

---

## 🎨 Design System

| Token | Value |
|-------|-------|
| Accent Orange | `#FF6B35` |
| Background | `#F8F8F8` |
| Card White | `#FFFFFF` |
| Text Black | `#1A1A1A` |
| Font | Poppins (400 → 900) |
| Border Radius | 12 / 16 / 20 / 24 px |

---

## 📸 Screenshots

> Run the app on a device and use `flutter screenshot` or your emulator's screenshot tool.

---

## 📄 License

This project is for educational / portfolio purposes. Nike brand assets belong to Nike, Inc.
# Nike
