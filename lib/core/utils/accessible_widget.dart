import 'package:flutter/material.dart';

/// Accessibility wrapper widget
/// WCAG 2.1 AA standartlarına uygun widget'lar için
class AccessibleWidget extends StatelessWidget {
  final Widget child;
  final String? label;
  final String? hint;
  final String? value;
  final bool isButton;
  final bool isImage;
  final bool isHeader;
  final bool excludeSemantics;
  final VoidCallback? onTap;

  const AccessibleWidget({
    super.key,
    required this.child,
    this.label,
    this.hint,
    this.value,
    this.isButton = false,
    this.isImage = false,
    this.isHeader = false,
    this.excludeSemantics = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (excludeSemantics) {
      return ExcludeSemantics(child: child);
    }

    return Semantics(
      label: label,
      hint: hint,
      value: value,
      button: isButton,
      image: isImage,
      header: isHeader,
      onTap: onTap,
      child: child,
    );
  }
}

/// Accessible Button (minimum 48x48 touch target)
class AccessibleButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget child;
  final String label;
  final String? tooltip;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final EdgeInsets? padding;
  final double? minWidth;
  final double? minHeight;
  final BorderRadius? borderRadius;

  const AccessibleButton({
    super.key,
    required this.onPressed,
    required this.child,
    required this.label,
    this.tooltip,
    this.backgroundColor,
    this.foregroundColor,
    this.padding,
    this.minWidth,
    this.minHeight,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: label,
      button: true,
      enabled: true,
      child: Tooltip(
        message: tooltip ?? label,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor,
            foregroundColor: foregroundColor,
            padding: padding ??
                const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            minimumSize: Size(
              minWidth ?? 48,
              minHeight ?? 48,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: borderRadius ?? BorderRadius.circular(12),
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}

/// Accessible Icon Button (48x48 minimum)
class AccessibleIconButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final String label;
  final String? tooltip;
  final Color? color;
  final double? size;

  const AccessibleIconButton({
    super.key,
    required this.onPressed,
    required this.icon,
    required this.label,
    this.tooltip,
    this.color,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: label,
      button: true,
      enabled: true,
      child: Tooltip(
        message: tooltip ?? label,
        child: IconButton(
          onPressed: onPressed,
          icon: Icon(icon, color: color, size: size ?? 24),
          iconSize: size ?? 24,
          constraints: const BoxConstraints(
            minWidth: 48,
            minHeight: 48,
          ),
          splashRadius: 24,
        ),
      ),
    );
  }
}

/// Accessible Text Field
class AccessibleTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? hint;
  final String? errorText;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final int? maxLines;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;

  const AccessibleTextField({
    super.key,
    required this.controller,
    required this.label,
    this.hint,
    this.errorText,
    this.keyboardType,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.maxLines = 1,
    this.onChanged,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: label,
      hint: hint,
      textField: true,
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        maxLines: maxLines,
        onChanged: onChanged,
        onTap: onTap,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          errorText: errorText,
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          // High contrast for accessibility
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.blue, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.red, width: 2),
          ),
        ),
      ),
    );
  }
}

/// Accessible Card (with proper contrast and focus)
class AccessibleCard extends StatelessWidget {
  final Widget child;
  final String? label;
  final VoidCallback? onTap;
  final EdgeInsets? padding;
  final double? elevation;
  final Color? backgroundColor;

  const AccessibleCard({
    super.key,
    required this.child,
    this.label,
    this.onTap,
    this.padding,
    this.elevation,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final card = Card(
      elevation: elevation ?? 2,
      color: backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: padding ?? const EdgeInsets.all(16),
        child: child,
      ),
    );

    if (onTap != null) {
      return Semantics(
        label: label,
        button: true,
        enabled: true,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: card,
        ),
      );
    }

    return Semantics(
      label: label,
      child: card,
    );
  }
}

/// Contrast Checker (WCAG 2.1 AA)
class ContrastChecker {
  /// Minimum contrast ratio for normal text (WCAG AA)
  static const double minContrastNormal = 4.5;

  /// Minimum contrast ratio for large text (WCAG AA)
  static const double minContrastLarge = 3.0;

  /// Calculate contrast ratio between two colors
  static double calculateContrast(Color foreground, Color background) {
    final l1 = _calculateRelativeLuminance(foreground);
    final l2 = _calculateRelativeLuminance(background);

    final lighter = l1 > l2 ? l1 : l2;
    final darker = l1 > l2 ? l2 : l1;

    return (lighter + 0.05) / (darker + 0.05);
  }

  /// Calculate relative luminance
  static double _calculateRelativeLuminance(Color color) {
    final r = _sRGBtoLinear(color.red / 255);
    final g = _sRGBtoLinear(color.green / 255);
    final b = _sRGBtoLinear(color.blue / 255);

    return 0.2126 * r + 0.7152 * g + 0.0722 * b;
  }

  static double _sRGBtoLinear(double value) {
    if (value <= 0.03928) {
      return value / 12.92;
    } else {
      return ((value + 0.055) / 1.055).pow(2.4);
    }
  }

  /// Check if contrast meets WCAG AA standard
  static bool meetsContrastAA(Color foreground, Color background,
      {bool isLargeText = false}) {
    final contrast = calculateContrast(foreground, background);
    final minContrast = isLargeText ? minContrastLarge : minContrastNormal;
    return contrast >= minContrast;
  }
}

/// Extension for num.pow()
extension NumPow on num {
  double pow(num exponent) {
    return (this as double).pow(exponent);
  }
}

/// Focus Management Helper
class FocusHelper {
  /// Request focus on next field
  static void nextFocus(BuildContext context) {
    FocusScope.of(context).nextFocus();
  }

  /// Request focus on previous field
  static void previousFocus(BuildContext context) {
    FocusScope.of(context).previousFocus();
  }

  /// Unfocus current field
  static void unfocus(BuildContext context) {
    FocusScope.of(context).unfocus();
  }

  /// Request focus on specific field
  static void requestFocus(BuildContext context, FocusNode node) {
    FocusScope.of(context).requestFocus(node);
  }
}

/// Accessible Loading Indicator
class AccessibleLoadingIndicator extends StatelessWidget {
  final String label;
  final double? size;
  final Color? color;

  const AccessibleLoadingIndicator({
    super.key,
    this.label = 'Yükleniyor',
    this.size,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: label,
      liveRegion: true,
      child: Center(
        child: SizedBox(
          width: size ?? 40,
          height: size ?? 40,
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
              color ?? Theme.of(context).primaryColor,
            ),
            strokeWidth: 3,
          ),
        ),
      ),
    );
  }
}

/// Accessible Image (with semantic label)
class AccessibleImage extends StatelessWidget {
  final ImageProvider image;
  final String label;
  final double? width;
  final double? height;
  final BoxFit? fit;

  const AccessibleImage({
    super.key,
    required this.image,
    required this.label,
    this.width,
    this.height,
    this.fit,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: label,
      image: true,
      child: Image(
        image: image,
        width: width,
        height: height,
        fit: fit,
        excludeFromSemantics: true, // Prevent duplicate announcements
      ),
    );
  }
}
