import 'package:creative_ui_button/src/components/buttons/base_button.dart';
import 'package:flutter/material.dart';
import 'package:creative_ui_button/src/models/button_options.dart';

class CreativeUIBackButton extends StatelessWidget {
  /// Custom button styling, animation, sound, etc.
  final CreativeUIButtonOptions? options;

  /// Optional override for back navigation.
  final VoidCallback? onBack;

  /// Icon to display (defaults to arrow_back_rounded).
  final Widget? icon;

  /// Label text (defaults to "Back").
  final String? label;

  /// Whether to automatically hide if no back stack AND no fallback route.
  final bool autoHide;

  /// Fallback route to push if stack is empty (e.g., '/home').
  final String? fallbackRoute;

  /// Optional arguments for the fallback route.
  final Object? fallbackArguments;

  const CreativeUIBackButton({
    super.key,
    this.options,
    this.onBack,
    this.icon,
    this.label,
    this.autoHide = true,
    this.fallbackRoute,
    this.fallbackArguments,
  });

  @override
  Widget build(BuildContext context) {
    final navigator = Navigator.of(context);
    final canPop = navigator.canPop();
    final hasFallback = fallbackRoute != null && fallbackRoute!.isNotEmpty;

    // Hide the button if there's no route to pop and no fallback route
    if (autoHide && !canPop && !hasFallback) {
      return const SizedBox.shrink();
    }

    final base = options ?? const CreativeUIButtonOptions();

    // Default visuals
    final iconWidget =
        icon ??
        Icon(
          Icons.arrow_back_rounded,
          color: base.style?.textStyle?.color ?? Colors.white,
        );

    final labelText = label ?? "Back";

    final mergedOptions = CreativeUIButtonOptions(
      key: base.key,
      variant: base.variant ?? ButtonVariant.outlined,
      disabled: base.disabled,
      style: base.style,
      soundOptions: base.soundOptions,
      animationOptions: base.animationOptions,
      onPressed: onBack ?? () => _handleBack(context),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          iconWidget,
          const SizedBox(width: 8),
          Text(
            labelText,
            style:
                base.style?.textStyle ??
                const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );

    return CreativeUIButton(options: mergedOptions);
  }

  void _handleBack(BuildContext context) {
    final navigator = Navigator.of(context);
    final canPop = navigator.canPop();

    if (canPop) {
      navigator.maybePop();
    } else if (fallbackRoute != null && fallbackRoute!.isNotEmpty) {
      navigator.pushNamedAndRemoveUntil(
        fallbackRoute!,
        (route) => false, // Clears the stack
        arguments: fallbackArguments,
      );
    }
  }
}
