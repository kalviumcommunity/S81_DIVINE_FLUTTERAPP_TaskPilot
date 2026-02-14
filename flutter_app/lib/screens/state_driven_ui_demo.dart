import 'package:flutter/material.dart';
import '../constants/retro_theme.dart';
import '../utils/responsive_helper.dart';

/// State-Driven UI Demo Screen
/// Demonstrates Flutter's reactive UI model and widget tree hierarchy
/// 
/// Widget Tree Structure:
/// Scaffold
/// ├── AppBar
/// └── Body (Scrollable)
///     └── Column
///         ├── TreeVisualizer
///         ├── ProfileCardDemo
///         ├── CounterDemo
///         └── ThemeSwitcherDemo

class StateDrivenUIDemoScreen extends StatefulWidget {
  const StateDrivenUIDemoScreen({Key? key}) : super(key: key);

  @override
  State<StateDrivenUIDemoScreen> createState() => _StateDrivenUIDemoState();
}

class _StateDrivenUIDemoState extends State<StateDrivenUIDemoScreen> {
  // State variables - UI updates when these change
  int _counter = 0;
  bool _isDarkMode = false;
  bool _showProfileDetails = false;

  // Increment counter and trigger rebuild
  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  // Decrement counter and trigger rebuild
  void _decrementCounter() {
    setState(() {
      if (_counter > 0) _counter--;
    });
  }

  // Reset counter to 0
  void _resetCounter() {
    setState(() {
      _counter = 0;
    });
  }

  // Toggle theme mode
  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  // Toggle profile details visibility
  void _toggleProfileDetails() {
    setState(() {
      _showProfileDetails = !_showProfileDetails;
    });
  }

