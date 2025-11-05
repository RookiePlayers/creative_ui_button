library;

import 'package:flutter/physics.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

const double defaultScaleMinValue = 0.95;
const double defaultScaleOpacityValue = 0.90;
final Curve defaultScaleCurve = CurveSpring();
const Curve defaultOpacityCurve = Curves.ease;
const Duration defaultDuration = Duration(milliseconds: 300);

class ScaleTapConfig {
  static double? scaleMinValue;
  static Curve? scaleCurve;
  static double? opacityMinValue;
  static Curve? opacityCurve;
  static Duration? duration;
}

class ScaleTap extends StatefulWidget {
  final Function()? onPressed;
  final Function()? onLongPress;
  final Widget? child;
  final Duration? duration;
  final double? scaleMinValue;
  final Curve? scaleCurve;
  final Curve? opacityCurve;
  final double? opacityMinValue;
  final bool enableFeedback;
  final Key? gestureEventKey;

  const ScaleTap({
    super.key,
    this.gestureEventKey,
    this.enableFeedback = true,
    this.onPressed,
    this.onLongPress,
    required this.child,
    this.duration,
    this.scaleMinValue,
    this.opacityMinValue,
    this.scaleCurve,
    this.opacityCurve,
  });

  @override
  State<ScaleTap> createState() => _ScaleTapState();
}

class _ScaleTapState extends State<ScaleTap>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scale;
  late Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: widget.duration ?? ScaleTapConfig.duration ?? defaultDuration,
    );
    _scale = Tween<double>(begin: 1.0, end: 1.0).animate(_animationController);
    _opacity = Tween<double>(
      begin: 1.0,
      end: 1.0,
    ).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.stop();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> anim({
    double? scale,
    double? opacity,
    Duration? duration,
  }) async {
    if (!mounted) return;
    _animationController.stop();
    _animationController.duration = duration ?? Duration.zero;

    _scale = Tween<double>(begin: _scale.value, end: scale).animate(
      CurvedAnimation(
        curve:
            widget.scaleCurve ?? ScaleTapConfig.scaleCurve ?? defaultScaleCurve,
        parent: _animationController,
      ),
    );

    _opacity = Tween<double>(begin: _opacity.value, end: opacity).animate(
      CurvedAnimation(
        curve:
            widget.opacityCurve ??
            ScaleTapConfig.opacityCurve ??
            defaultOpacityCurve,
        parent: _animationController,
      ),
    );

    _animationController.reset();
    await _animationController.forward();
  }

  Future<void> _onTapDown(_) {
    return anim(
      scale:
          widget.scaleMinValue ??
          ScaleTapConfig.scaleMinValue ??
          defaultScaleMinValue,
      opacity:
          widget.opacityMinValue ??
          ScaleTapConfig.opacityMinValue ??
          defaultScaleOpacityValue,
      duration: widget.duration ?? ScaleTapConfig.duration ?? defaultDuration,
    );
  }

  Future<void> _onTapUp(_) {
    return anim(
      scale: 1.0,
      opacity: 1.0,
      duration: widget.duration ?? ScaleTapConfig.duration ?? defaultDuration,
    );
  }

  Future<void> _onTapCancel(n) {
    return _onTapUp(n);
  }

  @override
  Widget build(BuildContext context) {
    final bool isTapEnabled =
        widget.onPressed != null || widget.onLongPress != null;

    return AnimatedBuilder(
      animation: _animationController,
      builder: (_, Widget? child) {
        return Opacity(
          opacity: _opacity.value,
          child: Transform.scale(
            alignment: Alignment.center,
            scale: _scale.value,
            child: child,
          ),
        );
      },
      child: Listener(
        onPointerDown: isTapEnabled ? _onTapDown : null,
        onPointerCancel: _onTapCancel,
        onPointerUp: _onTapUp,
        child: GestureDetector(
          onTap: isTapEnabled
              ? () {
                  if (widget.enableFeedback) {
                    SystemSound.play(SystemSoundType.click);
                    HapticFeedback.selectionClick();
                  }
                  widget.onPressed?.call();
                }
              : null,
          onLongPress: isTapEnabled ? widget.onLongPress : null,
          child: widget.child,
        ),
      ),
    );
  }
}

class CurveSpring extends Curve {
  final SpringSimulation sim;

  CurveSpring() : sim = _sim(70, 20);

  @override
  double transform(double t) => sim.x(t) + t * (1 - sim.x(1.0));
}

SpringSimulation _sim(double stiffness, double damping) => SpringSimulation(
  SpringDescription.withDampingRatio(mass: 1, stiffness: stiffness, ratio: 0.7),
  0.0,
  1.0,
  0.0,
);
