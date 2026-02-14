import 'package:flutter/material.dart';
import '../constants/retro_theme.dart';
import '../utils/responsive_helper.dart';

/// Development Tools & Debugging Demo Screen
/// 
/// Demonstrates:
/// 1. Hot Reload - Instant UI updates without app restart
/// 2. Debug Console - Logging and error tracking
/// 3. Flutter DevTools - Widget inspector, performance, memory monitoring
/// 4. Integrated workflow - Combining all tools effectively
class DevToolsDemoScreen extends StatefulWidget {
  const DevToolsDemoScreen({Key? key}) : super(key: key);

  @override
  State<DevToolsDemoScreen> createState() => _DevToolsDemoState();
}

class _DevToolsDemoState extends State<DevToolsDemoScreen> {
  // State variables for demonstrating Hot Reload
  String _messageText = 'Hot Reload Test Message';
  Color _bgColor = RetroColors.retroBlue;
  int _clickCount = 0;
  double _containerSize = 100;
  bool _showDetailedInfo = false;

  // Performance monitoring
  int _buildCount = 0;
  DateTime _startTime = DateTime.now();
  List<String> _logHistory = [];

  @override
  void initState() {
    super.initState();
    _logEvent('App initialized', 'initState() called');
    debugPrint('🔧 DevTools Demo Screen - initState()');
  }

  /// Log event helper with structured formatting
  void _logEvent(String event, String description) {
    final timestamp = DateTime.now().toString().split('.')[0];
    final logEntry = '[$timestamp] $event: $description';
    
    setState(() {
      _logHistory.insert(0, logEntry);
      if (_logHistory.length > 15) {
        _logHistory.removeLast();
      }
    });

    debugPrint('📝 [${event.toUpperCase()}] $description');
  }

  /// Hot Reload Test 1: Change message
  void _changeMessage() {
    setState(() {
      _clickCount++;
      _messageText = 'Message Updated ${_clickCount}x!';
    });
    _logEvent('Message Changed', 'Count: $_clickCount');
    debugPrint('💬 Message changed to: $_messageText');
  }

  /// Hot Reload Test 2: Change colors
  void _changeColor() {
    final colors = [
      RetroColors.retroBlue,
      RetroColors.retroGreen,
      RetroColors.retroYellow,
      RetroColors.retroRed,
      Colors.purple,
      Colors.orange,
    ];
    
    setState(() {
      _bgColor = colors[_clickCount % colors.length];
    });
    _logEvent('Color Changed', 'New color index: ${_clickCount % colors.length}');
    debugPrint('🎨 Color changed to: $_bgColor');
  }

  /// Hot Reload Test 3: Resize container
  void _resizeContainer() {
    setState(() {
      _containerSize = _containerSize == 100 ? 200 : 100;
    });
    _logEvent('Size Changed', 'New size: $_containerSize');
    debugPrint('📐 Container resized to: $_containerSize');
  }

