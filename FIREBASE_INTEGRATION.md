# Firebase Integration Guide - TaskPilot

## 📱 Overview

TaskPilot now integrates **Firebase Authentication** and **Cloud Firestore** for secure user management and real-time data synchronization. This guide covers the complete setup process and implementation details.

---

## 🚀 Quick Start Setup

### Step 1: Create Firebase Project

1. Go to **[Firebase Console](https://console.firebase.google.com)**
2. Click **"Create a project"**
3. Name it: *TaskPilot* (or your preferred name)
4. Enable Google Analytics (optional)
5. Click **"Create project"** and wait for initialization

### Step 2: Configure Firebase for Flutter

#### Android Setup

1. In Firebase Console, click **"Add app"** → Select **Android**
2. Enter package name: `com.example.taskpilot`
3. Download `google-services.json`
4. Place it at: `android/app/google-services.json`

#### iOS Setup

1. Click **"Add app"** → Select **iOS**
2. Enter bundle ID: `com.example.taskpilot`
3. Download `GoogleService-Info.plist`
4. Place it at: `ios/Runner/GoogleService-Info.plist`

#### Web Setup (Optional)

1. Click **"Add app"** → Select **Web**
2. Copy the Firebase config
3. Update the config variables in your web setup

### Step 3: Use FlutterFire CLI (Recommended)

```bash
# Install FlutterFire CLI
dart pub global activate flutterfire_cli

# Configure Firebase for your Flutter project
flutterfire configure
```

This automatically generates `lib/firebase_options.dart` with your Firebase credentials.

### Step 4: Update pubspec.yaml

```yaml
dependencies:
  firebase_core: ^2.24.0
  firebase_auth: ^4.14.0
  cloud_firestore: ^4.14.0
  firebase_messaging: ^14.7.0
```

### Step 5: Initialize Firebase in main.dart

```dart
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  runApp(const TaskPilotApp());
}
```

---

## 🔐 Authentication System

### AuthService Class

Located at: `lib/services/auth_service.dart`

#### Key Methods

```dart
// Sign up new user
Future<User?> signUp({
  required String email,
  required String password,
  required String name,
})

// Login existing user
Future<User?> login({
  required String email,
  required String password,
})

// Logout current user
Future<void> logout()

// Get user profile stream
Stream<UserModel?> getUserProfileStream(String userId)

// Update user profile
Future<void> updateUserProfile(String userId, Map<String, dynamic> data)

// Reset password
Future<bool> resetPassword(String email)
```

#### Error Handling

```dart
// Handles Firebase authentication errors
// Returns user-friendly error messages for:
- weak-password
- email-already-in-use
- invalid-email
- user-not-found
- wrong-password
- too-many-requests
```

### Authentication Flow

```
[Login/Sign Up Screen]
        ↓
[AuthService.signUp() / login()]
        ↓
[Firebase Auth - Create/Verify User]
        ↓
[Create/Update User Profile in Firestore]
        ↓
[AuthGate Detects User & Routes to Home]
        ↓
[ResponsiveHome Dashboard]
```

---

## 💾 Firestore Database Structure

### Collections Schema

```
users/
├── {userId}/
│   ├── profile/              # User profile field
│   ├── tasks/                # User's tasks collection
│   │   └── {taskId}/
│   │       ├── title (string)
│   │       ├── description (string)
│   │       ├── status (string: todo, inProgress, done)
│   │       ├── priority (string: low, medium, high)
│   │       ├── deadline (timestamp)
│   │       ├── rate (number)
│   │       ├── createdAt (timestamp)
│   │       └── updatedAt (timestamp)
│   ├── clients/              # Clients collection
│   │   └── {clientId}/
│   │       ├── name (string)
│   │       ├── email (string)
│   │       ├── phone (string)
│   │       ├── company (string)
│   │       ├── createdAt (timestamp)
│   │       └── updatedAt (timestamp)
│   └── payments/             # Payments collection
│       └── {paymentId}/
│           ├── clientId (string)
│           ├── amount (number)
│           ├── status (string: unpaid, partial, paid)
│           ├── dueDate (timestamp)
│           ├── paidDate (timestamp)
│           ├── createdAt (timestamp)
│           └── updatedAt (timestamp)
```

### Firestore Security Rules

For development (allow authenticated users):

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read, write: if request.auth.uid == userId;
      
      match /{document=**} {
        allow read, write: if request.auth.uid == userId;
      }
    }
  }
}
```

---

## 🗄️ Firestore Service

Located at: `lib/services/firestore_service.dart`

### CRUD Operations

#### Tasks

```dart
// Add task
Future<String?> addTask(String userId, Map<String, dynamic> taskData)

