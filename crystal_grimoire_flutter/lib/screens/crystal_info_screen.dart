import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../data/crystal_database.dart';
import '../config/enhanced_theme.dart';
import '../widgets/common/enhanced_mystical_widgets.dart';
import '../widgets/animations/enhanced_animations.dart';

class CrystalInfoScreen extends StatefulWidget {
  final CrystalData crystal;

  const CrystalInfoScreen({
    Key? key,
    required this.crystal,
  }) : super(key: key);

  @override
  State<CrystalInfoScreen> createState() => _CrystalInfoScreenState();
}

class _CrystalInfoScreenState extends State<CrystalInfoScreen> 
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  VideoPlayerController? _videoController;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    
    // Initialize video if available
    if (widget.crystal.videoAsset != null) {
      _videoController = VideoPlayerController.asset(widget.crystal.videoAsset!)
        ..initialize().then((_) {
          setState(() {});
        });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _videoController?.dispose();
    super.dispose();
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
              _buildCrystalHero(),
              _buildTabBar(),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildOverviewTab(),
                    _buildMetaphysicalTab(),
                    _buildHealingTab(),
                    _buildMeditationTab(),
                  ],
                ),
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
          Expanded(
            child: Text(
              widget.crystal.name,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1.2,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.favorite_border, color: Colors.white),
            onPressed: () {
              // Add to favorites - could integrate with collection later
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Add to collection feature coming soon!'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCrystalHero() {
    return Container(
      height: 200,
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            _getCrystalColor(widget.crystal).withOpacity(0.3),
            CrystalGrimoireTheme.royalPurple.withOpacity(0.6),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: _getCrystalColor(widget.crystal).withOpacity(0.3),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Stack(
        children: [
          if (widget.crystal.videoAsset != null && 
              _videoController != null && 
              _videoController!.value.isInitialized)
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: AspectRatio(
                aspectRatio: _videoController!.value.aspectRatio,
                child: VideoPlayer(_videoController!),
              ),
            )
          else
            Center(
              child: PulsingGlow(
                child: Icon(
                  Icons.diamond,
                  size: 100,
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
            ),
          
          // Overlay information
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.crystal.scientificName,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      _buildPropertyChip(
                        Icons.color_lens_outlined,
                        widget.crystal.colorDescription.split(',').first.trim(),
                        _getCrystalColor(widget.crystal),
                      ),
                      const SizedBox(width: 8),
                      if (widget.crystal.chakras.isNotEmpty)
                        _buildPropertyChip(
                          Icons.self_improvement,
                          widget.crystal.chakras.first,
                          _getChakraColor(widget.crystal.chakras.first),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: CrystalGrimoireTheme.amethyst.withOpacity(0.8),
          borderRadius: BorderRadius.circular(12),
        ),
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white.withOpacity(0.6),
        labelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        tabs: const [
          Tab(text: 'Overview'),
          Tab(text: 'Metaphysical'),
          Tab(text: 'Healing'),
          Tab(text: 'Meditation'),
        ],
      ),
    );
  }

  Widget _buildOverviewTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildInfoCard(
          'Physical Properties',
          Icons.science_outlined,
          [
            _buildInfoRow('Scientific Name', widget.crystal.scientificName),
            _buildInfoRow('Hardness', '${widget.crystal.hardness} (Mohs scale)'),
            _buildInfoRow('Formation', widget.crystal.formation),
            _buildInfoRow('Color', widget.crystal.colorDescription),
            _buildInfoRow('Rarity', widget.crystal.rarity),
          ],
        ),
        const SizedBox(height: 16),
        
        if (widget.crystal.chakras.isNotEmpty)
          _buildInfoCard(
            'Chakra Alignment',
            Icons.self_improvement,
            [
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: widget.crystal.chakras.map((chakra) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: _getChakraColor(chakra).withOpacity(0.3),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: _getChakraColor(chakra).withOpacity(0.5)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.brightness_1,
                          color: _getChakraColor(chakra),
                          size: 16,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          chakra,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildMetaphysicalTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildInfoCard(
          'Metaphysical Properties',
          Icons.auto_awesome,
          widget.crystal.metaphysicalProperties.map((prop) => 
            Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: CrystalGrimoireTheme.cosmicViolet.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: CrystalGrimoireTheme.cosmicViolet.withOpacity(0.3),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.star,
                    color: CrystalGrimoireTheme.celestialGold,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      prop,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 14,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ).toList(),
        ),
      ],
    );
  }

  Widget _buildHealingTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildInfoCard(
          'Healing Applications',
          Icons.healing,
          [
            _buildHealingSection('Emotional Healing', _getEmotionalHealing()),
            const SizedBox(height: 16),
            _buildHealingSection('Physical Support', _getPhysicalHealing()),
            const SizedBox(height: 16),
            _buildHealingSection('Spiritual Growth', _getSpiritualHealing()),
          ],
        ),
      ],
    );
  }

  Widget _buildMeditationTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildInfoCard(
          'Meditation Guide',
          Icons.spa,
          [
            _buildMeditationSection('Preparation', _getMeditationPrep()),
            const SizedBox(height: 16),
            _buildMeditationSection('Visualization', _getMeditationVisualization()),
            const SizedBox(height: 16),
            _buildMeditationSection('Affirmation', _getAffirmation()),
          ],
        ),
      ],
    );
  }

  Widget _buildInfoCard(String title, IconData icon, List<Widget> children) {
    return EnhancedMysticalCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: CrystalGrimoireTheme.celestialGold),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPropertyChip(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 14),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHealingSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: CrystalGrimoireTheme.amethyst,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            content,
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMeditationSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.brightness_1,
              color: CrystalGrimoireTheme.etherealBlue,
              size: 16,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                color: CrystalGrimoireTheme.etherealBlue,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: CrystalGrimoireTheme.etherealBlue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: CrystalGrimoireTheme.etherealBlue.withOpacity(0.3),
            ),
          ),
          child: Text(
            content,
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 14,
              height: 1.5,
              fontStyle: title == 'Affirmation' ? FontStyle.italic : FontStyle.normal,
            ),
          ),
        ),
      ],
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
      return Colors.grey[800]!;
    } else if (crystal.colorDescription.toLowerCase().contains('white')) {
      return Colors.white;
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

  String _getEmotionalHealing() {
    switch (widget.crystal.name.toLowerCase()) {
      case 'amethyst':
        return 'Calms anxiety and stress, promotes emotional balance, helps overcome addiction and negative thought patterns.';
      case 'rose_quartz':
        return 'Opens the heart to love, heals emotional wounds, promotes self-acceptance and compassion.';
      case 'clear_quartz':
        return 'Amplifies positive emotions, clears mental fog, enhances clarity and focus.';
      case 'citrine':
        return 'Dispels negativity, promotes joy and optimism, builds confidence and self-esteem.';
      case 'black_tourmaline':
        return 'Protects against negative emotions, grounds scattered energy, promotes emotional stability.';
      default:
        return 'Supports emotional balance and healing, promotes inner peace and harmony.';
    }
  }

  String _getPhysicalHealing() {
    switch (widget.crystal.name.toLowerCase()) {
      case 'amethyst':
        return 'Supports the nervous system, helps with insomnia, may ease headaches and tension.';
      case 'rose_quartz':
        return 'Supports heart health, may help with circulation, promotes overall physical healing.';
      case 'clear_quartz':
        return 'Amplifies the body\'s natural healing abilities, supports immune system function.';
      case 'citrine':
        return 'Supports digestive health, may boost energy levels, promotes vitality.';
      case 'black_tourmaline':
        return 'May help with electromagnetic stress, supports grounding and physical stability.';
      default:
        return 'Supports overall physical wellbeing and the body\'s natural healing processes.';
    }
  }

  String _getSpiritualHealing() {
    switch (widget.crystal.name.toLowerCase()) {
      case 'amethyst':
        return 'Enhances spiritual awareness, facilitates meditation, connects to higher consciousness.';
      case 'rose_quartz':
        return 'Opens the heart chakra, promotes unconditional love, enhances spiritual compassion.';
      case 'clear_quartz':
        return 'Amplifies spiritual energy, enhances psychic abilities, facilitates spiritual growth.';
      case 'citrine':
        return 'Manifests abundance, enhances personal power, promotes spiritual confidence.';
      case 'black_tourmaline':
        return 'Provides spiritual protection, grounds spiritual energy, maintains energetic boundaries.';
      default:
        return 'Supports spiritual growth and development, enhances connection to higher realms.';
    }
  }

  String _getMeditationPrep() {
    return 'Find a quiet space and hold your ${widget.crystal.name} in your hands or place it nearby. Take three deep breaths and set your intention for the meditation. Allow yourself to feel the crystal\'s energy resonating with your own.';
  }

  String _getMeditationVisualization() {
    switch (widget.crystal.name.toLowerCase()) {
      case 'amethyst':
        return 'Visualize violet light emanating from the crystal, surrounding you in a protective bubble of calm energy. See this light clearing away stress and negativity.';
      case 'rose_quartz':
        return 'Imagine pink light flowing from the crystal into your heart, filling you with unconditional love and compassion for yourself and others.';
      case 'clear_quartz':
        return 'Envision brilliant white light amplifying through the crystal, illuminating your entire being and enhancing your natural abilities.';
      case 'citrine':
        return 'Picture golden yellow light radiating from the crystal, filling you with confidence, joy, and the power to manifest your desires.';
      case 'black_tourmaline':
        return 'See dark, grounding energy flowing from the crystal into the earth, creating a protective shield around you while keeping you centered.';
      default:
        return 'Visualize the crystal\'s unique energy color flowing through and around you, bringing balance and harmony to your entire being.';
    }
  }

  String _getAffirmation() {
    switch (widget.crystal.name.toLowerCase()) {
      case 'amethyst':
        return '"I am calm, centered, and spiritually connected.\nPeace flows through me in all situations."';
      case 'rose_quartz':
        return '"I am worthy of love and give love freely.\nMy heart is open to receive all the love in the universe."';
      case 'clear_quartz':
        return '"I am clear in my intentions and purpose.\nMy energy is amplified for the highest good."';
      case 'citrine':
        return '"I attract abundance and prosperity.\nSuccess flows to me naturally and effortlessly."';
      case 'selenite':
        return '"I am connected to angelic realms.\nClarity and peace fill my entire being."';
      case 'labradorite':
        return '"I embrace transformation and trust my magic.\nMy true self shines through."';
      case 'malachite':
        return '"I release what no longer serves me.\nTransformation brings positive change."';
      case 'lapis_lazuli':
        return '"I speak my truth with wisdom and clarity.\nMy voice matters and I am heard."';
      case 'obsidian':
        return '"I face my shadows with courage.\nTruth and healing guide my journey."';
      default:
        return '"I am aligned with the crystal\'s energy.\nHealing and transformation flow through me."';
    }
  }
}