  @override
  Widget build(BuildContext context) {
    _buildCount++;
    final responsive = context.responsive;

    debugPrint('🏗️ Build #$_buildCount - Total elapsed: ${DateTime.now().difference(_startTime).inSeconds}s');

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('DevTools & Debugging Demo'),
        backgroundColor: RetroColors.retroBlue,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(responsive.paddingMedium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Hot Reload Demo Section
              _buildHotReloadDemo(context, responsive),
              SizedBox(height: responsive.spacingLarge),

              // 2. Debug Console Demo Section
              _buildDebugConsoleDemo(context, responsive),
              SizedBox(height: responsive.spacingLarge),

              // 3. DevTools Guide Section
              _buildDevToolsGuide(context, responsive),
              SizedBox(height: responsive.spacingLarge),

              // 4. Performance Monitor
              _buildPerformanceMonitor(context, responsive),
              SizedBox(height: responsive.spacingLarge),

              // 5. Log History Viewer
              _buildLogHistory(context, responsive),
            ],
          ),
        ),
      ),
    );
  }

  /// 1. HOT RELOAD DEMO
  Widget _buildHotReloadDemo(BuildContext context, ResponsiveHelper responsive) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue[50],
        border: Border.all(color: RetroColors.retroBlue, width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: EdgeInsets.all(responsive.paddingMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            '⚡ Hot Reload Demo',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: RetroColors.retroBlue,
                  fontWeight: FontWeight.bold,
                ),
          ),
          SizedBox(height: responsive.spacingMedium),

          // Explanation
          Container(
            decoration: BoxDecoration(
              color: Colors.blue[100],
              borderRadius: BorderRadius.circular(8),
            ),
            padding: EdgeInsets.all(responsive.paddingSmall),
            child: Text(
              'Hot Reload allows you to instantly apply code changes without restarting the app. '
              'Try changing widget properties (colors, text, sizes) in the code and see updates in milliseconds!',
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 13,
                height: 1.5,
              ),
            ),
          ),
          SizedBox(height: responsive.spacingMedium),

          // Test 1: Message Changes
          Text(
            'Test 1: Message Changes (Modify _messageText in code)',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
              color: Colors.grey[700],
            ),
          ),
          SizedBox(height: responsive.spacingSmall),
          Container(
            decoration: BoxDecoration(
              color: _bgColor.withOpacity(0.2),
              border: Border.all(color: _bgColor),
              borderRadius: BorderRadius.circular(8),
            ),
            padding: EdgeInsets.all(responsive.paddingMedium),
            child: Column(
              children: [
                Text(
                  _messageText,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: responsive.spacingSmall),
                ElevatedButton.icon(
                  onPressed: _changeMessage,
                  icon: const Icon(Icons.edit),
                  label: const Text('Update Message'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: RetroColors.retroBlue,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: responsive.spacingMedium),

          // Test 2: Color Changes
          Text(
            'Test 2: Color Changes (Modify _bgColor in code)',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
              color: Colors.grey[700],
            ),
          ),
          SizedBox(height: responsive.spacingSmall),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                // Current color display
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: _bgColor,
                    border: Border.all(color: Colors.black, width: 2),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [RetroEffects.deepShadow],
                  ),
                  child: Center(
                    child: Text(
                      'Current\nColor',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                SizedBox(width: responsive.spacingMedium),
                // Change button
                ElevatedButton.icon(
                  onPressed: _changeColor,
                  icon: const Icon(Icons.palette),
                  label: const Text('Change Color'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: RetroColors.retroGreen,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: responsive.spacingMedium),

          // Test 3: Size Changes
          Text(
            'Test 3: Size Changes (Modify _containerSize in code)',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
              color: Colors.grey[700],
            ),
          ),
          SizedBox(height: responsive.spacingSmall),
          Center(
            child: Column(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: _containerSize,
                  height: _containerSize,
                  decoration: BoxDecoration(
                    color: RetroColors.retroGreen,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [RetroEffects.deepShadow],
                  ),
                  child: Center(
                    child: Text(
                      '${_containerSize.toInt()}x${_containerSize.toInt()}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: responsive.spacingMedium),
                ElevatedButton.icon(
                  onPressed: _resizeContainer,
                  icon: const Icon(Icons.zoom_in),
                  label: const Text('Toggle Size'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: RetroColors.retroGreen,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: responsive.spacingMedium),
          Container(
            decoration: BoxDecoration(
              color: Colors.green[100],
              borderRadius: BorderRadius.circular(8),
            ),
            padding: EdgeInsets.all(responsive.paddingSmall),
            child: const Row(
              children: [
                Icon(Icons.lightbulb, color: Colors.green),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Press r in terminal to Hot Reload • Changes apply instantly',
                    style: TextStyle(color: Colors.green, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 2. DEBUG CONSOLE DEMO
  Widget _buildDebugConsoleDemo(BuildContext context, ResponsiveHelper responsive) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[900],
        border: Border.all(color: Colors.green, width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: EdgeInsets.all(responsive.paddingMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Row(
            children: [
              Text(
                '📋 Debug Console Demo',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const Spacer(),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: responsive.paddingSmall,
                  vertical: responsive.spacingSmall,
                ),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'real-time logs',
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: responsive.spacingMedium),

          // Explanation
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[800],
              borderRadius: BorderRadius.circular(8),
            ),
            padding: EdgeInsets.all(responsive.paddingSmall),
            child: const Text(
              'Use debugPrint() to log messages visible in Debug Console. '
              'The console helps track widget rebuilds, user interactions, and errors.',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12,
                height: 1.5,
              ),
            ),
          ),
          SizedBox(height: responsive.spacingMedium),

          // Debug Console View
          Container(
            decoration: BoxDecoration(
              color: Colors.black,
              border: Border.all(color: Colors.green, width: 1),
              borderRadius: BorderRadius.circular(8),
            ),
            padding: EdgeInsets.all(responsive.paddingSmall),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Console header
                Text(
                  '>>> Flutter Debug Console',
                  style: TextStyle(
                    color: Colors.green[400],
                    fontFamily: 'Courier',
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: responsive.spacingSmall),

                // Recent logs preview
                ..._logHistory.take(5).map((log) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: responsive.spacingSmall),
                    child: Text(
                      log,
                      style: const TextStyle(
                        color: Color(0xFF39FF14),
                        fontFamily: 'Courier',
                        fontSize: 10,
                      ),
                    ),
                  );
                }),

                if (_logHistory.isEmpty)
                  Text(
                    'Waiting for events...',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontFamily: 'Courier',
                      fontSize: 10,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(height: responsive.spacingMedium),

          // Logging examples
          Text(
            'Common Logging Patterns:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 12,
            ),
          ),
          SizedBox(height: responsive.spacingSmall),
          _buildCodeExample(
            'debugPrint("Message"); // Simple message',
            Colors.grey[800]!,
            responsive,
          ),
          _buildCodeExample(
            'debugPrint("Count: \$count"); // Variable values',
            Colors.grey[800]!,
            responsive,
          ),
          _buildCodeExample(
            'debugPrint("Error: \${e.toString()}"); // Errors',
            Colors.grey[800]!,
            responsive,
          ),

          SizedBox(height: responsive.spacingMedium),
          Container(
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            padding: EdgeInsets.all(responsive.paddingSmall),
            child: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green, size: 20),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Open View → Debug Console in VS Code to see live logs',
                    style: TextStyle(color: Colors.green, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 3. DEVTOOLS GUIDE
  Widget _buildDevToolsGuide(BuildContext context, ResponsiveHelper responsive) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.amber[50],
        border: Border.all(color: RetroColors.retroYellow, width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: EdgeInsets.all(responsive.paddingMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '🔍 Flutter DevTools Guide',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: RetroColors.retroYellow,
                  fontWeight: FontWeight.bold,
                ),
          ),
          SizedBox(height: responsive.spacingMedium),

          // Launch instructions
          Container(
            decoration: BoxDecoration(
              color: Colors.amber[100],
              borderRadius: BorderRadius.circular(8),
            ),
            padding: EdgeInsets.all(responsive.paddingSmall),
            child: const Text(
              'Launch DevTools with: flutter pub global run devtools',
              style: TextStyle(
                color: Colors.black87,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(height: responsive.spacingMedium),

          // DevTools tabs
          ..._buildDevToolsTabs(context, responsive),

          SizedBox(height: responsive.spacingMedium),
          Container(
            decoration: BoxDecoration(
              color: Colors.orange[100],
              borderRadius: BorderRadius.circular(8),
            ),
            padding: EdgeInsets.all(responsive.paddingSmall),
            child: const Row(
              children: [
                Icon(Icons.lightbulb, color: Colors.orange),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'DevTools is invaluable for debugging complex widget hierarchies',
                    style: TextStyle(color: Colors.orange, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// DevTools tabs explanation
  List<Widget> _buildDevToolsTabs(BuildContext context, ResponsiveHelper responsive) {
    final tabs = [
      {
        'icon': '📊',
        'name': 'Widget Inspector',
        'desc': 'Visualize widget tree hierarchy • Select widgets on screen • View properties',
      },
      {
        'icon': '⚙️',
        'name': 'Performance',
        'desc': 'Monitor frame rendering • Detect jank/lag • Profile CPU usage',
      },
      {
        'icon': '💾',
        'name': 'Memory',
        'desc': 'Track memory usage • Identify leaks • Monitor allocations',
      },
      {
        'icon': '🌐',
        'name': 'Network',
        'desc': 'View HTTP requests • Monitor API calls • Debug Firebase',
      },
      {
        'icon': '🖥️',
        'name': 'Console',
        'desc': 'View logs and errors • Execute Dart code • Debug expressions',
      },
    ];

    return tabs.map((tab) {
      return Padding(
        padding: EdgeInsets.only(bottom: responsive.spacingMedium),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(8),
          ),
          padding: EdgeInsets.all(responsive.paddingSmall),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    tab['icon']!,
                    style: const TextStyle(fontSize: 18),
                  ),
                  SizedBox(width: responsive.spacingSmall),
                  Text(
                    tab['name']!,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
              SizedBox(height: responsive.spacingSmall),
              Text(
                tab['desc']!,
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      );
    }).toList();
  }

  /// 4. PERFORMANCE MONITOR
  Widget _buildPerformanceMonitor(BuildContext context, ResponsiveHelper responsive) {
    final elapsed = DateTime.now().difference(_startTime);
    final elapsedSeconds = elapsed.inSeconds;
    final elapsedMs = elapsed.inMilliseconds;

    return Container(
      decoration: BoxDecoration(
        color: Colors.purple[50],
        border: Border.all(color: Colors.purple, width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: EdgeInsets.all(responsive.paddingMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '📈 Performance Monitor',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.purple,
                  fontWeight: FontWeight.bold,
                ),
          ),
          SizedBox(height: responsive.spacingMedium),

          // Metrics grid
          GridView.count(
            crossAxisCount: responsive.isMobile ? 2 : 3,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 1.5,
            children: [
              _buildMetricCard(
                'Total Builds',
                _buildCount.toString(),
                Colors.blue,
                responsive,
              ),
              _buildMetricCard(
                'Elapsed Time',
                elapsedSeconds < 60
                    ? '${elapsedSeconds}s'
                    : '${(elapsedSeconds / 60).toStringAsFixed(1)}m',
                Colors.green,
                responsive,
              ),
              _buildMetricCard(
                'Total ms',
                '${elapsedMs}ms',
                Colors.orange,
                responsive,
              ),
              _buildMetricCard(
                'Avg Build Time',
                '${(elapsedMs / _buildCount).toStringAsFixed(2)}ms',
                Colors.red,
                responsive,
              ),
              _buildMetricCard(
                'Click Count',
                _clickCount.toString(),
                Colors.purple,
                responsive,
              ),
              _buildMetricCard(
                'Log Events',
                _logHistory.length.toString(),
                Colors.teal,
                responsive,
              ),
            ],
          ),

          SizedBox(height: responsive.spacingMedium),
          Container(
            decoration: BoxDecoration(
              color: Colors.blue[100],
              borderRadius: BorderRadius.circular(8),
            ),
            padding: EdgeInsets.all(responsive.paddingSmall),
            child: const Row(
              children: [
                Icon(Icons.info, color: Colors.blue),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Use DevTools Performance tab to see frame graphs and GPU/CPU usage',
                    style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Metric card helper
  Widget _buildMetricCard(
    String label,
    String value,
    Color color,
    ResponsiveHelper responsive,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        border: Border.all(color: color),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: EdgeInsets.all(responsive.paddingSmall),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: color,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: responsive.spacingSmall),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  /// 5. LOG HISTORY VIEWER
  Widget _buildLogHistory(BuildContext context, ResponsiveHelper responsive) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        border: Border.all(color: Colors.grey[400]!, width: 1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            padding: EdgeInsets.all(responsive.paddingSmall),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '📜 Event Log History',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                Text(
                  '${_logHistory.length} events',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Container(
            constraints: BoxConstraints(
              maxHeight: responsive.isMobile ? 250 : 350,
            ),
            child: ListView.separated(
              padding: EdgeInsets.all(responsive.paddingSmall),
              itemCount: _logHistory.length,
              separatorBuilder: (context, index) => Divider(
                color: Colors.grey[300],
                height: 1,
              ),
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: responsive.spacingSmall),
                  child: Text(
                    _logHistory[index],
                    style: TextStyle(
                      fontSize: 11,
                      fontFamily: 'Courier',
                      color: Colors.grey[700],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  /// Code example helper
  Widget _buildCodeExample(String code, Color bgColor, ResponsiveHelper responsive) {
    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
      ),
      padding: EdgeInsets.all(responsive.paddingSmall),
      margin: EdgeInsets.only(bottom: responsive.spacingSmall),
      child: Text(
        code,
        style: const TextStyle(
          color: Color(0xFF39FF14),
          fontFamily: 'Courier',
          fontSize: 10,
        ),
      ),
    );
  }
}
