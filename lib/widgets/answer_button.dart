import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../providers/game_provider.dart';

class AnswerButton extends StatefulWidget {
  final String label;
  final AnswerState state;
  final bool isSelected;
  final bool isCorrect;
  final VoidCallback onTap;

  const AnswerButton({
    super.key,
    required this.label,
    required this.state,
    required this.isSelected,
    required this.isCorrect,
    required this.onTap,
  });

  @override
  State<AnswerButton> createState() => _AnswerButtonState();
}

class _AnswerButtonState extends State<AnswerButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    );
    _scaleAnim = Tween<double>(begin: 1.0, end: 0.93).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color get _bgColor {
    if (widget.state == AnswerState.idle) return AppTheme.cardBg;
    if (widget.isSelected) {
      return widget.state == AnswerState.correct
          ? AppTheme.correct.withValues(alpha: 0.85)
          : AppTheme.wrong.withValues(alpha: 0.85);
    }
    if (!widget.isSelected && widget.isCorrect &&
        widget.state == AnswerState.wrong) {
      return AppTheme.correct.withValues(alpha: 0.5);
    }
    return AppTheme.cardBg;
  }

  Color get _borderColor {
    if (widget.state == AnswerState.idle) return AppTheme.cardBorder;
    if (widget.isSelected) {
      return widget.state == AnswerState.correct
          ? AppTheme.correct
          : AppTheme.wrong;
    }
    if (!widget.isSelected && widget.isCorrect &&
        widget.state == AnswerState.wrong) {
      return AppTheme.correct;
    }
    return AppTheme.cardBorder;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onTap();
      },
      onTapCancel: () => _controller.reverse(),
      child: ScaleTransition(
        scale: _scaleAnim,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          decoration: BoxDecoration(
            color: _bgColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: _borderColor, width: 1.5),
          ),
          child: Text(
            widget.label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 17,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.3,
            ),
          ),
        ),
      ),
    );
  }
}
