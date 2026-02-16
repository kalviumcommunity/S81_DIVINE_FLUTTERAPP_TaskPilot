# Responsive Layouts Guide

## Overview

Building responsive layouts is one of the most critical skills in Flutter development. The three core layout widgets — **Container**, **Row**, and **Column** — form the foundation of virtually every Flutter UI. This guide teaches you how to master these widgets and create layouts that adapt beautifully across mobile phones, tablets, and desktops.

**What You'll Learn:**
- Container widget for box model layouts
- Row widget for horizontal arrangement
- Column widget for vertical arrangement
- Flexible and Expanded widgets for proportional sizing
- MediaQuery for responsive design
- Practical responsive layout patterns
- Common pitfalls and solutions
- Best practices for maintainability

---

## Table of Contents

1. [The Container Widget](#the-container-widget)
2. [The Row Widget](#the-row-widget)
3. [The Column Widget](#the-column-widget)
4. [Flexible and Expanded](#flexible-and-expanded)
5. [Responsive Design with MediaQuery](#responsive-design-with-mediaquery)
6. [Layout Patterns](#layout-patterns)
7. [Nested Layouts](#nested-layouts)
8. [Common Pitfalls](#common-pitfalls)
9. [Best Practices](#best-practices)
10. [Complete Examples](#complete-examples)

---

## The Container Widget

### What is a Container?

A **Container** is a widget that combines common painting, positioning, and sizing widgets. It's essentially a box model element that can hold any widget as its child and control how that widget is displayed.

### Key Properties

```dart
Container(
  // Dimensions
  width: 100,
  height: 100,
  
  // Space around the child
  padding: EdgeInsets.all(16),
  
  // Space around the container
  margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
  
  // Visual styling
  color: Colors.blue,
  decoration: BoxDecoration(
    color: Colors.blue,
    borderRadius: BorderRadius.circular(8),
    border: Border.all(color: Colors.black, width: 2),
    boxShadow: [
      BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 8),
    ],
  ),
  
  // Positioning the child
  alignment: Alignment.center,
  
  // Child widget
  child: Text('Hello World'),
)
```

### Container vs DecoratedBox

**Container** is more flexible but heavier:
```dart
Container(
  padding: EdgeInsets.all(16),
  color: Colors.blue,
  child: child,
)
```

**DecoratedBox** is lighter but less flexible:
```dart
DecoratedBox(
  decoration: BoxDecoration(color: Colors.blue),
  child: Padding(
    padding: EdgeInsets.all(16),
    child: child,
  ),
)
```

### Common Use Cases

1. **Creating spacing and padding:**
```dart
Container(
  padding: EdgeInsets.all(16),
  child: Text('Padded text'),
)
```

2. **Adding background color:**
```dart
Container(
  color: Colors.blueAccent,
  child: Text('Colored background'),
)
```

3. **Styling with borders:**
```dart
Container(
  decoration: BoxDecoration(
    border: Border.all(color: Colors.black, width: 2),
    borderRadius: BorderRadius.circular(8),
  ),
  child: child,
)
```

4. **Creating cards with shadows:**
```dart
Container(
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(8),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.2),
        blurRadius: 8,
      ),
    ],
  ),
  padding: EdgeInsets.all(16),
  child: child,
)
```

---

## The Row Widget

### What is a Row?

A **Row** arranges its children horizontally (left to right). It's the horizontal equivalent of a Column and provides powerful alignment control through `mainAxisAlignment` and `crossAxisAlignment`.

### Key Concepts

**Main Axis:** The horizontal axis (primary direction for Row)
**Cross Axis:** The vertical axis (perpendicular to main axis)

### MainAxisAlignment Options

```dart
Row(
  mainAxisAlignment: MainAxisAlignment.start,      // LEFT align (default)
  children: [Icon(Icons.home), Icon(Icons.search)],
)

Row(
  mainAxisAlignment: MainAxisAlignment.center,     // CENTER align
  children: [Icon(Icons.home), Icon(Icons.search)],
)

Row(
  mainAxisAlignment: MainAxisAlignment.end,        // RIGHT align
  children: [Icon(Icons.home), Icon(Icons.search)],
)

Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,  // Space between items
  children: [Icon(Icons.home), Icon(Icons.search), Icon(Icons.person)],
)

Row(
  mainAxisAlignment: MainAxisAlignment.spaceAround,   // Space around items
  children: [Icon(Icons.home), Icon(Icons.search), Icon(Icons.person)],
)

Row(
  mainAxisAlignment: MainAxisAlignment.spaceEvenly,   // Equal space
  children: [Icon(Icons.home), Icon(Icons.search), Icon(Icons.person)],
)
```

### CrossAxisAlignment Options

```dart
Row(
  crossAxisAlignment: CrossAxisAlignment.start,    // Top align
  children: [
    Icon(Icons.home),
    Text('Short'),
    Text('Very long text that wraps to multiple lines'),
  ],
)

Row(
  crossAxisAlignment: CrossAxisAlignment.center,   // Center vertically (default)
  children: [Icon(Icons.home), Text('Centered')],
)

Row(
  crossAxisAlignment: CrossAxisAlignment.end,      // Bottom align
  children: [Icon(Icons.home), Text('Bottom')],
)

Row(
  crossAxisAlignment: CrossAxisAlignment.stretch,  // Fill height
  children: [
    Icon(Icons.home),
    Expanded(child: Container(color: Colors.blue)),
  ],
)
```

### Common Patterns

1. **Top Navigation Bar:**
```dart
Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    Text('App Title'),
    Row(
      children: [
        IconButton(icon: Icon(Icons.search), onPressed: () {}),
        IconButton(icon: Icon(Icons.settings), onPressed: () {}),
      ],
    ),
  ],
)
```

2. **List Item with Icon and Text:**
```dart
Row(
  children: [
    Icon(Icons.person, size: 40),
    SizedBox(width: 16),
    Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('John Doe', style: TextStyle(fontWeight: FontWeight.bold)),
          Text('john@example.com', style: TextStyle(color: Colors.grey)),
        ],
      ),
    ),
    Icon(Icons.arrow_forward),
  ],
)
```

---

## The Column Widget

### What is a Column?

A **Column** arranges its children vertically (top to bottom). It's the vertical equivalent of a Row with similar alignment controls.

### Key Concepts

**Main Axis:** The vertical axis (primary direction for Column)
**Cross Axis:** The horizontal axis (perpendicular to main axis)

### MainAxisAlignment Options

```dart
Column(
  mainAxisAlignment: MainAxisAlignment.start,      // TOP align (default)
  children: [Text('Item 1'), Text('Item 2')],
)

Column(
  mainAxisAlignment: MainAxisAlignment.center,     // CENTER vertically
  children: [Text('Item 1'), Text('Item 2')],
)

Column(
  mainAxisAlignment: MainAxisAlignment.end,        // BOTTOM align
  children: [Text('Item 1'), Text('Item 2')],
)

Column(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,  // Space between
  children: [Text('Item 1'), Text('Item 2'), Text('Item 3')],
)
```

### CrossAxisAlignment Options

```dart
Column(
  crossAxisAlignment: CrossAxisAlignment.start,    // Left align children
  children: [
    Text('Short'),
    Text('Longer text that is wider'),
  ],
)

Column(
  crossAxisAlignment: CrossAxisAlignment.center,   // Center horizontally (default)
  children: [Text('Item 1'), Text('Item 2')],
)

Column(
  crossAxisAlignment: CrossAxisAlignment.end,      // Right align children
  children: [Text('Item 1'), Text('Item 2')],
)

Column(
  crossAxisAlignment: CrossAxisAlignment.stretch,  // Fill width
  children: [
    Container(color: Colors.blue, child: Text('Full width')),
    Container(color: Colors.red, child: Text('Full width')),
  ],
)
```

### Common Patterns

1. **Card Layout:**
```dart
Column(
  children: [
    Image.network('https://example.com/image.jpg'),
    SizedBox(height: 16),
    Text('Title', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
    SizedBox(height: 8),
    Text('Description here'),
    SizedBox(height: 16),
    ElevatedButton(onPressed: () {}, child: Text('Action')),
  ],
)
```

2. **Form Layout:**
```dart
Column(
  crossAxisAlignment: CrossAxisAlignment.stretch,
  children: [
    TextField(decoration: InputDecoration(hintText: 'Username')),
    SizedBox(height: 16),
    TextField(decoration: InputDecoration(hintText: 'Password')),
    SizedBox(height: 24),
    ElevatedButton(
      onPressed: () {},
      child: Text('Login'),
      style: ElevatedButton.styleFrom(padding: EdgeInsets.symmetric(vertical: 12)),
    ),
  ],
)
```

---

## Flexible and Expanded

### Flexible Widget

**Flexible** lets you control how much space a child takes in a Row/Column:

```dart
Row(
  children: [
    Container(width: 100, color: Colors.blue), // Fixed 100px
    Flexible(
      flex: 2,
      fit: FlexFit.tight,
      child: Container(color: Colors.red), // Takes 2x the remaining space
    ),
    Flexible(
      flex: 1,
      fit: FlexFit.tight,
      child: Container(color: Colors.green), // Takes 1x the remaining space
    ),
  ],
)
```

**flex property:** Determines proportion (1, 2, 3, etc.)
**fit property:** 
- `FlexFit.tight` - Must take assigned space
- `FlexFit.loose` - Takes at most assigned space

### Expanded Widget

**Expanded** is shorthand for `Flexible(fit: FlexFit.tight)`:

```dart
Row(
  children: [
    Expanded(
      flex: 2,
      child: Container(color: Colors.blue), // 2/3 of remaining space
    ),
    Expanded(
      flex: 1,
      child: Container(color: Colors.red), // 1/3 of remaining space
    ),
  ],
)

// Equivalent to:
Row(
  children: [
    Flexible(
      flex: 2,
      fit: FlexFit.tight,
      child: Container(color: Colors.blue),
    ),
    Flexible(
      flex: 1,
      fit: FlexFit.tight,
      child: Container(color: Colors.red),
    ),
  ],
)
```

---

## Responsive Design with MediaQuery

### Getting Screen Size

```dart
// Get screen dimensions
final size = MediaQuery.of(context).size;
final width = size.width;   // Full width
final height = size.height; // Full height

// Get device padding (notches, safe areas)
final padding = MediaQuery.of(context).padding;
final top = padding.top;    // Height of top notch
final bottom = padding.bottom; // Height of bottom notch

// Get device info
final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

// Get device pixel ratio (for high-density displays)
final pixelRatio = MediaQuery.of(context).devicePixelRatio;

// Get text scale factor
final textScaleFactor = MediaQuery.of(context).textScaleFactor;
```

### Responsive Size Constants

```dart
// Define breakpoints
const double mobileBreakpoint = 600;
const double tabletBreakpoint = 1200;

// Use in layout
final screenWidth = MediaQuery.of(context).size.width;
final isMobile = screenWidth < mobileBreakpoint;
final isTablet = screenWidth < tabletBreakpoint;
final isDesktop = screenWidth >= tabletBreakpoint;
```

### Building Responsive Layouts

```dart
@override
Widget build(BuildContext context) {
  final screenWidth = MediaQuery.of(context).size.width;
  
  if (screenWidth < 600) {
    // Mobile layout: single column
    return Column(
      children: [
        Container(height: 200, color: Colors.blue),
        Container(height: 200, color: Colors.red),
        Container(height: 200, color: Colors.green),
      ],
    );
  } else if (screenWidth < 1200) {
    // Tablet layout: 2 columns
    return Row(
      children: [
        Expanded(
          child: Column(
            children: [
              Container(height: 200, color: Colors.blue),
              Container(height: 200, color: Colors.red),
            ],
          ),
        ),
        Expanded(
          child: Container(height: 400, color: Colors.green),
        ),
      ],
    );
  } else {
    // Desktop layout: 3 columns
    return Row(
      children: [
        Expanded(child: Container(color: Colors.blue)),
        Expanded(child: Container(color: Colors.red)),
        Expanded(child: Container(color: Colors.green)),
      ],
    );
  }
}
```

---

## Layout Patterns

### Pattern 1: Master-Detail Layout

Show list on left, detail on right (desktop only):

```dart
Widget build(BuildContext context) {
  final isMobile = MediaQuery.of(context).size.width < 600;
  
  return isMobile
      ? _buildMobileLayout(context)
      : _buildDesktopLayout(context);
}

Widget _buildMobileLayout(BuildContext context) {
  return Column(
    children: [
      _buildListView(),
      _buildDetailView(),
    ],
  );
}

Widget _buildDesktopLayout(BuildContext context) {
  return Row(
    children: [
      Expanded(flex: 1, child: _buildListView()),
      Expanded(flex: 2, child: _buildDetailView()),
    ],
  );
}
```

### Pattern 2: Adaptive Grid

Grid that changes columns based on screen size:

```dart
int getGridColumns(BuildContext context) {
  final width = MediaQuery.of(context).size.width;
  if (width < 600) return 1;      // Mobile: 1 column
  if (width < 1200) return 2;     // Tablet: 2 columns
  return 3;                        // Desktop: 3 columns
}

GridView.builder(
  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: getGridColumns(context),
    childAspectRatio: 1.0,
    mainAxisSpacing: 16,
    crossAxisSpacing: 16,
  ),
  itemCount: items.length,
  itemBuilder: (context, index) => ItemCard(items[index]),
)
```

### Pattern 3: Collapsible Sidebar

Show/hide sidebar on mobile:

```dart
Widget build(BuildContext context) {
  final isMobile = MediaQuery.of(context).size.width < 600;
  
  return isMobile
      ? Scaffold(
          appBar: AppBar(...),
          drawer: _buildSidebar(),
          body: MainContent(),
        )
      : Row(
          children: [
            SizedBox(width: 250, child: _buildSidebar()),
            Expanded(child: MainContent()),
          ],
        );
}
```

---

## Nested Layouts

Complex layouts often require nesting multiple Row/Column combinations:

```dart
Column(
  children: [
    // Header
    Container(
      padding: EdgeInsets.all(16),
      color: Colors.blue,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('App Title'),
          Row(
            children: [
              IconButton(icon: Icon(Icons.search), onPressed: () {}),
              IconButton(icon: Icon(Icons.settings), onPressed: () {}),
            ],
          ),
        ],
      ),
    ),
    
    // Main Content
    Expanded(
      child: Row(
        children: [
          // Sidebar
          SizedBox(
            width: 200,
            child: ListView(
              children: [Text('Item 1'), Text('Item 2'), Text('Item 3')],
            ),
          ),
          
          // Main Area
          Expanded(
            child: Column(
              children: [
                Text('Main Content'),
                Expanded(child: GridView.builder(...)),
              ],
            ),
          ),
        ],
      ),
    ),
    
    // Footer
    Container(
      padding: EdgeInsets.all(16),
      color: Colors.grey[300],
      child: Text('© 2024 MyApp'),
    ),
  ],
)
```

---

## Common Pitfalls

### ❌ Pitfall 1: Unbounded Height/Width

```dart
// WRONG: Column inside unbounded height
ListView(
  children: [
    Column(
      children: [
        Text('Item 1'),
        Text('Item 2'),
        // Error! Column has unbounded height
      ],
    ),
  ],
)

// RIGHT: Use Expanded or SizedBox
ListView(
  children: [
    SizedBox(
      height: 200,
      child: Column(
        children: [
          Text('Item 1'),
          Text('Item 2'),
        ],
      ),
    ),
  ],
)
```

### ❌ Pitfall 2: Row/Column Overflow

```dart
// WRONG: Text overflows in Row
Row(
  children: [
    Icon(Icons.person),
    Text('Very long text that will overflow the screen'),
    Icon(Icons.arrow_forward),
  ],
)

// RIGHT: Wrap long text with Expanded
Row(
  children: [
    Icon(Icons.person),
    Expanded(
      child: Text('Very long text that will wrap properly'),
    ),
    Icon(Icons.arrow_forward),
  ],
)
```

### ❌ Pitfall 3: Not Handling Orientation

```dart
// WRONG: Hardcoded layout
Row(
  children: [
    Container(width: 400, color: Colors.blue),
    Container(width: 400, color: Colors.red),
  ],
)

// RIGHT: Responsive layout
Orientation.Portrait
  ? Column(children: [...])
  : Row(children: [...])
```

### ❌ Pitfall 4: Excess Nesting

```dart
// WRONG: Too many nested Containers
Container(
  child: Container(
    child: Container(
      child: Container(
        child: Text('Hello'),
      ),
    ),
  ),
)

// RIGHT: Combine properties or use Column/Row
Container(
  padding: EdgeInsets.all(16),
  decoration: BoxDecoration(...),
  child: Text('Hello'),
)
```

---

## Best Practices

### 🎯 1. Use Constants for Spacing

```dart
class AppSpacing {
  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 16.0;
  static const lg = 24.0;
  static const xl = 32.0;
}

// Usage
Column(
  children: [
    Text('Header'),
    SizedBox(height: AppSpacing.md),
    Text('Content'),
  ],
)
```

### 🎯 2. Create Responsive Helper Functions

```dart
bool isMobile(BuildContext context) =>
    MediaQuery.of(context).size.width < 600;

bool isTablet(BuildContext context) =>
    MediaQuery.of(context).size.width < 1200;

int getGridColumns(BuildContext context) =>
    isMobile(context) ? 1 : isTablet(context) ? 2 : 3;
```

### 🎯 3. Extract Complex Layouts into Widgets

```dart
// Instead of huge build() method
class MyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeader(),
        _buildContent(),
        _buildFooter(),
      ],
    );
  }
  
  Widget _buildHeader() => Container(...);
  Widget _buildContent() => Container(...);
  Widget _buildFooter() => Container(...);
}
```

### 🎯 4. Test on Multiple Devices

```dart
// Test on:
// - Small phone (Pixel 5: 412x915)
// - Regular phone (Pixel 4: 412x869)
// - Large phone (Pixel XL: 412x823)
// - Tablet (iPad: 768x1024)
// - Desktop (1920x1080)
```

### 🎯 5. Use SafeArea for Notches

```dart
Scaffold(
  body: SafeArea(
    child: Column(
      children: [
        // Safe from notches and status bar
      ],
    ),
  ),
)
```

### 🎯 6. Profile Performance

```dart
debugPrint('Building layout: ${DateTime.now()}');
final start = DateTime.now();

return build();

final elapsed = DateTime.now().difference(start).inMilliseconds;
debugPrint('Build took ${elapsed}ms');
```

---

## Complete Examples

### Example 1: Profile Card Layout

```dart
Container(
  padding: EdgeInsets.all(16),
  child: Column(
    children: [
      // Avatar
      CircleAvatar(radius: 50),
      SizedBox(height: 16),
      
      // Name
      Text('John Doe', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
      SizedBox(height: 8),
      
      // Bio
      Text('Flutter Developer', style: TextStyle(color: Colors.grey)),
      SizedBox(height: 24),
      
      // Stats Row
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(children: [Text('100'), Text('Followers')]),
          Column(children: [Text('50'), Text('Following')]),
          Column(children: [Text('200'), Text('Posts')]),
        ],
      ),
      SizedBox(height: 24),
      
      // Action Buttons
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton(onPressed: () {}, child: Text('Follow')),
          ElevatedButton(onPressed: () {}, child: Text('Message')),
        ],
      ),
    ],
  ),
)
```

### Example 2: Dashboard Layout

```dart
Scaffold(
  body: SafeArea(
    child: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Container(
            padding: EdgeInsets.all(16),
            color: Colors.blue,
            child: Text('Dashboard', style: TextStyle(fontSize: 24, color: Colors.white)),
          ),
          
          // Stats Cards
          GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.5,
            ),
            itemCount: 4,
            itemBuilder: (context, index) => Card(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Metric ${index + 1}'),
                  Text('${(index + 1) * 100}'),
                ],
              ),
            ),
          ),
          
          // Details Section
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Recent Activity', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: 5,
                  itemBuilder: (context, index) => ListTile(
                    title: Text('Activity ${index + 1}'),
                    subtitle: Text('2 hours ago'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  ),
)
```

---

## Summary

Responsive layouts are the backbone of modern Flutter apps. By mastering Container, Row, Column, and responsive techniques:

✅ Create flexible, adaptive layouts
✅ Handle different screen sizes gracefully
✅ Build maintainable, scalable UIs
✅ Provide excellent user experience across all devices

Practice these patterns regularly, and you'll develop intuition for building beautiful, responsive layouts! 🚀
