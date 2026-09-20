import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';

class Animations {
  // Button press scale animation
  static Widget scaleOnTap({
    required Widget child,
    required VoidCallback onTap,
    double scale = 0.96,
    Duration duration = const Duration(milliseconds: 100),
    Curve curve = Curves.easeInOut,
  }) {
    return _ScaleOnTap(
      child: child,
      onTap: onTap,
      scale: scale,
      duration: duration,
      curve: curve,
    );
  }

  // Correct answer animation - green checkmark with bounce
  static Widget correctAnswer({
    required Widget child,
    required bool isCorrect,
    Duration duration = const Duration(milliseconds: 500),
  }) {
    return _CorrectAnswerAnimation(
      child: child,
      isCorrect: isCorrect,
      duration: duration,
    );
  }

  // Wrong answer animation - red shake
  static Widget wrongAnswer({
    required Widget child,
    required bool isWrong,
    Duration duration = const Duration(milliseconds: 500),
  }) {
    return _WrongAnswerAnimation(
      child: child,
      isWrong: isWrong,
      duration: duration,
    );
  }

  // XP increase animation - number count up
  static Widget xpCounter({
    required int value,
    required int previousValue,
    Duration duration = const Duration(milliseconds: 800),
    TextStyle? style,
  }) {
    return _XPCounter(
      value: value,
      previousValue: previousValue,
      duration: duration,
      style: style,
    );
  }

  // Coin animation - spinning coin with count up
  static Widget coinCounter({
    required int value,
    required int previousValue,
    Duration duration = const Duration(milliseconds: 800),
    TextStyle? style,
  }) {
    return _CoinCounter(
      value: value,
      previousValue: previousValue,
      duration: duration,
      style: style,
    );
  }

  // Level up animation
  static Widget levelUp({
    required bool show,
    required int level,
    required VoidCallback onComplete,
    Duration duration = const Duration(milliseconds: 1500),
  }) {
    return _LevelUpAnimation(
      show: show,
      level: level,
      onComplete: onComplete,
      duration: duration,
    );
  }

  // Streak animation - fire icon with pulse
  static Widget streakIndicator({
    required int streak,
    required bool isAnimating,
    Duration duration = const Duration(milliseconds: 1000),
  }) {
    return _StreakIndicator(
      streak: streak,
      isAnimating: isAnimating,
      duration: duration,
    );
  }

  // Confetti animation
  static Widget confetti({
    required ConfettiController controller,
    double blastDirection = -3.14159 / 2, // Up
    Duration duration = const Duration(seconds: 3),
    double maxParticles = 100,
  }) {
    return ConfettiWidget(
      confettiController: controller,
      blastDirection: blastDirection,
      blastDirectionality: BlastDirectionality.explosive,
      emissionFrequency: 0.05,
      numberOfParticles: maxParticles.toInt(),
      maxBlastForce: 20,
      minBlastForce: 10,
      gravity: 0.3,
      shouldLoop: false,
      colors: const [
        Color(0xFF007B6E), // Primary
        Color(0xFFE8A800), // Gold
        Color(0xFF2E7D32), // Correct green
        Color(0xFF00A896), // Primary light
        Color(0xFFFFD600), // Gold light
      ],
    );
  }
}

class _ScaleOnTap extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;
  final double scale;
  final Duration duration;
  final Curve curve;

  const _ScaleOnTap({
    required this.child,
    required this.onTap,
    required this.scale,
    required this.duration,
    required this.curve,
  });

  @override
  State<_ScaleOnTap> createState() => _ScaleOnTapState();
}

class _ScaleOnTapState extends State<_ScaleOnTap> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _scaleAnimation = Tween<double>(begin: 1.0, end: widget.scale).animate(
      CurvedAnimation(parent: _controller, curve: widget.curve),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) => _controller.forward();
  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
    widget.onTap();
  }
  void _onTapCancel() => _controller.reverse();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: widget.child,
      ),
    );
  }
}

class _CorrectAnswerAnimation extends StatefulWidget {
  final Widget child;
  final bool isCorrect;
  final Duration duration;

  const _CorrectAnswerAnimation({
    required this.child,
    required this.isCorrect,
    required this.duration,
  });

  @override
  State<_CorrectAnswerAnimation> createState() => _CorrectAnswerAnimationState();
}