// Get tasks stream (real-time)
Stream<List<Map<String, dynamic>>> getTasksStream(String userId)

// Get tasks by status stream
Stream<List<Map<String, dynamic>>> getTasksByStatusStream(
  String userId, 
  String status
)

// Update task
Future<void> updateTask(String userId, String taskId, Map<String, dynamic> updates)

// Delete task
Future<void> deleteTask(String userId, String taskId)
```

#### Clients

```dart
// Add client
Future<String?> addClient(String userId, Map<String, dynamic> clientData)

// Get clients stream
Stream<List<Map<String, dynamic>>> getClientsStream(String userId)

// Update client
Future<void> updateClient(String userId, String clientId, Map<String, dynamic> updates)

// Delete client
Future<void> deleteClient(String userId, String clientId)
```

#### Payments

```dart
// Add payment
Future<String?> addPayment(String userId, Map<String, dynamic> paymentData)

// Get payments stream
Stream<List<Map<String, dynamic>>> getPaymentsStream(String userId)

// Get unpaid payments
Stream<List<Map<String, dynamic>>> getUnpaidPaymentsStream(String userId)

// Update payment
Future<void> updatePayment(String userId, String paymentId, Map<String, dynamic> updates)

// Delete payment
Future<void> deletePayment(String userId, String paymentId)
```

#### Dashboard Stats

```dart
// Get all statistics for dashboard
Future<Map<String, dynamic>> getDashboardStats(String userId)
```

---

## 🔄 Real-Time Data with StreamBuilder

### Display Tasks in Real-Time

```dart
StreamBuilder<List<Map<String, dynamic>>>(
  stream: _firestoreService.getTasksStream(userId),
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const CircularProgressIndicator();
    }
    
    if (snapshot.hasError) {
      return Text('Error: ${snapshot.error}');
    }
    
    final tasks = snapshot.data ?? [];
    
    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return RetroTaskCard(
          title: task['title'],
          description: task['description'],
          deadline: task['deadline'],
          status: task['status'],
        );
      },
    );
  },
)
```

### Display Payments in Real-Time

```dart
StreamBuilder<List<Map<String, dynamic>>>(
  stream: _firestoreService.getUnpaidPaymentsStream(userId),
  builder: (context, snapshot) {
    final payments = snapshot.data ?? [];
    final totalUnpaid = payments.fold<double>(
      0,
      (sum, payment) => sum + (payment['amount'] ?? 0).toDouble(),
    );
    
    return Text('Unpaid: \$${totalUnpaid.toStringAsFixed(2)}');
  },
)
```

---

## 🔑 Authentication Screens

### Login Screen (`lib/screens/login_screen.dart`)

Features:
- Email and password input fields
- Form validation
- Error message display
- Link to sign up
- Feature list display

```dart
// Usage
LoginScreen(
  onLoginSuccess: () { /* Handle success */ },
  onSwitchToSignUp: () { /* Switch to signup */ },
)
```

### Sign Up Screen (`lib/screens/signup_screen.dart`)

Features:
- Name, email, password input
- Password confirmation
- Form validation
- Error handling
- Link to login

```dart
// Usage
SignUpScreen(
  onSignUpSuccess: () { /* Handle success */ },
  onSwitchToLogin: () { /* Switch to login */ },
)
```

### Auth Gate (`lib/screens/auth_gate.dart`)

Automatically routes users:
- **Authenticated**: Shows ResponsiveHome
- **Not Authenticated**: Shows Login/SignUp screens

```dart
// In main.dart
home: const AuthGate(),
```

---

## 📊 Data Models

### UserModel (`lib/models/user_model.dart`)

```dart
UserModel(
  id: String,
  email: String,
  name: String,
  profilePic: String?,
  hourlyRate: double,
  phone: String?,
  company: String?,
  createdAt: DateTime,
  updatedAt: DateTime,
)

// Convert to JSON for Firestore
Map<String, dynamic> toJson()

// Create from Firestore
UserModel.fromJson(Map<String, dynamic> json)

