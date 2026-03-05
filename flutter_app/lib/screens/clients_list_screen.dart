import 'package:flutter/material.dart';
import '../services/firestore_service.dart';
import '../models/client_model.dart';
import '../constants/retro_theme.dart';

///
/// ClientsListScreen - Display all clients from Firestore in real-time
///
/// Features:
/// - Real-time updates using StreamBuilder
/// - Active/inactive status
/// - Total amount spent tracking
/// - Contact information display
/// - Auto-refresh on data changes
///
class ClientsListScreen extends StatefulWidget {
  final String userId;

  const ClientsListScreen({
    Key? key,
    required this.userId,
  }) : super(key: key);

  @override
  State<ClientsListScreen> createState() => _ClientsListScreenState();
}

class _ClientsListScreenState extends State<ClientsListScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  bool _showInactive = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('👥 Clients'),
        backgroundColor: Colors.grey[900],
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(
              child: Tooltip(
                message: 'Show ${_showInactive ? 'Active' : 'All'} Clients',
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _showInactive = !_showInactive;
                    });
                  },
                  child: Icon(
                    _showInactive
                        ? Icons.filter_list_off
                        : Icons.filter_list,
                    color: _showInactive
                        ? RetroColors.neonPink
                        : RetroColors.neonCyan,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: StreamBuilder<List<ClientModel>>(
        stream: _showInactive
            ? _firestoreService.getAllUserClients(widget.userId)
            : _firestoreService.getUserClients(widget.userId),
        builder: (context, snapshot) {
          // Loading state
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(RetroColors.neonCyan),
              ),
            );
          }

          // Error state
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline,
                      size: 48, color: RetroColors.neonPink),
                  const SizedBox(height: 16),
                  Text(
                    'Error loading clients',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: RetroColors.neonPink,
                        ),
                  ),
                ],
              ),
            );
          }

          // Empty state
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.people_outline,
                      size: 64, color: RetroColors.neonCyan),
                  const SizedBox(height: 16),
                  Text(
                    _showInactive
                        ? 'No clients yet'
                        : 'No active clients',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: RetroColors.neonCyan,
                        ),
                  ),
                ],
              ),
            );
          }

          // Clients list
          final clients = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: clients.length,
            itemBuilder: (context, index) {
              final client = clients[index];
              return _ClientCard(client: client);
            },
          );
        },
      ),
    );
  }
}

/// Client card widget
class _ClientCard extends StatelessWidget {
  final ClientModel client;

  const _ClientCard({required this.client});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Card(
        color: Colors.grey[900],
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(
            color: client.isActive ? Colors.grey[700]! : Colors.grey[900]!,
            width: 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Client name and status
              Row(
                children: [
                  Expanded(
                    child: Text(
                      client.name,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: client.isActive
                          ? Colors.green[700]
                          : Colors.grey[700],
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      client.isActive ? 'ACTIVE' : 'INACTIVE',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: Colors.white,
                          ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Contact information
              _ContactRow(
                icon: Icons.email,
                label: 'Email',
                value: client.email,
                color: RetroColors.neonCyan,
              ),
              const SizedBox(height: 6),
              _ContactRow(
                icon: Icons.phone,
                label: 'Phone',
                value: client.phone,
                color: RetroColors.neonCyan,
              ),
              if (client.address.isNotEmpty) ...[
                const SizedBox(height: 6),
                _ContactRow(
                  icon: Icons.location_on,
                  label: 'Address',
                  value: client.fullAddress,
                  color: RetroColors.neonCyan,
                ),
              ],
              const SizedBox(height: 12),

              // Total spent
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: RetroColors.neonGreen.withOpacity(0.1),
                  border:
                      Border.all(color: RetroColors.neonGreen, width: 1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Spent',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: Colors.white,
                          ),
                    ),
                    Text(
                      '\$${client.totalSpent.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: RetroColors.neonGreen,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Contact row widget for displaying contact info
class _ContactRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _ContactRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: color,
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: Colors.grey[400],
              ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value.isEmpty ? 'Not provided' : value,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.white,
                ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
