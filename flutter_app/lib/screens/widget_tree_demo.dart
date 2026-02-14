import 'package:flutter/material.dart';
import '../constants/retro_theme.dart';
import '../utils/responsive_helper.dart';

/// Widget Tree & Reactive UI Demo Screen
/// Demonstrates Flutter's widget hierarchy and state-driven UI updates
/// 
/// Widget Tree Structure:
/// Scaffold
///  ├─ AppBar
///  └─ Body
///     └─ SingleChildScrollView
///        └─ Column
///           ├─ TaskCard (Profile Demo)
///           │  ├─ Row
///           │  │  ├─ Text (Header)
///           │  │  └─ IconButton (Toggle)
///           │  └─ AnimatedContainer (Details)
///           ├─ SizedBox
///           ├─ ThemeSwitcherCard
///           │  ├─ Row
///           │  │  ├─ Text
///           │  │  └─ Switch
///           │  └─ AnimatedContainer
///           ├─ SizedBox
///           └─ CounterCard (Interactive Counter)
///              ├─ Text (Count Display)
///              └─ Row (Buttons)
///                 ├─ ElevatedButton
///                 └─ ElevatedButton
class WidgetTreeDemoScreen extends StatefulWidget {
  const WidgetTreeDemoScreen({Key? key}) : super(key: key);

  @override
  State<WidgetTreeDemoScreen> createState() => _WidgetTreeDemoScreenState();
}

class _WidgetTreeDemoScreenState extends State<WidgetTreeDemoScreen> {
  // State variables demonstrating reactive UI
  bool _showDetails = false;
  bool _isDarkMode = false;
  int _counter = 0;

  /// Increment counter - triggers setState() and UI rebuild
  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  /// Decrement counter - triggers setState() and UI rebuild
  void _decrementCounter() {
    setState(() {
      if (_counter > 0) _counter--;
    });
  }

  /// Toggle details visibility - triggers setState() and smooth animation
  void _toggleDetails() {
    setState(() {
      _showDetails = !_showDetails;
    });
  }

