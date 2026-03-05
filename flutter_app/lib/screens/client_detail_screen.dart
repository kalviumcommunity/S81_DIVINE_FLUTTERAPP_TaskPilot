import 'package:flutter/material.dart';
import '../services/firestore_service.dart';
import '../models/client_model.dart';
import '../constants/retro_theme.dart';

///
/// ClientDetailScreen - Display a single client document from Firestore
///
/// Features:
/// - Single document read using FutureBuilder
/// - Complete client contact information
/// - Address display with full formatting
/// - Total spent tracking
/// - Active/inactive status
/// - Professional detail layout
///
class ClientDetailScreen extends StatelessWidget {
  final String clientId;

  const ClientDetailScreen({
    Key? key,
    required this.clientId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FirestoreService firestoreService = FirestoreService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('👤 Client Details'),
        backgroundColor: Colors.grey[900],
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: FutureBuilder<ClientModel?>(
        future: firestoreService.getClientById(clientId),
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
                    'Error loading client',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: RetroColors.neonPink,
                        ),
                  ),
                ],
              ),
            );
          }

          // Client not found
          if (!snapshot.hasData || snapshot.data == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.person_outline,
                      size: 48, color: RetroColors.neonCyan),
                  const SizedBox(height: 16),
                  Text(
                    'Client not found',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: RetroColors.neonCyan,
                        ),
                  ),
                ],
              ),
            );
          }

          final client = snapshot.data!;
          return _ClientDetailContent(client: client);
        },
      ),
    );
  }
}

/// Client detail content widget
class _ClientDetailContent extends StatelessWidget {
  final ClientModel client;

  const _ClientDetailContent({required this.client});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Client name and status
          Row(
            children: [
              Expanded(
                child: Text(
                  client.name,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color:
                      client.isActive ? Colors.green[700] : Colors.grey[700],
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  client.isActive ? 'ACTIVE' : 'INACTIVE',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Contact Information Section
          _SectionTitle(title: 'Contact Information'),
          const SizedBox(height: 12),

          _ContactInfoRow(
            icon: Icons.email,
            label: 'Email',
            value: client.email.isEmpty ? 'Not provided' : client.email,
            color: RetroColors.neonCyan,
          ),
          const SizedBox(height: 12),

          _ContactInfoRow(
            icon: Icons.phone,
            label: 'Phone',
            value: client.phone.isEmpty ? 'Not provided' : client.phone,
            color: RetroColors.neonCyan,
          ),
          const SizedBox(height: 12),

          _ContactInfoRow(
            icon: Icons.language,
            label: 'Tax ID',
            value: client.taxId.isEmpty ? 'Not provided' : client.taxId,
            color: RetroColors.neonCyan,
          ),
          const SizedBox(height: 20),

          // Address Section
          if (client.address.isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SectionTitle(title: 'Address'),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: Colors.grey[800]!),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (client.address.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Text(
                            client.address,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                      if (client.city.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Text(
                            '${client.city}, ${client.state}',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                      if (client.zipCode.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Text(
                            client.zipCode,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                      if (client.country.isNotEmpty)
                        Text(
                          client.country,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),

          // Financial Information Section
          _SectionTitle(title: 'Financial Information'),
          const SizedBox(height: 12),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: RetroColors.neonGreen.withOpacity(0.1),
              border: Border.all(
                color: RetroColors.neonGreen,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total Amount Spent',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: Colors.grey[400],
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '\$${client.totalSpent.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                            color: RetroColors.neonGreen,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
                Icon(
                  Icons.trending_up,
                  size: 48,
                  color: RetroColors.neonGreen.withOpacity(0.6),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Timestamps
          _SectionTitle(title: 'Details'),
          const SizedBox(height: 12),

          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: Colors.grey[800]!),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _TimestampRow(
                  label: 'Created',
                  date: client.createdAt,
                ),
                const SizedBox(height: 8),
                Container(
                  height: 1,
                  color: Colors.grey[800],
                ),
                const SizedBox(height: 8),
                _TimestampRow(
                  label: 'Last Updated',
                  date: client.updatedAt,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Section title widget
class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: RetroColors.neonCyan,
            fontWeight: FontWeight.bold,
          ),
    );
  }
}

/// Contact info row widget
class _ContactInfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _ContactInfoRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.grey[800]!),
      ),
      child: Row(
        children: [
          Icon(icon, size: 24, color: color),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Colors.grey[400],
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.white,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Timestamp row widget
class _TimestampRow extends StatelessWidget {
  final String label;
  final DateTime date;

  const _TimestampRow({
    required this.label,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: Colors.grey[400],
              ),
        ),
        Text(
          '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}',
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: RetroColors.neonCyan,
              ),
        ),
      ],
    );
  }
}
