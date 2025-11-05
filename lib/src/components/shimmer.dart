library;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

enum ShimmerDirection { ltr, rtl, ttb, btt }

@immutable
class Shimmer extends StatefulWidget {
  final Widget child;
  final Duration period;
  final Duration pause;
  final ShimmerDirection direction;
  final Gradient gradient;
  final int loop;
  final bool enabled;

  const Shimmer({
    super.key,
    required this.child,
    required this.gradient,
    this.direction = ShimmerDirection.ltr,
    this.period = const Duration(milliseconds: 1500),
    this.pause = const Duration(milliseconds: 0),
    this.loop = 0,
    this.enabled = true,
  });

  Shimmer.fromColors({
    super.key,
    required this.child,
    required Color baseColor,
    required Color highlightColor,
    this.period = const Duration(milliseconds: 1500),
    this.pause = const Duration(milliseconds: 0),
    this.direction = ShimmerDirection.ltr,
    this.loop = 0,
    this.enabled = true,
  }) : gradient = LinearGradient(
         begin: Alignment.topLeft,
         end: Alignment.centerRight,
         colors: <Color>[
           baseColor,
           baseColor,
           highlightColor,
           baseColor,
           baseColor,
         ],
         stops: const <double>[0.0, 0.35, 0.5, 0.65, 1.0],
       );

  @override
  State createState() => _ShimmerState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Gradient>('gradient', gradient));
    properties.add(EnumProperty<ShimmerDirection>('direction', direction));
    properties.add(DiagnosticsProperty<Duration>('period', period));
    properties.add(DiagnosticsProperty<Duration>('pause', pause));
    properties.add(DiagnosticsProperty<bool>('enabled', enabled));
    properties.add(DiagnosticsProperty<int>('loop', loop));
  }
}

class _ShimmerState extends State<Shimmer> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  int _count = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.period)
      ..addStatusListener(_onStatusChanged);

    if (widget.enabled) {
      _controller.forward();
    }
  }

  void _onStatusChanged(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      _handleLoop();
    }
  }

  void _handleLoop() async {
    _count++;
    final hasMoreLoops = widget.loop <= 0 || _count < widget.loop;

    if (hasMoreLoops) {
      if (widget.pause > Duration.zero) {
        await Future.delayed(widget.pause);
      }

      if (mounted && widget.enabled) {
        _controller.forward(from: 0.0);
      }
    }
  }

  @override
  void didUpdateWidget(Shimmer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.enabled && !_controller.isAnimating) {
      _controller.forward();
    } else if (!widget.enabled && _controller.isAnimating) {
      _controller.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      child: widget.child,
      builder: (context, child) => _Shimmer(
        direction: widget.direction,
        gradient: widget.gradient,
        percent: _controller.value,
        child: child,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

@immutable
class _Shimmer extends SingleChildRenderObjectWidget {
  final double percent;
  final ShimmerDirection direction;
  final Gradient gradient;

  const _Shimmer({
    super.child,
    required this.percent,
    required this.direction,
    required this.gradient,
  });

  @override
  _ShimmerFilter createRenderObject(BuildContext context) {
    return _ShimmerFilter(percent, direction, gradient);
  }

  @override
  void updateRenderObject(BuildContext context, _ShimmerFilter shimmer) {
    shimmer.percent = percent;
    shimmer.gradient = gradient;
    shimmer.direction = direction;
  }
}

class _ShimmerFilter extends RenderProxyBox {
  ShimmerDirection _direction;
  Gradient _gradient;
  double _percent;

  _ShimmerFilter(this._percent, this._direction, this._gradient);

  @override
  ShaderMaskLayer? get layer => super.layer as ShaderMaskLayer?;

  @override
  bool get alwaysNeedsCompositing => child != null;

  set percent(double newValue) {
    if (newValue == _percent) return;
    _percent = newValue;
    markNeedsPaint();
  }

  set gradient(Gradient newValue) {
    if (newValue == _gradient) return;
    _gradient = newValue;
    markNeedsPaint();
  }

  set direction(ShimmerDirection newDirection) {
    if (newDirection == _direction) return;
    _direction = newDirection;
    markNeedsLayout();
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (child != null) {
      assert(needsCompositing);

      final double width = child!.size.width;
      final double height = child!.size.height;

      double dx = 0.0, dy = 0.0;
      Rect rect;

      switch (_direction) {
        case ShimmerDirection.rtl:
          dx = _offset(width, -width, _percent);
          rect = Rect.fromLTWH(dx - width, dy, 3 * width, height);
          break;
        case ShimmerDirection.ttb:
          dy = _offset(-height, height, _percent);
          rect = Rect.fromLTWH(dx, dy - height, width, 3 * height);
          break;
        case ShimmerDirection.btt:
          dy = _offset(height, -height, _percent);
          rect = Rect.fromLTWH(dx, dy - height, width, 3 * height);
          break;
        case ShimmerDirection.ltr:
          dx = _offset(-width, width, _percent);
          rect = Rect.fromLTWH(dx - width, dy, 3 * width, height);
          break;
      }

      layer ??= ShaderMaskLayer();
      layer!
        ..shader = _gradient.createShader(rect)
        ..maskRect = offset & size
        ..blendMode = BlendMode.srcIn;

      context.pushLayer(layer!, super.paint, offset);
    } else {
      layer = null;
    }
  }

  double _offset(double start, double end, double percent) {
    return start + (end - start) * percent;
  }
}
