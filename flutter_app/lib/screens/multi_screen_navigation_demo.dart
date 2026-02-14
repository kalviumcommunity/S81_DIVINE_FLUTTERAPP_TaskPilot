import 'package:flutter/material.dart';
import '../constants/retro_theme.dart';
import '../utils/responsive_helper.dart';

/// Multi-Screen Navigation Demo
///
/// Demonstrates:
/// 1. Navigator.pushNamed() - Navigate to named routes
/// 2. Navigator.pop() - Return to previous screen
/// 3. Data passing with arguments - Pass data between screens
/// 4. Pop with return value - Get data back from screens
/// 5. Multiple navigation levels - Complex screen hierarchies
/// 6. Conditional navigation - Navigate based on conditions
/// 7. Navigation state management - Preserve UI state across navigation

class MultiScreenNavigationDemoScreen extends StatefulWidget {
  const MultiScreenNavigationDemoScreen({Key? key}) : super(key: key);

  @override
  State<MultiScreenNavigationDemoScreen> createState() =>
      _MultiScreenNavigationDemoScreenState();
}

class _MultiScreenNavigationDemoScreenState
    extends State<MultiScreenNavigationDemoScreen> {
  String? _returnedData;
  int _navigationCount = 0;
  final List<String> _navigationHistory = [];

  void _recordNavigation(String route) {
    setState(() {
      _navigationCount++;
      _navigationHistory.insert(0, 'Navigated to $route (Count: $_navigationCount)');
      if (_navigationHistory.length > 10) {
        _navigationHistory.removeLast();
      }
    });
    debugPrint('🧭 [Navigation] Route: $route');
  }

  Future<void> _navigateToBasicScreen() async {
    _recordNavigation('/navigation/basic');
    Navigator.pushNamed(context, '/navigation/basic');
  }

  Future<void> _navigateWithData() async {
    _recordNavigation('/navigation/data');
    final result = await Navigator.pushNamed(
      context,
      '/navigation/data',
      arguments: 'Hello from Home!',
    ) as String?;
    
    if (result != null) {
      setState(() => _returnedData = result);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('📬 Received: $_returnedData')),
      );
    }
  }

  Future<void> _navigateToSettings() async {
    _recordNavigation('/navigation/settings');
    final result = await Navigator.pushNamed(
      context,
      '/navigation/settings',
    ) as Map<String, dynamic>?;
    
    if (result != null && result['theme'] != null) {
      setState(() {
        _returnedData = 'Theme: ${result['theme']}, Language: ${result['language']}';
      });
    }
  }

  Future<void> _navigateToWizard() async {
    _recordNavigation('/navigation/wizard');
    final result = await Navigator.pushNamed(
      context,
      '/navigation/wizard',
    ) as String?;
    
    if (result != null) {
      setState(() => _returnedData = result);
    }
  }

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveHelper.of(context);
    final isSmall = responsive.isSmall;

    return Scaffold(
      appBar: AppBar(
        title: const Text('🧭 Multi-Screen Navigation'),
        centerTitle: true,
        backgroundColor: RetroColors.retroGreen,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(responsive.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Summary Card
            Container(
              decoration: BoxDecoration(
                color: RetroColors.retroBlue.withOpacity(0.1),
                border: Border.all(
                  color: RetroColors.retroBlue,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: EdgeInsets.all(responsive.paddingSmall),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Navigation Hub',
                    style: TextStyle(
                      fontSize: responsive.fontSize(18),
                      fontWeight: FontWeight.bold,
                      color: RetroColors.retroBlue,
                    ),
                  ),
                  SizedBox(height: responsive.spacingSmall),
                  Text(
                    'Total navigations: $_navigationCount',
                    style: TextStyle(fontSize: responsive.fontSize(14)),
                  ),
                  if (_returnedData != null) ...[
                    SizedBox(height: responsive.spacingSmall),
                    Container(
                      padding: EdgeInsets.all(responsive.paddingSmall),
                      decoration: BoxDecoration(
                        color: RetroColors.retroGreen.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '✅ Returned: $_returnedData',
                        style: TextStyle(
                          fontSize: responsive.fontSize(13),
                          color: RetroColors.retroGreen,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            SizedBox(height: responsive.spacingMedium),

            // Navigation Examples Section
            Text(
              '📍 Navigation Examples',
              style: TextStyle(
                fontSize: responsive.fontSize(16),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: responsive.spacingSmall),

            // Example 1: Basic Navigation
            _buildNavigationCard(
              responsive,
              title: '1️⃣ Basic Navigation',
              description: 'Simple pushNamed() and pop()',
              onTap: _navigateToBasicScreen,
            ),

            // Example 2: Data Passing
            _buildNavigationCard(
              responsive,
              title: '2️⃣ Pass Data & Return',
              description: 'Send arguments and receive results',
              onTap: _navigateWithData,
            ),

            // Example 3: Settings (Complex Data)
            _buildNavigationCard(
              responsive,
              title: '3️⃣ Settings Navigation',
              description: 'Return structured data (Map)',
              onTap: _navigateToSettings,
            ),

            // Example 4: Wizard Flow
            _buildNavigationCard(
              responsive,
              title: '4️⃣ Wizard Flow',
              description: 'Multi-step navigation with completion',
              onTap: _navigateToWizard,
            ),

            SizedBox(height: responsive.spacingMedium),

            // Code Examples Section
            Text(
              '💻 Code Patterns',
              style: TextStyle(
                fontSize: responsive.fontSize(16),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: responsive.spacingSmall),

            _buildCodeExample(
              responsive,
              'pushNamed()',
              '''Navigator.pushNamed(
  context,
  '/details',
);''',
            ),

            _buildCodeExample(
              responsive,
              'pushNamed with Arguments',
              '''Navigator.pushNamed(
  context,
  '/details',
  arguments: 'Hello!',
);''',
            ),

            _buildCodeExample(
              responsive,
              'Receive Arguments',
              '''final args = ModalRoute.of(context)
    ?.settings.arguments as String?;''',
            ),

            _buildCodeExample(
              responsive,
              'Pop with Result',
              '''Navigator.pop(
  context,
  'Return value',
);''',
            ),

            SizedBox(height: responsive.spacingMedium),

            // Key Concepts
            Text(
              '🎯 Key Concepts',
              style: TextStyle(
                fontSize: responsive.fontSize(16),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: responsive.spacingSmall),

            _buildConceptCard(
              responsive,
              '📚 Routes Map',
              'Connect route names to widgets in MaterialApp',
            ),

            _buildConceptCard(
              responsive,
              '🔄 Navigator.push()',
              'Add new screen to navigation stack',
            ),

            _buildConceptCard(
              responsive,
              '⬅️ Navigator.pop()',
              'Remove current screen from stack',
            ),

            _buildConceptCard(
              responsive,
              '🔗 Named Routes',
              'Use string identifiers instead of widget classes',
            ),

            _buildConceptCard(
              responsive,
              '📦 Arguments Passing',
              'Send and receive data between screens',
            ),

            _buildConceptCard(
              responsive,
              '🔀 Route Parameters',
              'Extract dynamic values from route paths',
            ),

            SizedBox(height: responsive.spacingMedium),

            // Navigation History
            if (_navigationHistory.isNotEmpty) ...[
              Text(
                '📜 Navigation History',
                style: TextStyle(
                  fontSize: responsive.fontSize(16),
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: responsive.spacingSmall),
              Container(
                decoration: BoxDecoration(
                  color: Colors.black,
                  border: Border.all(color: RetroColors.retroGreen),
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: EdgeInsets.all(responsive.paddingSmall),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _navigationHistory
                      .asMap()
                      .entries
                      .map(
                        (entry) => Padding(
                          padding: EdgeInsets.only(
                            bottom: entry.key < _navigationHistory.length - 1
                                ? responsive.spacingSmall
                                : 0,
                          ),
                          child: Text(
                            entry.value,
                            style: TextStyle(
                              color: RetroColors.retroGreen,
                              fontSize: responsive.fontSize(12),
                              fontFamily: 'monospace',
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
            SizedBox(height: responsive.spacingLarge),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationCard(
    ResponsiveHelper responsive, {
    required String title,
    required String description,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: EdgeInsets.only(bottom: responsive.spacingSmall),
      color: RetroColors.retroYellow.withOpacity(0.05),
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(
            fontSize: responsive.fontSize(14),
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          description,
          style: TextStyle(fontSize: responsive.fontSize(12)),
        ),
        trailing: Icon(
          Icons.arrow_forward,
          color: RetroColors.retroYellow,
        ),
        onTap: onTap,
      ),
    );
  }

  Widget _buildCodeExample(
    ResponsiveHelper responsive,
    String title,
    String code,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: responsive.spacingSmall),
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border.all(color: RetroColors.retroYellow, width: 1),
        borderRadius: BorderRadius.circular(4),
      ),
      padding: EdgeInsets.all(responsive.paddingSmall),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: RetroColors.retroYellow,
              fontSize: responsive.fontSize(12),
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: responsive.spacingSmall),
          Text(
            code,
            style: TextStyle(
              color: Colors.green[400],
              fontSize: responsive.fontSize(11),
              fontFamily: 'monospace',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConceptCard(
    ResponsiveHelper responsive,
    String title,
    String description,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: responsive.spacingSmall),
      decoration: BoxDecoration(
        border: Border.all(color: RetroColors.retroRed.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(4),
      ),
      padding: EdgeInsets.all(responsive.paddingSmall),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: responsive.fontSize(13),
              fontWeight: FontWeight.bold,
              color: RetroColors.retroRed,
            ),
          ),
          SizedBox(height: 4),
          Text(
            description,
            style: TextStyle(fontSize: responsive.fontSize(12)),
          ),
        ],
      ),
    );
  }
}

// Basic Example Screen
class BasicExampleScreen extends StatelessWidget {
  const BasicExampleScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveHelper.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Basic Navigation Example'),
        backgroundColor: RetroColors.retroBlue,
      ),
      body: Padding(
        padding: EdgeInsets.all(responsive.paddingMedium),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(responsive.paddingMedium),
              decoration: BoxDecoration(
                color: RetroColors.retroBlue.withOpacity(0.1),
                border: Border.all(color: RetroColors.retroBlue),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Text(
                    '1️⃣ Basic Navigation',
                    style: TextStyle(
                      fontSize: responsive.fontSize(18),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: responsive.spacingMedium),
                  Text(
                    'This screen was opened with:\n'
                    'Navigator.pushNamed(context, \'/navigation/basic\')',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: responsive.fontSize(14)),
                  ),
                  SizedBox(height: responsive.spacingMedium),
                  Text(
                    'Each push() adds a new layer to the navigation stack.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: responsive.fontSize(12),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: responsive.spacingLarge),
            ElevatedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back),
              label: const Text('Back to Home'),
              style: ElevatedButton.styleFrom(
                backgroundColor: RetroColors.retroBlue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Data Passing Example Screen
class DataPassingScreen extends StatelessWidget {
  const DataPassingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveHelper.of(context);
    final message =
        ModalRoute.of(context)?.settings.arguments as String? ??
            'No data received';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Passing Example'),
        backgroundColor: RetroColors.retroGreen,
      ),
      body: Padding(
        padding: EdgeInsets.all(responsive.paddingMedium),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(responsive.paddingMedium),
              decoration: BoxDecoration(
                color: RetroColors.retroGreen.withOpacity(0.1),
                border: Border.all(color: RetroColors.retroGreen),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Text(
                    '2️⃣ Data Passing',
                    style: TextStyle(
                      fontSize: responsive.fontSize(18),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: responsive.spacingMedium),
                  Text(
                    'Received Message:',
                    style: TextStyle(fontSize: responsive.fontSize(12)),
                  ),
                  SizedBox(height: responsive.spacingSmall),
                  Container(
                    padding: EdgeInsets.all(responsive.paddingSmall),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      border: Border.all(color: RetroColors.retroGreen),
                    ),
                    child: Text(
                      message,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: responsive.fontSize(14),
                        color: RetroColors.retroGreen,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ),
                  SizedBox(height: responsive.spacingMedium),
                  Text(
                    'Arguments are passed via the arguments parameter.\n'
                    'Received using ModalRoute.of(context).settings.arguments',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: responsive.fontSize(12)),
                  ),
                ],
              ),
            ),
            SizedBox(height: responsive.spacingLarge),
            ElevatedButton.icon(
              onPressed: () => Navigator.pop(context, '✅ Data returned!'),
              icon: const Icon(Icons.send),
              label: const Text('Return Data & Go Back'),
              style: ElevatedButton.styleFrom(
                backgroundColor: RetroColors.retroGreen,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Settings Screen with Structured Data Return
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _selectedTheme = 'Dark';
  String _selectedLanguage = 'English';

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveHelper.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings Navigation'),
        backgroundColor: RetroColors.retroYellow,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: EdgeInsets.all(responsive.paddingMedium),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(responsive.paddingMedium),
              decoration: BoxDecoration(
                color: RetroColors.retroYellow.withOpacity(0.1),
                border: Border.all(color: RetroColors.retroYellow),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '3️⃣ Settings with Structured Data',
                    style: TextStyle(
                      fontSize: responsive.fontSize(16),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: responsive.spacingMedium),
                  Text(
                    'Theme:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: responsive.spacingSmall),
                  DropdownButton<String>(
                    value: _selectedTheme,
                    isExpanded: true,
                    items: ['Dark', 'Light', 'System'].map((theme) {
                      return DropdownMenuItem(
                        value: theme,
                        child: Text(theme),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() => _selectedTheme = value ?? 'Dark');
                    },
                  ),
                  SizedBox(height: responsive.spacingMedium),
                  Text(
                    'Language:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: responsive.spacingSmall),
                  DropdownButton<String>(
                    value: _selectedLanguage,
                    isExpanded: true,
                    items: ['English', 'Spanish', 'French'].map((lang) {
                      return DropdownMenuItem(
                        value: lang,
                        child: Text(lang),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() => _selectedLanguage = value ?? 'English');
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: responsive.spacingLarge),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(
                  context,
                  {
                    'theme': _selectedTheme,
                    'language': _selectedLanguage,
                  },
                );
              },
              icon: const Icon(Icons.check),
              label: const Text('Save & Return'),
              style: ElevatedButton.styleFrom(
                backgroundColor: RetroColors.retroYellow,
                foregroundColor: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Wizard Flow Screen
class WizardScreen extends StatefulWidget {
  const WizardScreen({Key? key}) : super(key: key);

  @override
  State<WizardScreen> createState() => _WizardScreenState();
}

class _WizardScreenState extends State<WizardScreen> {
  int _currentStep = 1;
  final List<String> _answers = [];

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveHelper.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Wizard Flow'),
        backgroundColor: RetroColors.retroRed,
      ),
      body: Padding(
        padding: EdgeInsets.all(responsive.paddingMedium),
        child: Column(
          children: [
            // Progress indicator
            Container(
              padding: EdgeInsets.all(responsive.paddingSmall),
              decoration: BoxDecoration(
                color: RetroColors.retroRed.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Step $_currentStep of 3',
                style: TextStyle(
                  fontSize: responsive.fontSize(14),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: responsive.spacingMedium),

            // Step content
            Expanded(
              child: Container(
                padding: EdgeInsets.all(responsive.paddingMedium),
                decoration: BoxDecoration(
                  border: Border.all(color: RetroColors.retroRed),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: _buildStepContent(responsive),
              ),
            ),

            SizedBox(height: responsive.spacingMedium),

            // Navigation buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if (_currentStep > 1)
                  ElevatedButton.icon(
                    onPressed: () => setState(() => _currentStep--),
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Previous'),
                  ),
                if (_currentStep < 3)
                  ElevatedButton.icon(
                    onPressed: () => setState(() => _currentStep++),
                    icon: const Icon(Icons.arrow_forward),
                    label: const Text('Next'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: RetroColors.retroRed,
                    ),
                  ),
                if (_currentStep == 3)
                  ElevatedButton.icon(
                    onPressed: () => Navigator.pop(context, '✅ Wizard Complete!'),
                    icon: const Icon(Icons.done),
                    label: const Text('Complete'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: RetroColors.retroRed,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepContent(ResponsiveHelper responsive) {
    switch (_currentStep) {
      case 1:
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Step 1: Welcome',
              style: TextStyle(fontSize: responsive.fontSize(18)),
            ),
            SizedBox(height: responsive.spacingMedium),
            Text(
              'This is a multi-step wizard flow. '
              'Users navigate through each step sequentially.',
              textAlign: TextAlign.center,
            ),
          ],
        );
      case 2:
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Step 2: Configuration',
              style: TextStyle(fontSize: responsive.fontSize(18)),
            ),
            SizedBox(height: responsive.spacingMedium),
            Text(
              'Configure your preferences here. '
              'Progress is maintained as you move between steps.',
              textAlign: TextAlign.center,
            ),
          ],
        );
      case 3:
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Step 3: Review & Complete',
              style: TextStyle(fontSize: responsive.fontSize(18)),
            ),
            SizedBox(height: responsive.spacingMedium),
            Text(
              'Review your selections and complete the wizard. '
              'Data can be collected and returned.',
              textAlign: TextAlign.center,
            ),
          ],
        );
      default:
        return const SizedBox();
    }
  }
}
