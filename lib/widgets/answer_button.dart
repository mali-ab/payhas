import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../providers/game_provider.dart';
import '../utils/animations.dart';

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
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnim = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color get _bgColor {
    if (widget.state == AnswerState.idle) return AppTheme.surface;
    if (widget.isSelected) {
      return widget.state == AnswerState.correct
          ? AppTheme.correctContainer
          : AppTheme.wrongContainer;
    }
    if (!widget.isSelected && widget.isCorrect &&
        widget.state == AnswerState.wrong) {
      return AppTheme.correctContainer;
    }
    return AppTheme.surface;
  }

  Color get _borderColor {
    if (widget.state == AnswerState.idle) return AppTheme.outlineVariant;
    if (widget.isSelected) {
      return widget.state == AnswerState.correct
          ? AppTheme.correct
          : AppTheme.wrong;
    }
    if (!widget.isSelected && widget.isCorrect &&
        widget.state == AnswerState.wrong) {
      return AppTheme.correct;
    }
    return AppTheme.outlineVariant;
  }

  Color get _textColor {
    if (widget.state == AnswerState.idle) return AppTheme.textPrimary;
    if (widget.isSelected) {
      return widget.state == AnswerState.correct
          ? AppTheme.correct
          : AppTheme.wrong;
    }
    if (!widget.isSelected && widget.isCorrect &&
        widget.state == AnswerState.wrong) {
      return AppTheme.correct;
    }
    return AppTheme.textPrimary;
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
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          decoration: BoxDecoration(
            color: _bgColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: _borderColor, width: 2),
            boxShadow: widget.state != AnswerState.idle
                ? [
                    BoxShadow(
                      color: widget.isSelected
                          ? (widget.state == AnswerState.correct
                              ? AppTheme.correct.withValues(alpha: 0.3)
                              : AppTheme.wrong.withValues(alpha: 0.3))
                          : AppTheme.correct.withValues(alpha: 0.2),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Text(
            widget.label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _textColor,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.3,
            ),
          ),
        ),
      ),
    );
  }
}