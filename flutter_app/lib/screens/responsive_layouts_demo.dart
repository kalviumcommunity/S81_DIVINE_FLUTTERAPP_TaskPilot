import 'package:flutter/material.dart';
import '../constants/retro_theme.dart';
import '../utils/responsive_helper.dart';

/// Responsive Layouts Demo
///
/// Demonstrates:
/// 1. Container - Flexible box with padding, margin, decoration
/// 2. Row - Horizontal layout with alignment control
/// 3. Column - Vertical layout with spacing control
/// 4. Responsive design patterns - Mobile, tablet, desktop
/// 5. MediaQuery usage - Detecting screen size and orientation
/// 6. Flexible and Expanded widgets - Proportional sizing
/// 7. Nested layouts - Complex hierarchical structures

class ResponsiveLayoutsDemoScreen extends StatefulWidget {
  const ResponsiveLayoutsDemoScreen({Key? key}) : super(key: key);

  @override
  State<ResponsiveLayoutsDemoScreen> createState() =>
      _ResponsiveLayoutsDemoScreenState();
}

class _ResponsiveLayoutsDemoScreenState extends State<ResponsiveLayoutsDemoScreen> {
  int _selectedLayoutExample = 0;
  bool _showDetailedExplanation = false;

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return Scaffold(
      appBar: AppBar(
        title: const Text('📐 Responsive Layouts'),
        centerTitle: true,
        backgroundColor: RetroColors.retroYellow,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(responsive.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Overview Card
            _buildOverviewCard(responsive),
            SizedBox(height: responsive.spacingMedium),

            // Layout Examples Selector
            _buildLayoutSelector(responsive),
            SizedBox(height: responsive.spacingMedium),

            // Dynamic Content Based on Selection
            _buildSelectedLayoutDemo(responsive),
            SizedBox(height: responsive.spacingMedium),

            // Explanation Toggle
            _buildExplanationSection(responsive),
            SizedBox(height: responsive.spacingLarge),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewCard(ResponsiveHelper responsive) {
    return Container(
      decoration: BoxDecoration(
        color: RetroColors.retroYellow.withOpacity(0.1),
        border: Border.all(color: RetroColors.retroYellow, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: EdgeInsets.all(responsive.paddingMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '🎯 Layout Building Blocks',
            style: TextStyle(
              fontSize: responsive.responsiveFontSize(
                mobileSize: 16,
                tabletSize: 18,
                desktopSize: 20,
              ),
              fontWeight: FontWeight.bold,
              color: RetroColors.retroYellow,
            ),
          ),
          SizedBox(height: responsive.spacingSmall),
          Text(
            'Rows, Columns, and Containers form the foundation of Flutter layouts. '
            'Master these widgets to create responsive designs that work across all device sizes.',
            style: TextStyle(
              fontSize: responsive.responsiveFontSize(
                mobileSize: 13,
                tabletSize: 14,
                desktopSize: 15,
              ),
            ),
          ),
          SizedBox(height: responsive.spacingMedium),
          // Device Info
          Container(
            padding: EdgeInsets.all(responsive.paddingSmall),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Current Device Info:',
                  style: TextStyle(
                    color: RetroColors.retroYellow,
                    fontWeight: FontWeight.bold,
                    fontSize: responsive.responsiveFontSize(
                      mobileSize: 12,
                      tabletSize: 13,
                      desktopSize: 14,
                    ),
                  ),
                ),
                SizedBox(height: responsive.spacingSmall),
                Text(
                  'Type: ${responsive.isMobile ? "📱 Mobile" : responsive.isTablet ? "📱 Tablet" : "🖥️ Desktop"}',
                  style: TextStyle(
                    color: Colors.green[400],
                    fontSize: responsive.responsiveFontSize(
                      mobileSize: 11,
                      tabletSize: 12,
                      desktopSize: 13,
                    ),
                  ),
                ),
                Text(
                  'Width: ${MediaQuery.of(context).size.width.toStringAsFixed(0)}px',
                  style: TextStyle(
                    color: Colors.green[400],
                    fontSize: responsive.responsiveFontSize(
                      mobileSize: 11,
                      tabletSize: 12,
                      desktopSize: 13,
                    ),
                  ),
                ),
                Text(
                  'Orientation: ${MediaQuery.of(context).orientation == Orientation.portrait ? "🔝 Portrait" : "◀️ Landscape"}',
                  style: TextStyle(
                    color: Colors.green[400],
                    fontSize: responsive.responsiveFontSize(
                      mobileSize: 11,
                      tabletSize: 12,
                      desktopSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLayoutSelector(ResponsiveHelper responsive) {
    final examples = [
      '1️⃣ Containers',
      '2️⃣ Rows',
      '3️⃣ Columns',
      '4️⃣ Mixed Layout',
      '5️⃣ Adaptive Grid',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '📚 Example Library',
          style: TextStyle(
            fontSize: responsive.responsiveFontSize(
              mobileSize: 14,
              tabletSize: 15,
              desktopSize: 16,
            ),
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: responsive.spacingSmall),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(examples.length, (index) {
              final isSelected = _selectedLayoutExample == index;
              return Padding(
                padding: EdgeInsets.only(right: responsive.spacingSmall),
                child: ElevatedButton(
                  onPressed: () {
                    setState(() => _selectedLayoutExample = index);
                    debugPrint('📐 [Layout] Selected: ${examples[index]}');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isSelected
                        ? RetroColors.retroYellow
                        : RetroColors.retroYellow.withOpacity(0.4),
                    foregroundColor: isSelected
                        ? Colors.black
                        : Colors.black.withOpacity(0.6),
                    padding: EdgeInsets.symmetric(
                      horizontal: responsive.paddingMedium,
                      vertical: responsive.paddingSmall,
                    ),
                  ),
                  child: Text(
                    examples[index],
                    style: TextStyle(
                      fontSize: responsive.responsiveFontSize(
                        mobileSize: 11,
                        tabletSize: 12,
                        desktopSize: 13,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildSelectedLayoutDemo(ResponsiveHelper responsive) {
    switch (_selectedLayoutExample) {
      case 0:
        return _buildContainersExample(responsive);
      case 1:
        return _buildRowsExample(responsive);
      case 2:
        return _buildColumnsExample(responsive);
      case 3:
        return _buildMixedLayoutExample(responsive);
      case 4:
        return _buildAdaptiveGridExample(responsive);
      default:
        return const SizedBox();
    }
  }

  Widget _buildContainersExample(ResponsiveHelper responsive) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Containers: Flexible Boxes',
          style: TextStyle(
            fontSize: responsive.responsiveFontSize(
              mobileSize: 15,
              tabletSize: 16,
              desktopSize: 17,
            ),
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: responsive.spacingMedium),
        // Example 1: Basic Container
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(responsive.paddingMedium),
          decoration: BoxDecoration(
            color: RetroColors.retroBlue.withOpacity(0.2),
            border: Border.all(color: RetroColors.retroBlue, width: 2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Basic Container',
                style: TextStyle(
                  fontSize: responsive.responsiveFontSize(
                    mobileSize: 13,
                    tabletSize: 14,
                    desktopSize: 15,
                  ),
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: responsive.spacingSmall),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(responsive.paddingMedium),
                decoration: BoxDecoration(
                  color: RetroColors.retroBlue,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'Container with padding, color, and border radius',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: responsive.responsiveFontSize(
                      mobileSize: 12,
                      tabletSize: 13,
                      desktopSize: 14,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: responsive.spacingMedium),
        // Example 2: Container with Different Sizes
        Container(
          padding: EdgeInsets.all(responsive.paddingMedium),
          decoration: BoxDecoration(
            color: RetroColors.retroGreen.withOpacity(0.2),
            border: Border.all(color: RetroColors.retroGreen, width: 2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Containers with Proportional Sizing',
                style: TextStyle(
                  fontSize: responsive.responsiveFontSize(
                    mobileSize: 13,
                    tabletSize: 14,
                    desktopSize: 15,
                  ),
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: responsive.spacingSmall),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      height: 60,
                      decoration: BoxDecoration(
                        color: RetroColors.retroGreen,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Center(
                        child: Text(
                          'Flex: 1',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: responsive.responsiveFontSize(
                              mobileSize: 11,
                              tabletSize: 12,
                              desktopSize: 13,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: responsive.spacingSmall),
                  Expanded(
                    flex: 2,
                    child: Container(
                      height: 60,
                      decoration: BoxDecoration(
                        color: RetroColors.retroGreen,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Center(
                        child: Text(
                          'Flex: 2',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: responsive.responsiveFontSize(
                              mobileSize: 11,
                              tabletSize: 12,
                              desktopSize: 13,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRowsExample(ResponsiveHelper responsive) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Rows: Horizontal Layouts',
          style: TextStyle(
            fontSize: responsive.responsiveFontSize(
              mobileSize: 15,
              tabletSize: 16,
              desktopSize: 17,
            ),
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: responsive.spacingMedium),
        // Example 1: Row with MainAxisAlignment
        Container(
          padding: EdgeInsets.all(responsive.paddingMedium),
          decoration: BoxDecoration(
            color: RetroColors.retroRed.withOpacity(0.2),
            border: Border.all(color: RetroColors.retroRed, width: 2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Row with MainAxisAlignment.spaceEvenly',
                style: TextStyle(
                  fontSize: responsive.responsiveFontSize(
                    mobileSize: 13,
                    tabletSize: 14,
                    desktopSize: 15,
                  ),
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: responsive.spacingMedium),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(responsive.paddingSmall),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildLayoutBox('Item 1', ResponsiveHelper(context)),
                    _buildLayoutBox('Item 2', ResponsiveHelper(context)),
                    _buildLayoutBox('Item 3', ResponsiveHelper(context)),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: responsive.spacingMedium),
        // Example 2: Row with Different Alignments
        Container(
          padding: EdgeInsets.all(responsive.paddingMedium),
          decoration: BoxDecoration(
            color: RetroColors.retroPink.withOpacity(0.2),
            border: Border.all(color: RetroColors.retroPink, width: 2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Row with MainAxisAlignment.spaceBetween',
                style: TextStyle(
                  fontSize: responsive.responsiveFontSize(
                    mobileSize: 13,
                    tabletSize: 14,
                    desktopSize: 15,
                  ),
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: responsive.spacingMedium),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(responsive.paddingSmall),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildLayoutBox('Start', ResponsiveHelper(context)),
                    _buildLayoutBox('Center', ResponsiveHelper(context)),
                    _buildLayoutBox('End', ResponsiveHelper(context)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildColumnsExample(ResponsiveHelper responsive) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Columns: Vertical Layouts',
          style: TextStyle(
            fontSize: responsive.responsiveFontSize(
              mobileSize: 15,
              tabletSize: 16,
              desktopSize: 17,
            ),
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: responsive.spacingMedium),
        Container(
          padding: EdgeInsets.all(responsive.paddingMedium),
          decoration: BoxDecoration(
            color: Colors.purple.withOpacity(0.2),
            border: Border.all(color: Colors.purple, width: 2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Column with Vertical Spacing',
                style: TextStyle(
                  fontSize: responsive.responsiveFontSize(
                    mobileSize: 13,
                    tabletSize: 14,
                    desktopSize: 15,
                  ),
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: responsive.spacingMedium),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildLayoutBox('Header', ResponsiveHelper(context)),
                  SizedBox(height: responsive.spacingMedium),
                  _buildLayoutBox('Content Area', ResponsiveHelper(context)),
                  SizedBox(height: responsive.spacingMedium),
                  Row(
                    children: [
                      Expanded(
                        child: _buildLayoutBox('Footer Left', ResponsiveHelper(context)),
                      ),
                      SizedBox(width: responsive.spacingSmall),
                      Expanded(
                        child: _buildLayoutBox('Footer Right', ResponsiveHelper(context)),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMixedLayoutExample(ResponsiveHelper responsive) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Mixed Layout: Complex Hierarchies',
          style: TextStyle(
            fontSize: responsive.responsiveFontSize(
              mobileSize: 15,
              tabletSize: 16,
              desktopSize: 17,
            ),
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: responsive.spacingMedium),
        // Header
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(responsive.paddingMedium),
          decoration: BoxDecoration(
            color: RetroColors.neonCyan.withOpacity(0.3),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            'Header Section',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: responsive.responsiveFontSize(
                mobileSize: 13,
                tabletSize: 14,
                desktopSize: 15,
              ),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: responsive.spacingMedium),
        // Content Row
        responsive.isMobile
            ? Column(
                children: [
                  _buildLayoutBox('Left Panel', ResponsiveHelper(context)),
                  SizedBox(height: responsive.spacingSmall),
                  _buildLayoutBox('Right Panel', ResponsiveHelper(context)),
                ],
              )
            : Row(
                children: [
                  Expanded(
                    child: _buildLayoutBox('Left Panel', ResponsiveHelper(context)),
                  ),
                  SizedBox(width: responsive.spacingSmall),
                  Expanded(
                    child: _buildLayoutBox('Right Panel', ResponsiveHelper(context)),
                  ),
                ],
              ),
        SizedBox(height: responsive.spacingMedium),
        // Footer
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(responsive.paddingMedium),
          decoration: BoxDecoration(
            color: RetroColors.neonCyan.withOpacity(0.3),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            '© 2026 TaskPilot | Responsive Layout Demo',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: responsive.responsiveFontSize(
                mobileSize: 10,
                tabletSize: 11,
                desktopSize: 12,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAdaptiveGridExample(ResponsiveHelper responsive) {
    final items = List.generate(6, (i) => 'Item ${i + 1}');
    final columns = responsive.gridColumns;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Adaptive Grid Layout',
          style: TextStyle(
            fontSize: responsive.responsiveFontSize(
              mobileSize: 15,
              tabletSize: 16,
              desktopSize: 17,
            ),
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: responsive.spacingSmall),
        Text(
          'Grid columns: $columns (responsive to device width)',
          style: TextStyle(
            fontSize: responsive.responsiveFontSize(
              mobileSize: 11,
              tabletSize: 12,
              desktopSize: 13,
            ),
            fontStyle: FontStyle.italic,
          ),
        ),
        SizedBox(height: responsive.spacingMedium),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            childAspectRatio: 1.0,
            mainAxisSpacing: responsive.spacingSmall,
            crossAxisSpacing: responsive.spacingSmall,
          ),
          itemCount: items.length,
          itemBuilder: (context, index) {
            return Container(
              decoration: BoxDecoration(
                color: [
                  RetroColors.retroBlue,
                  RetroColors.retroGreen,
                  RetroColors.retroYellow,
                  RetroColors.retroRed,
                  RetroColors.retroPink,
                  RetroColors.neonCyan,
                ][index % 6],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  items[index],
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: responsive.responsiveFontSize(
                      mobileSize: 13,
                      tabletSize: 14,
                      desktopSize: 15,
                    ),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildExplanationSection(ResponsiveHelper responsive) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => setState(() => _showDetailedExplanation = !_showDetailedExplanation),
          child: Container(
            padding: EdgeInsets.all(responsive.paddingMedium),
            decoration: BoxDecoration(
              color: RetroColors.retroBlue.withOpacity(0.1),
              border: Border.all(color: RetroColors.retroBlue, width: 2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '💡 Key Concepts',
                  style: TextStyle(
                    fontSize: responsive.responsiveFontSize(
                      mobileSize: 14,
                      tabletSize: 15,
                      desktopSize: 16,
                    ),
                    fontWeight: FontWeight.bold,
                    color: RetroColors.retroBlue,
                  ),
                ),
                Icon(
                  _showDetailedExplanation ? Icons.expand_less : Icons.expand_more,
                  color: RetroColors.retroBlue,
                ),
              ],
            ),
          ),
        ),
        if (_showDetailedExplanation) ...[
          SizedBox(height: responsive.spacingMedium),
          _buildConceptTile(responsive, '📦 Container', 'Flexible box for layout, padding, margin, color, and decoration'),
          SizedBox(height: responsive.spacingSmall),
          _buildConceptTile(responsive, '➡️ Row', 'Arranges children horizontally with mainAxisAlignment and crossAxisAlignment'),
          SizedBox(height: responsive.spacingSmall),
          _buildConceptTile(responsive, '⬇️ Column', 'Arranges children vertically with flexible spacing and alignment'),
          SizedBox(height: responsive.spacingSmall),
          _buildConceptTile(responsive, '📱 MediaQuery', 'Detects screen size, orientation, and device properties'),
          SizedBox(height: responsive.spacingSmall),
          _buildConceptTile(responsive, '🔄 Expanded', 'Makes child take available space proportionally (flex property)'),
          SizedBox(height: responsive.spacingSmall),
          _buildConceptTile(responsive, '📐 GridView', 'Creates responsive grid layouts that adapt to screen size'),
        ],
      ],
    );
  }

  Widget _buildConceptTile(ResponsiveHelper responsive, String title, String description) {
    return Container(
      padding: EdgeInsets.all(responsive.paddingSmall),
      decoration: BoxDecoration(
        border: Border.all(color: RetroColors.retroBlue.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: responsive.responsiveFontSize(
                mobileSize: 12,
                tabletSize: 13,
                desktopSize: 14,
              ),
              fontWeight: FontWeight.bold,
              color: RetroColors.retroBlue,
            ),
          ),
          SizedBox(height: 4),
          Text(
            description,
            style: TextStyle(
              fontSize: responsive.responsiveFontSize(
                mobileSize: 11,
                tabletSize: 12,
                desktopSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLayoutBox(String label, ResponsiveHelper responsive) {
    return Container(
      padding: EdgeInsets.all(responsive.paddingSmall),
      decoration: BoxDecoration(
        color: RetroColors.retroBlue,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
          fontSize: responsive.responsiveFontSize(
            mobileSize: 11,
            tabletSize: 12,
            desktopSize: 13,
          ),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
