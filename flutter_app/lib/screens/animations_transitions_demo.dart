import 'package:flutter/material.dart';

import '../constants/retro_theme.dart';
import '../widgets/retro_widgets.dart';
import '../widgets/taskpilot_primary_button.dart';

class AnimationsTransitionsDemo extends StatefulWidget {
  const AnimationsTransitionsDemo({Key? key}) : super(key: key);

  @override
  State<AnimationsTransitionsDemo> createState() => _AnimationsTransitionsDemoState();
}

class _AnimationsTransitionsDemoState extends State<AnimationsTransitionsDemo>
    with SingleTickerProviderStateMixin {
  bool _toggled = false;
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleImplicit() {
    setState(() {
      _toggled = !_toggled;
    });
  }

  void _openWithSlideTransition() {
    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 700),
        pageBuilder: (context, animation, secondaryAnimation) {
          return const _AnimatedTransitionTargetPage();
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final curved = CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOut,
          );
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).animate(curved),
            child: child,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Animations & Transitions')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(RetroSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            RetroCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Implicit Animations', style: RetroTypography.retroHeadline),
                  const SizedBox(height: RetroSpacing.sm),
                  Text(
                    'AnimatedContainer + AnimatedOpacity respond to state changes.',
                    style: RetroTypography.retroBody,
                  ),
                  const SizedBox(height: RetroSpacing.md),
                  Center(
                    child: GestureDetector(
                      onTap: _toggleImplicit,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 800),
                        curve: Curves.easeInOut,
                        width: _toggled ? 220 : 140,
                        height: _toggled ? 140 : 220,
                        decoration: BoxDecoration(
                          color:
                              _toggled ? RetroColors.neonCyan : RetroColors.neonOrange,
                          borderRadius:
                              BorderRadius.circular(RetroBorderRadius.md),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'Tap Me!',
                          style: RetroTypography.retroTitle.copyWith(
                            color: RetroColors.retroBlack,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: RetroSpacing.md),
                  Center(
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 800),
                      opacity: _toggled ? 1.0 : 0.25,
                      child: Image.asset(
                        'assets/images/logo.png',
                        width: 120,
                        height: 120,
                      ),
                    ),
                  ),
                  const SizedBox(height: RetroSpacing.md),
                  TaskPilotPrimaryButton(
                    label: _toggled ? 'Reset' : 'Animate',
                    onPressed: _toggleImplicit,
                  ),
                ],
              ),
            ),
            const SizedBox(height: RetroSpacing.md),
            RetroCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Explicit Animation', style: RetroTypography.retroHeadline),
                  const SizedBox(height: RetroSpacing.sm),
                  Text(
                    'RotationTransition driven by an AnimationController.',
                    style: RetroTypography.retroBody,
                  ),
                  const SizedBox(height: RetroSpacing.md),
                  Center(
                    child: RotationTransition(
                      turns: _controller,
                      child: Image.asset(
                        'assets/images/logo.png',
                        width: 90,
                        height: 90,
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
                  Text('Page Transition', style: RetroTypography.retroHeadline),
                  const SizedBox(height: RetroSpacing.sm),
                  Text(
                    'Navigate with a custom slide transition (PageRouteBuilder).',
                    style: RetroTypography.retroBody,
                  ),
                  const SizedBox(height: RetroSpacing.md),
                  TaskPilotPrimaryButton(
                    label: 'Open Next Page',
                    onPressed: _openWithSlideTransition,
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

class _AnimatedTransitionTargetPage extends StatelessWidget {
  const _AnimatedTransitionTargetPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Transition Target')),
      body: Center(
        child: RetroCard(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Hello!', style: RetroTypography.retroHeadline),
              const SizedBox(height: RetroSpacing.sm),
              Text(
                'This page used a custom slide transition.',
                style: RetroTypography.retroBody,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: RetroSpacing.md),
              TaskPilotPrimaryButton(
                label: 'Back',
                onPressed: () => Navigator.pop(context),
                fullWidth: false,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
