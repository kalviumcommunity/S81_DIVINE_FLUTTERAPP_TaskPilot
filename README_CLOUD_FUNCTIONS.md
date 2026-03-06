# Firebase Cloud Functions - Serverless Backend Logic

**Date:** March 6, 2026  
**Feature:** Triggering Cloud Functions for Serverless Event Handling  
**Sprint:** S81 Divine Flutter App - TaskPilot  

## Overview

Firebase Cloud Functions enable you to run backend logic without managing servers. Functions automatically scale with demand and you only pay for what you use. This feature demonstrates both callable functions (invoked from Flutter) and event-based functions (triggered by Firebase events).

### What You Get

✅ **Callable Functions** - Call backend code directly from Flutter  
✅ **Event-Based Triggers** - Auto-run on Firestore/Auth/Storage changes  
✅ **Schedulable Tasks** - Cron jobs via Pub/Sub  
✅ **No Server Management** - Google Cloud handles infrastructure  
✅ **Automatic Scaling** - From 1 to millions of calls  
✅ **Secure Execution** - Isolated, validated backend code  
✅ **Comprehensive Logging** - Monitor all function executions  
✅ **Cost Effective** - Free tier covers 2M calls/month  

## Architecture

### Two Types of Cloud Functions

#### 1. Callable Functions (HTTPS)

Called directly from your Flutter app with request-response pattern:

```
Flutter App
    ↓ (call)
Cloud Function (processes)
    ↓ (response)
Flutter App (receives result)
```

**Example Use Cases:**
- Say hello, get personalized greeting
- Validate email uniqueness
- Process payments securely
- Generate documents (PDFs, invoices)

#### 2. Event-Based Functions

Triggered automatically by Firebase events without app involvement:

```
Firestore Event (document created)
    ↓ (triggers)
Cloud Function (processes automatically)
    ↓ (result)
Sends email, updates data, logs analytics
```

**Types of Triggers:**
- **Firestore Triggers** - onCreate, onUpdate, onDelete, onWrite
- **Auth Triggers** - onCreate (new user), onDelete (user deleted)
- **Storage Triggers** - onFinalize (upload complete), onDelete
- **Pub/Sub Triggers** - Scheduled tasks (daily, weekly)
- **RTDB Triggers** - Real-time database changes

## Service Architecture

### CloudFunctionsService

A comprehensive singleton service with methods for:

```dart
// Basic functions
sayHello(String name)
getServerTime()
healthCheck()

// Notifications
sendNotification(...)
sendWelcomeEmail(...)

// Data Processing
generateInvoice(...)
processPayment(...)
getUserStatistics(...)
bulkUpdateTasks(...)

// Validation
validateEmail(String email)
validateUsername(String username)

// Cleanup
deleteUserAccount(...)
archiveOldData(...)

// AI/ML
generateTaskSummary(...)
suggestNextTask(...)

// Scheduling
scheduleReminder(...)
sendDailyDigest(...)

// Utilities
getAppConfig()
isFunctionAvailable(String name)
callWithRetry(...) // Automatic retry on failure
```

## Implementation Guide

### Step 1: Add Dependency

```yaml
dependencies:
  cloud_functions: ^5.0.0
```

### Step 2: Install Firebase CLI

```bash
npm install -g firebase-tools
firebase login
firebase init functions
# Choose JavaScript or TypeScript
```

### Step 3: Create Callable Function

**File: `functions/index.js`**

```javascript
const functions = require('firebase-functions');

// Callable function - invoked from Flutter
exports.sayHello = functions.https.onCall((data, context) => {
  const name = data.name || 'User';
  return {
    message: `Hello, ${name}!`
  };
});

// Another callable function
exports.validateEmail = functions.https.onCall(async (data) => {
  const email = data.email;
  
  // Check if email exists in database
  const exists = await admin.firestore()
    .collection('users')
    .where('email', '==', email)
    .get()
    .then(snap => !snap.empty);
  
  return {
    isValid: !exists,
    message: exists ? 'Email already in use' : 'Email available'
  };
});
```

