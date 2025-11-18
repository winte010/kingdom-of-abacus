import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'dart:math' as math;

/// Animated book page with page-turn effects and watercolor backgrounds
class AnimatedBookPage extends StatefulWidget {
  final List<String> pages;
  final Function()? onComplete;
  final int initialPage;

  const AnimatedBookPage({
    super.key,
    required this.pages,
    this.onComplete,
    this.initialPage = 0,
  });

  @override
  State<AnimatedBookPage> createState() => _AnimatedBookPageState();
}

class _AnimatedBookPageState extends State<AnimatedBookPage>
    with SingleTickerProviderStateMixin {
  late PageController _pageController;
  int _currentPage = 0;
  List<String> _backgroundImages = [];
  Duration _animationDuration = const Duration(milliseconds: 600);
  Curve _animationCurve = Curves.easeInOut;
  double _watercolorOpacity = 0.25;
  bool _roughEdgesEnabled = true;

  @override
  void initState() {
    super.initState();
    _currentPage = widget.initialPage;
    _pageController = PageController(initialPage: _currentPage);
    _loadConfiguration();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  /// Load configuration from theme.json
  Future<void> _loadConfiguration() async {
    try {
      final String response =
          await rootBundle.loadString('assets/config/theme.json');
      final data = json.decode(response);

      // Get page turn animation settings
      final pageTurnConfig = data['animations']?['pageTurn'];
      if (pageTurnConfig != null) {
        final duration = pageTurnConfig['duration'] as int? ?? 600;
        _animationDuration = Duration(milliseconds: duration);

        final curveName = pageTurnConfig['curve'] as String? ?? 'easeInOut';
        _animationCurve = _getCurveFromName(curveName);
      }

      // Get watercolor opacity
      final effects = data['animations']?['effects'];
      if (effects != null) {
        _watercolorOpacity =
            (effects['watercolorFade']?['opacity'] as num?)?.toDouble() ?? 0.25;
        _roughEdgesEnabled =
            effects['roughEdges']?['enabled'] as bool? ?? true;
      }

      // Get background images
      final bookConfig = data['book'];
      if (bookConfig != null) {
        final backgrounds = bookConfig['pageBackgrounds'] as List<dynamic>?;
        if (backgrounds != null) {
          _backgroundImages = backgrounds.cast<String>();
        }
      }

      setState(() {});
    } catch (e) {
      debugPrint('Failed to load theme configuration: $e');
      // Use default values
      _backgroundImages = [
        'assets/images/backgrounds/watercolor_1.png',
        'assets/images/backgrounds/watercolor_2.png',
        'assets/images/backgrounds/watercolor_3.png',
      ];
    }
  }

  Curve _getCurveFromName(String name) {
    switch (name.toLowerCase()) {
      case 'linear':
        return Curves.linear;
      case 'ease':
        return Curves.ease;
      case 'easein':
        return Curves.easeIn;
      case 'easeout':
        return Curves.easeOut;
      case 'easeinout':
        return Curves.easeInOut;
      case 'fastoutslowIn':
        return Curves.fastOutSlowIn;
      default:
        return Curves.easeInOut;
    }
  }

  String _getBackgroundForPage(int pageIndex) {
    if (_backgroundImages.isEmpty) {
      return 'assets/placeholders/backgrounds/paper_texture.png';
    }
    return _backgroundImages[pageIndex % _backgroundImages.length];
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });

    // If reached the last page, call onComplete
    if (page >= widget.pages.length - 1 && widget.onComplete != null) {
      // Delay slightly to allow page animation to complete
      Future.delayed(_animationDuration, () {
        if (mounted) {
          widget.onComplete!();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Main page view with swipe gesture
        PageView.builder(
          controller: _pageController,
          onPageChanged: _onPageChanged,
          itemCount: widget.pages.length,
          physics: const BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            return AnimatedBuilder(
              animation: _pageController,
              builder: (context, child) {
                double value = 1.0;
                if (_pageController.position.haveDimensions) {
                  value = _pageController.page! - index;
                  value = (1 - (value.abs() * 0.3)).clamp(0.0, 1.0);
                }

                return Center(
                  child: SizedBox(
                    height: Curves.easeOut.transform(value) *
                        MediaQuery.of(context).size.height,
                    child: child,
                  ),
                );
              },
              child: _buildPage(index),
            );
          },
        ),

        // Page indicator
        Positioned(
          bottom: 20,
          left: 0,
          right: 0,
          child: _buildPageIndicator(),
        ),
      ],
    );
  }

  Widget _buildPage(int index) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: _roughEdgesEnabled
          ? ClipPath(
              clipper: RoughEdgeClipper(seed: index),
              child: _buildPageContent(index),
            )
          : _buildPageContent(index),
    );
  }

  Widget _buildPageContent(int index) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFFFDF7), // Cream paper color
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Watercolor background
          if (_backgroundImages.isNotEmpty)
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  _getBackgroundForPage(index),
                  fit: BoxFit.cover,
                  opacity: AlwaysStoppedAnimation(_watercolorOpacity),
                  errorBuilder: (context, error, stackTrace) {
                    // Fallback to solid color if image not found
                    return Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            const Color(0xFFFFFDF7),
                            const Color(0xFFFFF8E7),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

          // Text content
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Text(
                  widget.pages[index],
                  style: const TextStyle(
                    fontSize: 18,
                    height: 1.8,
                    color: Color(0xDE000000),
                    fontFamily: 'serif',
                    letterSpacing: 0.2,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        widget.pages.length,
        (index) => AnimatedContainer(
          duration: _animationDuration,
          curve: _animationCurve,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: _currentPage == index ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: _currentPage == index
                ? Theme.of(context).colorScheme.primary
                : Colors.grey.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }
}

/// Custom clipper to create rough/torn page edges
class RoughEdgeClipper extends CustomClipper<Path> {
  final int seed;

  RoughEdgeClipper({this.seed = 0});

  @override
  Path getClip(Size size) {
    final path = Path();
    final random = math.Random(seed);

    // Start from top-left with slight roughness
    path.moveTo(0, _roughness(random, 2));

    // Top edge
    double currentX = 0;
    while (currentX < size.width) {
      final stepX = 15 + random.nextDouble() * 10;
      currentX += stepX;
      if (currentX > size.width) currentX = size.width;
      path.lineTo(currentX, _roughness(random, 3));
    }

    // Right edge
    double currentY = 0;
    while (currentY < size.height) {
      final stepY = 15 + random.nextDouble() * 10;
      currentY += stepY;
      if (currentY > size.height) currentY = size.height;
      path.lineTo(size.width - _roughness(random, 3), currentY);
    }

    // Bottom edge
    currentX = size.width;
    while (currentX > 0) {
      final stepX = 15 + random.nextDouble() * 10;
      currentX -= stepX;
      if (currentX < 0) currentX = 0;
      path.lineTo(currentX, size.height - _roughness(random, 3));
    }

    // Left edge
    currentY = size.height;
    while (currentY > 0) {
      final stepY = 15 + random.nextDouble() * 10;
      currentY -= stepY;
      if (currentY < 0) currentY = 0;
      path.lineTo(_roughness(random, 3), currentY);
    }

    path.close();
    return path;
  }

  double _roughness(math.Random random, double max) {
    return random.nextDouble() * max;
  }

  @override
  bool shouldReclip(RoughEdgeClipper oldClipper) => oldClipper.seed != seed;
}
