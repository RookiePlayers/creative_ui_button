import 'package:creative_ui_button/creative_ui_button.dart';
import 'package:flutter/material.dart';

import '../shimmer.dart';

// === ANIMATED BUTTON ===

class AnimatedButton extends StatefulWidget {
  final GestureTapCallback? onPressed;
  final Widget child;
  final bool enabled;
  final Color color;
  final double height;
  final double width;
  final ShadowDegree shadowDegree;
  final int duration;
  final BoxShape shape;
  final AnimatedButtonConfig? config;

  const AnimatedButton({
    super.key,
    this.onPressed,
    required this.child,
    this.enabled = true,
    this.color = Colors.blue,
    this.height = 64,
    this.shadowDegree = ShadowDegree.light,
    this.width = 200,
    this.duration = 70,
    this.shape = BoxShape.rectangle,
    this.config,
  });

  @override
  State<AnimatedButton> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton>
    with TickerProviderStateMixin {
  static double _shadowHeight = 4;
  double _position = 4;

  late final AnimationController _glowController;
  late final AnimationController _burstController;
  late final AnimationController _shimmerSweepController;

  late final Animation<double> _glowAnimation;
  late final Animation<double> _burstAnimation;
  late final AnimatedButtonConfig _config;

  @override
  void initState() {
    _config = widget.config ?? const AnimatedButtonConfig();
    _shadowHeight = _config.raiseHeight;
    super.initState();

    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);

    _glowAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );

    _burstController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _burstAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _burstController, curve: Curves.easeOut));

    final duration = _config.sweepShimmerConfig?.duration ??
        const Duration(milliseconds: 1800);
    _shimmerSweepController = AnimationController(
      vsync: this,
      duration: duration,
    );
    _startSweepAnimation();
  }

  void _startSweepAnimation() async {
    while (mounted && _config.enableSweepShimmer) {
      await _shimmerSweepController.forward(from: 0.0);
      await Future.delayed(
        _config.sweepShimmerConfig?.pause ?? const Duration(milliseconds: 800),
      );
    }
  }

  @override
  void dispose() {
    _glowController.dispose();
    _burstController.dispose();
    _shimmerSweepController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double height = widget.height - _shadowHeight;

    return GestureDetector(
      onTapDown: widget.enabled ? _pressed : null,
      onTapUp: widget.enabled ? _unPressedOnTapUp : null,
      onTapCancel: widget.enabled ? _unPressed : null,
      child: SizedBox(
        width: widget.width,
        height: height + _shadowHeight,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // === SHADOW (unaffected by glow/shimmer effects) ===
            Positioned(
              bottom: 0,
              child: Container(
                height: height,
                width: widget.width,
                decoration: BoxDecoration(
                  color: _darken(
                    widget.enabled ? widget.color : Colors.grey,
                    widget.shadowDegree,
                  ),
                  borderRadius: widget.shape != BoxShape.circle
                      ? BorderRadius.circular(_config.borderRadius)
                      : null,
                  shape: widget.shape,
                ),
              ),
            ),

            // === BURST GLOW ===
            if (_config.enableGlow && _config.enableBurst)
              Positioned.fill(
                child: AnimatedBuilder(
                  animation: _burstAnimation,
                  builder: (_, __) {
                    final intensity = 1.0 - _burstAnimation.value;
                    return IgnorePointer(
                      child: Container(
                        decoration: BoxDecoration(
                          shape: widget.shape,
                          borderRadius: widget.shape != BoxShape.circle
                              ? BorderRadius.circular(_config.borderRadius)
                              : null,
                          boxShadow: [
                            BoxShadow(
                              color: (_config.glowColor ?? widget.color)
                                  .withValues(alpha: 0.8 * intensity),
                              blurRadius: 24 * intensity,
                              spreadRadius: 8 * intensity,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

            // === BUTTON ===
            AnimatedPositioned(
              curve: Curves.easeIn,
              duration: Duration(milliseconds: widget.duration),
              bottom: _position,
              child: _config.enableGlow
                  ? AnimatedBuilder(
                      animation: _glowAnimation,
                      builder: (_, __) => _buildButton(
                        height,
                        glowStrength:
                            _glowAnimation.value * _config.glowIntensity,
                      ),
                    )
                  : _buildButton(height),
            ),

            // === STATIC SHIMMER ===
            if (_config.enableShimmer)
              Align(
                child: AnimatedBuilder(
                  animation: _glowAnimation,
                  builder: (_, __) {
                    final shimmerAlpha = 0.2 + (_glowAnimation.value * 0.3);
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(_config.borderRadius),
                      child: Container(
                        height: height,
                        width: widget.width,
                        decoration: BoxDecoration(
                          color: widget.color.withValues(alpha: shimmerAlpha),
                          gradient: LinearGradient(
                            colors: [
                              widget.color.withValues(
                                alpha: shimmerAlpha * 0.6,
                              ),
                              (_config.shimmerHighlight ??
                                      widget.color.withValues(alpha: 0.7))
                                  .withValues(alpha: shimmerAlpha),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

            // === SWEEP SHIMMER ===
            if (_config.enableSweepShimmer)
              Positioned.fill(
                child: IgnorePointer(
                  child: AnimatedBuilder(
                    animation: _shimmerSweepController,
                    builder: (_, __) {
                      final sweepCfg = _config.sweepShimmerConfig;
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(
                          _config.borderRadius,
                        ),
                        child: Transform.rotate(
                          angle: sweepCfg?.angle ?? 180,
                          child: Shimmer.fromColors(
                            pause: sweepCfg?.pause ??
                                const Duration(milliseconds: 800),
                            period: sweepCfg?.duration ??
                                const Duration(milliseconds: 1800),
                            loop: sweepCfg?.loop ?? 0,
                            direction:
                                sweepCfg?.direction ?? ShimmerDirection.ltr,
                            baseColor: sweepCfg?.baseColor ??
                                widget.color.withValues(alpha: 0.2),
                            highlightColor: sweepCfg?.highlightColor ??
                                widget.color.withValues(alpha: 0.1),
                            child: Container(
                              color: sweepCfg?.baseColor ??
                                  widget.color.withValues(alpha: 0.5),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(double height, {double glowStrength = 1.0}) {
    return Container(
      height: height,
      width: widget.width,
      decoration: BoxDecoration(
        color: widget.enabled ? widget.color : Colors.grey,
        borderRadius: widget.shape != BoxShape.circle
            ? BorderRadius.circular(_config.borderRadius)
            : null,
        shape: widget.shape,
        boxShadow: _config.enableGlow
            ? [
                BoxShadow(
                  color: (_config.glowColor ?? widget.color).withValues(
                    alpha: 0.6 * glowStrength,
                  ),
                  blurRadius: 16 * glowStrength,
                  spreadRadius: 1 * glowStrength,
                ),
              ]
            : null,
      ),
      child: Center(child: widget.child),
    );
  }

  void _pressed(_) {
    setState(() => _position = 0);
    if (_config.enableBurst) {
      _burstController.forward(from: 0.0);
    }
  }

  void _unPressedOnTapUp(_) => _unPressed();

  void _unPressed() {
    setState(() => _position = 4);
    widget.onPressed?.call();
  }

  Color _darken(Color color, ShadowDegree degree) {
    double amount = degree == ShadowDegree.dark ? 0.3 : 0.12;
    final hsl = HSLColor.fromColor(color);
    final dark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
    return dark.toColor();
  }
}
