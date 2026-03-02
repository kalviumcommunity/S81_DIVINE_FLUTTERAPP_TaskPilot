import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import '../constants/retro_theme.dart';
import '../utils/firebase_initializer.dart';
import '../widgets/retro_widgets.dart';

class FirebaseSetupScreen extends StatefulWidget {
  const FirebaseSetupScreen({Key? key}) : super(key: key);

  @override
  State<FirebaseSetupScreen> createState() => _FirebaseSetupScreenState();
}

class _FirebaseSetupScreenState extends State<FirebaseSetupScreen> {
  late Future<FirebaseApp?> _initFuture;

  @override
  void initState() {
    super.initState();
    _initFuture = initializeFirebaseSafely();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Firebase Setup Status')),
      body: Padding(
        padding: const EdgeInsets.all(RetroSpacing.md),
        child: FutureBuilder<FirebaseApp?>(
          future: _initFuture,
          builder: (context, snapshot) {
            final isLoading = snapshot.connectionState == ConnectionState.waiting;
            final app = snapshot.data;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                RetroCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Initialization', style: RetroTypography.retroHeadline),
                      const SizedBox(height: RetroSpacing.sm),
                      if (isLoading)
                        const Text('Initializing Firebase…')
                      else if (app != null)
                        Text(
                          'Connected ✅\nApp name: ${app.name}',
                          style: RetroTypography.retroBody,
                        )
                      else
                        Text(
                          'Not connected yet ⚠️\nAdd Firebase config files to enable initialization.',
                          style: RetroTypography.retroBody,
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: RetroSpacing.md),
                RetroCard(
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Android Checklist', style: RetroTypography.retroHeadline),
                      SizedBox(height: RetroSpacing.sm),
                      Text(
                        '1) Firebase Console → Add Android app\n'
                        '2) Package name: com.example.taskpilot\n'
                        '3) Download google-services.json\n'
                        '4) Place at: android/app/google-services.json\n'
                        '5) Run: flutter pub get\n'
                        '6) Run the app and reopen this screen',
                        style: RetroTypography.retroBody,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: RetroSpacing.md),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _initFuture = initializeFirebaseSafely();
                    });
                  },
                  child: const Text('Re-check Connection'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
