import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// The supplied Paýhas brand image.
class BrandMark extends StatelessWidget {
  const BrandMark({super.key, this.size = 88});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppTheme.primary.withValues(alpha: .35),
            blurRadius: size * .18,
            offset: Offset(0, size * .06),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Image.asset('assets/images/logo.jpeg', fit: BoxFit.cover),
    );
  }
}