### Step 4: Create Event-Based Function

```javascript
// Triggered on new user signup
exports.onUserCreate = functions.auth
  .user()
  .onCreate(async (user) => {
    const email = user.email;
    const uid = user.uid;
    
    // Send welcome email
    await sendEmail(email, 'Welcome!', 'Welcome email body');
    
    // Create user profile document
    await admin.firestore()
      .collection('users')
      .doc(uid)
      .set({
        email: email,
        createdAt: admin.firestore.FieldValue.serverTimestamp(),
        emailVerified: false
      });
    
    return null;
  });

// Triggered on Firestore document creation
exports.onTaskCreate = functions.firestore
  .document('tasks/{taskId}')
  .onCreate( (snap, context) => {
    const taskData = snap.data();
    console.log('New task created:', taskData);
    
    // Could send notification, update stats, etc.
    return admin.firestore()
      .collection('statistics')
      .doc(taskData.userId)
      .update({
        totalTasks: firebase.firestore.FieldValue.increment(1)
      });
  });
```

### Step 5: Deploy Functions

```bash
firebase deploy --only functions

# Deploy specific function:
# firebase deploy --only functions:sayHello

# Deploy to specific region:
# firebase deploy --only functions:sayHello --region us-east1
```

### Step 6: Call from Flutter

```dart
import 'services/cloud_functions_service.dart';

final service = CloudFunctionsService();

// Simple call
final result = await service.sayHello(name: 'Alex');
print(result); // Hello, Alex!

// With error handling
try {
  final valid = await service.validateEmail('test@example.com');
  if (valid) {
    print('Email is available!');
  }
} on FirebaseFunctionsException catch (e) {
  print('Error: ${service.getErrorMessage(e)}');
}
```

## Code Examples

### Example 1: Simple Callable Function

```dart
// Firebase Cloud Function
exports.sayHello = functions.https.onCall((data, context) => {
  return { message: `Hello, ${data.name}!` };
});

// Flutter call
final result = await CloudFunctionsService()
  .sayHello(name: 'World');
print(result); // Hello, World!
```

### Example 2: Callable Function with Validation

```javascript
// Firebase  
exports.validateEmail = functions.https
  .onCall(async (data, context) => {
    // Require authentication
    if (!context.auth) {
      throw new functions.https.HttpsError(
        'unauthenticated',
        'Must be logged in'
      );
    }
    
    const email = data.email;
    if (!email || !email.includes('@')) {
      throw new functions.https.HttpsError(
        'invalid-argument',
        'Invalid email address'
      );
    }
    
    // Check database
    const exists = await admin.firestore()
      .collection('users')
      .where('email', '==', email)
      .get()
      .then(snap => !snap.empty);
    
    return {
      isValid: !exists,
      message: exists ? 'Email in use' : 'Available'
    };
  });

// Flutter
try {
  final result = await service.validateEmail('test@example.com');
  if (result['isValid']) {
    print(result['message']);
  }
} on FirebaseFunctionsException catch (e) {
  print(service.getErrorMessage(e));
}
```

### Example 3: Event-Based Function - Send Welcome Email

```javascript
// Automatically runs when new user signs up
exports.sendWelcomeEmail = functions.auth
  .user()
  .onCreate(async (user) => {
    const email = user.email;
    const displayName = user.displayName || 'Friend';
    
    // Send email using SendGrid/Firebase Email
    await admin.firestore()
      .collection('mail')
      .add({
        to: email,
        message: {
          subject: `Welcome, ${displayName}!`,
          html: `<h1>Welcome to TaskPilot!</h1>
                 <p>Hello ${displayName},</p>
                 <p>Your account has been created.</p>`
        }
      });
    
    return null;
  });
```

### Example 4: Process Payment Securely

