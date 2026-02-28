import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constants/retro_theme.dart';
import '../widgets/retro_widgets.dart';

class AssetsDemoScreen extends StatelessWidget {
  const AssetsDemoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Assets Demo')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(RetroSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            RetroCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Local Images', style: RetroTypography.retroHeadline),
                  const SizedBox(height: RetroSpacing.sm),
                  Center(
                    child: Image.asset(
                      'assets/images/logo.png',
                      width: 140,
                      height: 140,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: RetroSpacing.md),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(RetroBorderRadius.md),
                    child: Image.asset(
                      'assets/images/banner.png',
                      height: 140,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: RetroSpacing.md),
            RetroCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Image as Background (DecorationImage)',
                    style: RetroTypography.retroHeadline,
                  ),
                  const SizedBox(height: RetroSpacing.sm),
                  Container(
                    height: 160,
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(RetroBorderRadius.md),
                      image: const DecorationImage(
                        image: AssetImage('assets/images/background.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: RetroColors.retroWhite.withOpacity(0.85),
                          borderRadius:
                              BorderRadius.circular(RetroBorderRadius.sm),
                        ),
                        child: Text(
                          'Welcome to TaskPilot',
                          style: RetroTypography.retroTitle,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: RetroSpacing.md),
            RetroCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Icons (Material + Cupertino)',
                      style: RetroTypography.retroHeadline),
                  const SizedBox(height: RetroSpacing.sm),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: const [
                      Icon(Icons.flutter_dash, size: 34),
                      Icon(Icons.android, size: 34),
                      Icon(Icons.apple, size: 34),
                      Icon(CupertinoIcons.heart_fill, size: 32),
                    ],
                  ),
                  const SizedBox(height: RetroSpacing.md),
                  Text('Local Icon PNGs', style: RetroTypography.retroTitle),
                  const SizedBox(height: RetroSpacing.sm),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/icons/star.png',
                        width: 56,
                        height: 56,
                      ),
                      const SizedBox(width: 16),
                      Image.asset(
                        'assets/icons/profile.png',
                        width: 56,
                        height: 56,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
