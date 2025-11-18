import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

/// Displays story text in book-style interface
class BookPage extends StatelessWidget {
  final String text;
  final String? backgroundImage;

  const BookPage({
    super.key,
    required this.text,
    this.backgroundImage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: backgroundImage != null
          ? BoxDecoration(
              image: DecorationImage(
                image: AssetImage(backgroundImage!),
                fit: BoxFit.cover,
                opacity: 0.3,
              ),
            )
          : null,
      padding: EdgeInsets.all(AppTheme.spacing.lg),
      child: SingleChildScrollView(
        child: Text(
          text,
          style: getStoryTextStyle(context),
        ),
      ),
    );
  }
}