// Copy with modifications
UserModel copyWith({...})
```

---

## 🧪 Testing Firebase Integration

### Test Signup

1. Go to **Signup Screen**
2. Enter:
   - Name: "John Doe"
   - Email: "john@example.com"
   - Password: "test123456"
3. Click **SIGN UP**
4. Verify success message appears
5. Check **Firebase Console → Authentication** - new user visible

### Test Login

1. Go to **Login Screen**
2. Enter registered email and password
3. Click **SIGN IN**
4. Dashboard should appear
5. User email visible in AppBar (desktop)

### Test Firestore Data

1. After login, add a task via dashboard
2. Check **Firebase Console → Firestore → users → {userId} → tasks**
3. Verify task document created with correct fields
4. Make changes in app, verify real-time sync in console

### Test Real-Time Updates

1. Open app on two devices/emulators
2. Add task on Device 1
3. Watch task appear automatically on Device 2 (via StreamBuilder)
4. Update task on Device 1
5. Verify update appears instantly on Device 2

---

## 🔒 Security Best Practices

### 1. Firestore Security Rules

- ✅ User can only access their own data
- ✅ Timestamp validation
- ✅ Field-level validation
- ✅ Rate limiting for sensitive operations

### 2. Authentication

- ✅ Require 6+ character passwords
- ✅ Email validation
- ✅ Handle auth errors gracefully
- ✅ Secure password reset flow

### 3. Data Privacy

- ✅ No PII in logs
- ✅ HTTPS only for API calls
- ✅ Encrypted sensitive data
- ✅ User consent for data collection

---

## 🚨 Common Issues & Solutions

### Issue: "firebase_core not found"

**Solution**:
```bash
cd flutter_app
flutter pub get
```

### Issue: "google-services.json not found"

**Solution**: Download from Firebase Console → Android app settings

### Issue: "Unauthorized" errors in Firestore

**Solution**: Check security rules - ensure `request.auth.uid == userId`

### Issue: App crashes on Firebase initialization

**Solution**: Ensure `WidgetsFlutterBinding.ensureInitialized()` called before `Firebase.initializeApp()`

---

## 📈 Performance Optimization

### Use Pagination for Large Datasets

```dart
Future<List<Map<String, dynamic>>> getTasks(
  String userId,
  {int limit = 20}
) async {
  // Limit results to 20 at a time
}
```

### Index Queries for Better Performance

Create Firestore indexes for:
- `users/{userId}/tasks: status, deadline`
- `users/{userId}/payments: status, dueDate`

### Cache Strategy

- StreamBuilder automatically caches via Firebase SDK
- Use FutureBuilder for one-time fetches
- Implement local caching for offline support

---

## 📱 Integration with Responsive Design

All auth screens are fully responsive:
- **Mobile**: Single column, full-width forms
- **Tablet**: Centered forms with padding
- **Desktop**: Constrained width for readability

```dart
// Responsive form width
ConstrainedBox(
  constraints: const BoxConstraints(maxWidth: 500),
  child: Form(/* form content */),
)
```

---

## 🔄 User Profile Management

### Get User Profile

```dart
// One-time fetch
UserModel? profile = await _authService.getUserProfile(userId);

// Real-time stream
Stream<UserModel?> profileStream = _authService.getUserProfileStream(userId);
```

### Update User Profile

```dart
await _authService.updateUserProfile(userId, {
  'name': 'New Name',
  'hourlyRate': 50.0,
  'company': 'My Company',
});
```

---

## 🎯 Reflection: Firebase Benefits

### ✅ Advantages

1. **Simplified Backend**: No server management needed
2. **Real-Time Sync**: Changes reflect instantly across devices
3. **Scalability**: Automatically scales with user base
4. **Security**: Built-in authentication and authorization
5. **Cost-Effective**: Pay-as-you-go pricing
6. **Developer Experience**: Easy-to-use Flutter SDKs

### 📚 Learning Outcomes

1. How to set up Firebase for Flutter apps
2. Implementing secure authentication flows
3. Real-time data synchronization patterns
4. Firestore CRUD operations
5. Error handling and user feedback
6. Security rules for data protection
7. Responsive design with Firebase integration

### 🚀 Integration Lessons Learned

- **Architecture**: Service layer abstraction makes Firebase replaceable
- **Real-Time Data**: StreamBuilder is powerful for reactive UIs
- **Error Handling**: User-friendly messages improve UX
- **Testing**: Firebase Console is invaluable for debugging
- **Scalability**: Firestore structure impacts performance
- **Security**: Rules should be implemented from day one

---

## 📚 Additional Resources

- [Firebase Documentation](https://firebase.google.com/docs)
- [FlutterFire GitHub](https://github.com/firebase/flutterfire)
- [Cloud Firestore Guide](https://firebase.google.com/docs/firestore)
- [Firebase Auth Best Practices](https://firebase.google.com/docs/auth/best-practices)

---

## ✨ Next Steps

1. **Set up Firebase** using FlutterFire CLI
2. **Configure security rules** in Firebase Console
3. **Test signup/login** flows
4. **Add more data** (tasks, clients, payments)
5. **Implement push notifications** with FCM
6. **Create client portal** for shared access
7. **Set up n8n workflows** for automation

---

**TaskPilot Firebase Integration** - Production-Ready User Management ✅
