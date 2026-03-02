import 'package:flutter/material.dart';
import 'screens/responsive_layout.dart';
import 'screens/state_driven_ui_demo.dart';
import 'screens/stateless_stateful_demo.dart';
import 'screens/dev_tools_demo.dart';
import 'screens/multi_screen_navigation_demo.dart';
import 'screens/responsive_layouts_demo.dart';
import 'screens/scrollable_views.dart';
import 'constants/retro_theme.dart';
import 'screens/user_input_form.dart';
import 'screens/state_management_demo.dart';
import 'screens/responsive_design_demo.dart';
import 'screens/assets_demo_screen.dart';
import 'screens/animations_transitions_demo.dart';
import 'screens/firebase_setup_screen.dart';
import 'utils/firebase_initializer.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Defensive init: app still runs even if config files are missing.
  await initializeFirebaseSafely();
  runApp(const TaskPilotApp());
}

class TaskPilotApp extends StatelessWidget {
  const TaskPilotApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TaskPilot',
      theme: RetroAppTheme.light(),
      darkTheme: RetroAppTheme.dark(),
      themeMode: ThemeMode.light,
      home: ResponsiveLayout(),
      routes: {
        '/state-driven-ui': (context) => const StateDrivenUIDemoScreen(),
        '/stateless-stateful': (context) => const StatelessStatefulDemoScreen(),
        '/dev-tools': (context) => const DevToolsDemoScreen(),
        '/multi-screen-navigation': (context) => const MultiScreenNavigationDemoScreen(),
        '/responsive-layouts': (context) => const ResponsiveLayoutsDemoScreen(),
        '/scrollable-views': (context) => const ScrollableViewsScreen(),
        '/user-input-form': (context) => const UserInputForm(),
        '/state-management-demo': (context) => const StateManagementDemo(),
        '/responsive-design-demo': (context) => const ResponsiveDesignDemo(),
        '/assets-demo': (context) => const AssetsDemoScreen(),
        '/animations-transitions-demo': (context) => const AnimationsTransitionsDemo(),
        '/firebase-setup': (context) => const FirebaseSetupScreen(),

        // Internal routes used by MultiScreenNavigationDemoScreen
        '/navigation/basic': (context) => const BasicExampleScreen(),
        '/navigation/data': (context) => const DataPassingScreen(),
        '/navigation/settings': (context) => const SettingsScreen(),
        '/navigation/wizard': (context) => const WizardScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

