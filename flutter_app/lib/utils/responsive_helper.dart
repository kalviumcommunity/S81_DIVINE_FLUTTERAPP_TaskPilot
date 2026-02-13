import 'package:flutter/material.dart';

/// Responsive Helper Class
/// Provides utility methods for responsive design using MediaQuery
class ResponsiveHelper {
  BuildContext context;

  ResponsiveHelper(this.context);

  /// Get screen dimensions
  Size get screenSize => MediaQuery.of(context).size;
  double get screenWidth => screenSize.width;
  double get screenHeight => screenSize.height;

  /// Get device type based on screen width
  DeviceType get deviceType {
    double width = screenWidth;
    if (width < 600) {
      return DeviceType.mobile;
    } else if (width < 1200) {
      return DeviceType.tablet;
    } else {
      return DeviceType.desktop;
    }
  }

  /// Check if device is in landscape mode
  bool get isLandscape =>
      MediaQuery.of(context).orientation == Orientation.landscape;

  /// Check if device is in portrait mode
  bool get isPortrait =>
      MediaQuery.of(context).orientation == Orientation.portrait;

  /// Check specific device types
  bool get isMobile => deviceType == DeviceType.mobile;
  bool get isTablet => deviceType == DeviceType.tablet;
  bool get isDesktop => deviceType == DeviceType.desktop;

  /// Get responsive padding based on screen width
  EdgeInsets get responsivePadding {
    if (isMobile) {
      return const EdgeInsets.all(12.0);
    } else if (isTablet) {
      return const EdgeInsets.all(20.0);
    } else {
      return const EdgeInsets.all(32.0);
    }
  }

  /// Get responsive font size
  double responsiveFontSize({
    required double mobileSize,
    double? tabletSize,
    double? desktopSize,
  }) {
    if (isMobile) {
      return mobileSize;
    } else if (isTablet) {
      return tabletSize ?? mobileSize * 1.2;
    } else {
      return desktopSize ?? mobileSize * 1.5;
    }
  }

  /// Get responsive dimension
  double responsiveDimension({
    required double mobileSize,
    double? tabletSize,
    double? desktopSize,
  }) {
    if (isMobile) {
      return mobileSize;
    } else if (isTablet) {
      return tabletSize ?? mobileSize * 1.3;
    } else {
      return desktopSize ?? mobileSize * 1.6;
    }
  }

  /// Get grid columns based on device type
  int get gridColumns {
    if (isMobile) {
      return 1;
    } else if (isTablet) {
      return 2;
    } else {
      return 3;
    }
  }

  /// Get responsive width percentage
  double percentWidth(double percent) => screenWidth * (percent / 100);

  /// Get responsive height percentage
  double percentHeight(double percent) => screenHeight * (percent / 100);

  /// Get aspect ratio for images based on device
  double get imageAspectRatio {
    if (isMobile) {
      return 16 / 9;
    } else {
      return 21 / 9;
    }
  }
}

enum DeviceType { mobile, tablet, desktop }

/// Extension for easier access to ResponsiveHelper
extension ResponsiveContext on BuildContext {
  ResponsiveHelper get responsive => ResponsiveHelper(this);
}