  /// Toggle theme - triggers setState() and changes colors
  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return Scaffold(
      backgroundColor: _isDarkMode ? RetroColors.retroBlack : RetroColors.retroWhite,
      appBar: AppBar(
        title: const Text('Widget Tree & Reactive UI'),
        backgroundColor: _isDarkMode ? RetroColors.retroDarkGray : RetroColors.neonPurple,
        elevation: 8,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: responsive.responsivePadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. PROFILE CARD WITH TOGGLE
                _buildProfileCard(responsive),
                
                SizedBox(height: RetroSpacing.lg),

                // 2. THEME SWITCHER CARD
                _buildThemeSwitcherCard(responsive),
                
                SizedBox(height: RetroSpacing.lg),

                // 3. COUNTER CARD
                _buildCounterCard(responsive),

                SizedBox(height: RetroSpacing.lg),

                // 4. WIDGET TREE EXPLANATION
                _buildWidgetTreeInfo(responsive),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Profile Card Widget - Demonstrates toggle and conditional rendering
  /// Widget Tree:
  /// RetroCard
  ///  ├─ Row
  ///  │  ├─ Text ('Profile')
  ///  │  └─ IconButton
  ///  └─ AnimatedContainer
  ///     └─ Text (Details)
  Widget _buildProfileCard(ResponsiveHelper responsive) {
    return Container(
      padding: EdgeInsets.all(RetroSpacing.md),
      decoration: BoxDecoration(
        border: Border.all(
          color: _isDarkMode ? RetroColors.neonCyan : RetroColors.neonPurple,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(RetroBorderRadius.md),
        boxShadow: [RetroEffects.deepShadow],
        color: _isDarkMode ? RetroColors.retroDarkGray : Colors.white,
      ),
      child: Column(
        children: [
          // Header Row with toggle button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Freelancer Profile',
                    style: RetroTypography.retroHeadline.copyWith(
                      color: _isDarkMode ? RetroColors.neonCyan : RetroColors.neonPurple,
                    ),
                  ),
                  Text(
                    'Click to toggle details',
                    style: RetroTypography.retroLabel.copyWith(
                      color: _isDarkMode ? RetroColors.retroGray : RetroColors.retroGray,
                    ),
                  ),
                ],
              ),
              IconButton(
                icon: Icon(
                  _showDetails ? Icons.expand_less : Icons.expand_more,
                  color: _isDarkMode ? RetroColors.neonCyan : RetroColors.neonPurple,
                  size: 28,
                ),
                onPressed: _toggleDetails,
              ),
            ],
          ),

          SizedBox(height: RetroSpacing.md),

          // Animated Details Section - Demonstrates reactive UI with animation
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: _showDetails ? null : 0,
            overflow: Overflow.hidden,
            child: _showDetails
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDetailRow('Name:', 'Alex Johnson'),
                      _buildDetailRow('Specialization:', 'Mobile Development'),
                      _buildDetailRow('Rating:', '4.9/5 ⭐'),
                      _buildDetailRow('Tasks Completed:', '47'),
                      _buildDetailRow('Total Earnings:', '\$12,450'),
                    ],
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  /// Helper widget for profile detail rows
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: RetroSpacing.sm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: RetroTypography.retroBody.copyWith(
              fontWeight: FontWeight.bold,
              color: _isDarkMode ? RetroColors.neonCyan : RetroColors.retroBlack,
            ),
          ),
          Text(
            value,
            style: RetroTypography.retroBody.copyWith(
              color: _isDarkMode ? RetroColors.retroWhite : RetroColors.neonPurple,
            ),
          ),
        ],
      ),
    );
  }

  /// Theme Switcher Card - Demonstrates dynamic theming via state
  /// Widget Tree:
  /// RetroCard
  ///  ├─ Row
  ///  │  ├─ Text
  ///  │  └─ Switch
  ///  └─ AnimatedContainer
  ///     └─ Text
  Widget _buildThemeSwitcherCard(ResponsiveHelper responsive) {
    return Container(
      padding: EdgeInsets.all(RetroSpacing.md),
      decoration: BoxDecoration(
        border: Border.all(
          color: _isDarkMode ? RetroColors.neonGreen : RetroColors.neonPink,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(RetroBorderRadius.md),
        boxShadow: [RetroEffects.deepShadow],
        color: _isDarkMode ? RetroColors.retroDarkGray : Colors.white,
      ),
      child: Column(
        children: [
          // Theme Toggle Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _isDarkMode ? '🌙 Dark Mode' : '☀️ Light Mode',
                style: RetroTypography.retroHeadline.copyWith(
                  fontSize: 18,
                  color: _isDarkMode ? RetroColors.neonGreen : RetroColors.neonPink,
                ),
              ),
              Transform.scale(
                scale: 1.3,
                child: Switch(
                  value: _isDarkMode,
                  onChanged: (value) => _toggleTheme(),
                  activeColor: RetroColors.neonGreen,
                  inactiveThumbColor: RetroColors.neonPink,
                  inactiveTrackColor: RetroColors.retroGray.withOpacity(0.3),
                ),
              ),
            ],
          ),

          SizedBox(height: RetroSpacing.sm),

          // Info Text
          AnimatedOpacity(
            opacity: 1.0,
            duration: const Duration(milliseconds: 300),
            child: Text(
              _isDarkMode
                  ? 'Dark mode reduces eye strain and looks cool 😎'
                  : 'Light mode provides clear visibility 👀',
              style: RetroTypography.retroBody.copyWith(
                color: _isDarkMode ? RetroColors.retroWhite : RetroColors.retroBlack,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Counter Card - Interactive counter demonstrating reactive state updates
  /// Widget Tree:
  /// RetroCard
  ///  ├─ Text (Title)
  ///  ├─ Container
  ///  │  └─ Text (Count)
  ///  └─ Row
  ///     ├─ ElevatedButton
  ///     └─ ElevatedButton
  Widget _buildCounterCard(ResponsiveHelper responsive) {
    return Container(
      padding: EdgeInsets.all(RetroSpacing.md),
      decoration: BoxDecoration(
        border: Border.all(
          color: _isDarkMode ? RetroColors.neonOrange : RetroColors.neonCyan,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(RetroBorderRadius.md),
        boxShadow: [RetroEffects.deepShadow],
        color: _isDarkMode ? RetroColors.retroDarkGray : Colors.white,
      ),
      child: Column(
        children: [
          Text(
            'Interactive Counter',
            style: RetroTypography.retroHeadline.copyWith(
              color: _isDarkMode ? RetroColors.neonOrange : RetroColors.neonCyan,
            ),
          ),

          SizedBox(height: RetroSpacing.lg),

          // Counter Display
          Container(
            padding: EdgeInsets.all(RetroSpacing.lg),
            decoration: BoxDecoration(
              border: Border.all(
                color: _isDarkMode ? RetroColors.neonOrange : RetroColors.neonCyan,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(RetroBorderRadius.sm),
              color: _isDarkMode 
                  ? RetroColors.retroBlack.withOpacity(0.5)
                  : RetroColors.retroWhite.withOpacity(0.5),
            ),
            child: Text(
              '$_counter',
              style: RetroTypography.retroDisplayLarge.copyWith(
                fontSize: 64,
                color: _isDarkMode ? RetroColors.neonOrange : RetroColors.neonCyan,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          SizedBox(height: RetroSpacing.md),

          // Button Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Decrement Button
              ElevatedButton.icon(
                onPressed: _decrementCounter,
                icon: const Icon(Icons.remove),
                label: const Text('Decrease'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isDarkMode ? RetroColors.neonPink : RetroColors.neonPink,
                  foregroundColor: Colors.white,
                  elevation: 8,
                ),
              ),

              // Reset Button
              ElevatedButton.icon(
                onPressed: () => setState(() => _counter = 0),
                icon: const Icon(Icons.refresh),
                label: const Text('Reset'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isDarkMode ? RetroColors.retroGray : RetroColors.retroGray,
                  foregroundColor: Colors.white,
                  elevation: 8,
                ),
              ),

              // Increment Button
              ElevatedButton.icon(
                onPressed: _incrementCounter,
                icon: const Icon(Icons.add),
                label: const Text('Increase'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isDarkMode ? RetroColors.neonGreen : RetroColors.neonGreen,
                  foregroundColor: Colors.white,
                  elevation: 8,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Widget Tree Information Card - Educational content
  Widget _buildWidgetTreeInfo(ResponsiveHelper responsive) {
    return Container(
      padding: EdgeInsets.all(RetroSpacing.md),
      decoration: BoxDecoration(
        border: Border.all(
          color: _isDarkMode ? RetroColors.neonCyan : RetroColors.neonPurple,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(RetroBorderRadius.md),
        color: _isDarkMode 
            ? RetroColors.retroBlack.withOpacity(0.3)
            : RetroColors.retroWhite.withOpacity(0.3),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '🌳 Widget Tree Concept',
            style: RetroTypography.retroHeadline.copyWith(
              color: _isDarkMode ? RetroColors.neonCyan : RetroColors.neonPurple,
            ),
          ),
          SizedBox(height: RetroSpacing.md),
          _buildInfoBullet('Every UI element is a widget'),
          _buildInfoBullet('Widgets form a hierarchical tree'),
          _buildInfoBullet('setState() triggers UI rebuild'),
          _buildInfoBullet('Only affected widgets are re-rendered'),
          _buildInfoBullet('Reactive model = automatic updates'),
        ],
      ),
    );
  }

  /// Helper widget for info bullets
  Widget _buildInfoBullet(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: RetroSpacing.xs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '• ',
            style: RetroTypography.retroBody.copyWith(
              color: _isDarkMode ? RetroColors.neonCyan : RetroColors.neonPurple,
              fontSize: 20,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: RetroTypography.retroBody.copyWith(
                color: _isDarkMode ? RetroColors.retroWhite : RetroColors.retroBlack,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
