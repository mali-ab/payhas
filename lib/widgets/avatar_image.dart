import 'package:flutter/material.dart';

/// Displays an avatar asset and continues to support existing emoji avatars.
class AvatarImage extends StatelessWidget {
  const AvatarImage({
    required this.avatar,
    required this.size,
    super.key,
  });

  final String avatar;
  final double size;

  @override
  Widget build(BuildContext context) {
    if (!avatar.startsWith('assets/avatars/')) {
      return Text(avatar, style: TextStyle(fontSize: size * .5));
    }

    return ClipOval(
      child: Image.asset(
        avatar,
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => const Icon(Icons.person),
      ),
    );
  }
}
