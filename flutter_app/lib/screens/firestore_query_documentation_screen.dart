import 'package:flutter/material.dart';
import '../constants/retro_theme.dart';

///
/// FirestoreQueryDocumentationScreen - Educational guide for Firestore queries
///
/// Covers:
/// - Filtering with where()
/// - Ordering with orderBy()
/// - Limiting results
/// - Complex queries
/// - Performance and indexing
/// - Query best practices
///
class FirestoreQueryDocumentationScreen extends StatelessWidget {
  const FirestoreQueryDocumentationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('📚 Firestore Queries Guide'),
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
              title: '🎯 Why Query?',
              content: '''
Firestore queries let you retrieve only the data you need from your database.

Benefits:
• Faster app performance - Only load needed documents
• Reduced bandwidth - Less data transfer
• Better battery life - Less processing
• Cleaner UX - Display pre-sorted/filtered data
• Lower costs - Fewer reads with proper filtering

Instead of:
- Fetch 1000 documents, filter in app
- Fetch all, display everything

Do:
- Query only what you need
- Let Firestore do the filtering
              ''',
              color: Colors.blue[900]!,
            ),
            _buildSection(
              context,
              title: '🔍 Filtering with where()',
              content: '''
Use where() to filter documents by a field value.

Syntax:
.where("fieldName", condition: value)

Equality Filter:
.where("status", isEqualTo: "pending")

Comparison Operators:
.where("priority", isGreaterThan: 5)
.where("price", isLessThanOrEqualTo: 100)

In Array:
.where("tags", arrayContains: "featured")

In List of Values:
.where("status", whereIn: ["pending", "in_progress"])

Multiple Filters (AND logic):
.where("userId", isEqualTo: "user123")
.where("status", isEqualTo: "active")
.where("priority", isGreaterThan: 3)

⚠️ First filter should narrow down most documents!
              ''',
              color: Colors.green[900]!,
            ),
            _buildSection(
              context,
              title: '📊 Ordering with orderBy()',
              content: '''
Use orderBy() to sort results.

Syntax:
.orderBy("fieldName")         // Ascending (default)
.orderBy("fieldName", 
    descending: true)         // Descending

Examples:
// Sort by due date (earliest first)
.orderBy("dueDate")

// Sort by priority (high first)
.orderBy("priority", descending: true)

// Multiple orderBy() - Chain them
.orderBy("priority", descending: true)
.orderBy("dueDate")
// First by priority desc, then by dueDate asc

⚠️ Firestore may require an index for complex sorts
              ''',
              color: Colors.orange[900]!,
            ),
            _buildSection(
              context,
              title: '📍 Limiting Results',
              content: '''
Use limit() to fetch only N documents.

Syntax:
.limit(10)

Benefits:
• Pagination support (load more...)
• Faster queries on large collections
• Reduced bandwidth
• Better performance

Example - Load 20 tasks at a time:
final tasks = await _firestore
    .collection("tasks")
    .where("userId", isEqualTo: userId)
    .orderBy("dueDate")
    .limit(20)
    .get();

Next page - Use startAfter():
final nextBatch = await query
    .startAfter([lastDocument])
    .limit(20)
    .get();
              ''',
              color: Colors.purple[900]!,
            ),
            _buildSection(
              context,
              title: '🏗️ Building Complex Queries',
              content: '''
Combine where(), orderBy(), and limit() for power.

Pattern:
.where(...filters...)
.orderBy(...sort...)
.limit(count)

Real Example - Get high-priority pending tasks:
final query = _firestore
    .collection("tasks")
    .where("userId", isEqualTo: "user123")
    .where("status", isEqualTo: "pending")
    .where("priority", whereIn: ["urgent", "high"])
    .orderBy("priority", descending: true)
    .orderBy("dueDate")
    .limit(50)
    .get();

Real-Time Version - Use snapshots():
query.snapshots().map((snapshot) {
  return snapshot.docs
      .map((doc) => TaskModel.fromFirestore(doc.data()))
      .toList();
})

Benefits:
✓ Only fetch needed documents
✓ Pre-sorted on server
✓ Pre-filtered on server
✓ Updates in real-time with snapshots()
              ''',
              color: Colors.indigo[900]!,
            ),
            _buildSection(
              context,
              title: '⚡ Performance Tips',
              content: '''
Optimize your queries for speed:

1. Use Filters First
✓ Good:
  .where("userId", isEqualTo: userId)
  .where("isActive", isEqualTo: true)
  
✗ Bad:
  .collection("tasks")  // Get all first!

2. Create Indexes for Complex Queries
If Firestore shows an index suggestion,
create it! Indexes make queries 10x faster.

3. Order by Filtered Fields
✓ Filter by status, order by date

✗ Don't order by high-cardinality field

4. Use Pagination
✓ Load 20-50 items, not 1000

✗ Don't fetch entire collection

5. Combine Multiple Filters
✓ Use multiple where() to narrow results

✗ Don't fetch then filter in JavaScript

6. Cache Results
✓ Use Firestore offline persistence

✗ Don't re-query same data constantly

Query Cost:
One read = one document retrieved
Firestore counts reads for billing!
              ''',
              color: Colors.red[900]!,
            ),
            _buildSection(
              context,
              title: '🔗 Firestore Indexes',
              content: '''
Indexes make queries fast!

Single-Field Indexes (Automatic):
- Firestore creates automatically for common queries
- Example: orderBy("name")

Composite Indexes (Manual):
- Required for complex queries
- Example: orderBy("priority") + orderBy("dueDate")

When You Need an Index:
❌ Error Message: "The query requires an index"
✅ Solution: Click the link in error to create it

In Firebase Console:
1. Go to Firestore → Indexes
2. Click "Create Composite Index"
3. Select collection: "tasks"
4. Add fields: 
   - priority (Descending)
   - dueDate (Ascending)
5. Click Create

Firestore will suggest missing indexes!
              ''',
              color: Colors.teal[900]!,
            ),
            _buildSection(
              context,
              title: '📝 Common Query Patterns',
              content: '''
Pattern 1: Recent Items
.orderBy("createdAt", descending: true)
.limit(10)

Pattern 2: Status Grouped
.where("status", isEqualTo: "pending")
.orderBy("priority", descending: true)

Pattern 3: User Specific
.where("userId", isEqualTo: currentUserId)
.where("isActive", isEqualTo: true)

Pattern 4: Date Range
.where("dueDate", 
    isGreaterThanOrEqualTo: startDate)
.where("dueDate", 
    isLessThanOrEqualTo: endDate)

Pattern 5: Search-like
.where("name", 
    isGreaterThanOrEqualTo: query)
.where("name", 
    isLessThan: query + "z")

Pattern 6: Pagination
final firstPage = await collection
    .orderBy("createdAt", descending: true)
    .limit(20)
    .get();

final secondPage = await collection
    .orderBy("createdAt", descending: true)
    .startAfter([firstPage.docs.last])
    .limit(20)
    .get();
              ''',
              color: Colors.cyan[900]!,
            ),
            _buildSection(
              context,
              title: '⚠️ Common Mistakes',
              content: '''
Mistake 1: Fetching Too Much
❌ .collection("users").get()  // Gets all!
✅ .where("status", isEqualTo: "active").get()

Mistake 2: Ordering Without Index
❌ Multiple orderBy without index
✅ Create composite index first

Mistake 3: Case-Sensitive Search
❌ .where("name", isEqualTo: "John")
   // Won't find "john"
✅ Save lowercase field:
   .where("nameLower", isEqualTo: "john")

Mistake 4: Not Using Limits
❌ .get()  // Could return millions!
✅ .limit(50).get()

Mistake 5: Complex Filters in App
❌ Get all documents, filter in code
✅ Let Firestore do filtering with where()

Mistake 6: Ignoring Costs
❌ Querying unnecessarily
✅ Cache results, use pagination
              ''',
              color: Colors.pink[900]!,
            ),
            _buildSection(
              context,
              title: '💡 Real-World Examples',
              content: '''
Example 1: Task Dashboard
Get today's high-priority tasks:

.where("userId", isEqualTo: userId)
.where("dueDate", 
    isGreaterThanOrEqualTo: today)
.where("priority", whereIn: ["urgent", "high"])
.orderBy("priority", descending: true)
.orderBy("dueDate")
.limit(10)

Example 2: Activity Feed
Get recent user activities:

.where("recipientId", isEqualTo: userId)
.orderBy("createdAt", descending: true)
.limit(20)

Use pagination for more

Example 3: Completed Tasks  
Get finished tasks this month:

.where("userId", isEqualTo: userId)
.where("status", isEqualTo: "completed")
.where("completedAt", 
    isGreaterThan: monthStart)
.orderBy("completedAt", descending: true)

Example 4: Search Results
Search tasks by title prefix:

.where("userId", isEqualTo: userId)
.where("titleLower",
    isGreaterThanOrEqualTo: searchLower)
.where("titleLower",
    isLessThan: searchLower + "z")
.limit(50)
              ''',
              color: Colors.lime[900]!,
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
