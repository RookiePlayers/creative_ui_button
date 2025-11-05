import 'dart:async';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import 'package:creative_ui_button/src/components/buttons/base_button.dart'
    as btn; // CreativeUIButton
import 'package:creative_ui_button/src/extensions/color.dart';
import 'package:creative_ui_button/src/models/button_options.dart';

class AsyncButton extends StatefulWidget {
  final CreativeUIButtonOptions? options;

  /// External loading control (if you want to drive it from outside).
  final bool loading;

  /// Fire-and-forget callback (sync). Use this OR [onAsyncSubmit].
  final VoidCallback? onAsync;

  /// Awaitable callback. Button auto-disables and shows spinner until it resolves.
  final Future<void> Function()? onAsyncSubmit;

  /// Optional: called when onAsyncSubmit completes successfully.
  final VoidCallback? onSuccess;

  /// Optional: called when onAsyncSubmit throws.
  final void Function(Object error, StackTrace stack)? onError;

  const AsyncButton({
    super.key,
    this.options,
    this.loading = false,
    this.onAsync,
    this.onAsyncSubmit,
    this.onSuccess,
    this.onError,
  });

  @override
  State<AsyncButton> createState() => _AsyncButtonState();
}

class _AsyncButtonState extends State<AsyncButton> {
  bool _internalLoading = false;

  bool get _isLoading => widget.loading || _internalLoading;

  @override
  void didUpdateWidget(covariant AsyncButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    // If parent turns loading off, clear internal flag too.
    if (!widget.loading && _internalLoading) {
      _internalLoading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final base = widget.options ?? const CreativeUIButtonOptions();

    // Build the loading child (spinner) or fall back to provided child/label.
    final loadingChild = SizedBox(
      width: (base.style?.textStyle?.fontSize ?? 16) * 1.25,
      height: (base.style?.textStyle?.fontSize ?? 16) * 1.25,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        valueColor: AlwaysStoppedAnimation<Color>(
          // Try to derive readable color over the button bg
          (base.style?.textStyle?.color) ??
              ((base.style?.backgroundColor) != null
                  ? Colors.white
                  : Theme.of(context).colorScheme.primary),
        ),
      ),
    );

    final normalChild =
        base.child ??
        base.label ??
        AutoSizeText(
          base.labelText ?? '',
          maxLines: 1,
          style:
              base.style?.textStyle ??
              TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color:
                    (base.style?.backgroundColor ??
                            Theme.of(context).colorScheme.primary)
                        .withShade(0.4),
              ),
        );

    // Animated child swap
    final animatedChild = AnimatedSwitcher(
      duration: const Duration(milliseconds: 160),
      switchInCurve: Curves.easeOut,
      switchOutCurve: Curves.easeIn,
      transitionBuilder: (child, anim) =>
          FadeTransition(opacity: anim, child: child),
      child: _isLoading ? loadingChild : normalChild,
    );

    // Compose effective options without requiring copyWith on your model.
    final effectiveOptions = CreativeUIButtonOptions(
      key: base.key,
      style: base.style,
      variant: base.variant,
      icon: base.icon,
      // Disable while loading to avoid double taps.
      disabled: base.disabled || _isLoading,
      // Force our child (spinner or provided content).
      child: animatedChild,
      // Inject our async handler
      onPressed: _handlePressed(base.onPressed),
      // Preserve extras
      animationOptions: base.animationOptions,
      soundOptions: base.soundOptions,
      animatedButtonConfig: base.animatedButtonConfig,
      label: null, // child supersedes label
      labelText: null,
    );

    return Semantics(
      // Accessible name. Prefer labelText, fallback to key or generic.
      label: base.labelText ?? (base.key?.toString() ?? 'Async button'),
      // Announce busy state to assistive tech
      // (Flutter will treat this as a live region change when toggled).
      enabled: !effectiveOptions.disabled,
      // You could add `value: _isLoading ? 'Loading' : 'Idle'`
      child: btn.CreativeUIButton(options: effectiveOptions),
    );
  }

  VoidCallback? _handlePressed(VoidCallback? originalOnPressed) {
    if (_isLoading) return null;

    // If a Future handler exists, we wrap it. Else, delegate to onAsync or original.
    if (widget.onAsyncSubmit != null) {
      return () async {
        setState(() => _internalLoading = true);
        try {
          await widget.onAsyncSubmit!.call();
          widget.onSuccess?.call();
        } catch (e, st) {
          widget.onError?.call(e, st);
          // Rethrow if you want upstream handling:
          // rethrow;
        } finally {
          if (mounted) setState(() => _internalLoading = false);
        }
      };
    }

    if (widget.onAsync != null) {
      return () {
        // Fire-and-forget; optionally show brief loading bump if desired.
        widget.onAsync!.call();
      };
    }

    // Fallback to whatever the underlying button had.
    return originalOnPressed;
  }
}