```javascript
// NEVER handle card data in Flutter - use Cloud Function!
exports.processPayment = functions.https
  .onCall(async (data, context) => {
    // Authenticate
    if (!context.auth) {
      throw new functions.https.HttpsError(
        'unauthenticated',
        'Not authenticated'
      );
    }
    
    const userId = context.auth.uid;
    const { amount, currency } = data;
    
    // Validate
    if (!amount || amount <= 0) {
      throw new functions.https.HttpsError(
        'invalid-argument',
        'Invalid amount'
      );
    }
    
    try {
      // Process with Stripe
      const payment = await stripe.charges.create({
        amount: Math.round(amount * 100),
        currency: currency || 'usd',
        customer: userId,
        // Card token comes from frontend, never stored
      });
      
      // Log transaction
      await admin.firestore()
        .collection('transactions')
        .add({
          userId: userId,
          amount: amount,
          status: 'completed',
          stripeId: payment.id,
          timestamp: admin.firestore.FieldValue.serverTimestamp()
        });
      
      return {
        success: true,
        transactionId: payment.id,
        message: 'Payment processed'
      };
    } catch (error) {
      throw new functions.https.HttpsError(
        'internal',
        'Payment failed: ' + error.message
      );
    }
  });

// Flutter
try {
  final result = await service.processPayment(
    userId: userId,
    amount: 29.99,
    currency: 'usd'
  );
  print('Payment ID: ${result['transactionId']}');
} catch (e) {
  print('Payment error: $e');
}
```

### Example 5: Aggregate User Statistics

```javascript
exports.getUserStatistics = functions.https
  .onCall(async (data, context) => {
    const userId = data.userId;
    
    // Count tasks by status
    const tasks = await admin.firestore()
      .collection('tasks')
      .where('userId', '==', userId)
      .get();
    
    let completed = 0, pending = 0, total = 0;
    
    tasks.forEach(doc => {
      const task = doc.data();
      total++;
      if (task.status === 'completed') completed++;
      if (task.status === 'pending') pending++;
    });
    
    // Calculate completion rate
    const completionRate = total > 0 ? (completed / total) * 100 : 0;
    
    return {
      totalTasks: total,
      completedTasks: completed,
      pendingTasks: pending,
      completionRate: completionRate.toFixed(2)
    };
  });

// Flutter
final stats = await service.getUserStatistics(userId: userId);
print('Completion: ${stats['completionRate']}%');
```

### Example 6: Retry with Exponential Backoff

```dart
// Automatic retry on network/timeout errors
final result = await service.callWithRetry(
  () => service.sayHello(name: 'User'),
  maxRetries: 3,
  initialDelay: Duration(milliseconds: 500),
);
// Function retries on: deadline-exceeded, resource-exhausted
```

## Performance Metrics

### Function Execution Speed

- **Simple string function:** 100-300ms
- **Database query function:** 500-1000ms
- **Third-party API call:** 1000-3000ms+

### Cost Analysis

| Metric | Pricing |
|--------|---------|
| Calls | 2M/month free, then $0.40/million |
| Compute time | $0.000002400 per GB-second |
| Data transfer | First 5GB free, then variable |

### Example Monthly Cost

| Scenario | Calls | Cost |
|----------|-------|------|
| 100 users, 10 calls/day | 36K | Free (under 2M) |
| 1000 users, 10 calls/day | 365K | Free |
| 10000 users, 10 calls/day | 3.65M | ~$2.60 |
| 100K users, 10 calls/day | 36.5M | ~$15.00 |

## Security Best Practices

### ✅ What To Do

1. **Authenticate users** before calling functions
   ```javascript
   if (!context.auth) {
     throw new functions.https.HttpsError('unauthenticated', 'Login required');
   }
   ```

2. **Validate all input server-side** - Never trust the app
   ```javascript
   if (!data.email || !data.email.includes('@')) {
     throw new functions.https.HttpsError('invalid-argument', 'Bad email');
   }
   ```

3. **Use environment variables** for secrets
   ```bash
   firebase functions:config:set stripe.secret="sk_test_..."
   firebase deploy --only functions
   ```

