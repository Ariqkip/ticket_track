import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';


enum AppButtonType { primary, secondary }

class AppButton extends HookConsumerWidget {
  final String text;
  final Widget? label;
  final VoidCallback onPressed;
  final bool enabled;
  final bool loading;
  final AppButtonType type;
  final double radius;

  const AppButton({
    this.label,
    super.key,
    required this.text,
    required this.onPressed,
    this.enabled = true,
    this.loading = false,
    this.type = AppButtonType.primary,
    this.radius = 12,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final baseStyle = theme.elevatedButtonTheme.style;

    final isPrimary = type == AppButtonType.primary;
    final resolvedBg = baseStyle?.backgroundColor?.resolve(
      enabled ? {} : {WidgetState.disabled},
    );
    final resolvedFg = baseStyle?.foregroundColor?.resolve(
      enabled ? {} : {WidgetState.disabled},
    );
    final resolvedSide = baseStyle?.side?.resolve(
      enabled ? {} : {WidgetState.disabled},
    );

    final bgColor = isPrimary ? resolvedBg : theme.scaffoldBackgroundColor;
    final textColor = isPrimary ? resolvedFg : theme.scaffoldBackgroundColor;
    final defaultSide =
        baseStyle?.side?.resolve({}) ??
            BorderSide(color: colorScheme.primary, width: 1);
    final borderColor = isPrimary ? Colors.transparent : defaultSide.color;

    final pressedColor = isPrimary
        ? Colors.blueGrey
        : Colors.green;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      height: 48,
      width: double.infinity,

      child: ElevatedButton(
        onPressed: enabled && !loading ? onPressed : null,
        style: baseStyle?.copyWith(
          backgroundColor: WidgetStateProperty.all(bgColor),
          foregroundColor: WidgetStateProperty.all(textColor),
          side: isPrimary
              ? WidgetStateProperty.all(BorderSide.none)
              : WidgetStateProperty.all(
            BorderSide(color: borderColor, width: 1),
          ),
          overlayColor: WidgetStateProperty.all(pressedColor.withOpacity(0.3)),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius),
              side: BorderSide(color: borderColor, width: 1),
            ),
          ),
        ),
        child: loading
            ? SizedBox(
          height: 20,
          width: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: isPrimary ? resolvedFg : defaultSide.color,
          ),
        )
            : label != null
            ? Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ?label,
            SizedBox(width: 8),
            Text(
              text,
              style: theme.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: isPrimary ? resolvedFg : defaultSide.color,
              ),
            ),
          ],
        )
            : Text(
          text,
          style: theme.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: isPrimary ? resolvedFg : defaultSide.color,
          ),
        ),
      ),
    );
  }
}