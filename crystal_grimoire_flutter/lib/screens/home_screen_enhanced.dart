import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/app_state.dart';
import '../widgets/animations/mystical_animations.dart';
import '../widgets/common/mystical_button.dart';
import '../widgets/common/mystical_card.dart';
import '../widgets/crystal_logo_painter.dart';
import '../widgets/daily_crystal_card.dart';
import 'camera_screen.dart';
import 'collection_screen.dart';
import 'journal_screen.dart';
import 'settings_screen.dart';
import 'metaphysical_guidance_screen.dart';
import 'account_screen.dart';
import 'dart:math' as math;

class EnhancedHomeScreen extends StatefulWidget {
  const EnhancedHomeScreen({Key? key}) : super(key: key);

  @override
  State<EnhancedHomeScreen> createState() => _EnhancedHomeScreenState();
}

class _EnhancedHomeScreenState extends State<EnhancedHomeScreen> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  late AnimationController _floatController;
  late Animation<double> _floatAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    ));
    
    _floatController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);
    
    _floatAnimation = Tween<double>(
      begin: -10.0,
      end: 10.0,
    ).animate(CurvedAnimation(
      parent: _floatController,
      curve: Curves.easeInOut,
    ));
    
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _floatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appState = context.watch<AppState>();
    
    return Scaffold(
      body: Stack(
        children: [
          // Enhanced mystical background gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF0A0A1F), // Deep midnight blue
                  Color(0xFF1A0A2F), // Purple-tinted dark
                  Color(0xFF0F0F23), // Original dark
                ],
                stops: [0.0, 0.5, 1.0],
              ),
            ),
          ),
          
          // Enhanced floating particles with multiple layers
          Stack(
            children: [
              FloatingParticles(
                particleCount: 20,
                color: Colors.purpleAccent.withOpacity(0.3),
                speed: 0.5,
              ),
              FloatingParticles(
                particleCount: 10,
                color: Colors.cyanAccent.withOpacity(0.2),
                speed: 0.8,
              ),
              FloatingParticles(
                particleCount: 5,
                color: Colors.amberAccent.withOpacity(0.2),
                speed: 1.2,
              ),
            ],
          ),
          
          // Main content
          SafeArea(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: CustomScrollView(
                slivers: [
                  // Enhanced header with custom logo and title
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          // Animated custom crystal logo
                          FadeScaleIn(
                            delay: const Duration(milliseconds: 200),
                            child: AnimatedBuilder(
                              animation: _floatAnimation,
                              builder: (context, child) {
                                return Transform.translate(
                                  offset: Offset(0, _floatAnimation.value),
                                  child: const AnimatedCrystalLogo(size: 100),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 20),
                          
                          // Enhanced app title with gradient and custom font
                          FadeScaleIn(
                            delay: const Duration(milliseconds: 400),
                            child: ShaderMask(
                              shaderCallback: (bounds) => LinearGradient(
                                colors: [
                                  Color(0xFF9C27B0), // Purple
                                  Color(0xFF00BCD4), // Teal
                                  Color(0xFFFF5722), // Orange
                                ],
                                stops: [0.0, 0.5, 1.0],
                              ).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
                              child: Text(
                                'Crystal Grimoire',
                                style: GoogleFonts.cinzelDecorative(
                                  fontSize: 42,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: 2,
                                ),
                              ),
                            ),
                          ),
                          
                          const SizedBox(height: 8),
                          
                          // Animated subtitle
                          FadeScaleIn(
                            delay: const Duration(milliseconds: 600),
                            child: AnimatedDefaultTextStyle(
                              duration: Duration(seconds: 2),
                              style: GoogleFonts.raleway(
                                fontSize: 16,
                                color: Colors.white.withOpacity(0.8),
                                letterSpacing: 1.5,
                              ),
                              child: Text('Your Mystical Crystal Companion'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  // Main action button
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: FadeScaleIn(
                        delay: const Duration(milliseconds: 800),
                        child: Container(
                          height: 80,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            gradient: LinearGradient(
                              colors: [
                                Color(0xFF00BCD4),
                                Color(0xFF9C27B0),
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xFF00BCD4).withOpacity(0.4),
                                blurRadius: 20,
                                offset: Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () => _navigateToIdentify(context),
                              borderRadius: BorderRadius.circular(20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.camera_alt, color: Colors.white, size: 32),
                                  SizedBox(width: 12),
                                  Text(
                                    'Identify Crystal',
                                    style: GoogleFonts.poppins(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  
                  // Feature cards grid
                  SliverPadding(
                    padding: const EdgeInsets.all(20.0),
                    sliver: SliverGrid(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        childAspectRatio: 1.0,
                      ),
                      delegate: SliverChildListDelegate([
                        FadeScaleIn(
                          delay: const Duration(milliseconds: 1000),
                          child: FeatureCard(
                            icon: Icons.collections_bookmark,
                            title: 'Collection',
                            description: 'Your crystal inventory',
                            iconColor: Colors.amber,
                            isPremium: true,
                            infoText: '${appState.collectionCount} Crystals',
                            infoSubtext: 'Premium Feature',
                            onTap: () => _navigateToCollection(context),
                          ),
                        ),
                        FadeScaleIn(
                          delay: const Duration(milliseconds: 1100),
                          child: FeatureCard(
                            icon: Icons.auto_stories,
                            title: 'Journal',
                            description: 'Spiritual diary',
                            iconColor: Colors.blue,
                            isPremium: false,
                            infoText: '${appState.journalEntryCount} Entries',
                            infoSubtext: 'Start Writing',
                            onTap: () => _navigateToJournal(context),
                          ),
                        ),
                        FadeScaleIn(
                          delay: const Duration(milliseconds: 1200),
                          child: FeatureCard(
                            icon: Icons.auto_fix_high,
                            title: 'Guidance',
                            description: 'AI spiritual wisdom',
                            iconColor: Colors.purple,
                            isPremium: true,
                            infoText: '${appState.guidanceQueriesUsed}/5',
                            infoSubtext: 'Pro Feature',
                            onTap: () => _navigateToMetaphysicalGuidance(context),
                          ),
                        ),
                        FadeScaleIn(
                          delay: const Duration(milliseconds: 1300),
                          child: FeatureCard(
                            icon: Icons.account_circle,
                            title: 'Account',
                            description: 'Profile & billing',
                            iconColor: Colors.green,
                            infoText: appState.isSignedIn ? 'Signed In' : 'Guest',
                            infoSubtext: appState.subscriptionTier.toUpperCase(),
                            onTap: () => _navigateToAccount(context),
                          ),
                        ),
                      ]),
                    ),
                  ),
                  
                  // Daily Crystal Card - moved down and integrated better
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: FadeScaleIn(
                        delay: const Duration(milliseconds: 1400),
                        child: _buildDailyCrystalCard(context, theme),
                      ),
                    ),
                  ),
                  
                  // Daily Spiritual Section
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: FadeScaleIn(
                        delay: const Duration(milliseconds: 1500),
                        child: _buildDailySpiritualSection(context, theme),
                      ),
                    ),
                  ),
                  
                  // Usage stats with better design
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: FadeScaleIn(
                        delay: const Duration(milliseconds: 1600),
                        child: _buildEnhancedUsageCard(context, appState, theme),
                      ),
                    ),
                  ),
                  
                  // Bottom padding
                  const SliverToBoxAdapter(
                    child: SizedBox(height: 80),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      
      // Enhanced floating action button
      floatingActionButton: FadeScaleIn(
        delay: const Duration(milliseconds: 1700),
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [
                Color(0xFF00BCD4),
                Color(0xFF9C27B0),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: Color(0xFF00BCD4).withOpacity(0.4),
                blurRadius: 20,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: FloatingActionButton(
            onPressed: () => _navigateToIdentify(context),
            backgroundColor: Colors.transparent,
            elevation: 0,
            child: Icon(Icons.add_a_photo, color: Colors.white, size: 28),
          ),
        ),
      ),
    );
  }
  
  Widget _buildDailyCrystalCard(BuildContext context, ThemeData theme) {
    final crystals = ['Amethyst', 'Rose Quartz', 'Clear Quartz', 'Citrine', 'Black Tourmaline'];
    final crystal = crystals[DateTime.now().day % crystals.length];
    
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.purple.withOpacity(0.3),
            Colors.deepPurple.withOpacity(0.4),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.purpleAccent.withOpacity(0.5),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.auto_awesome, color: Colors.amber, size: 24),
              SizedBox(width: 8),
              Text(
                'Crystal of the Day',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.amber,
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Text(
            crystal,
            style: GoogleFonts.cinzel(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 8),
          Text(
            _getCrystalMessage(crystal),
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.8),
            ),
          ),
          SizedBox(height: 12),
          Row(
            children: [
              _buildCrystalProperty('Protection', Icons.shield),
              SizedBox(width: 16),
              _buildCrystalProperty('Healing', Icons.favorite),
              SizedBox(width: 16),
              _buildCrystalProperty('Clarity', Icons.visibility),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildCrystalProperty(String label, IconData icon) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white70, size: 16),
          SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: Colors.white70,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
  
  String _getCrystalMessage(String crystal) {
    final messages = {
      'Amethyst': 'Enhances intuition and spiritual connection',
      'Rose Quartz': 'Opens the heart to unconditional love',
      'Clear Quartz': 'Amplifies energy and clarifies thoughts',
      'Citrine': 'Attracts abundance and positive energy',
      'Black Tourmaline': 'Provides protection and grounding',
    };
    return messages[crystal] ?? 'Discover the magic within';
  }
  
  Widget _buildDailySpiritualSection(BuildContext context, ThemeData theme) {
    final spiritualMessages = [
      "The universe speaks through crystal vibrations today",
      "Your intuition is heightened under the current lunar phase",
      "Trust the crystals that call to you - they have messages",
      "Today's energy supports deep healing and transformation",
      "The veil between worlds is thin - perfect for crystal work",
    ];
    
    final dailyMessage = spiritualMessages[DateTime.now().day % spiritualMessages.length];
    final moonPhase = _getCurrentMoonPhase();
    final numerologyNumber = (DateTime.now().day % 9) + 1;
    
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.deepPurple.withOpacity(0.3),
            Colors.indigo.withOpacity(0.2),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.purpleAccent.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.stars, color: Colors.amberAccent, size: 24),
              SizedBox(width: 8),
              Text(
                'Daily Spiritual Guidance',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.amberAccent,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Text(
            dailyMessage,
            style: GoogleFonts.raleway(
              fontSize: 16,
              fontStyle: FontStyle.italic,
              color: Colors.white.withOpacity(0.9),
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildDailyInsightChip(
                icon: Icons.nightlight_round,
                label: moonPhase,
                color: Colors.blue,
              ),
              _buildDailyInsightChip(
                icon: Icons.looks_one,
                label: 'Number $numerologyNumber',
                color: Colors.purple,
              ),
              _buildDailyInsightChip(
                icon: Icons.local_fire_department,
                label: _getElement(),
                color: Colors.orange,
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildDailyInsightChip({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withOpacity(0.5),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 18),
          SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
  
  String _getCurrentMoonPhase() {
    final phases = ['New Moon', 'Waxing', 'Full Moon', 'Waning'];
    return phases[DateTime.now().day ~/ 8 % phases.length];
  }
  
  String _getElement() {
    final elements = ['Fire', 'Earth', 'Air', 'Water'];
    return elements[DateTime.now().day % elements.length];
  }
  
  Widget _buildEnhancedUsageCard(BuildContext context, AppState appState, ThemeData theme) {
    final usageData = appState.currentMonthUsage;
    final isFreeTier = appState.subscriptionTier == 'free';
    final limit = appState.monthlyLimit;
    final used = usageData['identifications'] ?? 0;
    final remaining = limit - used;
    final percentage = limit > 0 ? used / limit : 0.0;
    
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.surface.withOpacity(0.8),
            theme.colorScheme.surface.withOpacity(0.6),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Daily Usage',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    isFreeTier ? 'Free Tier' : appState.subscriptionTier.toUpperCase(),
                    style: TextStyle(
                      fontSize: 12,
                      color: isFreeTier ? Colors.grey : Colors.amber,
                    ),
                  ),
                ],
              ),
              if (isFreeTier)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.purple, Colors.deepPurple],
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Upgrade',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 20),
          
          // Enhanced usage display
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$used / $limit',
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    Text(
                      'Crystals Identified Today',
                      style: TextStyle(
                        fontSize: 12,
                        color: theme.colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 80,
                height: 80,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CircularProgressIndicator(
                      value: percentage,
                      strokeWidth: 8,
                      backgroundColor: theme.colorScheme.primary.withOpacity(0.2),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        percentage > 0.8 ? Colors.orange : theme.colorScheme.primary,
                      ),
                    ),
                    Text(
                      '$remaining',
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    Positioned(
                      bottom: 20,
                      child: Text(
                        'left',
                        style: TextStyle(
                          fontSize: 10,
                          color: theme.colorScheme.onSurface.withOpacity(0.7),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          if (isFreeTier) ...[
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.amber.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.amber.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.star, color: Colors.amber, size: 20),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Upgrade for unlimited identifications & premium features!',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.amber,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
  
  // Navigation methods
  void _navigateToIdentify(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CameraScreen()),
    );
  }
  
  void _navigateToCollection(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CollectionScreen()),
    );
  }
  
  void _navigateToJournal(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const JournalScreen()),
    );
  }
  
  void _navigateToMetaphysicalGuidance(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MetaphysicalGuidanceScreen()),
    );
  }
  
  void _navigateToAccount(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AccountScreen()),
    );
  }
}

// Keep the enhanced FeatureCard from original file
class FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final Color iconColor;
  final VoidCallback onTap;
  final bool isPremium;
  final String? infoText;
  final String? infoSubtext;

  const FeatureCard({
    Key? key,
    required this.icon,
    required this.title,
    required this.description,
    required this.iconColor,
    required this.onTap,
    this.isPremium = false,
    this.infoText,
    this.infoSubtext,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              theme.colorScheme.surface.withOpacity(0.8),
              theme.colorScheme.surface.withOpacity(0.6),
            ],
          ),
          border: Border.all(
            color: isPremium 
              ? Colors.amber.withOpacity(0.5)
              : theme.colorScheme.outline.withOpacity(0.2),
            width: isPremium ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isPremium 
                ? Colors.amber.withOpacity(0.2)
                : Colors.black.withOpacity(0.1),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          iconColor.withOpacity(0.3),
                          iconColor.withOpacity(0.1),
                        ],
                      ),
                    ),
                    child: Icon(
                      icon,
                      size: 32,
                      color: iconColor,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 11,
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                  ),
                  if (infoText != null) ...[
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: iconColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          Text(
                            infoText!,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: iconColor,
                            ),
                          ),
                          if (infoSubtext != null)
                            Text(
                              infoSubtext!,
                              style: TextStyle(
                                fontSize: 10,
                                color: iconColor.withOpacity(0.8),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (isPremium)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.amber, Colors.orange],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.star, size: 12, color: Colors.black),
                      const SizedBox(width: 2),
                      Text(
                        'PRO',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}