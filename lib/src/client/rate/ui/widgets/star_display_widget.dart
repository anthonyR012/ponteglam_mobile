import 'package:flutter/material.dart';
import 'package:ponte_glam/config/theme/theme.dart';

class StarDisplayWidget extends StatelessWidget {
  const StarDisplayWidget({
    super.key,
    required this.rating,
    this.size = 18,
  });

  final int rating;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return Icon(
          index < rating ? Icons.star : Icons.star_border,
          color: secondaryColorTheme,
          size: size,
        );
      }),
    );
  }
}

class StarSelectorWidget extends StatelessWidget {
  const StarSelectorWidget({
    super.key,
    required this.rating,
    required this.onChanged,
    this.size = 36,
  });

  final int rating;
  final ValueChanged<int> onChanged;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        return GestureDetector(
          onTap: () => onChanged(index + 1),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Icon(
              index < rating ? Icons.star_rounded : Icons.star_outline_rounded,
              color: index < rating ? secondaryColorTheme : grayTextColorTheme,
              size: size,
            ),
          ),
        );
      }),
    );
  }
}
