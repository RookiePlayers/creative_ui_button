import 'package:flutter/widgets.dart';

class AnimationOptions<T> {
  final Duration duration;
  final Curve curve;
  final Duration pause;
  final Duration? interval;
  final bool loop;
  final T? from;
  final T? to;
  final Matrix4? transformation;

  const AnimationOptions({
    this.duration = const Duration(milliseconds: 1000),
    this.pause = const Duration(seconds: 2),
    this.interval,
    this.curve = Curves.easeInOutSine,
    this.loop = false,
    this.from,
    this.to,
    this.transformation,
  });
}