import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/secure_profile_service.dart';
import '../constants/retro_theme.dart';

class SecureProfileScreen extends StatefulWidget {
  const SecureProfileScreen({Key? key}) : super(key: key);

  @override
  State<SecureProfileScreen> createState() => _SecureProfileScreenState();
}

class _SecureProfileScreenState extends State<SecureProfileScreen> {
  final SecureProfileService _profileService = SecureProfileService();
  late TextEditingController _displayNameController;
  late TextEditingController _bioController;
  late TextEditingController _phoneController;
  late TextEditingController _targetUidController;

  UserProfile? _currentProfile;
  String? _accessAttemptLog;
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _displayNameController = TextEditingController();
    _bioController = TextEditingController();
    _phoneController = TextEditingController();
    _targetUidController = TextEditingController();
    _loadMyProfile();
  }

  Future<void> _loadMyProfile() async {
    setState(() => _isLoading = true);
    try {
      final profile = await _profileService.getMyProfile();
      setState(() {
        _currentProfile = profile;
        if (profile != null) {
          _displayNameController.text = profile.displayName;
          _bioController.text = profile.bio;
          _phoneController.text = profile.phoneNumber;
        }
        _isLoading = false;
        _error = null;
      });
    } catch (e) {
      setState(() {
        _error = 'Error loading profile: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _updateProfile() async {
    if (_displayNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Display name required')),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      await _profileService.updateMyProfile(
        displayName: _displayNameController.text,
        bio: _bioController.text,
        phoneNumber: _phoneController.text,
      );
      
      _addLog('✓ Profile updated successfully for ${_profileService.currentUserUid}');
      
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully')),
      );
      
      await _loadMyProfile();
    } catch (e) {
      _addLog('✗ Profile update failed: $e');
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> _attemptUnauthorizedRead() async {
    if (_targetUidController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter a user UID to test')),
      );
      return;
    }

    _addLog('Attempting to read profile for: ${_targetUidController.text}');
    _addLog('Current user UID: ${_profileService.currentUserUid}');
    
    setState(() => _isLoading = true);
    try {
      final profile = await _profileService.getOtherUserProfile(
        _targetUidController.text,
      );
      
      _addLog('✗ SECURITY ISSUE: Unauthorized read succeeded!');
      _addLog('Profile accessed: ${profile?.displayName}');
      
      setState(() => _isLoading = false);
    } catch (e) {
      if (e.toString().contains('permission-denied') || 
          e.toString().contains('Permission denied')) {
        _addLog('✓ SECURE: Read blocked - ${e.toString().split(':').first}');
      } else {
        _addLog('✗ Error: $e');
      }
      setState(() => _isLoading = false);
    }
  }

  Future<void> _attemptUnauthorizedWrite() async {
    if (_targetUidController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter a user UID to test')),
      );
      return;
    }

    _addLog('Attempting to write to profile for: ${_targetUidController.text}');
    _addLog('Current user UID: ${_profileService.currentUserUid}');
    
    setState(() => _isLoading = true);
    try {
      await _profileService.updateOtherUserProfile(
        targetUid: _targetUidController.text,
        displayName: 'HACKED',
        bio: 'Unauthorized modification',
        phoneNumber: '0000000000',
      );
      
      _addLog('✗ SECURITY ISSUE: Unauthorized write succeeded!');
      
      setState(() => _isLoading = false);
    } catch (e) {
      if (e.toString().contains('permission-denied') || 
          e.toString().contains('Permission denied')) {
        _addLog('✓ SECURE: Write blocked - ${e.toString().split(':').first}');
      } else {
        _addLog('✗ Error: $e');
      }
      setState(() => _isLoading = false);
    }
  }

  void _addLog(String message) {
    final timestamp = DateTime.now().toString().split('.').first;
    setState(() {
      _accessAttemptLog = '[$timestamp] $message\n${_accessAttemptLog ?? ''}';
    });
  }

  void _clearLog() {
    setState(() => _accessAttemptLog = null);
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Secure Profile Demo'),
        backgroundColor: RetroColors.neonPurple,
        elevation: 8,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Current User Info Card
            Card(
              color: Colors.blue[50],
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Current Authenticated User',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: RetroColors.neonPurple,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text('Email: ${currentUser?.email ?? "Not authenticated"}'),
                    Text('UID: ${currentUser?.uid ?? "Not available"}'),
                    const SizedBox(height: 8),
                    const Text(
                      '⚡ Only this user can read/write their own profile document in Firestore',
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // My Profile Section
            Text(
              'Your Profile (/users/{uid})',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else if (_error != null)
              Card(
                color: Colors.red[50],
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text('Error: $_error', style: const TextStyle(color: Colors.red)),
                ),
              )
            else ...[
              // Profile Form
              TextFormField(
                controller: _displayNameController,
                decoration: InputDecoration(
                  labelText: 'Display Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _bioController,
                decoration: InputDecoration(
                  labelText: 'Bio',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _updateProfile,
                icon: const Icon(Icons.save),
                label: const Text('Update My Profile'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ],

            const SizedBox(height: 32),

            // Security Test Section
            Text(
              'Security Rule Testing',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            Card(
              color: Colors.orange[50],
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '⚠️ Security Rule Demo',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Test the security rules by attempting to read or write to another user\'s profile.',
                      style: TextStyle(fontSize: 12),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Expected Result: Both operations should be DENIED by Firestore security rules.',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Target UID Input
            TextFormField(
              controller: _targetUidController,
              decoration: InputDecoration(
                labelText: 'Target User UID (for testing unauthorized access)',
                hintText: 'Paste another user\'s UID here',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Security Test Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _attemptUnauthorizedRead,
                    icon: const Icon(Icons.block),
                    label: const Text('Test Read Block'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _attemptUnauthorizedWrite,
                    icon: const Icon(Icons.security),
                    label: const Text('Test Write Block'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Access Attempt Log
            Text(
              'Security Events Log',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),

            Container(
              height: 250,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey[50],
              ),
              child: _accessAttemptLog == null || _accessAttemptLog!.isEmpty
                  ? const Center(
                    child: Text('No security events logged yet'),
                  )
                  : SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: SelectableText(
                        _accessAttemptLog!,
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ),
            ),
            const SizedBox(height: 12),

            ElevatedButton.icon(
              onPressed: _clearLog,
              icon: const Icon(Icons.clear),
              label: const Text('Clear Log'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey,
              ),
            ),

            const SizedBox(height: 16),

            // Rules Explanation
            Card(
              color: Colors.blue[50],
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Firestore Security Rules:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: RetroColors.neonPurple,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(4),
                      ),
                      padding: const EdgeInsets.all(8),
                      child: const SelectableText(
                        '''match /users/{uid} {
  allow read: if request.auth != null 
             && request.auth.uid == uid;
  allow create: if request.auth != null 
               && request.auth.uid == uid;
  allow update, delete: if request.auth != null 
                       && request.auth.uid == uid;
}''',
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 10,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'These rules ensure:',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const Text('• Only authenticated users can access'),
                    const Text('• Users can only access their own document (matching their UID)'),
                    const Text('• Unauthorized access is blocked by Firestore'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _displayNameController.dispose();
    _bioController.dispose();
    _phoneController.dispose();
    _targetUidController.dispose();
    super.dispose();
  }
}
