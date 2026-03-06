import 'package:flutter/material.dart';
import '../constants/retro_theme.dart';

///
/// RealtimeSyncDocumentationScreen - Educational guide for real-time sync
///
/// Displays comprehensive documentation about:
/// - How StreamBuilder works
/// - Real-time listener patterns
/// - Error handling and states
/// - Best practices
/// - Code examples
///
class RealtimeSyncDocumentationScreen extends StatelessWidget {
  const RealtimeSyncDocumentationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('📚 Real-Time Sync Guide'),
        backgroundColor: Colors.grey[900],
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(
              context,
              title: '🎯 What is Real-Time Sync?',
              content: '''
Real-time synchronization automatically updates your Flutter UI whenever 
data changes in Firestore. Instead of manually refreshing, Firestore 
listeners notify your app instantly of any changes.

Use cases:
• Chat applications with instant message delivery
• Live dashboards displaying metrics
• Collaborative editing tools
• Activity feeds
• Stock price tickers
• Order status tracking
              ''',
              color: Colors.blue[900]!,
            ),
            _buildSection(
              context,
              title: '🔌 Collection Snapshots (Multiple Documents)',
              content: '''
Listen to an entire collection for changes:

Stream<List<TaskModel>> getUserTasks(String userId) {
  return _firestore
      .collection('tasks')
      .where('userId', isEqualTo: userId)
      .snapshots()  // ← Real-time listener
      .map((snapshot) {
        return snapshot.docs
            .map((doc) => TaskModel.fromFirestore(
              doc.data(), 
              doc.id
            ))
            .toList();
      });
}

Triggers when:
✓ A document is added to the collection
✓ A document is modified
✓ A document is deleted
              ''',
              color: Colors.green[900]!,
            ),
            _buildSection(
              context,
              title: '📄 Document Snapshots (Single Document)',
              content: '''
Listen to a single document for changes:

Stream<TaskModel?> watchTask(String taskId) {
  return _firestore
      .collection('tasks')
      .doc(taskId)  // ← Specific document
      .snapshots()  // ← Real-time listener
      .map((snapshot) {
        if (snapshot.exists) {
          return TaskModel.fromFirestore(
            snapshot.data()!, 
            snapshot.id
          );
        }
        return null;
      });
}

Perfect for:
• Updating task detail screens
• Tracking individual item changes
• Authorization/permission updates
              ''',
              color: Colors.purple[900]!,
            ),
            _buildSection(
              context,
              title: '🎨 Using StreamBuilder in UI',
              content: '''
StreamBuilder automatically rebuilds when stream emits:

StreamBuilder<List<TaskModel>>(
  stream: _firestoreService.getUserTasks(userId),
  builder: (context, snapshot) {
    // Loading state
    if (snapshot.connectionState == 
        ConnectionState.waiting) {
      return CircularProgressIndicator();
    }

    // Error state
    if (snapshot.hasError) {
      return Text('Error: \${snapshot.error}');
    }

    // Empty state
    if (!snapshot.hasData || 
        snapshot.data!.isEmpty) {
      return Text('No tasks yet');
    }

    // Data available
    final tasks = snapshot.data!;
    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        return TaskCard(task: tasks[index]);
      },
    );
  },
)
              ''',
              color: Colors.orange[900]!,
            ),
            _buildSection(
              context,
              title: '🔍 Connection States Explained',
              content: '''
ConnectionState has these values:

1. ConnectionState.waiting
   → First time loading, waiting for data
   → Show loading spinner

2. ConnectionState.active
   → Stream is connected and receiving data
   → Data available (check snapshot.hasData)

3. ConnectionState.done
   → Stream has finished/closed
   → Rare for cloud listeners

4. ConnectionState.none
   → No stream connected yet
   → Usually doesn't happen

Code:
if (snapshot.connectionState == 
    ConnectionState.waiting) {
  return LoadingIndicator();
}
              ''',
              color: Colors.cyan[900]!,
            ),
            _buildSection(
              context,
              title: '⚡ Snapshot Metadata (Advanced)',
              content: '''
Get detailed change information:

Stream<QuerySnapshot> watchTasksSnapshot(
  String userId
) {
  return _firestore
      .collection('tasks')
      .where('userId', isEqualTo: userId)
      .snapshots(includeMetadataChanges: true)
      // ^^ Includes metadata events
}

Usage in StreamBuilder:
final isFromServer = 
  !snapshot.data!.metadata.isFromCache;
final hasPendingWrites = 
  snapshot.data!.metadata.hasPendingWrites;

Benefits:
• Detect server vs local cache data
• Track pending write operations
• Show sync status indicators
              ''',
              color: Colors.indigo[900]!,
            ),
            _buildSection(
              context,
              title: '📊 Tracking Document Changes',
              content: '''
See exactly which documents changed:

Stream<List<DocumentChange>> watchTaskChanges(
  String userId
) {
  return _firestore
      .collection('tasks')
      .where('userId', isEqualTo: userId)
      .snapshots()
      .map((snapshot) => snapshot.docChanges);
}

In StreamBuilder:
final changes = snapshot.data!;
...changes.map((change) {
  final type = change.type;
  // DocumentChangeType.added
  // DocumentChangeType.modified
  // DocumentChangeType.removed
  
  final document = change.doc;
  final data = document.data();
  final docId = document.id;
})

Perfect for:
• Animating list changes
• Showing change indicators
• Tracking who made changes
              ''',
              color: Colors.teal[900]!,
            ),
            _buildSection(
              context,
              title: '✅ Error Handling Best Practices',
              content: '''
Always handle errors in listeners:

Stream<List<TaskModel>> getUserTasks(
  String userId
) {
  return _firestore
      .collection('tasks')
      .where('userId', isEqualTo: userId)
      .snapshots()
      .map((snapshot) {
        return snapshot.docs
            .map((doc) => TaskModel.fromFirestore(
              doc.data(), 
              doc.id
            ))
            .toList();
      })
      .handleError((error) {
        print('Error: \$error');
        return <TaskModel>[]; // Return empty list
      });
}

In UI, check:
if (snapshot.hasError) {
  return ErrorWidget(
    error: snapshot.error.toString()
  );
}
              ''',
              color: Colors.red[900]!,
            ),
            _buildSection(
              context,
              title: '🚀 Performance Tips',
              content: '''
Optimize real-time listeners:

1. Use where() and orderBy() filters
   // Good - Only listen to your tasks
   .where('userId', isEqualTo: userId)
   
   // Bad - Listen to entire collection
   // (Expensive and slow)

2. Add indexes for complex queries
   Check Firestore Console for suggestions

3. Limit documents in queries
   .limit(50)

4. Avoid unnecessary listeners
   // Bad - Creates new listener every build
   StreamBuilder(
     stream: FirebaseFirestore.instance
       .collection('tasks')
       .snapshots(),  // Creates new every time
   )
   
   // Good - Create in provider/service
   final _streamFactory = 
     () => firestoreService.getUserTasks(userId);

5. Unsubscribe when not needed
   Streams automatically dispose in StatefulWidget
   But dispose StreamControllers manually
              ''',
              color: Colors.pink[900]!,
            ),
            _buildSection(
              context,
              title: '🎓 Common Patterns',
              content: '''
Pattern 1: Filter + Real-time
StreamBuilder(
  stream: _selectedStatus != null
      ? firestoreService.getTasksByStatus(
          userId, _selectedStatus)
      : firestoreService.getUserTasks(userId),
)

Pattern 2: Combined Streams
StreamBuilder(
  stream: CombineLatestStream.list([
    firestore.watchTask(taskId1),
    firestore.watchTask(taskId2),
  ]),
)

Pattern 3: Search with Real-time
// In UI:
StreamBuilder(
  stream: _buildSearchStream(_searchText),
)

// In service:
Stream<List<T>> search(String query) {
  return _firestore
      .collection('tasks')
      .where('title', 
          isGreaterThanOrEqualTo: query)
      .where('title',
          isLessThan: query + 'z')
      .snapshots()
      .map((snapshot) => ...);
}
              ''',
              color: Colors.lime[900]!,
            ),
            _buildSection(
              context,
              title: '⚠️ Important Notes',
              content: '''
Security:
• Real-time listeners respect Firestore security rules
• Users can only listen to data they have permission to read

Costs:
• Each document read/write counts toward quota
• Real-time listeners generate reads when data changes
• Deleting fields only updates if you modify the document

Offline:
• Listeners work with offline persistence
• Local cached data updates first
• Server data syncs when online

Network:
• Listeners survive network disconnections
• Automatically reconnect when connection restored
• Firestore handles reconnection logic
              ''',
              color: Colors.amber[900]!,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required String content,
    required Color color,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[700]!),
            borderRadius: BorderRadius.circular(8),
            color: Colors.grey[900],
          ),
          child: SelectableText(
            content,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontFamily: 'monospace',
              fontSize: 11,
              height: 1.6,
            ),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
