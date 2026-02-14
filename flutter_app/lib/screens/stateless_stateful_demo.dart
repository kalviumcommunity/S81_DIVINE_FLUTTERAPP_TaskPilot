import 'package:flutter/material.dart';
import '../constants/retro_theme.dart';
import '../utils/responsive_helper.dart';

/// Main Demo Screen for Stateless vs Stateful Widgets
/// 
/// This screen demonstrates the two fundamental widget types in Flutter:
/// - StatelessWidget: Static content with no internal state
/// - StatefulWidget: Dynamic content that changes based on internal state
class StatelessStatefulDemoScreen extends StatefulWidget {
  const StatelessStatefulDemoScreen({Key? key}) : super(key: key);

  @override
  State<StatelessStatefulDemoScreen> createState() =>
      _StatelessStatefulDemoState();
}

class _StatelessStatefulDemoState extends State<StatelessStatefulDemoScreen> {
  // State variables for the parent StatefulWidget
  int _counter = 0;
  bool _isDarkTheme = false;
  bool _showCode = false;

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return Scaffold(
      backgroundColor: _isDarkTheme ? Colors.grey[900] : Colors.white,
      appBar: AppBar(
        title: const Text('Stateless vs Stateful Widgets'),
        backgroundColor: RetroColors.retroBlue,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(responsive.paddingMedium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. StatelessWidget Demo
              _buildStatelessDemo(context, responsive),
              SizedBox(height: responsive.spacingLarge),

              // 2. StatefulWidget Demo
              _buildStatefulDemo(context, responsive),
              SizedBox(height: responsive.spacingLarge),

              // 3. Comparison Section
              _buildComparisonChart(context, responsive),
              SizedBox(height: responsive.spacingLarge),

              // 4. When to Use Each
              _buildUsageGuide(context, responsive),
            ],
          ),
        ),
      ),
    );
  }

  /// 1. STATELESS WIDGET DEMO
  /// Shows a reusable component that never changes internally
  Widget _buildStatelessDemo(BuildContext context, ResponsiveHelper responsive) {
    return Container(
      decoration: BoxDecoration(
        color: _isDarkTheme ? Colors.grey[800] : Colors.blue[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: RetroColors.retroBlue, width: 2),
      ),
      padding: EdgeInsets.all(responsive.paddingMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            '📌 StatelessWidget Demo',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: RetroColors.retroBlue,
                  fontWeight: FontWeight.bold,
                ),
          ),
          SizedBox(height: responsive.spacingMedium),

          // Explanation
          Container(
            decoration: BoxDecoration(
              color: _isDarkTheme ? Colors.grey[700] : Colors.blue[100],
              borderRadius: BorderRadius.circular(8),
            ),
            padding: EdgeInsets.all(responsive.paddingSmall),
            child: Text(
              'A StatelessWidget has no internal state. It\'s immutable and displays '
              'static content. Perfect for reusable UI components like headers, cards, '
              'and buttons that don\'t need to change.',
              style: TextStyle(
                color: _isDarkTheme ? Colors.white : Colors.black87,
                fontSize: 13,
                height: 1.5,
              ),
            ),
          ),
          SizedBox(height: responsive.spacingMedium),

          // Multiple instances of the same StatelessWidget
          Text(
            'Multiple Instances (all static, no internal changes):',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: _isDarkTheme ? Colors.white : Colors.black,
            ),
          ),
          SizedBox(height: responsive.spacingSmall),

          // Instance 1
          StaticInfoCard(
            title: 'Profile Card 1',
            description: 'User: Alice',
            isDark: _isDarkTheme,
          ),
          SizedBox(height: responsive.spacingSmall),

          // Instance 2
          StaticInfoCard(
            title: 'Profile Card 2',
            description: 'User: Bob',
            isDark: _isDarkTheme,
          ),
          SizedBox(height: responsive.spacingSmall),

          // Instance 3
          StaticInfoCard(
            title: 'Profile Card 3',
            description: 'User: Charlie',
            isDark: _isDarkTheme,
          ),

          SizedBox(height: responsive.spacingMedium),

          // Code Example
          _buildCodeBlock(
            context,
            'Stateless Widget Example',
            '''class GreetingWidget extends StatelessWidget {
  final String name;

  const GreetingWidget({required this.name});

  @override
  Widget build(BuildContext context) {
    return Text('Hello, \$name!');
  }
}''',
            responsive,
          ),

          SizedBox(height: responsive.spacingMedium),

          Container(
            decoration: BoxDecoration(
              color: Colors.green[100],
              borderRadius: BorderRadius.circular(8),
            ),
            padding: EdgeInsets.all(responsive.paddingSmall),
            child: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green),
                SizedBox(width: responsive.spacingSmall),
                Expanded(
                  child: Text(
                    'No setState() call needed • Immutable • Lightweight',
                    style: TextStyle(color: Colors.green[900]),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 2. STATEFUL WIDGET DEMO
  /// Shows an interactive component that changes based on user input
  Widget _buildStatefulDemo(BuildContext context, ResponsiveHelper responsive) {
    return Container(
      decoration: BoxDecoration(
        color: _isDarkTheme ? Colors.grey[800] : Colors.green[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: RetroColors.retroGreen, width: 2),
      ),
      padding: EdgeInsets.all(responsive.paddingMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            '⚡ StatefulWidget Demo',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: RetroColors.retroGreen,
                  fontWeight: FontWeight.bold,
                ),
          ),
          SizedBox(height: responsive.spacingMedium),

          // Explanation
          Container(
            decoration: BoxDecoration(
              color: _isDarkTheme ? Colors.grey[700] : Colors.green[100],
              borderRadius: BorderRadius.circular(8),
            ),
            padding: EdgeInsets.all(responsive.paddingSmall),
            child: Text(
              'A StatefulWidget maintains internal state that can change. It rebuilds '
              'whenever setState() is called. Essential for interactive components like '
              'forms, counters, toggles, and animations.',
              style: TextStyle(
                color: _isDarkTheme ? Colors.white : Colors.black87,
                fontSize: 13,
                height: 1.5,
              ),
            ),
          ),
          SizedBox(height: responsive.spacingMedium),

          // Demo 1: Counter
          _buildCounterDemoSection(context, responsive),
          SizedBox(height: responsive.spacingMedium),

          // Demo 2: Toggle/Switch
          _buildThemeToggleSection(context, responsive),
          SizedBox(height: responsive.spacingMedium),

          // Code Example
          _buildCodeBlock(
            context,
            'Stateful Widget Example',
            '''class CounterWidget extends StatefulWidget {
  @override
  _CounterWidgetState createState() => _CounterWidgetState();
}

class _CounterWidgetState extends State<CounterWidget> {
  int count = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Count: \$count'),
        ElevatedButton(
          onPressed: () {
            setState(() {
              count++;
            });
          },
          child: Text('Increment'),
        ),
      ],
    );
  }
}''',
            responsive,
          ),

          SizedBox(height: responsive.spacingMedium),

          Container(
            decoration: BoxDecoration(
              color: Colors.green[100],
              borderRadius: BorderRadius.circular(8),
            ),
            padding: EdgeInsets.all(responsive.paddingSmall),
            child: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green),
                SizedBox(width: responsive.spacingSmall),
                Expanded(
                  child: Text(
                    'Uses setState() • Mutable • Dynamic UI updates',
                    style: TextStyle(color: Colors.green[900]),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Counter Demo Section
  Widget _buildCounterDemoSection(
    BuildContext context,
    ResponsiveHelper responsive,
  ) {
    return Card(
      color: _isDarkTheme ? Colors.grey[700] : Colors.white,
      child: Padding(
        padding: EdgeInsets.all(responsive.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Interactive Counter (State Example)',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: _isDarkTheme ? Colors.white : Colors.black,
              ),
            ),
            SizedBox(height: responsive.spacingMedium),
            Center(
              child: Container(
                decoration: BoxDecoration(
                  color: RetroColors.retroGreen,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [RetroEffects.deepShadow],
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
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: responsive.spacingSmall),
                    Text(
                      '$_counter',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: responsive.spacingMedium),
            // Controls
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        if (_counter > 0) _counter--;
                      });
                    },
                    icon: const Icon(Icons.remove),
                    label: const Text('−'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                  ),
                  SizedBox(width: responsive.spacingSmall),
                  ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        _counter = 0;
                      });
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Reset'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                    ),
                  ),
                  SizedBox(width: responsive.spacingSmall),
                  ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        _counter++;
                      });
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('+'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: responsive.spacingSmall),
            Text(
              'Each button tap calls setState(), triggering rebuild with new count.',
              style: TextStyle(
                fontSize: 12,
                fontStyle: FontStyle.italic,
                color: _isDarkTheme ? Colors.grey[300] : Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Theme Toggle Section
  Widget _buildThemeToggleSection(
    BuildContext context,
    ResponsiveHelper responsive,
  ) {
    return Card(
      color: _isDarkTheme ? Colors.grey[700] : Colors.white,
      child: Padding(
        padding: EdgeInsets.all(responsive.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Theme Toggle (Multiple State Variables)',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: _isDarkTheme ? Colors.white : Colors.black,
              ),
            ),
            SizedBox(height: responsive.spacingMedium),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.light_mode,
                  color: RetroColors.retroYellow,
                  size: 32,
                ),
                SizedBox(width: responsive.spacingMedium),
                Switch(
                  value: _isDarkTheme,
                  onChanged: (value) {
                    setState(() {
                      _isDarkTheme = value;
                    });
                  },
                  activeColor: RetroColors.retroRed,
                ),
                SizedBox(width: responsive.spacingMedium),
                Icon(
                  Icons.dark_mode,
                  color: Colors.grey,
                  size: 32,
                ),
              ],
            ),
            SizedBox(height: responsive.spacingMedium),
            Container(
              decoration: BoxDecoration(
                color: _isDarkTheme
                    ? Colors.grey[900]
                    : Colors.blue[100],
                borderRadius: BorderRadius.circular(8),
              ),
              padding: EdgeInsets.all(responsive.paddingSmall),
              child: Text(
                _isDarkTheme
                    ? '🌙 Dark Mode Active - Theme state is true'
                    : '☀️ Light Mode Active - Theme state is false',
                style: TextStyle(
                  color: _isDarkTheme ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 3. COMPARISON CHART
  Widget _buildComparisonChart(BuildContext context, ResponsiveHelper responsive) {
    return Container(
      decoration: BoxDecoration(
        color: _isDarkTheme ? Colors.grey[800] : Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey, width: 1),
      ),
      padding: EdgeInsets.all(responsive.paddingMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '📊 Comparison Chart',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: _isDarkTheme ? Colors.white : Colors.black,
                ),
          ),
          SizedBox(height: responsive.spacingMedium),
          _buildComparisonRow(
            'Has Internal State',
            '❌ No',
            '✅ Yes',
            responsive,
          ),
          _buildComparisonRow(
            'Immutable',
            '✅ Yes',
            '❌ No',
            responsive,
          ),
          _buildComparisonRow(
            'Uses setState()',
            '❌ No',
            '✅ Yes',
            responsive,
          ),
          _buildComparisonRow(
            'Rebuilds on User Interaction',
            '❌ No',
            '✅ Yes',
            responsive,
          ),
          _buildComparisonRow(
            'Light & Efficient',
            '✅ Yes',
            '⚠️ Depends',
            responsive,
          ),
          _buildComparisonRow(
            'Best For Static Content',
            '✅ Yes',
            '❌ No',
            responsive,
          ),
          _buildComparisonRow(
            'Best For Interactive Content',
            '❌ No',
            '✅ Yes',
            responsive,
          ),
        ],
      ),
    );
  }

  /// Single row in comparison chart
  Widget _buildComparisonRow(
    String property,
    String stateless,
    String stateful,
    ResponsiveHelper responsive,
  ) {
    return Padding(
      padding: EdgeInsets.only(bottom: responsive.spacingSmall),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              property,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: _isDarkTheme ? Colors.white : Colors.black,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: responsive.paddingSmall,
                vertical: responsive.spacingSmall,
              ),
              decoration: BoxDecoration(
                color: Colors.blue[100],
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                stateless,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          SizedBox(width: responsive.spacingSmall),
          Expanded(
            flex: 1,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: responsive.paddingSmall,
                vertical: responsive.spacingSmall,
              ),
              decoration: BoxDecoration(
                color: Colors.green[100],
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                stateful,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 4. USAGE GUIDE
  Widget _buildUsageGuide(BuildContext context, ResponsiveHelper responsive) {
    return Container(
      decoration: BoxDecoration(
        color: _isDarkTheme ? Colors.grey[800] : Colors.amber[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: RetroColors.retroYellow, width: 2),
      ),
      padding: EdgeInsets.all(responsive.paddingMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '🎯 When to Use Each Type',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: RetroColors.retroYellow,
                  fontWeight: FontWeight.bold,
                ),
          ),
          SizedBox(height: responsive.spacingMedium),
          _buildUsageItem(
            'StatelessWidget',
            'Use when:',
            [
              '• Displaying static content (text, images, icons)',
              '• Building reusable UI components',
              '• No user interaction needed',
              '• Content doesn\'t change during app lifecycle',
              '• Want optimal performance & memory usage',
            ],
            Colors.blue,
            responsive,
          ),
          SizedBox(height: responsive.spacingMedium),
          _buildUsageItem(
            'StatefulWidget',
            'Use when:',
            [
              '• Handling user interactions (taps, form input)',
              '• Managing data that changes over time',
              '• Showing animations or transitions',
              '• Needing to update UI based on events',
              '• Building interactive features (forms, counters)',
            ],
            Colors.green,
            responsive,
          ),
          SizedBox(height: responsive.spacingMedium),
          Container(
            decoration: BoxDecoration(
              color: _isDarkTheme ? Colors.grey[700] : Colors.orange[100],
              borderRadius: BorderRadius.circular(8),
            ),
            padding: EdgeInsets.all(responsive.paddingSmall),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '💡 Pro Tip: Widget Composition',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: _isDarkTheme ? Colors.white : Colors.orange[900],
                  ),
                ),
                SizedBox(height: responsive.spacingSmall),
                Text(
                  'Combine both! Use StatelessWidgets for UI components, '
                  'and StatefulWidgets as containers that manage state. '
                  'This creates clean, reusable, and performant applications.',
                  style: TextStyle(
                    color: _isDarkTheme ? Colors.white : Colors.black87,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Helper widget for usage items
  Widget _buildUsageItem(
    String title,
    String subtitle,
    List<String> points,
    Color color,
    ResponsiveHelper responsive,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        border: Border.all(color: color, width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: EdgeInsets.all(responsive.paddingSmall),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: color,
            ),
          ),
          Text(
            subtitle,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 12,
              color: _isDarkTheme ? Colors.white70 : Colors.black54,
            ),
          ),
          SizedBox(height: responsive.spacingSmall),
          ...points.map((point) => Padding(
            padding: EdgeInsets.only(bottom: responsive.spacingSmall),
            child: Text(
              point,
              style: TextStyle(
                fontSize: 12,
                color: _isDarkTheme ? Colors.white : Colors.black87,
              ),
            ),
          )),
        ],
      ),
    );
  }

  /// Code block builder
  Widget _buildCodeBlock(
    BuildContext context,
    String title,
    String code,
    ResponsiveHelper responsive,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: Colors.black,
            padding: EdgeInsets.all(responsive.paddingSmall),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                Text(
                  'Dart',
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: EdgeInsets.all(responsive.paddingSmall),
              child: Text(
                code,
                style: const TextStyle(
                  color: Color(0xFF39FF14),
                  fontFamily: 'Courier',
                  fontSize: 11,
                  height: 1.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// STATELESS WIDGET EXAMPLE
/// Reusable static component that never changes internally
class StaticInfoCard extends StatelessWidget {
  final String title;
  final String description;
  final bool isDark;

  const StaticInfoCard({
    required this.title,
    required this.description,
    required this.isDark,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[700] : Colors.white,
        border: Border.all(
          color: isDark ? Colors.grey[600]! : Colors.grey[300]!,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: RetroColors.retroBlue,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                title[0],
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
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
