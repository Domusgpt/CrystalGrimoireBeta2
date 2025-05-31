import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../data/crystal_database.dart';
import '../config/enhanced_theme.dart';
import '../widgets/common/enhanced_mystical_widgets.dart';
import '../widgets/animations/enhanced_animations.dart';
import 'crystal_info_screen.dart';

class CrystalGalleryScreen extends StatefulWidget {
  const CrystalGalleryScreen({Key? key}) : super(key: key);

  @override
  State<CrystalGalleryScreen> createState() => _CrystalGalleryScreenState();
}

class _CrystalGalleryScreenState extends State<CrystalGalleryScreen> 
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  String _selectedFilter = 'All';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  
  final List<String> _filterOptions = [
    'All',
    'Common',
    'Rare',
    'Protection',
    'Love',
    'Healing',
    'Spiritual',
    'Abundance',
  ];

  final List<String> _chakras = [
    'Root',
    'Sacral',
    'Solar Plexus',
    'Heart',
    'Throat',
    'Third Eye',
    'Crown',
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  List<CrystalData> get filteredCrystals {
    var crystals = CrystalDatabase.crystals;
    
    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      crystals = CrystalDatabase.searchCrystals(_searchQuery);
    }
    
    // Apply category filter
    switch (_selectedFilter) {
      case 'Common':
        crystals = crystals.where((c) => c.rarity == 'Common' || c.rarity == 'Very Common').toList();
        break;
      case 'Rare':
        crystals = crystals.where((c) => c.rarity.contains('rare')).toList();
        break;
      case 'Protection':
        crystals = crystals.where((c) => c.keywords.contains('protection')).toList();
        break;
      case 'Love':
        crystals = crystals.where((c) => c.keywords.contains('love') || c.keywords.contains('heart')).toList();
        break;
      case 'Healing':
        crystals = crystals.where((c) => c.keywords.contains('healing')).toList();
        break;
      case 'Spiritual':
        crystals = crystals.where((c) => c.keywords.contains('spiritual') || c.keywords.contains('psychic')).toList();
        break;
      case 'Abundance':
        crystals = crystals.where((c) => c.keywords.contains('abundance') || c.keywords.contains('prosperity')).toList();
        break;
    }
    
    return crystals;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: CrystalGrimoireTheme.backgroundGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              _buildSearchBar(),
              _buildFilterChips(),
              Expanded(
                child: _buildCrystalGrid(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          const SizedBox(width: 8),
          const Text(
            '💎 Crystal Encyclopedia',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
        ),
      ),
      child: TextField(
        controller: _searchController,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: 'Search crystals by name, color, or property...',
          hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
          prefixIcon: const Icon(Icons.search, color: Colors.white70),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, color: Colors.white70),
                  onPressed: () {
                    setState(() {
                      _searchController.clear();
                      _searchQuery = '';
                    });
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        ),
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
        },
      ),
    );
  }

  Widget _buildFilterChips() {
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _filterOptions.length,
        itemBuilder: (context, index) {
          final filter = _filterOptions[index];
          final isSelected = _selectedFilter == filter;
          
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(filter),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedFilter = filter;
                });
              },
              backgroundColor: Colors.white.withOpacity(0.1),
              selectedColor: CrystalGrimoireTheme.mysticPurple,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : Colors.white70,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              side: BorderSide(
                color: isSelected 
                    ? CrystalGrimoireTheme.amethyst 
                    : Colors.white.withOpacity(0.3),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCrystalGrid() {
    final crystals = filteredCrystals;
    
    if (crystals.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: Colors.white.withOpacity(0.3),
            ),
            const SizedBox(height: 16),
            Text(
              'No crystals found',
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try adjusting your search or filters',
              style: TextStyle(
                color: Colors.white.withOpacity(0.5),
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    }
    
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: crystals.length,
      itemBuilder: (context, index) {
        final crystal = crystals[index];
        return _buildCrystalCard(crystal);
      },
    );
  }

  Widget _buildCrystalCard(CrystalData crystal) {
    return GestureDetector(
      onTap: () => _showCrystalDetails(crystal),
      child: EnhancedMysticalCard(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            _getCrystalColor(crystal).withOpacity(0.3),
            CrystalGrimoireTheme.royalPurple.withOpacity(0.6),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Crystal image placeholder
            Container(
              height: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  colors: [
                    _getCrystalColor(crystal).withOpacity(0.6),
                    _getCrystalColor(crystal).withOpacity(0.3),
                  ],
                ),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Icon(
                      Icons.diamond,
                      size: 60,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                  if (crystal.videoAsset != null)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.play_circle_filled,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              crystal.name,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              crystal.colorDescription,
              style: TextStyle(
                fontSize: 12,
                color: Colors.white.withOpacity(0.7),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 4,
              runSpacing: 4,
              children: crystal.chakras.take(2).map((chakra) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: _getChakraColor(chakra).withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _getChakraColor(chakra).withOpacity(0.5),
                    ),
                  ),
                  child: Text(
                    chakra,
                    style: const TextStyle(
                      fontSize: 10,
                      color: Colors.white,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  void _showCrystalDetails(CrystalData crystal) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CrystalInfoScreen(crystal: crystal),
      ),
    );
  }

  Color _getCrystalColor(CrystalData crystal) {
    if (crystal.colorDescription.toLowerCase().contains('purple')) {
      return CrystalGrimoireTheme.amethyst;
    } else if (crystal.colorDescription.toLowerCase().contains('pink')) {
      return CrystalGrimoireTheme.crystalRose;
    } else if (crystal.colorDescription.toLowerCase().contains('blue')) {
      return CrystalGrimoireTheme.etherealBlue;
    } else if (crystal.colorDescription.toLowerCase().contains('green')) {
      return Colors.green;
    } else if (crystal.colorDescription.toLowerCase().contains('yellow')) {
      return CrystalGrimoireTheme.celestialGold;
    } else if (crystal.colorDescription.toLowerCase().contains('black')) {
      return Colors.black;
    } else if (crystal.colorDescription.toLowerCase().contains('white')) {
      return CrystalGrimoireTheme.moonlightWhite;
    }
    return CrystalGrimoireTheme.mysticPurple;
  }

  Color _getChakraColor(String chakra) {
    switch (chakra) {
      case 'Root': return Colors.red;
      case 'Sacral': return Colors.orange;
      case 'Solar Plexus': return Colors.yellow;
      case 'Heart': return Colors.green;
      case 'Throat': return Colors.blue;
      case 'Third Eye': return Colors.indigo;
      case 'Crown': return Colors.purple;
      default: return CrystalGrimoireTheme.mysticPurple;
    }
  }
}
