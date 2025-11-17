import 'package:flutter/material.dart';

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
      padding: const EdgeInsets.all(24),
      child: SingleChildScrollView(
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 18,
            height: 1.5,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }
}
