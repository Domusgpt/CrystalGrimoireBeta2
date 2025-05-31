# Crystal Grimoire Flutter Project - CLAUDE.md

## 🔮 Project Overview
Crystal Grimoire is a mystical Flutter web application for crystal identification, collection management, and spiritual guidance. Currently undergoing major UI/UX redesign and feature expansion.

## 📍 Current Status
- **Phase**: Major redesign implementation based on user feedback
- **Live URL**: https://domusgpt.github.io/CrystalGrimoireBeta2/
- **Deployment**: GitHub Pages with GitHub Actions static deployment
- **Framework**: Flutter 3.10+ for web deployment

## 🎯 Critical Implementation Priorities

### Phase 1: Visual Redesign (CRITICAL - Week 1-2)
1. **Logo Replacement**: Replace "Crystal Grimoire" text with teal/red gem logo
2. **Homepage Restructure**: 
   - Enhanced Crystal of the Day (bigger, more dynamic, sparkle effects)
   - Crystal Identification prominence (top priority positioning)
   - Navigation updates (Gallery → Collection, Journal → Marketplace)

### Phase 2: Marketplace Development (HIGH - Week 3-6)
- Replace Spiritual Journal with full marketplace
- Metallic shimmer UI (ruby, emerald, sapphire effects)
- Buy/sell functionality with payment integration
- User tier system (priority for paid users)

### Phase 3: Collection & ID Features (HIGH - Week 7-8)
- Collection behind paywall (free = 5 crystals, paid = unlimited)
- Enhanced crystal identification (photo + verbal description)
- Auto-updating chakra coverage
- Quick Guide integration within Collection

## 🛠 Technical Architecture

### Current Tech Stack
```yaml
Framework: Flutter 3.10+
State Management: Provider pattern
Database: Local storage + SharedPreferences
Deployment: GitHub Pages
Audio: audioplayers package
Animations: Custom AnimationController widgets
Theme: Custom mystical theme with gradients
```

### Required New Dependencies
```yaml
# Payment & Marketplace
stripe_payment: ^1.1.4
purchases_flutter: ^6.4.0

# Crystal Identification
image_picker: ^0.8.7+4
camera: ^0.10.5+2
tflite_flutter: ^0.10.4

# Enhanced Animations
rive: ^0.11.4
lottie: ^2.4.0
```

## 📁 Key File Locations

### Core App Structure
- `lib/main.dart` - App entry point with routing
- `lib/screens/home_screen.dart` - Homepage requiring major redesign
- `lib/screens/crystal_gallery_screen.dart` - Convert to collection with paywall
- `lib/widgets/enhanced_app_title.dart` - Logo replacement needed here

### Critical Files for Redesign
- `lib/widgets/daily_crystal_card.dart` - Enhance with animations
- `lib/screens/spiritual_journal_screen.dart` - Replace with marketplace
- `lib/config/enhanced_theme.dart` - Add marketplace colors/effects
- `lib/widgets/animations/enhanced_animations.dart` - Shimmer effects

### New Files to Create
- `lib/screens/marketplace_screen.dart` - Complete marketplace
- `lib/screens/crystal_identification_screen.dart` - Enhanced ID system
- `lib/widgets/gem_logo.dart` - New teal/red gem logo
- `lib/services/subscription_service.dart` - User tier management
- `lib/services/marketplace_service.dart` - Buy/sell functionality

## 🎨 Design Specifications

### Color Palette
```dart
// New primary colors for gem logo
static const Color tealGem = Color(0xFF20B2AA);
static const Color redGem = Color(0xFF FF4500);

// Marketplace metallics
static const Color marketplaceGold = Color(0xFFFFD700);
static const Color marketplaceRuby = Color(0xFFE0115F);
static const Color marketplaceEmerald = Color(0xFF50C878);
static const Color marketplaceSapphire = Color(0xFF0F52BA);
```

### Animation Guidelines
- **Shimmer Duration**: 2-3 seconds
- **Sparkle Effects**: 15-20 particles, 1.5s lifetime
- **Gem Logo**: 360° rotation over 4s + scale pulse
- **Crystal of Day**: Ammolite/diamond sparkle effects

## 🚀 Development Workflow

### Building & Deployment
```bash
# Local development
flutter run -d web-server --web-port 8080

# Production build for GitHub Pages
flutter build web --release --base-href="/CrystalGrimoireBeta2/"

# Deploy to GitHub Pages
cp -r build/web/* . && git add . && git commit -m "Deploy updates" && git push
```

### Testing Strategy
1. **Local Testing**: Test all features in debug mode
2. **Console Verification**: Ensure no 404 errors or animation issues
3. **Mobile Responsive**: Test on various screen sizes
4. **Payment Flow**: Thoroughly test marketplace transactions
5. **Performance**: Monitor for smooth animations and fast loading

## 📊 User Experience Goals

### Current Issues to Address
- Logo needs to be more prominent and mystical
- Crystal of the Day lacks visual impact
- Crystal identification needs higher visibility
- Spiritual Journal underutilized (convert to marketplace)
- Quick Guide isolated (integrate into Collection)

### Target Improvements
- 40% increase in daily active users
- 60% increase in session duration
- 15-20% premium conversion rate
- Smooth, professional animations throughout
- Marketplace generating revenue within 3 months

## 🔧 Implementation Notes

### Deployment Considerations
- Use GitHub Actions static deployment (not Jekyll)
- Absolute paths required for GitHub Pages subdirectory
- Service worker caching may need clearing for major updates
- Test favicon.png and manifest.json accessibility

### Performance Optimization
- Optimize animation frame rates
- Lazy load marketplace images
- Compress audio files for sound bath
- Minimize bundle size with tree shaking

### User Tier System
```dart
enum UserTier {
  free,      // 5 crystal limit, basic features
  premium,   // $9.99/month, unlimited crystals
  pro        // $19.99/month, marketplace priority
}
```

## 📝 Development Guidelines

1. **Follow Development Plan**: Reference CRYSTAL_GRIMOIRE_DEVELOPMENT_PLAN.md
2. **Use Todo System**: Update TodoWrite for all major changes
3. **Maintain Mystical Theme**: Keep magical, spiritual aesthetic
4. **Test Before Deploy**: Always verify on GitHub Pages
5. **User-Centric**: Prioritize user experience over technical perfection
6. **Revenue Focus**: Marketplace and subscriptions are key monetization

## 🚨 Critical Notes

- **NO SHORTCUTS**: This is a production app requiring professional quality
- **Visual Appeal**: User specifically wants flashy, dynamic effects
- **Marketplace Priority**: This is the primary revenue generator
- **Collection Paywall**: Essential for subscription model
- **Mobile First**: Ensure responsive design on all devices

## 📚 Reference Documents
- `/CRYSTAL_GRIMOIRE_DEVELOPMENT_PLAN.md` - Complete technical specifications
- `/Changes for APP/suggestions for some chnsges.md` - Detailed implementation guide
- Screenshots in `/Changes for APP/` - Visual references for design