import 'package:flutter/material.dart';

import '../constants/retro_theme.dart';
import '../widgets/retro_widgets.dart';

class ResponsiveDesignDemo extends StatelessWidget {
  const ResponsiveDesignDemo({Key? key}) : super(key: key);

  double _clampDouble(double value, double min, double max) {
    if (value < min) return min;
    if (value > max) return max;
    return value;
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    final isPortrait = mediaQuery.orientation == Orientation.portrait;

    final horizontalPadding = _clampDouble(screenWidth * 0.05, 16, 36);
    final verticalPadding = _clampDouble(screenHeight * 0.02, 12, 24);
    final titleFontSize = _clampDouble(screenWidth * 0.055, 18, 28);

    return Scaffold(
      appBar: AppBar(title: const Text('Responsive Design Demo')),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isTabletLayout = constraints.maxWidth >= 600;

          final infoCard = RetroCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isTabletLayout ? 'Tablet / Wide Layout' : 'Mobile / Narrow Layout',
                  style: RetroTypography.retroHeadline.copyWith(
                    fontSize: titleFontSize,
                  ),
                ),
                const SizedBox(height: RetroSpacing.sm),
                Text(
                  'Width: ${screenWidth.toStringAsFixed(0)}  •  Height: ${screenHeight.toStringAsFixed(0)}',
                  style: RetroTypography.retroBody,
                ),
                const SizedBox(height: 6),
                Text(
                  'Orientation: ${isPortrait ? 'Portrait' : 'Landscape'}',
                  style: RetroTypography.retroBody,
                ),
              ],
            ),
          );

          final responsiveContainer = RetroCard(
            backgroundColor: RetroColors.pastelBlue,
            borderColor: RetroColors.neonCyan,
            child: SizedBox(
              width: screenWidth * 0.8,
              height: _clampDouble(screenHeight * 0.12, 84, 140),
              child: Center(
                child: Text(
                  'MediaQuery sizing\n(80% width, ~12% height)',
                  textAlign: TextAlign.center,
                  style: RetroTypography.retroTitle.copyWith(
                    color: RetroColors.retroBlack,
                  ),
                ),
              ),
            ),
          );

          final content = isTabletLayout
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: infoCard),
                    const SizedBox(width: 16),
                    Expanded(child: responsiveContainer),
                  ],
                )
              : Column(
                  children: [
                    infoCard,
                    const SizedBox(height: 16),
                    responsiveContainer,
                  ],
                );

          return Padding(
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding,
              vertical: verticalPadding,
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1000),
                child: content,
              ),
            ),
          );
        },
      ),
    );
  }
}
