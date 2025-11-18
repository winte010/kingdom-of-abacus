import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

/// Controls page turn animations with configurable settings from theme.json
class PageTurnController extends ChangeNotifier {
  int _currentPage = 0;
  bool _isAnimating = false;
  late AnimationController _animationController;
  late Animation<double> _animation;

  // Configuration from theme.json
  Duration _duration = const Duration(milliseconds: 600);
  Curve _curve = Curves.easeInOut;

  int get currentPage => _currentPage;
  bool get isAnimating => _isAnimating;
  Animation<double> get animation => _animation;

  PageTurnController(TickerProvider vsync) {
    _animationController = AnimationController(
      duration: _duration,
      vsync: vsync,
    );

    _animation = CurvedAnimation(
      parent: _animationController,
      curve: _curve,
    );

    _loadConfiguration();
  }

  /// Load animation configuration from theme.json
  Future<void> _loadConfiguration() async {
    try {
      final String response = await rootBundle.loadString('assets/config/theme.json');
      final data = json.decode(response);

      // Get page turn animation settings
      final pageTurnConfig = data['animations']?['pageTurn'];
      if (pageTurnConfig != null) {
        final duration = pageTurnConfig['duration'] as int? ?? 600;
        _duration = Duration(milliseconds: duration);

        final curveName = pageTurnConfig['curve'] as String? ?? 'easeInOut';
        _curve = _getCurveFromName(curveName);

        // Update animation controller with new settings
        _animationController.duration = _duration;
        _animation = CurvedAnimation(
          parent: _animationController,
          curve: _curve,
        );
      }
    } catch (e) {
      debugPrint('Failed to load theme configuration: $e');
      // Use default values
    }
  }

  /// Convert curve name string to Curve object
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
      case 'bouncein':
        return Curves.bounceIn;
      case 'bounceout':
        return Curves.bounceOut;
      case 'elastic':
        return Curves.elasticOut;
      default:
        return Curves.easeInOut;
    }
  }

  /// Turn to next page with animation
  Future<void> nextPage() async {
    if (_isAnimating) return;

    _isAnimating = true;
    notifyListeners();

    await _animationController.forward();
    _currentPage++;
    await _animationController.reverse();

    _isAnimating = false;
    notifyListeners();
  }

  /// Turn to previous page with animation
  Future<void> previousPage() async {
    if (_isAnimating || _currentPage <= 0) return;

    _isAnimating = true;
    notifyListeners();

    await _animationController.forward();
    _currentPage--;
    await _animationController.reverse();

    _isAnimating = false;
    notifyListeners();
  }

  /// Jump to specific page without animation
  void goToPage(int page) {
    if (_isAnimating) return;
    _currentPage = page;
    notifyListeners();
  }

  /// Reset controller to first page
  void reset() {
    _currentPage = 0;
    _animationController.reset();
    notifyListeners();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}

/// Widget that provides PageTurnController to its descendants
class PageTurnProvider extends StatefulWidget {
  final Widget child;

  const PageTurnProvider({
    super.key,
    required this.child,
  });

  @override
  State<PageTurnProvider> createState() => _PageTurnProviderState();

  static PageTurnController? of(BuildContext context) {
    return context.findAncestorStateOfType<_PageTurnProviderState>()?._controller;
  }
}

class _PageTurnProviderState extends State<PageTurnProvider>
    with SingleTickerProviderStateMixin {
  late PageTurnController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PageTurnController(this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
