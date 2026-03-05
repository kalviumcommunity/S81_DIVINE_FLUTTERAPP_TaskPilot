import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../constants/retro_theme.dart';

/// HomeScreen is displayed when the user is authenticated.
/// 
/// Shows:
/// - User's email address
/// - Welcome message
/// - Quick action buttons
/// - Logout option
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TaskPilot Dashboard'),
        backgroundColor: RetroColors.neonPurple,
        elevation: 8.0,
        centerTitle: true,
        actions: [
          Consumer<AuthProvider>(
            builder: (context, authProvider, _) {
              return PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'logout') {
                    _showLogoutDialog(context, authProvider);
                  } else if (value == 'profile') {
                    _showProfileDialog(context, authProvider);
                  }
                },
                itemBuilder: (BuildContext context) =>
                    <PopupMenuEntry<String>>[
                  PopupMenuItem<String>(
                    value: 'profile',
                    child: Row(
                      children: [
                        const Icon(Icons.person, size: 18.0),
                        const SizedBox(width: 10.0),
                        Text(authProvider.userEmail ?? 'Profile'),
                      ],
                    ),
                  ),
                  const PopupMenuDivider(),
                  const PopupMenuItem<String>(
                    value: 'logout',
                    child: Row(
                      children: [
                        Icon(Icons.logout, size: 18.0),
                        SizedBox(width: 10.0),
                        Text('Sign Out'),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Welcome section
                  _buildWelcomeSection(authProvider),

                  const SizedBox(height: 32.0),

                  // Quick actions
                  _buildQuickActionsSection(),

                  const SizedBox(height: 32.0),

                  // User info card
                  _buildUserInfoCard(authProvider),

                  const SizedBox(height: 32.0),

                  // Features section
                  _buildFeaturesSection(),

                  const SizedBox(height: 32.0),

                  // Sign out button
                  _buildSignOutButton(context, authProvider),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  /// Build welcome section
  Widget _buildWelcomeSection(AuthProvider authProvider) {
    return Column(
      children: [
        const Icon(
          Icons.check_circle_outline,
          size: 64.0,
          color: Colors.green,
        ),
        const SizedBox(height: 16.0),
        Text(
          'Welcome to TaskPilot! 🎉',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: RetroColors.neonPurple,
              ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8.0),
        Text(
          'You are successfully logged in',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[700],
              ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  /// Build quick actions section
  Widget _buildQuickActionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16.0),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 12.0,
          crossAxisSpacing: 12.0,
          children: [
            _buildActionCard(
              icon: Icons.task_alt,
              title: 'My Tasks',
              subtitle: 'View and manage tasks',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Tasks feature coming soon!')),
                );
              },
            ),
            _buildActionCard(
              icon: Icons.people,
              title: 'Clients',
              subtitle: 'Manage clients',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Client management coming soon!')),
                );
              },
            ),
            _buildActionCard(
              icon: Icons.payment,
              title: 'Payments',
              subtitle: 'Track payments',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Payment tracking coming soon!')),
                );
              },
            ),
            _buildActionCard(
              icon: Icons.analytics,
              title: 'Analytics',
              subtitle: 'View statistics',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Analytics coming soon!')),
                );
              },
            ),
          ],
        ),
      ],
    );
  }

  /// Build action card
  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: RetroColors.neonPurple,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: RetroColors.neonPurple.withOpacity(0.3),
              blurRadius: 4.0,
              offset: const Offset(2, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 40.0,
              color: RetroColors.neonPurple,
            ),
            const SizedBox(height: 8.0),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12.0,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4.0),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 10.0,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  /// Build user info card
  Widget _buildUserInfoCard(AuthProvider authProvider) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.amber[50],
        border: Border.all(
          color: RetroColors.neonPurple,
          width: 2.0,
        ),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.account_circle,
                size: 48.0,
                color: Color.fromARGB(255, 191, 144, 0),
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Account Information',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      authProvider.userEmail ?? 'No email',
                      style: Theme.of(context).textTheme.bodySmall,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12.0),
          const Divider(),
          const SizedBox(height: 12.0),
          _buildInfoRow('Status', '✅ Authenticated'),
          const SizedBox(height: 8.0),
          _buildInfoRow('Platform', 'Flutter'),
          const SizedBox(height: 8.0),
          _buildInfoRow('Security', '🔒 Secure Session'),
        ],
      ),
    );
  }

  /// Build info row
  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 12.0,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 12.0,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  /// Build features section
  Widget _buildFeaturesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Available Features',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16.0),
        _buildFeatureItem('✅ Task Management', 'Create and track your projects'),
        const SizedBox(height: 12.0),
        _buildFeatureItem('✅ Client Portal', 'Manage client relationships'),
        const SizedBox(height: 12.0),
        _buildFeatureItem('✅ Payment Tracking', 'Monitor invoices and payments'),
        const SizedBox(height: 12.0),
        _buildFeatureItem('✅ Real-time Sync', 'All data synced across devices'),
        const SizedBox(height: 12.0),
        _buildFeatureItem('✅ Notifications', 'Get updates on task changes'),
      ],
    );
  }

  /// Build feature item
  Widget _buildFeatureItem(String title, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.green[50],
        border: Border.all(color: Colors.green, width: 1.0),
        borderRadius: BorderRadius.circular(6.0),
      ),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: Colors.green, size: 20.0),
          const SizedBox(width: 12.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12.0,
                  ),
                ),
                const SizedBox(height: 2.0),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 11.0,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Build sign out button
  Widget _buildSignOutButton(
    BuildContext context,
    AuthProvider authProvider,
  ) {
    return ElevatedButton.icon(
      onPressed: () => _showLogoutDialog(context, authProvider),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red[600],
        padding: const EdgeInsets.symmetric(vertical: 14.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      icon: const Icon(Icons.logout, color: Colors.white),
      label: const Text(
        'Sign Out',
        style: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  /// Show logout confirmation dialog
  void _showLogoutDialog(BuildContext context, AuthProvider authProvider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Sign Out'),
          content: const Text(
            'Are you sure you want to sign out? You will need to log in again to access your account.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                authProvider.signOut();
                Navigator.pop(context);
              },
              child: const Text(
                'Sign Out',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  /// Show profile dialog
  void _showProfileDialog(BuildContext context, AuthProvider authProvider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Your Profile'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Email:', style: TextStyle(fontWeight: FontWeight.bold)),
              Text(authProvider.userEmail ?? 'Not available'),
              const SizedBox(height: 16.0),
              const Text('Status:', style: TextStyle(fontWeight: FontWeight.bold)),
              const Text('✅ Active'),
              const SizedBox(height: 16.0),
              const Text('Security:', style: TextStyle(fontWeight: FontWeight.bold)),
              const Text('🔒 Secure authenticated session'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
