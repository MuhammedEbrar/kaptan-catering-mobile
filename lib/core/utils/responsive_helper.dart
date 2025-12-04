import 'package:flutter/material.dart';

/// Responsive design helper class
/// Ekran boyutlarına göre adaptive değerler sağlar
class ResponsiveHelper {
  final BuildContext context;

  ResponsiveHelper(this.context);

  /// Ekran genişliği
  double get width => MediaQuery.of(context).size.width;

  /// Ekran yüksekliği
  double get height => MediaQuery.of(context).size.height;

  /// Ekran orientation (dikey/yatay)
  Orientation get orientation => MediaQuery.of(context).orientation;

  /// Cihaz türü kontrolü
  bool get isMobile => width < 600;
  bool get isTablet => width >= 600 && width < 1024;
  bool get isDesktop => width >= 1024;

  /// Orientation kontrolü
  bool get isPortrait => orientation == Orientation.portrait;
  bool get isLandscape => orientation == Orientation.landscape;

  /// Grid column count (responsive)
  int get gridColumnCount {
    if (isDesktop) return 4;
    if (isTablet) return 3;
    return 2;
  }

  /// Grid column count landscape için
  int get gridColumnCountLandscape {
    if (isDesktop) return 5;
    if (isTablet) return 4;
    return 3;
  }

  /// Dynamic grid columns (orientation'a göre)
  int get adaptiveGridColumns {
    if (isLandscape) return gridColumnCountLandscape;
    return gridColumnCount;
  }

  /// Font size scaling
  double scaledFontSize(double baseSize) {
    final textScaleFactor = MediaQuery.of(context).textScaleFactor;
    return baseSize * textScaleFactor;
  }

  /// Responsive padding
  EdgeInsets get screenPadding {
    if (isDesktop) {
      return const EdgeInsets.symmetric(horizontal: 48, vertical: 24);
    }
    if (isTablet) {
      return const EdgeInsets.symmetric(horizontal: 32, vertical: 20);
    }
    return const EdgeInsets.symmetric(horizontal: 16, vertical: 12);
  }

  /// Responsive card elevation
  double get cardElevation => isMobile ? 2 : 4;

  /// Responsive border radius
  double get borderRadius => isMobile ? 12 : 16;

  /// Responsive icon size
  double get iconSize {
    if (isDesktop) return 28;
    if (isTablet) return 24;
    return 20;
  }

  /// Responsive button height
  double get buttonHeight {
    if (isDesktop) return 56;
    if (isTablet) return 52;
    return 48;
  }

  /// Safe area insets
  EdgeInsets get safeAreaPadding => MediaQuery.of(context).padding;

  /// Bottom safe area (for notch/home indicator)
  double get bottomSafeArea => safeAreaPadding.bottom;

  /// Top safe area (for notch/status bar)
  double get topSafeArea => safeAreaPadding.top;

  /// Responsive app bar height
  double get appBarHeight {
    final topPadding = topSafeArea;
    if (isTablet) return kToolbarHeight + topPadding + 8;
    return kToolbarHeight + topPadding;
  }

  /// Responsive spacing
  double spacing(double base) {
    if (isDesktop) return base * 1.5;
    if (isTablet) return base * 1.25;
    return base;
  }

  /// Min touch target size (accessibility)
  static const double minTouchTargetSize = 48.0;

  /// Check if touch target is accessible
  bool isTouchTargetAccessible(double size) {
    return size >= minTouchTargetSize;
  }

  /// Responsive dialog width
  double get dialogWidth {
    if (isDesktop) return width * 0.3;
    if (isTablet) return width * 0.5;
    return width * 0.85;
  }

  /// Responsive bottom sheet max height
  double get bottomSheetMaxHeight {
    return height * 0.9;
  }

  /// Grid aspect ratio
  double get gridAspectRatio {
    if (isTablet) return 0.85;
    return 0.75;
  }

  /// Horizontal list item width
  double get horizontalListItemWidth {
    if (isDesktop) return 200;
    if (isTablet) return 180;
    return 150;
  }

  /// Card width for grid
  double get cardWidth {
    final columns = adaptiveGridColumns;
    final totalPadding = screenPadding.horizontal + (columns - 1) * 12;
    return (width - totalPadding) / columns;
  }
}

/// Extension for easy access
extension ResponsiveContext on BuildContext {
  ResponsiveHelper get responsive => ResponsiveHelper(this);
}

/// Responsive Widget Builder
class ResponsiveBuilder extends StatelessWidget {
  final Widget Function(BuildContext context, ResponsiveHelper responsive)
      builder;

  const ResponsiveBuilder({
    super.key,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return builder(context, ResponsiveHelper(context));
  }
}

/// Responsive Grid View
class ResponsiveGridView extends StatelessWidget {
  final List<Widget> children;
  final double? aspectRatio;
  final double? spacing;
  final EdgeInsets? padding;
  final ScrollPhysics? physics;

  const ResponsiveGridView({
    super.key,
    required this.children,
    this.aspectRatio,
    this.spacing,
    this.padding,
    this.physics,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return GridView.builder(
      padding: padding ?? responsive.screenPadding,
      physics: physics ?? const AlwaysScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: responsive.adaptiveGridColumns,
        childAspectRatio: aspectRatio ?? responsive.gridAspectRatio,
        crossAxisSpacing: spacing ?? 12,
        mainAxisSpacing: spacing ?? 12,
      ),
      itemCount: children.length,
      itemBuilder: (context, index) => children[index],
    );
  }
}

/// Responsive Value (T value based on screen size)
class ResponsiveValue<T> {
  final T mobile;
  final T? tablet;
  final T? desktop;

  const ResponsiveValue({
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  T getValue(BuildContext context) {
    final responsive = context.responsive;

    if (responsive.isDesktop && desktop != null) return desktop!;
    if (responsive.isTablet && tablet != null) return tablet!;
    return mobile;
  }
}

/// Extension for responsive values
extension ResponsiveValueExtension on BuildContext {
  T responsiveValue<T>({
    required T mobile,
    T? tablet,
    T? desktop,
  }) {
    return ResponsiveValue<T>(
      mobile: mobile,
      tablet: tablet,
      desktop: desktop,
    ).getValue(this);
  }
}
