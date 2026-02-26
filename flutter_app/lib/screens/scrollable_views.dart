import 'package:flutter/material.dart';

import '../constants/retro_theme.dart';
import '../widgets/retro_widgets.dart';

class ScrollableViewsScreen extends StatelessWidget {
  const ScrollableViewsScreen({Key? key}) : super(key: key);

  static const List<Color> _tileColors = [
    RetroColors.neonPurple,
    RetroColors.neonCyan,
    RetroColors.neonPink,
    RetroColors.neonGreen,
    RetroColors.neonOrange,
    RetroColors.retroBlue,
    RetroColors.retroGreen,
    RetroColors.retroYellow,
    RetroColors.retroRed,
  ];

  static const List<_HScrollCard> _listCards = [
    _HScrollCard(title: 'Inbox', subtitle: '3 new tasks', icon: Icons.inbox),
    _HScrollCard(title: 'Today', subtitle: '5 due items', icon: Icons.today),
    _HScrollCard(
      title: 'In Progress',
      subtitle: '2 active',
      icon: Icons.timelapse,
    ),
    _HScrollCard(
      title: 'Completed',
      subtitle: '12 done',
      icon: Icons.verified,
    ),
    _HScrollCard(
      title: 'Blocked',
      subtitle: '1 waiting',
      icon: Icons.block,
    ),
  ];

  static const List<_GridTile> _gridTiles = [
    _GridTile(label: 'Design', icon: Icons.palette),
    _GridTile(label: 'Build', icon: Icons.build),
    _GridTile(label: 'Test', icon: Icons.bug_report),
    _GridTile(label: 'Ship', icon: Icons.rocket_launch),
    _GridTile(label: 'Docs', icon: Icons.description),
    _GridTile(label: 'Review', icon: Icons.rate_review),
    _GridTile(label: 'Support', icon: Icons.support_agent),
    _GridTile(label: 'Ideas', icon: Icons.lightbulb),
    _GridTile(label: 'Archive', icon: Icons.archive),
    _GridTile(label: 'Settings', icon: Icons.settings),
    _GridTile(label: 'Profile', icon: Icons.person),
    _GridTile(label: 'Insights', icon: Icons.insights),
  ];

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Scrollable Views'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final crossAxisCount = _crossAxisCountForWidth(constraints.maxWidth);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(RetroSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ListView (horizontal)',
                  style: textTheme.headlineSmall,
                ),
                const SizedBox(height: RetroSpacing.sm),
                Text(
                  'Efficient for long/dynamic lists using ListView.builder.',
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: RetroSpacing.md),
                SizedBox(
                  height: 140,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _listCards.length,
                    itemBuilder: (context, index) {
                      final card = _listCards[index];
                      return Padding(
                        padding: EdgeInsets.only(
                          right: index == _listCards.length - 1
                              ? 0
                              : RetroSpacing.md,
                        ),
                        child: SizedBox(
                          width: 220,
                          child: RetroCard(
                            child: Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor:
                                      colorScheme.secondary.withOpacity(0.15),
                                  child: Icon(
                                    card.icon,
                                    color: colorScheme.primary,
                                  ),
                                ),
                                const SizedBox(width: RetroSpacing.md),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        card.title,
                                        style: textTheme.titleMedium,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        card.subtitle,
                                        style: textTheme.bodyMedium?.copyWith(
                                          color: colorScheme.onSurfaceVariant,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: RetroSpacing.lg),
                const Divider(thickness: 2),
                const SizedBox(height: RetroSpacing.lg),
                Text(
                  'GridView (responsive)',
                  style: textTheme.headlineSmall,
                ),
                const SizedBox(height: RetroSpacing.sm),
                Text(
                  'Great for galleries/dashboards. Uses GridView.builder for performance.',
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: RetroSpacing.md),
                GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: RetroSpacing.md,
                    mainAxisSpacing: RetroSpacing.md,
                    childAspectRatio: 1.2,
                  ),
                  itemCount: _gridTiles.length,
                  itemBuilder: (context, index) {
                    final tile = _gridTiles[index];
                    final tileColor = _tileColors[index % _tileColors.length];

                    return RetroCard(
                      borderColor: tileColor,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            tile.icon,
                            size: 34,
                            color: tileColor,
                          ),
                          const SizedBox(height: RetroSpacing.sm),
                          Text(
                            tile.label,
                            style: textTheme.titleMedium,
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  int _crossAxisCountForWidth(double width) {
    if (width >= 1200) return 4;
    if (width >= 800) return 3;
    return 2;
  }
}

class _HScrollCard {
  final String title;
  final String subtitle;
  final IconData icon;

  const _HScrollCard({
    required this.title,
    required this.subtitle,
    required this.icon,
  });
}

class _GridTile {
  final String label;
  final IconData icon;

  const _GridTile({required this.label, required this.icon});
}