class _CorrectAnswerAnimationState extends State<_CorrectAnswerAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _checkAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );
    _checkAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.3, 1.0, curve: Curves.elasticOut)),
    );
  }

  @override
  void didUpdateWidget(covariant _CorrectAnswerAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isCorrect && !oldWidget.isCorrect) {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isCorrect) return widget.child;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Stack(
            alignment: Alignment.center,
            children: [
              widget.child,
              ScaleTransition(
                scale: _checkAnimation,
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2E7D32),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF2E7D32).withValues(alpha: 0.4),
                        blurRadius: 16,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _WrongAnswerAnimation extends StatefulWidget {
  final Widget child;
  final bool isWrong;
  final Duration duration;

  const _WrongAnswerAnimation({
    required this.child,
    required this.isWrong,
    required this.duration,
  });

  @override
  State<_WrongAnswerAnimation> createState() => _WrongAnswerAnimationState();
}

class _WrongAnswerAnimationState extends State<_WrongAnswerAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _shakeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticIn),
    );
  }

  @override
  void didUpdateWidget(covariant _WrongAnswerAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isWrong && !oldWidget.isWrong) {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isWrong) return widget.child;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final shakeOffset = 12 * _shakeAnimation.value * (1 - _shakeAnimation.value) * 4;
        return Transform.translate(
          offset: Offset(shakeOffset * (1 - _shakeAnimation.value * 2), 0),
          child: Stack(
            alignment: Alignment.center,
            children: [
              widget.child,
              ScaleTransition(
                scale: _shakeAnimation,
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFFC62828),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFC62828).withValues(alpha: 0.4),
                        blurRadius: 16,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.close_rounded,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _XPCounter extends StatefulWidget {
  final int value;
  final int previousValue;
  final Duration duration;
  final TextStyle? style;

  const _XPCounter({
    required this.value,
    required this.previousValue,
    required this.duration,
    this.style,
  });

  @override
  State<_XPCounter> createState() => _XPCounterState();
}

class _XPCounterState extends State<_XPCounter> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _animation = IntTween(begin: widget.previousValue, end: widget.value).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
    if (widget.value != widget.previousValue) {
      _controller.forward(from: 0);
    }
  }

  @override
  void didUpdateWidget(covariant _XPCounter oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      _animation = IntTween(begin: oldWidget.value, end: widget.value).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
      );
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Text(
          _animation.value.toString(),
          style: widget.style,
        );
      },
    );
  }
}

class _CoinCounter extends StatefulWidget {
  final int value;
  final int previousValue;
  final Duration duration;
  final TextStyle? style;

  const _CoinCounter({
    required this.value,
    required this.previousValue,
    required this.duration,
    this.style,
  });

  @override
  State<_CoinCounter> createState() => _CoinCounterState();
}

class _CoinCounterState extends State<_CoinCounter> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _countAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _countAnimation = IntTween(begin: widget.previousValue, end: widget.value).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
    _rotationAnimation = Tween<double>(begin: 0, end: 2 * 3.14159).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
    if (widget.value != widget.previousValue) {
      _controller.forward(from: 0);
    }
  }

  @override
  void didUpdateWidget(covariant _CoinCounter oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      _countAnimation = IntTween(begin: oldWidget.value, end: widget.value).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
      );
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Transform.rotate(
              angle: _rotationAnimation.value,
              child: const Text('🪙', style: TextStyle(fontSize: 20)),
            ),
            const SizedBox(width: 6),
            Text(
              _countAnimation.value.toString(),
              style: widget.style,
            ),
          ],
        );
      },
    );
  }
}

class _LevelUpAnimation extends StatefulWidget {
  final bool show;
  final int level;
  final VoidCallback onComplete;
  final Duration duration;

  const _LevelUpAnimation({
    required this.show,
    required this.level,
    required this.onComplete,
    required this.duration,
  });

  @override
  State<_LevelUpAnimation> createState() => _LevelUpAnimationState();
}

class _LevelUpAnimationState extends State<_LevelUpAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.6, curve: Curves.easeOut)),
    );
  }

  @override
  void didUpdateWidget(covariant _LevelUpAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.show && !oldWidget.show) {
      _controller.forward(from: 0).then((_) {
        widget.onComplete();
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.show) return const SizedBox.shrink();

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF007B6E).withValues(alpha: 0.2),
                    blurRadius: 32,
                    spreadRadius: 4,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [Color(0xFFE8A800), Color(0xFFFFD600)],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFE8A800).withValues(alpha: 0.5),
                          blurRadius: 24,
                          spreadRadius: 4,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.star_rounded,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Dereje ýükseldi!',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: const Color(0xFF1A1C1B),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${widget.level}-nji dereje',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      color: const Color(0xFF007B6E),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _StreakIndicator extends StatefulWidget {
  final int streak;
  final bool isAnimating;
  final Duration duration;

  const _StreakIndicator({
    required this.streak,
    required this.isAnimating,
    required this.duration,
  });

  @override
  State<_StreakIndicator> createState() => _StreakIndicatorState();
}

class _StreakIndicatorState extends State<_StreakIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void didUpdateWidget(covariant _StreakIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isAnimating && !oldWidget.isAnimating) {
      _controller.repeat(reverse: true);
    } else if (!widget.isAnimating && oldWidget.isAnimating) {
      _controller.stop();
      _controller.reset();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: widget.isAnimating ? _pulseAnimation.value : 1.0,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.local_fire_department_rounded,
                color: Color(0xFFFF8A65),
                size: 20,
              ),
              const SizedBox(width: 6),
              Text(
                '${widget.streak} gün',
                style: const TextStyle(
                  color: Color(0xFFFF8A65),
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}