4. **Set reasonable timeouts**
   ```javascript
   exports.longTask = functions
     .runWith({ timeoutSeconds: 300 })
     .https.onCall((data, context) => { ... });
   ```

5. **Rate limit** function calls if needed
   ```javascript
   // Use Redis/Firestore to track calls
   ```

### ❌ What NOT To Do

- Don't pass card data to functions (use Stripe tokens)
- Don't log sensitive data
- Don't store secrets in code
- Don't trust client-side validation
- Don't leave functions public without auth checks

## Testing & Debugging

### Test Locally

```bash
# Start emulator
firebase emulators:start --only functions

# In another terminal, test:
firebase functions:shell
> sayHello({name: 'Test'})
```

### View Logs

1. Firebase Console → Functions → Logs
2. See all executions, errors, and console.log output
3. Filter by function, time, status

### Common Issues

| Issue | Cause | Solution |
|-------|-------|----------|
| Function timeout | Too slow | Increase timeout or optimize code |
| CORS error | Domain mismatch | Use proper CORS headers |
| 403 Forbidden | Not authenticated | Check auth rules |
| Function not found | Not deployed | Run `firebase deploy --only functions` |

## Event-Based Examples

### Firestore Triggers

```javascript
// On task creation, update user stats
exports.onTaskCreate = functions.firestore
  .document('tasks/{taskId}')
  .onCreate((snap) => {
    const task = snap.data();
    return admin.firestore()
      .collection('users').doc(task.userId)
      .update({
        totalTasks: firebase.firestore.FieldValue.increment(1)
      });
  });

// On task deletion, clean up
exports.onTaskDelete = functions.firestore
  .document('tasks/{taskId}')
  .onDelete((snap) => {
    // Delete related comments, attachments
  });
```

### Auth Triggers

```javascript
// Send welcome email on signup
exports.sendWelcome = functions.auth
  .user()
  .onCreate(async (user) => {
    // Send email
  });

// Clean up user data on delete
exports.deleteUserData = functions.auth
  .user()
  .onDelete(async (user) => {
    // Delete all user docs
  });
```

### Storage Triggers

```javascript
// Generate thumbnail on image upload
exports.generateThumbnail = functions.storage
  .object()
  .onFinalize(async (object) => {
    if (!object.name.endsWith('.jpg')) return;
    // Use Sharp to create thumbnail
  });
```

## Demo Screens

### Cloud Functions Demo (`/cloud-functions-demo`)

**Tab 1: Basic Functions**
- Say Hello with name input
- Get Server Time
- Health Check

**Tab 2: Advanced Functions**
- App Configuration
- User Statistics

**Tab 3: Event-Based**
- Visual explanation of all trigger types
- When functions auto-run

**Tab 4: Code Examples**
- Callable function example
- Error handling
- Server time usage
- Retry pattern
- Check availability

**Tab 5: Info**
- What are Cloud Functions
- Benefits
- Use cases

### Cloud Functions Documentation (`/cloud-functions-documentation`)

10 comprehensive sections covering concepts, implementation, examples, security, pricing, debugging, and best practices.

## Files Modified

- `flutter_app/pubspec.yaml` - Added cloud_functions dependency
- `flutter_app/lib/services/cloud_functions_service.dart` - New service (500+ lines)
- `flutter_app/lib/screens/cloud_functions_demo_screen.dart` - New demo (700+ lines)
- `flutter_app/lib/screens/cloud_functions_documentation_screen.dart` - New docs (600+ lines)
- `flutter_app/lib/main.dart` - Added 2 routes  

## Summary

Firebase Cloud Functions bring serverless backend to TaskPilot:
- ✅ Callable functions from Flutter
- ✅ Event-based automatic triggers
- ✅ Secure backend logic execution
- ✅ No server management
- ✅ Comprehensive logging
- ✅ Cost-effective

**Status:** ✅ Complete and Ready for Integration  
**Date Completed:** March 6, 2026  
**Lines of Code:** 1800+  
**Documentation:** Comprehensive  
