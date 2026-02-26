import 'package:flutter/material.dart';
import 'screens/responsive_layout.dart';
import 'screens/state_driven_ui_demo.dart';
import 'screens/stateless_stateful_demo.dart';
import 'screens/dev_tools_demo.dart';
import 'screens/multi_screen_navigation_demo.dart';
import 'screens/responsive_layouts_demo.dart';
import 'screens/scrollable_views.dart';
import 'constants/retro_theme.dart';

void main() {
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
