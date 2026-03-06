import 'package:flutter/material.dart';
import '../constants/retro_theme.dart';
import '../services/cloud_functions_service.dart';

/// Cloud Functions Demo Screen
///
/// Interactive demonstration of Firebase Cloud Functions.
/// Shows callable functions invoked from Flutter with real-time results.
class CloudFunctionsDemoScreen extends StatefulWidget {
  final String userId;

  const CloudFunctionsDemoScreen({
    Key? key,
    this.userId = 'demo-user-id',
  }) : super(key: key);

  @override
  State<CloudFunctionsDemoScreen> createState() =>
      _CloudFunctionsDemoScreenState();
}

class _CloudFunctionsDemoScreenState extends State<CloudFunctionsDemoScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final CloudFunctionsService _functionsService = CloudFunctionsService();

  // State management
  String? _result;
  bool _isLoading = false;
  String? _error;
  String _greetingName = 'TaskPilot User';
  String? _serverTime;
  Map<String, dynamic>? _statistics;
  Map<String, dynamic>? _appConfig;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  /// Reset result state
  void _clearResults() {
    setState(() {
      _result = null;
      _error = null;
      _isLoading = false;
    });
  }

  /// Call sayHello function
  Future<void> _callSayHello() async {
    _clearResults();
    setState(() => _isLoading = true);

    try {
      final result =
          await _functionsService.sayHello(name: _greetingName);
      setState(() {
        _result = result;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = _functionsService.getErrorMessage(e);
        _isLoading = false;
      });
    }
  }

  /// Call getServerTime function
  Future<void> _callGetServerTime() async {
    _clearResults();
    setState(() => _isLoading = true);

    try {
      final result = await _functionsService.getServerTime();
      setState(() {
        _serverTime = result.toString();
        _result = 'Server Time: ${result.toLocal()}';
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = _functionsService.getErrorMessage(e);
        _isLoading = false;
      });
    }
  }

  /// Call healthCheck function
  Future<void> _callHealthCheck() async {
    _clearResults();
    setState(() => _isLoading = true);

    try {
      final result = await _functionsService.healthCheck();
      setState(() {
        _result = 'Health: ${result['status']}\n'
            'Available Functions: ${(result['availableFunctions'] as List?)?.length ?? 0}';
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = _functionsService.getErrorMessage(e);
        _isLoading = false;
      });
    }
  }

  /// Call getAppConfig function
  Future<void> _callGetAppConfig() async {
    _clearResults();
    setState(() => _isLoading = true);

    try {
      final result = await _functionsService.getAppConfig();
      setState(() {
        _appConfig = result;
        _result = _formatJson(result);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = _functionsService.getErrorMessage(e);
        _isLoading = false;
      });
    }
  }

  /// Call getUserStatistics function
  Future<void> _callGetStatistics() async {
    _clearResults();
    setState(() => _isLoading = true);

    try {
      final result = await _functionsService.getUserStatistics(
        userId: widget.userId,
      );
      setState(() {
        _statistics = result;
        _result = _formatJson(result);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = _functionsService.getErrorMessage(e);
        _isLoading = false;
      });
    }
  }

  /// Format JSON for display
  String _formatJson(Map<String, dynamic> data) {
    StringBuffer buffer = StringBuffer();
    data.forEach((key, value) {
      buffer.writeln('$key: $value');
    });
    return buffer.toString();
  }

  /// Build basic functions tab
  Widget _buildBasicFunctionsTab() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Greeting function
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade900,
                border: Border.all(color: RetroColors.neonCyan, width: 2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Say Hello Function',
                    style: TextStyle(
                      color: RetroColors.neonCyan,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Enter your name',
                      hintStyle: const TextStyle(color: Colors.white30),
                      filled: true,
                      fillColor: Colors.grey.shade900,
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: RetroColors.neonCyan,
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                    ),
                    style: const TextStyle(color: Colors.white),
                    onChanged: (value) {
                      setState(() => _greetingName = value.isEmpty ? 'User' : value);
                    },
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _isLoading ? null : _callSayHello,
                      icon: const Icon(Icons.send),
                      label: Text(_isLoading ? 'Calling...' : 'Call Function'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: RetroColors.neonCyan,
                        foregroundColor: Colors.black,
                        disabledBackgroundColor: Colors.grey.shade700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Server time function
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.shade900,
                border: Border.all(color: RetroColors.neonGreen, width: 2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Get Server Time Function',
                    style: TextStyle(
                      color: RetroColors.neonGreen,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Retrieves current server time for synchronization',
                    style: TextStyle(color: Colors.white54, fontSize: 12),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _isLoading ? null : _callGetServerTime,
                      icon: const Icon(Icons.schedule),
                      label:
                          Text(_isLoading ? 'Getting Time...' : 'Get Time'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: RetroColors.neonGreen,
                        foregroundColor: Colors.black,
                        disabledBackgroundColor: Colors.grey.shade700,
                      ),
                    ),
                  ),
                  if (_serverTime != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Text(
                        'Server: $_serverTime',
                        style: const TextStyle(
                          color: RetroColors.neonGreen,
                          fontSize: 12,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Health check function
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.shade900,
                border: Border.all(color: RetroColors.neonOrange, width: 2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Health Check Function',
                    style: TextStyle(
                      color: RetroColors.neonOrange,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Verifies Cloud Functions are running and lists available functions',
                    style: TextStyle(color: Colors.white54, fontSize: 12),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _isLoading ? null : _callHealthCheck,
                      icon: const Icon(Icons.favorite),
                      label: Text(_isLoading ? 'Checking...' : 'Health Check'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: RetroColors.neonOrange,
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: Colors.grey.shade700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Results display
            if (_isLoading)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade900,
                  border: Border.all(color: RetroColors.neonCyan, width: 2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Calling Cloud Function...',
                      style: TextStyle(
                        color: RetroColors.neonCyan,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        RetroColors.neonCyan,
                      ),
                    ),
                  ],
                ),
              ),
            if (_error != null)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade900,
                  border: Border.all(color: Colors.red.shade600, width: 2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _error!,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            if (_result != null)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.shade900,
                  border: Border.all(color: RetroColors.neonGreen, width: 2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Function Result:',
                      style: TextStyle(
                        color: RetroColors.neonGreen,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SelectableText(
                      _result!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// Build advanced functions tab
  Widget _buildAdvancedFunctionsTab() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // App config
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.purple.shade900,
                border: Border.all(color: RetroColors.neonMagenta, width: 2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Get App Configuration',
                    style: TextStyle(
                      color: RetroColors.neonMagenta,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Fetches centralized app configuration from Cloud Function',
                    style: TextStyle(color: Colors.white54, fontSize: 12),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _isLoading ? null : _callGetAppConfig,
                      icon: const Icon(Icons.settings),
                      label: Text(_isLoading ? 'Loading...' : 'Get Config'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: RetroColors.neonMagenta,
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: Colors.grey.shade700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // User statistics
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF1a4d3a),
                border: Border.all(color: RetroColors.neonGreen, width: 2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Get User Statistics',
                    style: TextStyle(
                      color: RetroColors.neonGreen,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Cloud Function aggregates user data and returns statistics',
                    style: TextStyle(color: Colors.white54, fontSize: 12),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _isLoading ? null : _callGetStatistics,
                      icon: const Icon(Icons.bar_chart),
                      label: Text(_isLoading ? 'Loading...' : 'Get Stats'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: RetroColors.neonGreen,
                        foregroundColor: Colors.black,
                        disabledBackgroundColor: Colors.grey.shade700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Results display
            if (_isLoading)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade900,
                  border: Border.all(color: RetroColors.neonCyan, width: 2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Calling Cloud Function...',
                      style: TextStyle(
                        color: RetroColors.neonCyan,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        RetroColors.neonCyan,
                      ),
                    ),
                  ],
                ),
              ),
            if (_error != null)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade900,
                  border: Border.all(color: Colors.red.shade600, width: 2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _error!,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            if (_result != null)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.shade900,
                  border: Border.all(color: RetroColors.neonGreen, width: 2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Function Result:',
                      style: TextStyle(
                        color: RetroColors.neonGreen,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SelectableText(
                      _result!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// Build event-based functions explanation tab
  Widget _buildEventBasedTab() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildEventCard(
              'Firestore Triggers',
              'Run when Firestore documents change',
              [
                'onCreate - New document created',
                'onUpdate - Existing document modified',
                'onDelete - Document deleted',
                'onWrite - Any write operation',
              ],
              RetroColors.neonCyan,
              Colors.blue.shade900,
            ),
            const SizedBox(height: 16),
            _buildEventCard(
              'Authentication Triggers',
              'Run when user accounts change',
              [
                'onCreate - New user registered',
                'onDelete - User account deleted',
                'Sends welcome emails, creates user profiles',
              ],
              RetroColors.neonGreen,
              Colors.green.shade900,
            ),
            const SizedBox(height: 16),
            _buildEventCard(
              'Storage Triggers',
              'Run when files are uploaded/deleted',
              [
                'onFinalize - Upload complete',
                'onDelete - File deleted',
                'Generate thumbnails, process images',
              ],
              RetroColors.neonOrange,
              Colors.orange.shade900,
            ),
            const SizedBox(height: 16),
            _buildEventCard(
              'Scheduled Triggers (Pub/Sub)',
              'Run on schedule automatically',
              [
                'Daily reminders - Send daily digest',
                'Weekly cleanup - Archive old data',
                'Monthly stats - Calculate metrics',
              ],
              RetroColors.neonMagenta,
              Colors.purple.shade900,
            ),
            const SizedBox(height: 16),
            _buildEventCard(
              'Real Database Triggers (RTDB)',
              'Run when Realtime Database changes',
              [
                'onCreate, onUpdate, onDelete',
                'onWrite - Any change',
                'Monitor value changes in real-time',
              ],
              RetroColors.neonCyan,
              Colors.blue.shade900,
            ),
          ],
        ),
      ),
    );
  }

  /// Build event explanation card
  Widget _buildEventCard(
    String title,
    String description,
    List<String> examples,
    Color borderColor,
    Color bgColor,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        border: Border.all(color: borderColor, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: bgColor.withOpacity(0.7),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(6),
                topRight: Radius.circular(6),
              ),
            ),
            child: Text(
              title,
              style: TextStyle(
                color: borderColor,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  description,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 12),
                ...examples
                    .map((example) => Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: Row(
                            children: [
                              Text(
                                '• ',
                                style: TextStyle(
                                  color: borderColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  example,
                                  style: const TextStyle(
                                    color: Colors.white60,
                                    fontSize: 11,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ))
                    .toList(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Build code examples tab
  Widget _buildCodeExamplesTab() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCodeExample(
              'Call Callable Function',
              '''final callable = CloudFunctionsService();
final result = await callable.sayHello(name: 'Alex');
print(result); // Output: Hello, Alex!''',
            ),
            const SizedBox(height: 16),
            _buildCodeExample(
              'Handle Errors',
              '''try {
  final result = await service.sayHello();
} on FirebaseFunctionsException catch (e) {
  String message = service.getErrorMessage(e);
  print(message); // User-friendly error
} catch (e) {
  print('Unexpected: \$e');
}''',
            ),
            const SizedBox(height: 16),
            _buildCodeExample(
              'Get Server Time',
              '''final serverTime = 
  await service.getServerTime();
print('Server: \${serverTime}');

// Use for sync/validation''',
            ),
            const SizedBox(height: 16),
            _buildCodeExample(
              'Retry with Backoff',
              '''final result = await service.callWithRetry(
  () => service.getUserStatistics(
    userId: userId
  ),
  maxRetries: 3,
  initialDelay: Duration(milliseconds: 500),
);''',
            ),
            const SizedBox(height: 16),
            _buildCodeExample(
              'Check Function Available',
              '''final available = await service
  .isFunctionAvailable('sayHello');

if (available) {
  // Safe to call
  final result = await service.sayHello();
}''',
            ),
          ],
        ),
      ),
    );
  }

  /// Build code example widget
  Widget _buildCodeExample(String title, String code) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        border: Border.all(color: RetroColors.neonCyan, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: Color(0xFF1a1a1a),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(6),
                topRight: Radius.circular(6),
              ),
            ),
            child: Text(
              title,
              style: const TextStyle(
                color: RetroColors.neonCyan,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: SelectableText(
              code,
              style: const TextStyle(
                color: RetroColors.neonGreen,
                fontSize: 11,
                fontFamily: 'monospace',
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cloud Functions Demo'),
        backgroundColor: Colors.black87,
        foregroundColor: RetroColors.neonCyan,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          labelColor: RetroColors.neonCyan,
          unselectedLabelColor: Colors.grey,
          indicatorColor: RetroColors.neonMagenta,
          tabs: const [
            Tab(text: 'Basic', icon: Icon(Icons.functions)),
            Tab(text: 'Advanced', icon: Icon(Icons.settings)),
            Tab(text: 'Events', icon: Icon(Icons.event)),
            Tab(text: 'Code', icon: Icon(Icons.code)),
            Tab(text: 'Info', icon: Icon(Icons.info)),
          ],
        ),
      ),
      body: Container(
        color: Colors.black87,
        child: TabBarView(
          controller: _tabController,
          children: [
            _buildBasicFunctionsTab(),
            _buildAdvancedFunctionsTab(),
            _buildEventBasedTab(),
            _buildCodeExamplesTab(),
            _buildInfoTab(),
          ],
        ),
      ),
    );
  }

  /// Build info/help tab
  Widget _buildInfoTab() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade900,
                border: Border.all(color: RetroColors.neonCyan, width: 2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'What are Cloud Functions?',
                    style: TextStyle(
                      color: RetroColors.neonCyan,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Serverless backend code that runs in Google Cloud. No servers to manage - just write functions and deploy.',
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.shade900,
                border: Border.all(color: RetroColors.neonGreen, width: 2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Benefits',
                    style: TextStyle(
                      color: RetroColors.neonGreen,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildBulletPoint('No server infrastructure to manage'),
                  _buildBulletPoint('Automatically scales with demand'),
                  _buildBulletPoint('Pay only for what you use'),
                  _buildBulletPoint('Easy to test and deploy'),
                  _buildBulletPoint('Integrate with Firebase & Google Cloud'),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.shade900,
                border: Border.all(color: RetroColors.neonOrange, width: 2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Common Use Cases',
                    style: TextStyle(
                      color: RetroColors.neonOrange,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildBulletPoint('Send emails/notifications'),
                  _buildBulletPoint('Process payments securely'),
                  _buildBulletPoint('Validate user input server-side'),
                  _buildBulletPoint('Aggregate data from Firestore'),
                  _buildBulletPoint('Generate reports/PDFs'),
                  _buildBulletPoint('Run scheduled tasks'),
                  _buildBulletPoint('Execute when documents change'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build bullet point
  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '• ',
            style: TextStyle(
              color: Colors.white70,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(color: Colors.white70, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}
