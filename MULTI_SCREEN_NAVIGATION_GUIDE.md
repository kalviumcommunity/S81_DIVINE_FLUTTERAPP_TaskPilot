# Multi-Screen Navigation Guide

## Overview

Navigation is the backbone of multi-page applications in Flutter. This guide covers everything you need to know about implementing robust navigation patterns using the Navigator widget and named routes in your Flutter app.

**What You'll Learn:**
- Understanding the Navigation Stack
- Setting up Named Routes
- Navigating between screens
- Passing data between screens
- Returning data from screens
- Multi-step wizard flows
- Best practices for navigation management

---

## Table of Contents

1. [Core Concepts](#core-concepts)
2. [Setting Up Routes](#setting-up-routes)
3. [Basic Navigation](#basic-navigation)
4. [Passing Data](#passing-data)
5. [Returning Data](#returning-data)
6. [Advanced Patterns](#advanced-patterns)
7. [Common Pitfalls](#common-pitfalls)
8. [Best Practices](#best-practices)
9. [Complete Example](#complete-example)

---

## Core Concepts

### The Navigation Stack 📚

Flutter uses a stack-based navigation model where screens are pushed onto and popped off a stack:

```
Stack (Most Recent First):
┌─────────────────┐
│  Details Screen │ ← Top of Stack (Currently Visible)
├─────────────────┤
│   Home Screen   │
├─────────────────┤
│    Root Screen  │ ← Bottom of Stack
└─────────────────┘
```

**Key Operations:**
- **Push**: Add new screen to top of stack
- **Pop**: Remove current screen, going back
- **Replace**: Remove current screen and add new one
- **PopUntil**: Pop multiple screens until condition met

### Navigator Widget

The Navigator widget manages the stack of screens. It's typically created implicitly by MaterialApp:

```dart
MaterialApp(
  initialRoute: '/',
  routes: {
    '/': (context) => HomeScreen(),
    '/details': (context) => DetailsScreen(),
  },
)
```

### Named Routes vs Direct Navigation

**Named Routes (Recommended):**
```dart
Navigator.pushNamed(context, '/details');
```

**Direct Navigation (Avoid):**
```dart
Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => DetailsScreen()),
);
```

Named routes provide:
- ✅ Centralized route management
- ✅ Easier to track available routes
- ✅ Support for deep linking
- ✅ Better route configuration

---

## Setting Up Routes

### Basic Route Configuration

In `main.dart`, configure routes using MaterialApp:

```dart
import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/details_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Navigation Demo',
      
      // Define the first screen to show
      initialRoute: '/',
      
      // Map route names to their corresponding widgets
      routes: {
        '/': (context) => const HomeScreen(),
        '/details': (context) => const DetailsScreen(),
        '/settings': (context) => const SettingsScreen(),
        '/profile': (context) => const ProfileScreen(),
      },
      
      // Called when a route is requested that doesn't exist
      onUnknownRoute: (RouteSettings settings) {
        return MaterialPageRoute(
          builder: (context) => const ErrorScreen(),
        );
      },
    );
  }
}
```

**Key Parameters:**
- `initialRoute`: The route to load first
- `routes`: Map of route names to screen builders
- `onUnknownRoute`: Fallback for undefined routes
- `onGenerateRoute`: Advanced route generation

### Advanced: Route Generation

For dynamic routes with parameters, use `onGenerateRoute`:

```dart
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      onGenerateRoute: (RouteSettings settings) {
        final args = settings.arguments;
        
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(
              builder: (context) => const HomeScreen(),
            );
          case '/user':
            return MaterialPageRoute(
              builder: (context) => UserScreen(
                userId: args as String?,
              ),
            );
          default:
            return MaterialPageRoute(
              builder: (context) => const ErrorScreen(),
            );
        }
      },
    );
  }
}
```

---

## Basic Navigation

### 1. Simple Push Navigation

Navigate to a new screen and add it to the stack:

```dart
class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Navigate to Details Screen
            Navigator.pushNamed(context, '/details');
          },
          child: const Text('Go to Details'),
        ),
      ),
    );
  }
}
```

### 2. Pop to Go Back

Return to the previous screen:

```dart
class DetailsScreen extends StatelessWidget {
  const DetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Details')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Return to previous screen
            Navigator.pop(context);
          },
          child: const Text('Back'),
        ),
      ),
    );
  }
}
```

### 3. Replace Current Screen (No Back Button)

Replace the current screen without adding to history:

```dart
ElevatedButton(
  onPressed: () {
    Navigator.pushReplacementNamed(context, '/home');
  },
  child: const Text('Replace with Home'),
)
```

**Use Case:** Login/Logout flows where users shouldn't navigate back to login screen

### 4. Clear Stack and Navigate

Remove all previous screens and start fresh:

```dart
ElevatedButton(
  onPressed: () {
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/home',
      (route) => false, // Remove all routes
    );
  },
  child: const Text('Home (Clear Stack)'),
)
```

---

## Passing Data

### Method 1: Using Arguments (Basic)

Pass simple data (String, int, bool):

**Sending:**
```dart
Navigator.pushNamed(
  context,
  '/details',
  arguments: 'Product ID: 123',
);
```

**Receiving:**
```dart
class DetailsScreen extends StatelessWidget {
  const DetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Extract arguments from route
    final message = ModalRoute.of(context)?.settings.arguments as String?;
    
    return Scaffold(
      appBar: AppBar(title: const Text('Details')),
      body: Center(
        child: Text(message ?? 'No data received'),
      ),
    );
  }
}
```

### Method 2: Using Objects (Advanced)

Pass complex data structures:

**Define Data Class:**
```dart
class Product {
  final int id;
  final String name;
  final double price;

  Product({
    required this.id,
    required this.name,
    required this.price,
  });
}
```

**Sending:**
```dart
final product = Product(
  id: 123,
  name: 'Flutter Guide',
  price: 29.99,
);

Navigator.pushNamed(
  context,
  '/product-details',
  arguments: product,
);
```

**Receiving:**
```dart
@override
Widget build(BuildContext context) {
  final product = ModalRoute.of(context)?.settings.arguments as Product?;
  
  return Scaffold(
    appBar: AppBar(title: Text(product?.name ?? 'Product')),
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('ID: ${product?.id}'),
          Text('Price: \$${product?.price}'),
        ],
      ),
    ),
  );
}
```

### Method 3: Using Constructor Parameters

Pass data through widget constructor:

```dart
class DetailsScreen extends StatelessWidget {
  final String message;
  
  const DetailsScreen({
    Key? key,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Details')),
      body: Center(child: Text(message)),
    );
  }
}

// Use with onGenerateRoute
onGenerateRoute: (settings) {
  if (settings.name == '/details') {
    return MaterialPageRoute(
      builder: (context) => DetailsScreen(
        message: settings.arguments as String,
      ),
    );
  }
}
```

---

## Returning Data

### Pop with Return Value

Return data back to the calling screen and process the result:

**Calling Screen:**
```dart
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _result;

  Future<void> _navigateAndGetResult() async {
    // Push and wait for result
    final result = await Navigator.pushNamed(
      context,
      '/details',
    ) as String?;
    
    if (result != null) {
      setState(() => _result = result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _navigateAndGetResult,
              child: const Text('Go to Details'),
            ),
            if (_result != null)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('Result: $_result'),
              ),
          ],
        ),
      ),
    );
  }
}
```

**Destination Screen:**
```dart
class DetailsScreen extends StatelessWidget {
  const DetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Details')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Return data and pop
            Navigator.pop(context, 'Result from Details');
          },
          child: const Text('Send Data & Go Back'),
        ),
      ),
    );
  }
}
```

### Returning Complex Data

Return structured data as a Map:

```dart
class SettingsScreen extends StatefulWidget {
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _theme = 'light';
  String _language = 'en';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Column(
        children: [
          DropdownButton(
            value: _theme,
            items: ['light', 'dark', 'auto']
                .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                .toList(),
            onChanged: (v) => setState(() => _theme = v as String),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context, {
                'theme': _theme,
                'language': _language,
              });
            },
            child: const Text('Save & Return'),
          ),
        ],
      ),
    );
  }
}

// In calling screen:
final settings = await Navigator.pushNamed(
  context,
  '/settings',
) as Map<String, dynamic>?;

if (settings != null) {
  print('Theme: ${settings['theme']}');
  print('Language: ${settings['language']}');
}
```

---

## Advanced Patterns

### 1. Conditional Navigation

Navigate based on app state or user roles:

```dart
void _navigateBasedOnRole(BuildContext context, UserRole role) {
  switch (role) {
    case UserRole.admin:
      Navigator.pushNamed(context, '/admin-dashboard');
      break;
    case UserRole.user:
      Navigator.pushNamed(context, '/user-home');
      break;
    case UserRole.guest:
      Navigator.pushNamed(context, '/guest-home');
      break;
  }
}
```

### 2. Multi-Step Wizard

Navigate through multiple screens with progress tracking:

```dart
class WizardFlow {
  static Future<void> startWizard(BuildContext context) async {
    final step1 = await Navigator.pushNamed(context, '/wizard/step1') as bool?;
    if (step1 != true) return;
    
    final step2 = await Navigator.pushNamed(context, '/wizard/step2') as bool?;
    if (step2 != true) return;
    
    final step3 = await Navigator.pushNamed(context, '/wizard/step3') as bool?;
    if (step3 == true) {
      Navigator.pushNamed(context, '/wizard/complete');
    }
  }
}
```

### 3. Navigation with Callbacks

Update parent screen when child screen changes something:

```dart
class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _itemCount = 0;

  Future<void> _navigateAndRefresh() async {
    await Navigator.pushNamed(context, '/edit-items');
    // Refresh data after returning
    _loadItemCount();
  }

  void _loadItemCount() {
    setState(() {
      // Reload data from database/API
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ElevatedButton(
        onPressed: _navigateAndRefresh,
        child: Text('Edit Items ($_itemCount)'),
      ),
    );
  }
}
```

### 4. Deep Linking

Navigate directly to nested screens:

```dart
// In main.dart
onGenerateRoute: (settings) {
  if (settings.name == '/product/123/details') {
    return MaterialPageRoute(
      builder: (context) => const ProductDetailsScreen(productId: '123'),
    );
  }
}

// From push notification or link
await launchUrl(Uri.parse('app://product/123/details'));
```

### 5. Navigation State Machine

Manage complex navigation flows with a state machine:

```dart
enum NavigationState { home, details, settings, loading }

class NavigationManager {
  static Future<void> navigate(
    BuildContext context,
    NavigationState state, {
    Object? arguments,
  }) async {
    final route = _getRoute(state);
    
    if (arguments != null) {
      await Navigator.pushNamed(context, route, arguments: arguments);
    } else {
      await Navigator.pushNamed(context, route);
    }
  }

  static String _getRoute(NavigationState state) {
    switch (state) {
      case NavigationState.home:
        return '/';
      case NavigationState.details:
        return '/details';
      case NavigationState.settings:
        return '/settings';
      case NavigationState.loading:
        return '/loading';
    }
  }
}
```

---

## Common Pitfalls

### ❌ Pitfall 1: Passing Context Incorrectly

```dart
// WRONG: Context might be invalid after navigation
void wrongWay() {
  showDialog(context: context, ...);
  Navigator.pushNamed(context, '/next'); // May fail!
}

// RIGHT: Use futures to handle async properly
Future<void> correctWay() async {
  final result = await Navigator.pushNamed(context, '/next');
  if (result != null) {
    setState(() => _data = result);
  }
}
```

### ❌ Pitfall 2: Losing State During Navigation

```dart
// WRONG: State lost when navigating
class MyWidget extends StatelessWidget {
  int counter = 0; // Lost on navigation!

  void increment() {
    counter++;
    Navigator.pushNamed(context, '/next');
  }
}

// RIGHT: Use StatefulWidget
class MyWidget extends StatefulWidget {
  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  int counter = 0; // Preserved!
  
  void increment() {
    setState(() => counter++);
    Navigator.pushNamed(context, '/next');
  }
}
```

### ❌ Pitfall 3: Forgetting Arguments Can Be Null

```dart
// WRONG: Crashes if no arguments
final data = ModalRoute.of(context)!.settings.arguments as String;

// RIGHT: Handle null gracefully
final data = ModalRoute.of(context)?.settings.arguments as String? ?? 'default';
```

### ❌ Pitfall 4: Not Handling Navigation Errors

```dart
// WRONG: No error handling
Navigator.pushNamed(context, '/unknown-route');

// RIGHT: Verify route exists first
const availableRoutes = ['/home', '/details', '/settings'];
final route = '/unknown-route';

if (availableRoutes.contains(route)) {
  Navigator.pushNamed(context, route);
} else {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text('Route not found')),
  );
}
```

### ❌ Pitfall 5: Multiple Rapid Navigations

```dart
// WRONG: Rapid double-tap causes multiple navigations
onPressed: () {
  Navigator.pushNamed(context, '/details');
  Navigator.pushNamed(context, '/settings'); // Both execute!
}

// RIGHT: Prevent rapid navigation
bool _isNavigating = false;

onPressed: () {
  if (_isNavigating) return;
  _isNavigating = true;
  
  Navigator.pushNamed(context, '/details').then((_) {
    _isNavigating = false;
  });
}
```

---

## Best Practices

### 🎯 1. Centralize Route Definitions

Create a separate file for all routes:

```dart
// lib/routes/app_routes.dart
class AppRoutes {
  static const String home = '/';
  static const String details = '/details';
  static const String settings = '/settings';
  static const String profile = '/profile';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      home: (context) => const HomeScreen(),
      details: (context) => const DetailsScreen(),
      settings: (context) => const SettingsScreen(),
      profile: (context) => const ProfileScreen(),
    };
  }
}

// In main.dart
routes: AppRoutes.getRoutes(),
```

### 🎯 2. Use Named Constants for Routes

```dart
// Avoid magic strings
Navigator.pushNamed(context, '/home'); // Bad
Navigator.pushNamed(context, AppRoutes.home); // Good
```

### 🎯 3. Create Type-Safe Navigation Helpers

```dart
class NavigationHelper {
  static Future<T?> navigateTo<T>(
    BuildContext context,
    String route, {
    Object? arguments,
  }) async {
    return await Navigator.pushNamed<T>(
      context,
      route,
      arguments: arguments,
    );
  }

  static void goHome(BuildContext context) {
    Navigator.pushReplacementNamed(context, AppRoutes.home);
  }

  static Future<String?> getTextInput(BuildContext context) async {
    return await navigateTo<String>(context, AppRoutes.textInput);
  }
}
```

### 🎯 4. Handle App Lifecycle with Navigation

```dart
class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // App came to foreground - refresh navigation if needed
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const HomeScreen(),
    );
  }
}
```

### 🎯 5. Log Navigation Events

```dart
void _logNavigation(String fromRoute, String toRoute) {
  final timestamp = DateTime.now();
  debugPrint('🧭 [Navigation] $fromRoute → $toRoute at $timestamp');
}

// In route builders
onGenerateRoute: (settings) {
  _logNavigation('???', settings.name ?? 'unknown');
  // ... rest of route generation
}
```

### 🎯 6. Test Navigation Flows

```dart
void main() {
  testWidgets('Navigation flow test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    
    // Verify home screen is shown
    expect(find.text('Home'), findsOneWidget);
    
    // Navigate to details
    await tester.tap(find.byIcon(Icons.arrow_forward));
    await tester.pumpAndSettle();
    
    // Verify details screen
    expect(find.text('Details'), findsOneWidget);
    
    // Go back
    await tester.pageBack();
    await tester.pumpAndSettle();
    
    // Verify home again
    expect(find.text('Home'), findsOneWidget);
  });
}
```

---

## Complete Example

Here's a complete working example combining all concepts:

### Project Structure
```
lib/
├── main.dart
├── routes/
│   └── app_routes.dart
├── screens/
│   ├── home_screen.dart
│   ├── details_screen.dart
│   └── settings_screen.dart
└── models/
    └── user.dart
```

### main.dart
```dart
import 'package:flutter/material.dart';
import 'routes/app_routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Navigation Demo',
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.home,
      routes: AppRoutes.getRoutes(),
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) => const ErrorScreen(),
        );
      },
    );
  }
}

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Error')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Route not found!'),
            ElevatedButton(
              onPressed: () => Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.home,
                (route) => false,
              ),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    );
  }
}
```

### app_routes.dart
```dart
import 'package:flutter/material.dart';
import '../screens/home_screen.dart';
import '../screens/details_screen.dart';
import '../screens/settings_screen.dart';

class AppRoutes {
  static const String home = '/';
  static const String details = '/details';
  static const String settings = '/settings';

  static Map<String, WidgetBuilder> getRoutes() => {
    home: (context) => const HomeScreen(),
    details: (context) => const DetailsScreen(),
    settings: (context) => const SettingsScreen(),
  };
}
```

### home_screen.dart
```dart
import 'package:flutter/material.dart';
import '../routes/app_routes.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _result;

  Future<void> _navigateToDetails() async {
    final result = await Navigator.pushNamed(
      context,
      AppRoutes.details,
      arguments: {'user': 'John', 'id': 123},
    ) as String?;
    
    setState(() => _result = result);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.pushNamed(
              context,
              AppRoutes.settings,
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _navigateToDetails,
              child: const Text('Go to Details'),
            ),
            if (_result != null)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('Result: $_result'),
              ),
          ],
        ),
      ),
    );
  }
}
```

### details_screen.dart
```dart
import 'package:flutter/material.dart';

class DetailsScreen extends StatelessWidget {
  const DetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map?;
    final user = args?['user'] ?? 'Unknown';
    final id = args?['id'] ?? 0;

    return Scaffold(
      appBar: AppBar(title: const Text('Details Screen')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('User: $user'),
            Text('ID: $id'),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, '✅ Done!'),
              child: const Text('Back with Result'),
            ),
          ],
        ),
      ),
    );
  }
}
```

---

## Summary

Navigation in Flutter is powerful and flexible. By mastering these patterns:

✅ Use named routes for scalability
✅ Pass data with arguments parameters
✅ Return data using futures
✅ Handle navigation state carefully
✅ Centralize route definitions
✅ Test navigation flows
✅ Follow Flutter best practices

Your multi-screen applications will be maintainable, user-friendly, and production-ready!

Happy navigating! 🚀
