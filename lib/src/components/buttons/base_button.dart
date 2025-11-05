// lib/src/components/buttons/base_button.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animator/flutter_animator.dart';
import 'package:simple_animations/simple_animations.dart';

import 'package:creative_ui_button/src/audio/general_sfx.dart';
import 'package:creative_ui_button/src/components/buttons/animated_button.dart';
import 'package:creative_ui_button/src/components/scale_tap.dart';
import 'package:creative_ui_button/src/extensions/color.dart';
import 'package:creative_ui_button/src/models/button_options.dart';
import 'package:creative_ui_button/src/utils/screen_utils.dart';
import 'package:creative_ui_button/src/vibrator.dart';

class CreativeUIButton extends StatefulWidget {
  final CreativeUIButtonOptions? options;
  const CreativeUIButton({super.key, this.options});

  @override
  State<CreativeUIButton> createState() => _CreativeUIButtonState();
}

class _CreativeUIButtonState extends State<CreativeUIButton> {
  // Effective, theme-resolved options (never read before dependencies are ready)
  late CreativeUIButtonOptions _effective;

  final GlobalKey<AnimatorWidgetState> _pulseKey =
      GlobalKey<AnimatorWidgetState>();
  Timer? _pulseInterval;

  // Interaction state (for state-layer overlays)
  bool _isHovered = false;
  bool _isFocused = false;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    // Do NOT compute theme-dependent defaults here.
    // Do NOT start timers here (they read animation options).
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _effective = _withDefaults(context, widget.options);
    _restartAnimationIntervals(); // safe: uses _effective only (no Theme lookups)
  }

  @override
  void didUpdateWidget(covariant CreativeUIButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Recompute on prop changes (and when parent theme rebuilds, build() will run again)
    _effective = _withDefaults(context, widget.options);
    _restartAnimationIntervals();
  }

  @override
  void dispose() {
    _pulseInterval?.cancel();
    super.dispose();
  }

  // ---------------------------------------------------------------------------
  // Defaults & helpers (safe: called from build/didChangeDependencies)
  // ---------------------------------------------------------------------------

  CreativeUIButtonOptions _withDefaults(
    BuildContext ctx,
    CreativeUIButtonOptions? src,
  ) {
    final variant = src?.variant ?? ButtonVariant.contained;
    final inStyle = src?.style ?? const CreativeUIButtonStyle();
    final style = _effectiveStyle(ctx, variant, inStyle);

    return CreativeUIButtonOptions(
      key: src?.key,
      label: src?.label,
      labelText: src?.labelText,
      icon: src?.icon,
      child: src?.child,
      disabled: src?.disabled ?? false,
      variant: variant,
      style: style,
      animationOptions: src?.animationOptions,
      soundOptions: src?.soundOptions,
      animatedButtonConfig: src?.animatedButtonConfig,
      onPressed: src?.onPressed,
    );
  }

  CreativeUIButtonStyle _effectiveStyle(
    BuildContext ctx,
    ButtonVariant variant,
    CreativeUIButtonStyle inStyle,
  ) {
    final t = Theme.of(ctx);
    final cs = t.colorScheme;

    final basePrim = inStyle.backgroundColor ?? cs.primary;
    final defaultPadding = inStyle.padding ??
        const EdgeInsets.symmetric(vertical: 10, horizontal: 14);

    switch (variant) {
      case ButtonVariant.contained:
        return inStyle.copyWith(
          backgroundColor: inStyle.backgroundColor ?? basePrim,
          borderColor: inStyle.borderColor,
          borderWidth: inStyle.borderWidth ?? 0,
          borderRadius: inStyle.borderRadius ?? 12,
          padding: defaultPadding,
          textStyle: inStyle.textStyle ??
              TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: cs.onPrimary,
              ),
          shape: inStyle.shape ?? BoxShape.rectangle,
          applyShadow: inStyle.applyShadow,
          useGradient: inStyle.useGradient,
          gradient: inStyle.useGradient
              ? inStyle.gradient
              : LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: const [-0.4, 0.9, 1],
                  colors: [
                    basePrim,
                    basePrim.withTint(0.5),
                    basePrim.withTint(0.9),
                  ],
                ),
        );

      case ButtonVariant.outlined:
        final borderColor = inStyle.borderColor ?? basePrim;
        return inStyle.copyWith(
          backgroundColor: Colors.transparent,
          borderColor: borderColor,
          borderWidth: inStyle.borderWidth ?? 1.5,
          borderRadius: inStyle.borderRadius ?? 12,
          padding: defaultPadding,
          textStyle: inStyle.textStyle ??
              TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: borderColor,
              ),
          shape: inStyle.shape ?? BoxShape.rectangle,
          applyShadow: false,
          useGradient: false,
          gradient: null,
          disabledOpacity: inStyle.disabledOpacity ?? 0.6,
          disabledColor: inStyle.disabledColor ?? t.disabledColor,
        );

      case ButtonVariant.text:
        return inStyle.copyWith(
          backgroundColor: Colors.transparent,
          borderColor: Colors.transparent,
          borderWidth: 0,
          borderRadius: inStyle.borderRadius ?? 12,
          padding: inStyle.padding ??
              const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          textStyle: inStyle.textStyle ??
              TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: inStyle.backgroundColor ?? cs.primary,
              ),
          shape: inStyle.shape ?? BoxShape.rectangle,
          applyShadow: false,
          useGradient: false,
          gradient: null,
          disabledOpacity: inStyle.disabledOpacity ?? 0.6,
          disabledColor: inStyle.disabledColor ?? t.disabledColor,
        );

      case ButtonVariant.animated:
        // Visually same as contained unless overridden
        return _effectiveStyle(ctx, ButtonVariant.contained, inStyle);
    }
  }

  void _restartAnimationIntervals() {
    _pulseInterval?.cancel();

    final animMap = _effective.animationOptions?.animationOptions;
    if (animMap == null) return;

    final pulsing = animMap[AnimationType.pulsing];
    if (pulsing != null) {
      final pause = pulsing.pause;
      _pulseInterval = Timer.periodic(
        pause,
        (_) => _pulseKey.currentState?.forward(),
      );
    }
  }

  // ---------------------------------------------------------------------------
  // Build
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    // Re-derive each build to react to theme changes immediately.
    _effective = _withDefaults(context, widget.options);

    final hovering = _withHoveringAnimation(
      context,
      _withPulseAnimation(context, _buildByVariant()),
    );

    return IgnorePointer(
      ignoring: _effective.disabled,
      child: Opacity(
        opacity: _effective.disabled
            ? (_effective.style?.disabledOpacity ?? 0.6)
            : 1,
        child: hovering,
      ),
    );
  }

  // Floating/hover effect
  Widget _withHoveringAnimation(BuildContext context, Widget child) {
    final hasFloat = _effective.animationOptions?.animationOptions.containsKey(
          AnimationType.floating,
        ) ??
        false;

    if (!hasFloat) return child;

    final cfg =
        _effective.animationOptions!.animationOptions[AnimationType.floating]!;
    return MirrorAnimationBuilder<double>(
      duration: cfg.duration,
      builder: (_, value, c) =>
          Transform.translate(offset: Offset(0, value), child: c),
      tween: Tween(begin: cfg.from, end: cfg.to),
      child: child,
    );
  }

  // Pulse effect
  Widget _withPulseAnimation(BuildContext context, Widget child) {
    final hasPulse = _effective.animationOptions?.animationOptions.containsKey(
          AnimationType.pulsing,
        ) ??
        false;

    if (!hasPulse) return child;
    return Pulse(key: _pulseKey, child: child);
  }

  // Variant switch
  Widget _buildByVariant() {
    switch (_effective.variant) {
      case ButtonVariant.animated:
        return _buildAnimated();
      case ButtonVariant.outlined:
        return _buildMaterialWrapper(_buildContainedLike(isOutlined: true));
      case ButtonVariant.text:
        return _buildMaterialWrapper(_buildTextVariant());
      case ButtonVariant.contained:
      default:
        return _buildMaterialWrapper(_buildContainedLike());
    }
  }

  // ---------------------------------------------------------------------------
  // Material ripple + state layers
  // ---------------------------------------------------------------------------

  Widget _buildMaterialWrapper(Widget core) {
    final st = _effective.style!;
    final shape = st.shape ?? BoxShape.rectangle;
    final r = (shape == BoxShape.rectangle && st.borderRadius != null)
        ? BorderRadius.circular(st.borderRadius!)
        : null;

    final interactiveShape = (shape == BoxShape.circle)
        ? const CircleBorder()
        : RoundedRectangleBorder(borderRadius: r ?? BorderRadius.circular(12));

    final overlay = _stateOverlayColor(
      context,
      variant: _effective.variant ?? ButtonVariant.contained,
    );

    final ink = FocusableActionDetector(
      onShowFocusHighlight: (v) => setState(() => _isFocused = v),
      onShowHoverHighlight: (v) => setState(() => _isHovered = v),
      child: MouseRegion(
        cursor: _effective.disabled
            ? SystemMouseCursors.basic
            : SystemMouseCursors.click,
        child: Material(
          type: MaterialType.transparency,
          shape: interactiveShape,
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            customBorder: interactiveShape,
            onHighlightChanged: (v) => setState(() => _isPressed = v),
            onTap: _effective.disabled ? null : _handlePressed,
            splashFactory: InkRipple.splashFactory,
            child: DecoratedBox(
              position: DecorationPosition.foreground,
              decoration: overlay == null
                  ? const BoxDecoration()
                  : BoxDecoration(color: overlay),
              child: core,
            ),
          ),
        ),
      ),
    );

    // Keep your subtle scale-tap feel
    return ScaleTap(
      onPressed: _effective.disabled ? null : _handlePressed,
      child: ink,
    );
  }

  Color? _stateOverlayColor(
    BuildContext ctx, {
    required ButtonVariant variant,
  }) {
    final cs = Theme.of(ctx).colorScheme;
    Color base = Colors.black;
    switch (variant) {
      case ButtonVariant.contained:
      case ButtonVariant.animated:
        base = cs.onPrimary;
        break;
      case ButtonVariant.outlined:
      case ButtonVariant.text:
        base = cs.primary;
        break;
    }

    double opacity = 0.0;
    if (_isHovered) opacity = opacity._max(0.08);
    if (_isFocused) opacity = opacity._max(0.12);
    if (_isPressed) opacity = opacity._max(0.12);

    return opacity == 0.0 ? null : base.withValues(alpha: opacity);
  }

  // ---------------------------------------------------------------------------
  // Variant builders
  // ---------------------------------------------------------------------------

  Widget _buildAnimated() {
    final st = _effective.style!;
    return AnimatedButton(
      key: _effective.key,
      color: st.backgroundColor ?? Theme.of(context).colorScheme.primary,
      height: ScreenUtils.instance.scale(st.size?.height ?? 50),
      width: ScreenUtils.instance.scale(st.size?.width ?? 50),
      shape: st.shape ?? BoxShape.rectangle,
      config: _effective.animatedButtonConfig,
      onPressed: _effective.disabled ? null : _handlePressed,
      child: _contentRow(),
    );
  }

  Widget _buildContainedLike({bool isOutlined = false}) {
    final st = _effective.style!;
    final shape = st.shape ?? BoxShape.rectangle;
    final radius = (shape == BoxShape.rectangle && st.borderRadius != null)
        ? BorderRadius.circular(st.borderRadius!)
        : null;

    final decoration = BoxDecoration(
      color: st.useGradient
          ? null
          : (isOutlined ? Colors.transparent : st.backgroundColor),
      gradient: st.useGradient ? st.gradient : null,
      shape: shape,
      borderRadius: radius,
      border: isOutlined
          ? Border.all(
              color: st.borderColor ??
                  st.textStyle?.color ??
                  Theme.of(context).colorScheme.primary,
              width: st.borderWidth ?? 1.5,
            )
          : (st.borderColor != null && (st.borderWidth ?? 0) > 0
              ? Border.all(color: st.borderColor!, width: st.borderWidth!)
              : null),
      boxShadow:
          st.applyShadow && st.boxShadow != null ? [st.boxShadow!] : null,
    );

    final buttonCore = Container(
      height: st.size?.height,
      width: st.size?.width,
      padding: st.padding ??
          const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
      decoration: decoration,
      child: _effective.child ?? _contentRow(),
    );

    final content = (_effective.label != null && shape == BoxShape.circle)
        ? Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              buttonCore,
              const SizedBox(height: 8),
              _effective.label ??
                  Text(
                    _effective.labelText ?? "",
                    style: st.textStyle ??
                        TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
            ],
          )
        : buttonCore;

    return content;
  }

  Widget _buildTextVariant() {
    final st = _effective.style!;
    final cs = Theme.of(context).colorScheme;
    final fg = st.textStyle?.color ?? st.backgroundColor ?? cs.primary;

    final content = _effective.child ??
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: _iconThenLabel(
            label: _effective.label ??
                Text(
                  _effective.labelText ?? "",
                  style: st.textStyle ??
                      TextStyle(
                        color: fg,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                ),
            allowSpacer: true,
          ),
        );

    return Padding(
      padding:
          st.padding ?? const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: content,
    );
  }

  // ---------------------------------------------------------------------------
  // Content helpers
  // ---------------------------------------------------------------------------

  List<Widget> _iconThenLabel({Widget? label, bool allowSpacer = true}) {
    final List<Widget> children = [];
    if (_effective.icon != null) children.add(_effective.icon!);
    if (_effective.icon != null &&
        (_effective.label != null ||
            (_effective.labelText?.isNotEmpty ?? false)) &&
        (_effective.style?.shape != BoxShape.circle) &&
        allowSpacer) {
      children.add(const SizedBox(width: 10));
    }
    if (_effective.style?.shape != BoxShape.circle) {
      children.add(
        Flexible(
          child: label ??
              Text(
                _effective.labelText ?? "",
                style: _effective.style?.textStyle ??
                    TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
              ),
        ),
      );
    }
    return children;
  }

  Widget _contentRow() {
    final st = _effective.style!;
    final cs = Theme.of(context).colorScheme;

    final defaultText = TextStyle(
      color: (_effective.variant == ButtonVariant.contained ||
              _effective.variant == ButtonVariant.animated)
          ? (st.textStyle?.color ?? cs.onPrimary)
          : (st.textStyle?.color ?? st.backgroundColor ?? cs.primary),
      fontSize: 16,
      fontWeight: FontWeight.w700,
    );

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: _iconThenLabel(
        label: _effective.label ??
            Text(
              _effective.labelText ?? "",
              style: st.textStyle ?? defaultText,
            ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Press handler (SFX + vibration)
  // ---------------------------------------------------------------------------

  void _handlePressed() {
    final snd = _effective.soundOptions;

    if (snd?.enableSFX != false && snd?.sfxPath != null) {
      GeneralSFX.instance.playFx(snd!.sfxPath!);
    }
    if (snd?.disableVibration != true) {
      Vibrator.feedback();
    }

    _effective.onPressed?.call();
  }
}

// Small helper
extension on double {
  double _max(double other) => this > other ? this : other;
}
