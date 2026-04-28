import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

enum IconPosition { start, end }

class MyTextField extends HookConsumerWidget {
  final String value;
  final ValueChanged<String> onChange;
  final VoidCallback onDone;
  final bool isValid;
  final bool showErrorState;
  final String errorMessage;
  final bool showPassword;
  final ValueChanged<bool> onShowPasswordClicked;
  final String label;
  final String hint;
  final String fieldDescription;
  final bool isPassword;
  final bool isLongText;
  final Widget? fieldIcon;
  final IconPosition iconPosition;
  final VoidCallback? onTrailingIconClicked;
  final TextInputType keyboardType;
  final bool enabled;
  final bool readOnly;
  final bool boldLabel;
  final Widget? action;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;

  const MyTextField({
    super.key,
    required this.value,
    required this.onChange,
    this.onDone = _defaultVoidCallback,
    this.isValid = true,
    this.showErrorState = true,
    this.errorMessage = '',
    this.showPassword = false,
    this.onShowPasswordClicked = _defaultOnShowPasswordClicked,
    required this.label,
    required this.hint,
    required this.fieldDescription,
    required this.isPassword,
    this.isLongText = false,
    this.fieldIcon,
    this.iconPosition = IconPosition.start,
    this.onTrailingIconClicked,
    this.keyboardType = TextInputType.text,
    this.enabled = true,
    this.readOnly = false,
    this.boldLabel = true,
    this.action,
    this.textInputAction,
    this.focusNode,
  });

  static void _defaultVoidCallback() {}

  static void _defaultOnShowPasswordClicked(bool _) {}

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final controller = useTextEditingController(text: value);
    final node = focusNode ?? useFocusNode();

    useEffect(() {
      if (controller.text != value) {
        controller.text = value;
        controller.selection = TextSelection.collapsed(offset: value.length);
      }
      return null;
    }, [value]);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        ResponsiveText(
          text: label,
          maxLines: 1,
          style: theme.textTheme.labelMedium,
        ),

        if (fieldDescription.isNotEmpty) ...[
          SizedBox(height: 4),
          Text(
            fieldDescription,
            style: theme.textTheme.bodySmall?.copyWith(
              color: isValid
                  ? theme.colorScheme.onSurface.withOpacity(0.5)
                  : theme.colorScheme.error,
            ),
          ),
        ],

        SizedBox(height: 8),

        Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                focusNode: node,
                onChanged: onChange,
                onEditingComplete: onDone,
                readOnly: readOnly,
                enabled: enabled,
                maxLines: isLongText ? null : 1,
                minLines: isLongText ? 4 : null,
                keyboardType: keyboardType,
                textInputAction:
                textInputAction ??
                    (isLongText
                        ? TextInputAction.newline
                        : TextInputAction.next),
                obscureText: isPassword && !showPassword,
                obscuringCharacter: '*',

                decoration: InputDecoration(
                  hintText: hint,
                  errorText: showErrorState && errorMessage.isNotEmpty
                      ? errorMessage
                      : null,
                  prefixIcon:
                  fieldIcon != null && iconPosition == IconPosition.start
                      ? IconButton(
                    icon: fieldIcon!,
                    onPressed: onTrailingIconClicked,
                  )
                      : null,

                  hintStyle: theme.inputDecorationTheme.hintStyle,
                  labelStyle: theme.inputDecorationTheme.labelStyle,
                  filled: theme.inputDecorationTheme.filled,
                  fillColor: theme.inputDecorationTheme.fillColor,
                  contentPadding: theme.inputDecorationTheme.contentPadding,
                  enabledBorder: theme.inputDecorationTheme.enabledBorder,
                  focusedBorder: theme.inputDecorationTheme.focusedBorder,
                  errorBorder: theme.inputDecorationTheme.errorBorder,
                  focusedErrorBorder: theme.inputDecorationTheme.focusedBorder,
                  suffixIcon: _buildSuffixIcon(context),
                ),
              ),
            ),
            if (action != null) ...[SizedBox(width: 8), action!],
          ],
        ),
      ],
    );
  }

  Widget? _buildSuffixIcon(BuildContext context) {
    if (isPassword) {
      return IconButton(
        icon: Icon(
          showPassword ? Icons.visibility : Icons.visibility_off,
          color: Theme.of(context).iconTheme.color,
          size: 20,
        ),
        onPressed: () => onShowPasswordClicked(!showPassword),
      );
    } else if (fieldIcon != null && iconPosition == IconPosition.end) {
      return IconButton(icon: fieldIcon!, onPressed: onTrailingIconClicked);
    }
    return null;
  }
}

class ResponsiveText extends HookWidget {
  final String text;
  final TextStyle? style;
  final Color? color;
  final TextAlign textAlign;
  final int maxLines;

  const ResponsiveText({
    super.key,
    required this.text,
    this.style,
    this.color,
    this.textAlign = TextAlign.start,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    final fontSize = useState<double>(14);
    final defaultStyle = Theme.of(context).textTheme.bodyMedium;

    return LayoutBuilder(
      builder: (context, constraints) {
        final textPainter = TextPainter(
          text: TextSpan(
            text: text,
            style: (style ?? defaultStyle)?.copyWith(
              fontSize: fontSize.value,
              color: color,
            ),
          ),
          maxLines: maxLines,
          textDirection: TextDirection.ltr,
        )..layout(maxWidth: constraints.maxWidth);

        if (textPainter.didExceedMaxLines) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            fontSize.value = fontSize.value - 0.1;
          });
        }

        return Text(
          text,
          style: (style ?? defaultStyle)?.copyWith(
            fontSize: fontSize.value,
            color: color,
          ),
          textAlign: textAlign,
          maxLines: maxLines,
          overflow: TextOverflow.ellipsis,
        );
      },
    );
  }
}