import 'package:flutter/material.dart';
import '../constants/retro_theme.dart';

class FirestoreSecurityRulesScreen extends StatelessWidget {
  const FirestoreSecurityRulesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firestore Security Rules Guide'),
        backgroundColor: RetroColors.neonPurple,
        elevation: 8,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(
              context,
              'Overview',
              '''Firestore Security Rules are essential for protecting user data. They enforce access control at the database level, ensuring only authorized users can read or write specific documents.

Key Principles:
- Default Deny: All access is denied unless explicitly allowed
- Server-Side Enforcement: Rules execute on Firestore servers, not the client
- Authentication-Based: Rules can check if user is authenticated
- User-Specific: Rules can compare request.auth.uid with document fields''',
            ),
            _buildSection(
              context,
              'Authentication Context',
              '''Before accessing Firestore, a user must be authenticated with Firebase Auth.

The security rule variable request.auth contains:
- request.auth.uid: The authenticated user's unique ID
- request.auth.token.email: The user's email address  
- request.auth.token.email_verified: Email verification status
- request.auth.token.custom_claims: Custom role data (if set)

Example:
  request.auth != null  // True if user is authenticated
  request.auth.uid == "user123"  // True if user's UID is "user123"''',
            ),
            _buildSection(
              context,
              'Secure Profile Security Rules',
              '''The Secure Profile feature uses these rules:

FIRESTORE RULES:
================================================================
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{uid} {
      // Allow read if authenticated AND requesting own document
      allow read: if request.auth != null 
                  && request.auth.uid == uid;
      
      // Allow create if authenticated AND creating own document
      allow create: if request.auth != null 
                    && request.auth.uid == uid;
      
      // Allow update/delete if authenticated AND own document
      allow update, delete: if request.auth != null 
                            && request.auth.uid == uid;
    }
  }
}
================================================================

How It Works:

1. READ REQUEST
   Path: /users/user123
   Current User: user123
   Check: request.auth.uid == "user123"? YES [OK]
   Result: READ ALLOWED

2. UNAUTHORIZED READ
   Path: /users/user456
   Current User: user123
   Check: request.auth.uid == "user456"? NO [X]
   Result: READ DENIED (permission-denied error)

3. WRITE REQUEST
   Path: /users/user123
   Current User: user123
   Check: request.auth.uid == "user123"? YES [OK]
   Result: WRITE ALLOWED

4. UNAUTHORIZED WRITE
   Path: /users/user456
   Current User: user123
   Check: request.auth.uid == "user456"? NO [X]
   Result: WRITE DENIED (permission-denied error)''',
            ),
            _buildSection(
              context,
              'Step-by-Step: How the Demo Shows Security',
              '''The Secure Profile Demo demonstrates both allowed and blocked operations:

ALLOWED OPERATIONS (Work Successfully):
-----------------------------------------
1. Read Your Own Profile
   - User is authenticated
   - Database path: /users/{their-uid}
   - request.auth.uid matches the {uid} in path
   - Firestore returns the document [OK]

2. Write Your Own Profile
   - User is authenticated
   - Database path: /users/{their-uid}
   - request.auth.uid matches the {uid} in path
   - Document is updated successfully [OK]

BLOCKED OPERATIONS (Fail as Expected):
--------------------------------------
3. Attempt to Read Another User's Profile
   - User is authenticated (but with different UID)
   - Database path: /users/{other-user-uid}
   - request.auth.uid does NOT match the {uid} in path
   - Firestore denies the read with "permission-denied" [X]

4. Attempt to Write Another User's Profile
   - User is authenticated (but with different UID)
   - Database path: /users/{other-user-uid}
   - request.auth.uid does NOT match the {uid} in path
   - Firestore denies the write with "permission-denied" [X]

Testing in the Demo:
1. Sign in with your credentials
2. Your profile (read/write) works immediately
3. Get another user's UID from them
4. Paste their UID in the "Target User UID" field
5. Click "Test Read Block" - should fail
6. Click "Test Write Block" - should fail
7. Check the Security Events Log for confirmation''',
            ),
            _buildSection(
              context,
              'Common Security Rule Patterns',
              '''Pattern 1: Owner-Only Access (Secure Profile)
match /users/{uid} {
  allow read, write, delete: if request.auth.uid == uid;
}

Pattern 2: Read-Only Public Data
match /public/{document=**} {
  allow read: if true;  // Anyone can read
  allow write: if false;  // No one can write
}

Pattern 3: Authenticated Users Only
match /private/{document=**} {
  allow read, write: if request.auth != null;
}

Pattern 4: Role-Based Access
match /admin/{document=**} {
  allow read, write: if request.auth.token.admin == true;
}

Pattern 5: Subcollections
match /users/{uid}/posts/{postId} {
  allow read: if request.auth.uid == uid 
              || resource.data.isPublic == true;
  allow write: if request.auth.uid == uid;
}

Pattern 6: Data Validation
match /users/{uid} {
  allow create: if request.auth.uid == uid
                && request.resource.data.keys().hasAll(['email', 'name']);
  allow update: if request.auth.uid == uid
                && request.resource.data.email == resource.data.email;
}''',
            ),
            _buildSection(
              context,
              'Deploying Security Rules to Firebase',
              '''Step 1: Create/Update firestore.rules File
Create a file named firestore.rules in your project root:

rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{uid} {
      allow read, write: if request.auth != null 
                         && request.auth.uid == uid;
    }
  }
}

Step 2: Update firestore.json
Create/update firestore.json in project root:

{
  "firestore": {
    "rules": "firestore.rules",
    "indexes": "firestore.indexes.json"
  }
}

Step 3: Install Firebase CLI
\$ npm install -g firebase-tools

Step 4: Login to Firebase
\$ firebase login

Step 5: Deploy Rules
\$ firebase deploy --only firestore:rules

Output will show:
[OK] Deploy complete!
[OK] Firestore Rules updated successfully.

Step 6: Verify in Console
1. Go to Firebase Console
2. Project Settings > Firestore
3. Rules tab
4. Verify your rules are deployed

Step 7: Test Rules in Emulator (Optional)
For development, test with Firestore Emulator:

\$ firebase emulators:start

Then in your app:
instance.settings = const Settings(
  host: '127.0.0.1:8080',
  sslEnabled: false,
)''',
            ),
            _buildSection(
              context,
              'Security Rule Testing Best Practices',
              '''DO's:
[OK] Always require authentication (request.auth != null)
[OK] Compare user IDs (request.auth.uid == resource_uid)
[OK] Validate data structure before write
[OK] Use custom claims for roles
[OK] Test all paths (read, write, delete)
[OK] Test unauthorized scenarios
[OK] Use Firestore Emulator for development
[OK] Monitor Firestore activity in console
[OK] Update rules cache by redeploying
[OK] Document your security approach

DON'Ts:
[BLOCK] Don't use allow if true; on sensitive data
[BLOCK] Don't assume client-side security is enough
[BLOCK] Don't store plaintext sensitive data
[BLOCK] Don't hardcode user IDs in rules
[BLOCK] Don't forget to test negative scenarios
[BLOCK] Don't deploy untested rules to production
[BLOCK] Don't ignore permission-denied errors
[BLOCK] Don't assume rules are immediate
[BLOCK] Don't allow subcollection access unintentionally
[BLOCK] Don't mix authentication checks''',
            ),
            _buildSection(
              context,
              'Common Errors and Solutions',
              '''Error: "permission-denied" on read/write
-----------------------------------------
Cause: User doesn't match the security rule conditions
Solution: 
  - Check user is authenticated: request.auth != null
  - Check user ID matches: request.auth.uid == expected_uid
  - Verify the Firestore path matches the rule path
  - Confirm user UID in Firebase Console

Error: Rules not updated after deploy
--------------------------------------
Cause: Caching or deployment failure
Solution:
  - Wait 30 seconds after deploy
  - Reload the app completely
  - Clear browser cache if using web
  - Verify deployment with: firebase rules:list

Error: Unexpected network error
--------------------------------
Cause: Rule validation issue or network problem
Solution:
  - Check rule syntax with firebase emulators:start
  - Verify internet connection
  - Check Firebase project status
  - Review rule file for syntax errors

Error: Can't write even to own document
----------------------------------------
Cause: Path mismatch or rule logic error
Solution:
  - Verify document path uses correct uid
  - Check request.auth.uid is accessible
  - Test with simple rule first
  - Use Firestore console to debug''',
            ),
            _buildSection(
              context,
              'Testing the Rules Locally',
              '''Using Firestore Emulator:

1. Start the emulator:
   \$ firebase emulators:start

2. Configure app to use emulator:
   // In main.dart
   FirebaseFirestore.instance.settings = Settings(
     host: '127.0.0.1:8080',
     sslEnabled: false,
   );

3. Run your app with emulator

4. Test authorized and unauthorized access

5. View logs in emulator console

6. Stop with Ctrl+C

Benefits:
- No cost for testing
- Fast iteration
- See rule evaluation details
- Test data isolation''',
            ),
            _buildSection(
              context,
              'Production Checklist',
              '''Before deploying to production:

Security:
[ ] All sensitive collections have access rules
[ ] Default deny pattern implemented
[ ] Authentication required for protected data
[ ] User IDs validated in rules
[ ] Subcollections properly protected
[ ] Admin functions have role-based access
[ ] No allow if true; on sensitive paths

Testing:
[ ] Authorized reads succeed
[ ] Authorized writes succeed
[ ] Unauthorized reads fail
[ ] Unauthorized writes fail
[ ] User isolation verified
[ ] Edge cases tested
[ ] Error messages appropriate

Performance:
[ ] Rules are optimized
[ ] No overly complex conditions
[ ] Indexes created for queries
[ ] Query filtering optimized

Documentation:
[ ] Security rules documented
[ ] Access patterns explained
[ ] Testing procedures recorded
[ ] Deployment instructions clear''',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: RetroColors.neonPurple,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[50],
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.all(12),
          child: SelectableText(
            content,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              height: 1.5,
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
