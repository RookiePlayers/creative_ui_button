import 'package:creative_ui_button/src/models/animation_options.dart';
import 'package:flutter/material.dart';

import '../components/shimmer.dart';

enum AnimationType { pulsing, floating }

enum ButtonVariant { animated, outlined, text, contained }


enum ShadowDegree { light, dark }

enum ButtonEffect {
  glow,
  shimmer,
  sweepShimmer,
  burst,
}

class SweepShimmerConfig {
  final Duration duration;
  final Duration pause;
  final double angle; // in degrees
  final ShimmerDirection direction;
  final Color? baseColor;
  final Color? highlightColor;
  final int loop;

  const SweepShimmerConfig({
    this.duration = const Duration(milliseconds: 1800),
    this.pause = const Duration(milliseconds: 800),
    this.angle = 0,
    this.direction = ShimmerDirection.ltr,
    this.baseColor,
    this.highlightColor,
    this.loop = 0,
  });
}

class AnimatedButtonConfig {
  final List<ButtonEffect> effects;
  final double glowIntensity;
  final Color? glowColor;
  final Color? shimmerHighlight;
  final SweepShimmerConfig? sweepShimmerConfig;
  final double raiseHeight;
  final double borderRadius;

  const AnimatedButtonConfig({
    this.effects = const [],
    this.glowIntensity = 1.0,
    this.glowColor,
    this.shimmerHighlight,
    this.sweepShimmerConfig,
    this.raiseHeight = 4.0,
    this.borderRadius = 16.0,
  });

  bool get enableGlow => effects.contains(ButtonEffect.glow);
  bool get enableShimmer => effects.contains(ButtonEffect.shimmer);
  bool get enableSweepShimmer => effects.contains(ButtonEffect.sweepShimmer);
  bool get enableBurst => effects.contains(ButtonEffect.burst);
}


class CreativeUIButtonStyle {
  final Color? backgroundColor;
  final Color? borderColor;
  final Size? size;
  final double? borderWidth;
  final double? borderRadius;
  final EdgeInsetsGeometry? padding;
  final TextStyle? textStyle;
  final BoxShape? shape;
  final BoxShadow? boxShadow;
  final bool applyShadow;
  final bool useGradient;
  final Gradient? gradient;
  final Color? disabledColor;
  final double? disabledOpacity;

  const CreativeUIButtonStyle({
    this.backgroundColor,
    this.borderColor,
    this.size,
    this.borderWidth,
    this.borderRadius,
    this.padding,
    this.textStyle,
    this.shape,
    this.applyShadow = true,
    this.useGradient = false,
    this.boxShadow,
    this.gradient,
    this.disabledOpacity,
    this.disabledColor,
  });

  CreativeUIButtonStyle copyWith({
    Color? backgroundColor,
    Color? borderColor,
    Size? size,
    double? borderWidth,
    double? borderRadius,
    double? radius,
    EdgeInsetsGeometry? padding,
    TextStyle? textStyle,
    BoxShape? shape,
    bool? applyShadow,
    bool? useGradient,
    Gradient? gradient,
    Color? disabledColor,
    double? disabledOpacity,
  }) {
    return CreativeUIButtonStyle(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      borderColor: borderColor ?? this.borderColor,
      size: size ?? this.size,
      borderWidth: borderWidth ?? this.borderWidth,
      borderRadius: borderRadius ?? this.borderRadius,
      padding: padding ?? this.padding,
      textStyle: textStyle ?? this.textStyle,
      shape: shape ?? this.shape,
      applyShadow: applyShadow ?? this.applyShadow,
      useGradient: useGradient ?? this.useGradient,
      gradient: gradient ?? this.gradient,
      disabledColor: disabledColor ?? this.disabledColor,
      disabledOpacity: disabledOpacity ?? this.disabledOpacity,
    );
  }
}

class CreativeUIButtonAnimationOptions {
  final Map<AnimationType, AnimationOptions> animationOptions;

  const CreativeUIButtonAnimationOptions({required this.animationOptions});
}

class CreativeUIButtonSoundOptions {
  final String? sfxPath;
  final bool? enableSFX;
  final bool? disableVibration;

  const CreativeUIButtonSoundOptions({
    this.sfxPath,
    this.enableSFX,
    this.disableVibration,
  });
}

class CreativeUIButtonOptions {
  final Key? key;
  final Widget? label;
  final String? labelText;
  final Widget? icon;
  final Widget? child;
  final bool disabled;
  final ButtonVariant? variant;
  final CreativeUIButtonStyle? style;
  final CreativeUIButtonAnimationOptions? animationOptions;
  final CreativeUIButtonSoundOptions? soundOptions;
  final AnimatedButtonConfig? animatedButtonConfig;
  final Function()? onPressed;

  const CreativeUIButtonOptions({
    this.key,
    this.label,
    this.labelText,
    this.icon,
    this.child,
    this.disabled = false,
    this.variant,
    this.style,
    this.animationOptions,
    this.soundOptions,
    this.animatedButtonConfig,
    this.onPressed,
  });

  CreativeUIButtonOptions copyWith({
    Key? key,
    Widget? label,
    String? labelText,
    Widget? icon,
    Widget? child,
    bool? disabled,
    ButtonVariant? variant,
    CreativeUIButtonStyle? style,
    CreativeUIButtonAnimationOptions? animationOptions,
    CreativeUIButtonSoundOptions? soundOptions,
    AnimatedButtonConfig? animatedButtonConfig,
    Function()? onPressed,
  }) {
    return CreativeUIButtonOptions(
      key: key ?? this.key,
      label: label ?? this.label,
      labelText: labelText ?? this.labelText,
      icon: icon ?? this.icon,
      child: child ?? this.child,
      disabled: disabled ?? this.disabled,
      variant: variant ?? this.variant,
      style: style ?? this.style,
      animationOptions: animationOptions ?? this.animationOptions,
      soundOptions: soundOptions ?? this.soundOptions,
      animatedButtonConfig:
          animatedButtonConfig ?? this.animatedButtonConfig,
      onPressed: onPressed ?? this.onPressed,
    );
  }
}