  // Get dynamic colors based on theme state
  Color _getPrimaryColor() => _isDarkMode ? Colors.grey[900]! : RetroColors.retroWhite;
  Color _getSecondaryColor() => _isDarkMode ? Colors.grey[800]! : Colors.grey[100]!;
  Color _getTextColor() => _isDarkMode ? Colors.white : Colors.black;

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return Scaffold(
      backgroundColor: _getPrimaryColor(),
      appBar: AppBar(
        title: const Text('State-Driven UI Demo'),
        backgroundColor: RetroColors.retroBlue,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(responsive.paddingSmall),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Widget Tree Visualizer
              _buildTreeVisualizer(context, responsive),
              SizedBox(height: responsive.spacingLarge),

              // 2. Profile Card Demo
              _buildProfileCardDemo(context, responsive),
              SizedBox(height: responsive.spacingLarge),

              // 3. Counter Demo
              _buildCounterDemo(context, responsive),
              SizedBox(height: responsive.spacingLarge),

              // 4. Theme Switcher Demo
              _buildThemeSwitcherDemo(context, responsive),
              SizedBox(height: responsive.spacingLarge),

              // 5. State Management Explanation
              _buildStateExplanation(context, responsive),
            ],
          ),
        ),
      ),
    );
  }

  /// 1. Widget Tree Visualizer
  /// Shows the hierarchical structure of widgets
  Widget _buildTreeVisualizer(BuildContext context, ResponsiveHelper responsive) {
    return Container(
      decoration: BoxDecoration(
        color: _getSecondaryColor(),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: RetroColors.retroBlue, width: 2),
      ),
      padding: EdgeInsets.all(responsive.paddingMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '📊 Widget Tree Structure',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: RetroColors.retroBlue,
                  fontWeight: FontWeight.bold,
                ),
          ),
          SizedBox(height: responsive.spacingMedium),
          Text(
            'Scaffold\n'
            ' ├── AppBar\n'
            ' │   └── Text("State-Driven UI Demo")\n'
            ' └── Body\n'
            '     └── SingleChildScrollView\n'
            '         └── Column\n'
            '             ├── TreeVisualizer (this widget)\n'
            '             ├── ProfileCardDemo\n'
            '             ├── CounterDemo\n'
            '             ├── ThemeSwitcherDemo\n'
            '             └── StateExplanation',
            style: TextStyle(
              fontFamily: 'Courier',
              fontSize: responsive.isMobile ? 11 : 13,
              color: _getTextColor(),
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  /// 2. Profile Card Demo with Expandable Details
  /// Demonstrates state-driven widget visibility
  Widget _buildProfileCardDemo(BuildContext context, ResponsiveHelper responsive) {
    return Container(
      decoration: BoxDecoration(
        color: _getSecondaryColor(),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: RetroColors.retroGreen, width: 2),
      ),
      child: Column(
        children: [
          // Profile Header (Always visible)
          Padding(
            padding: EdgeInsets.all(responsive.paddingMedium),
            child: Row(
              children: [
                // Avatar
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: RetroColors.retroGreen,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      'JP',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: responsive.spacingMedium),
                // Profile Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'John Profile',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: _getTextColor(),
                        ),
                      ),
                      Text(
                        'Flutter Developer',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                // Toggle Button
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: _toggleProfileDetails,
                    child: Padding(
                      padding: EdgeInsets.all(responsive.paddingSmall),
                      child: Icon(
                        _showProfileDetails
                            ? Icons.expand_less
                            : Icons.expand_more,
                        color: RetroColors.retroGreen,
                        size: 28,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Expandable Details
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: RetroColors.retrofaded,
              ),
              padding: EdgeInsets.all(responsive.paddingMedium),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDetailRow('Email:', 'john@example.com'),
                  SizedBox(height: responsive.spacingSmall),
                  _buildDetailRow('Location:', 'San Francisco, CA'),
                  SizedBox(height: responsive.spacingSmall),
                  _buildDetailRow('Experience:', '5 years'),
                  SizedBox(height: responsive.spacingSmall),
                  _buildDetailRow('Status:', '🟢 Online'),
                ],
              ),
            ),
            crossFadeState: _showProfileDetails
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 400),
          ),
        ],
      ),
    );
  }

  /// Helper widget for profile detail rows
  Widget _buildDetailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: RetroColors.retroGreen,
            fontSize: 14,
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              color: _getTextColor(),
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }

  /// 3. Counter Demo
  /// Shows real-time state updates with increment/decrement
  Widget _buildCounterDemo(BuildContext context, ResponsiveHelper responsive) {
    return Container(
      decoration: BoxDecoration(
        color: _getSecondaryColor(),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: RetroColors.retroYellow, width: 2),
      ),
      padding: EdgeInsets.all(responsive.paddingMedium),
      child: Column(
        children: [
          Text(
            '🔢 Counter - State Updates in Real Time',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: RetroColors.retroYellow,
                  fontWeight: FontWeight.bold,
                ),
          ),
          SizedBox(height: responsive.spacingLarge),
          // Counter Display - Updates when _counter changes
          Container(
            decoration: BoxDecoration(
              color: RetroColors.retroYellow,
              borderRadius: BorderRadius.circular(12),
            ),
            padding: EdgeInsets.symmetric(
              horizontal: responsive.paddingLarge,
              vertical: responsive.paddingMedium,
            ),
            child: Column(
              children: [
                Text(
                  'Count',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: responsive.spacingSmall),
                Text(
                  '$_counter',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: responsive.spacingMedium),
          // Control Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                onPressed: _decrementCounter,
                icon: const Icon(Icons.remove),
                label: const Text('Decrease'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
              ),
              ElevatedButton.icon(
                onPressed: _resetCounter,
                icon: const Icon(Icons.refresh),
                label: const Text('Reset'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey,
                ),
              ),
              ElevatedButton.icon(
                onPressed: _incrementCounter,
                icon: const Icon(Icons.add),
                label: const Text('Increase'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                ),
              ),
            ],
          ),
          SizedBox(height: responsive.spacingMedium),
          // Explanation
          Container(
            decoration: BoxDecoration(
              color: RetroColors.retrofaded,
              borderRadius: BorderRadius.circular(8),
            ),
            padding: EdgeInsets.all(responsive.paddingSmall),
            child: Text(
              'Each button press calls setState(), which triggers a rebuild. '
              'The UI automatically updates to show the new count value.',
              style: TextStyle(
                color: _getTextColor(),
                fontSize: 12,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 4. Theme Switcher Demo
  /// Shows dynamic color changes based on state
  Widget _buildThemeSwitcherDemo(BuildContext context, ResponsiveHelper responsive) {
    return Container(
      decoration: BoxDecoration(
        color: _getSecondaryColor(),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: RetroColors.retroRed, width: 2),
      ),
      padding: EdgeInsets.all(responsive.paddingMedium),
      child: Column(
        children: [
          Text(
            '🎨 Theme Switcher - Dynamic Colors',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: RetroColors.retroRed,
                  fontWeight: FontWeight.bold,
                ),
          ),
          SizedBox(height: responsive.spacingLarge),
          // Theme Preview
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: _isDarkMode
                    ? [Colors.grey[900]!, Colors.grey[800]!]
                    : [Colors.blue[100]!, Colors.blue[50]!],
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _isDarkMode ? Colors.white30 : Colors.black12,
              ),
            ),
            padding: EdgeInsets.all(responsive.paddingMedium),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _isDarkMode ? Icons.dark_mode : Icons.light_mode,
                  size: 48,
                  color: _isDarkMode ? Colors.yellow[300] : Colors.orange,
                ),
                SizedBox(height: responsive.spacingMedium),
                Text(
                  _isDarkMode ? 'Dark Mode' : 'Light Mode',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: _isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                SizedBox(height: responsive.spacingSmall),
                Text(
                  _isDarkMode
                      ? 'Easy on your eyes at night'
                      : 'Bright and clear for daytime',
                  style: TextStyle(
                    fontSize: 12,
                    color: _isDarkMode ? Colors.grey[300] : Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: responsive.spacingMedium),
          // Toggle Switch
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.light_mode,
                color: RetroColors.retroYellow,
              ),
              SizedBox(width: responsive.spacingMedium),
              Switch(
                value: _isDarkMode,
                onChanged: (_) => _toggleTheme(),
                activeColor: RetroColors.retroRed,
              ),
              SizedBox(width: responsive.spacingMedium),
              Icon(
                Icons.dark_mode,
                color: Colors.grey[600],
              ),
            ],
          ),
          SizedBox(height: responsive.spacingMedium),
          // Explanation
          Container(
            decoration: BoxDecoration(
              color: RetroColors.retrofaded,
              borderRadius: BorderRadius.circular(8),
            ),
            padding: EdgeInsets.all(responsive.paddingSmall),
            child: Text(
              'Toggle the switch to change the theme. All colors update '
              'instantly because setState() triggers a rebuild with new '
              'color values from _isDarkMode state variable.',
              style: TextStyle(
                color: _getTextColor(),
                fontSize: 12,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 5. State Management Explanation
  Widget _buildStateExplanation(BuildContext context, ResponsiveHelper responsive) {
    return Container(
      decoration: BoxDecoration(
        color: _getSecondaryColor(),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: RetroColors.retroBlue, width: 2),
      ),
      padding: EdgeInsets.all(responsive.paddingMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '💡 How Reactive UI Works',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: RetroColors.retroBlue,
                  fontWeight: FontWeight.bold,
                ),
          ),
          SizedBox(height: responsive.spacingMedium),
          _buildExplanationStep(
            'Step 1',
            'User interacts (tap button, toggle switch)',
            _getTextColor(),
            responsive,
          ),
          _buildExplanationStep(
            'Step 2',
            'Event handler (e.g., _incrementCounter) is called',
            _getTextColor(),
            responsive,
          ),
          _buildExplanationStep(
            'Step 3',
            'setState() is called to update state variables',
            _getTextColor(),
            responsive,
          ),
          _buildExplanationStep(
            'Step 4',
            'build() method is invoked with new state',
            _getTextColor(),
            responsive,
          ),
          _buildExplanationStep(
            'Step 5',
            'UI re-renders with updated values',
            _getTextColor(),
            responsive,
          ),
          SizedBox(height: responsive.spacingMedium),
          Container(
            decoration: BoxDecoration(
              color: RetroColors.retrofaded,
              borderRadius: BorderRadius.circular(8),
            ),
            padding: EdgeInsets.all(responsive.paddingSmall),
            child: Text(
              'This is Flutter\'s reactive programming model: '
              'State → Rebuild → Render. Every interaction triggers '
              'this cycle automatically!',
              style: TextStyle(
                color: _getTextColor(),
                fontSize: 13,
                fontWeight: FontWeight.w600,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Helper to build explanation steps
  Widget _buildExplanationStep(
    String step,
    String description,
    Color textColor,
    ResponsiveHelper responsive,
  ) {
    return Padding(
      padding: EdgeInsets.only(bottom: responsive.spacingMedium),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: RetroColors.retroBlue,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                step.split(' ')[1],
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(width: responsive.spacingMedium),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  step,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: RetroColors.retroBlue,
                    fontSize: 14,
                  ),
                ),
                Text(
                  description,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
