import 'package:flutter/material.dart';
import '../utils/responsive_helper.dart';
import '../constants/retro_theme.dart';
import '../widgets/retro_widgets.dart';

/// Responsive Home Screen for TaskPilot
/// Implements MediaQuery, Flexible/Adaptive widgets, and device-specific layouts
class ResponsiveHome extends StatefulWidget {
  const ResponsiveHome({Key? key}) : super(key: key);

  @override
  State<ResponsiveHome> createState() => _ResponsiveHomeState();
}

class _ResponsiveHomeState extends State<ResponsiveHome> {
  int _selectedIndex = 0;
  bool _showSidebar = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Get responsive helper for this build context
        final responsive = context.responsive;

        return Scaffold(
          backgroundColor: RetroColors.retroWhite,
          appBar: _buildAppBar(context, responsive),
          body: SafeArea(
            child: responsive.isDesktop || responsive.isTablet
                ? _buildDesktopLayout(context, responsive)
                : _buildMobileLayout(context, responsive),
          ),
          bottomNavigationBar: responsive.isMobile
              ? _buildBottomNavBar(context, responsive)
              : null,
          drawer: responsive.isMobile && _showSidebar
              ? _buildDrawer(context, responsive)
              : null,
        );
      },
    );
  }

  /// Build responsive AppBar
  PreferredSizeWidget _buildAppBar(
    BuildContext context,
    ResponsiveHelper responsive,
  ) {
    return AppBar(
      backgroundColor: RetroColors.neonPurple.withOpacity(0.9),
      elevation: 8,
      title: Text(
        'TaskPilot',
        style: RetroTypography.retroDisplayMedium.copyWith(
          fontSize: responsive.responsiveFontSize(
            mobileSize: 20,
            tabletSize: 24,
            desktopSize: 28,
          ),
        ),
      ),
      centerTitle: false,
      actions: responsive.isMobile
          ? [
              IconButton(
                icon: const Icon(Icons.menu, color: RetroColors.retroWhite),
                onPressed: () => setState(() => _showSidebar = !_showSidebar),
              ),
            ]
          : [
              // Desktop actions
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: responsive.responsiveDimension(
                    mobileSize: 8,
                    tabletSize: 16,
                    desktopSize: 24,
                  ),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.notifications_active,
                          color: RetroColors.retroWhite),
                      onPressed: () {},
                      tooltip: 'Notifications',
                    ),
                    IconButton(
                      icon: const Icon(Icons.person,
                          color: RetroColors.retroWhite),
                      onPressed: () {},
                      tooltip: 'Profile',
                    ),
                    IconButton(
                      icon: const Icon(Icons.settings,
                          color: RetroColors.retroWhite),
                      onPressed: () {},
                      tooltip: 'Settings',
                    ),
                  ],
                ),
              ),
            ],
    );
  }

  /// Build desktop/tablet layout (multi-column)
  Widget _buildDesktopLayout(
    BuildContext context,
    ResponsiveHelper responsive,
  ) {
    return Row(
      children: [
        // Sidebar (visible on desktop/tablet)
        if (!responsive.isMobile)
          Expanded(
            flex: responsive.isDesktop ? 1 : 1,
            child: _buildSidebarContent(context, responsive),
          ),
        // Main content area
        Expanded(
          flex: responsive.isDesktop ? 3 : 2,
          child: _buildMainContent(context, responsive),
        ),
        // Right panel (visible only on desktop)
        if (responsive.isDesktop)
          Expanded(
            flex: 1,
            child: _buildRightPanel(context, responsive),
          ),
      ],
    );
  }

  /// Build mobile layout (single column)
  Widget _buildMobileLayout(
    BuildContext context,
    ResponsiveHelper responsive,
  ) {
    return SingleChildScrollView(
      child: _buildMainContent(context, responsive),
    );
  }

  /// Build sidebar content
  Widget _buildSidebarContent(
    BuildContext context,
    ResponsiveHelper responsive,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: RetroColors.retroDarkGray.withOpacity(0.05),
        border: Border(
          right: BorderSide(
            color: RetroColors.neonPurple.withOpacity(0.3),
            width: 2,
          ),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: responsive.percentHeight(3)),
            _buildSidebarItem(
              icon: Icons.dashboard,
              label: 'Dashboard',
              isSelected: _selectedIndex == 0,
              onTap: () => setState(() => _selectedIndex = 0),
            ),
            _buildSidebarItem(
              icon: Icons.assignment,
              label: 'Tasks',
              isSelected: _selectedIndex == 1,
              onTap: () => setState(() => _selectedIndex = 1),
            ),
            _buildSidebarItem(
              icon: Icons.person_outline,
              label: 'Clients',
              isSelected: _selectedIndex == 2,
              onTap: () => setState(() => _selectedIndex = 2),
            ),
            _buildSidebarItem(
              icon: Icons.payments,
              label: 'Payments',
              isSelected: _selectedIndex == 3,
              onTap: () => setState(() => _selectedIndex = 3),
            ),
            _buildSidebarItem(
              icon: Icons.bar_chart,
              label: 'Analytics',
              isSelected: _selectedIndex == 4,
              onTap: () => setState(() => _selectedIndex = 4),
            ),
          ],
        ),
      ),
    );
  }

  /// Build sidebar menu item
  Widget _buildSidebarItem({
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: RetroSpacing.md,
        vertical: RetroSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: isSelected
            ? RetroColors.neonPurple.withOpacity(0.2)
            : Colors.transparent,
        border: isSelected
            ? Border.all(
                color: RetroColors.neonPurple,
                width: 2,
              )
            : null,
        borderRadius: BorderRadius.circular(RetroBorderRadius.sm),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isSelected ? RetroColors.neonPurple : RetroColors.retroGray,
        ),
        title: Text(
          label,
          style: RetroTypography.retroBody.copyWith(
            color: isSelected
                ? RetroColors.neonPurple
                : RetroColors.retroBlack,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
        onTap: onTap,
      ),
    );
  }

  /// Build main dashboard content
  Widget _buildMainContent(
    BuildContext context,
    ResponsiveHelper responsive,
  ) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(
        responsive.responsiveDimension(
          mobileSize: 12,
          tabletSize: 20,
          desktopSize: 24,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Statistics Cards Row
          _buildStatisticsRow(context, responsive),
          SizedBox(height: responsive.percentHeight(3)),
          // Tasks Section
          _buildTasksSection(context, responsive),
          SizedBox(height: responsive.percentHeight(3)),
          // Recent Activity Section
          _buildRecentActivitySection(context, responsive),
        ],
      ),
    );
  }

  /// Build statistics row with responsive grid
  Widget _buildStatisticsRow(
    BuildContext context,
    ResponsiveHelper responsive,
  ) {
    final List<Map<String, dynamic>> stats = [
      {
        'title': 'Active Tasks',
        'value': '12',
        'icon': Icons.assignment,
        'color': RetroColors.neonCyan,
      },
      {
        'title': 'Pending Payments',
        'value': '\$2,450',
        'icon': Icons.payments,
        'color': RetroColors.neonOrange,
      },
      {
        'title': 'Clients',
        'value': '8',
        'icon': Icons.person,
        'color': RetroColors.neonGreen,
      },
      {
        'title': 'Completion Rate',
        'value': '85%',
        'icon': Icons.trending_up,
        'color': RetroColors.neonPink,
      },
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        // Determine grid columns based on responsive type
        int crossAxisCount = responsive.isMobile
            ? 2
            : responsive.isTablet
                ? 2
                : 4;

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: responsive.isMobile ? 1.2 : 1.1,
            crossAxisSpacing: responsive.responsiveDimension(
              mobileSize: 8,
              tabletSize: 12,
              desktopSize: 16,
            ),
            mainAxisSpacing: responsive.responsiveDimension(
              mobileSize: 8,
              tabletSize: 12,
              desktopSize: 16,
            ),
          ),
          itemCount: stats.length,
          itemBuilder: (context, index) {
            final stat = stats[index];
            return _buildStatCard(
              context,
              responsive,
              stat['title'],
              stat['value'],
              stat['icon'],
              stat['color'],
            );
          },
        );
      },
    );
  }

  /// Build individual stat card
  Widget _buildStatCard(
    BuildContext context,
    ResponsiveHelper responsive,
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return RetroCard(
      backgroundColor: color.withOpacity(0.1),
      borderColor: color,
      padding: EdgeInsets.all(responsive.responsiveDimension(
        mobileSize: 12,
        tabletSize: 16,
        desktopSize: 20,
      )),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Icon(
              icon,
              color: color,
              size: responsive.responsiveDimension(
                mobileSize: 24,
                tabletSize: 28,
                desktopSize: 32,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: RetroTypography.retroTitle.copyWith(
                  fontSize: responsive.responsiveFontSize(
                    mobileSize: 18,
                    tabletSize: 20,
                    desktopSize: 24,
                  ),
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: responsive.percentHeight(0.5)),
              Text(
                title,
                style: RetroTypography.retroLabel.copyWith(
                  fontSize: responsive.responsiveFontSize(
                    mobileSize: 10,
                    tabletSize: 11,
                    desktopSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Build tasks section
  Widget _buildTasksSection(
    BuildContext context,
    ResponsiveHelper responsive,
  ) {
    final tasks = [
      {
        'title': 'Mobile App UI Design',
        'description': 'Design retro-style dashboard',
        'deadline': 'Feb 20',
        'status': 'In Progress',
        'priority': RetroColors.neonCyan,
      },
      {
        'title': 'Backend API Integration',
        'description': 'Connect Firebase & n8n webhooks',
        'deadline': 'Feb 22',
        'status': 'To Do',
        'priority': RetroColors.neonOrange,
      },
      {
        'title': 'Payment Module Testing',
        'description': 'Test payment workflows',
        'deadline': 'Feb 25',
        'status': 'To Do',
        'priority': RetroColors.neonPink,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RetroHeader(
          title: 'Active Tasks',
          subtitle: 'You have 3 active tasks this week',
          actions: [
            RetroButton(
              label: '+ New Task',
              onPressed: () {},
              width: responsive.responsiveDimension(
                mobileSize: 80,
                tabletSize: 100,
                desktopSize: 120,
              ),
              height: responsive.responsiveDimension(
                mobileSize: 36,
                tabletSize: 40,
                desktopSize: 44,
              ),
            ),
          ],
        ),
        SizedBox(height: responsive.percentHeight(1.5)),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: responsive.isMobile
                ? 1
                : responsive.isTablet
                    ? 2
                    : 3,
            childAspectRatio: responsive.isMobile ? 1.4 : 1.3,
            crossAxisSpacing: responsive.responsiveDimension(
              mobileSize: 8,
              tabletSize: 12,
              desktopSize: 16,
            ),
            mainAxisSpacing: responsive.responsiveDimension(
              mobileSize: 8,
              tabletSize: 12,
              desktopSize: 16,
            ),
          ),
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            final task = tasks[index];
            return RetroTaskCard(
              title: task['title'] as String,
              description: task['description'] as String,
              deadline: task['deadline'] as String,
              status: task['status'] as String,
              priorityColor: task['priority'] as Color,
              onTap: () {},
            );
          },
        ),
      ],
    );
  }

  /// Build recent activity section
  Widget _buildRecentActivitySection(
    BuildContext context,
    ResponsiveHelper responsive,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RetroHeader(
          title: 'Recent Activity',
          subtitle: 'Latest updates from your tasks',
        ),
        SizedBox(height: responsive.percentHeight(1.5)),
        ...List.generate(
          4,
          (index) => Padding(
            padding: EdgeInsets.only(
              bottom: responsive.responsiveDimension(
                mobileSize: 8,
                tabletSize: 12,
                desktopSize: 16,
              ),
            ),
            child: _buildActivityItem(context, responsive, index),
          ),
        ),
      ],
    );
  }

  /// Build activity item
  Widget _buildActivityItem(
    BuildContext context,
    ResponsiveHelper responsive,
    int index,
  ) {
    final activities = [
      'Task "Mobile App UI Design" marked as in progress',
      'Payment received from Client A - \$500',
      'Deadline reminder: "Backend API Integration" due in 2 days',
      'New task created: "Project Documentation"',
    ];

    return RetroCard(
      backgroundColor: RetroColors.retroWhite,
      padding: EdgeInsets.all(responsive.responsiveDimension(
        mobileSize: 12,
        tabletSize: 16,
        desktopSize: 20,
      )),
      child: Row(
        children: [
          Container(
            width: responsive.responsiveDimension(
              mobileSize: 12,
              tabletSize: 14,
              desktopSize: 16,
            ),
            height: responsive.responsiveDimension(
              mobileSize: 12,
              tabletSize: 14,
              desktopSize: 16,
            ),
            decoration: BoxDecoration(
              color: RetroColors.neonPurple,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: responsive.responsiveDimension(
            mobileSize: 12,
            tabletSize: 16,
            desktopSize: 20,
          )),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activities[index],
                  style: RetroTypography.retroBody,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: responsive.percentHeight(0.5)),
                Text(
                  '${2 - index} hours ago',
                  style: RetroTypography.retroLabel,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Build right panel (desktop only)
  Widget _buildRightPanel(
    BuildContext context,
    ResponsiveHelper responsive,
  ) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(responsive.responsiveDimension(
        mobileSize: 12,
        tabletSize: 16,
        desktopSize: 20,
      )),
      child: Column(
        children: [
          RetroHeader(title: 'Quick Actions'),
          SizedBox(height: responsive.percentHeight(2)),
          RetroButton(
            label: 'Create Task',
            onPressed: () {},
            width: double.infinity,
          ),
          SizedBox(height: responsive.percentHeight(1.5)),
          RetroButton(
            label: 'Add Client',
            onPressed: () {},
            width: double.infinity,
            backgroundColor: RetroColors.neonOrange,
          ),
          SizedBox(height: responsive.percentHeight(1.5)),
          RetroButton(
            label: 'View Reports',
            onPressed: () {},
            width: double.infinity,
            backgroundColor: RetroColors.neonGreen,
          ),
          SizedBox(height: responsive.percentHeight(3)),
          RetroHeader(title: 'Upcoming Deadlines'),
          SizedBox(height: responsive.percentHeight(1.5)),
          _buildDeadlineItem(
            context,
            responsive,
            'Mobile UI Design',
            'Feb 20',
            RetroColors.neonCyan,
          ),
          _buildDeadlineItem(
            context,
            responsive,
            'Backend Integration',
            'Feb 22',
            RetroColors.neonOrange,
          ),
          _buildDeadlineItem(
            context,
            responsive,
            'Payment Testing',
            'Feb 25',
            RetroColors.neonPink,
          ),
        ],
      ),
    );
  }

  /// Build deadline item
  Widget _buildDeadlineItem(
    BuildContext context,
    ResponsiveHelper responsive,
    String title,
    String deadline,
    Color color,
  ) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: responsive.percentHeight(1),
      ),
      child: RetroCard(
        backgroundColor: color.withOpacity(0.1),
        borderColor: color,
        padding: EdgeInsets.all(responsive.responsiveDimension(
          mobileSize: 8,
          tabletSize: 10,
          desktopSize: 12,
        )),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                title,
                style: RetroTypography.retroBody,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            RetroStatusBadge(
              label: deadline,
              backgroundColor: color,
              textColor: RetroColors.retroWhite,
            ),
          ],
        ),
      ),
    );
  }

  /// Build bottom navigation bar (mobile only)
  BottomNavigationBar _buildBottomNavBar(
    BuildContext context,
    ResponsiveHelper responsive,
  ) {
    return BottomNavigationBar(
      backgroundColor: RetroColors.neonPurple.withOpacity(0.9),
      selectedItemColor: RetroColors.neonCyan,
      unselectedItemColor: RetroColors.retroWhite.withOpacity(0.6),
      currentIndex: _selectedIndex,
      onTap: (index) => setState(() => _selectedIndex = index),
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.dashboard),
          label: 'Dashboard',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.assignment),
          label: 'Tasks',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Clients',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.payments),
          label: 'Payments',
        ),
      ],
    );
  }

  /// Build drawer for mobile
  Drawer _buildDrawer(
    BuildContext context,
    ResponsiveHelper responsive,
  ) {
    return Drawer(
      child: SafeArea(
        child: _buildSidebarContent(context, responsive),
      ),
    );
  }
}
