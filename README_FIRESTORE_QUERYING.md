# Firestore Queries, Filters, and Ordering Implementation

## Overview

This feature implements comprehensive Firestore querying capabilities for the TaskPilot app. It enables powerful data retrieval with filters, sorting, limiting, and complex queries—all optimized for performance and reduced bandwidth usage.

**Key Features:**
- ✅ Flexible filtering with `where()` clauses
- ✅ Advanced sorting with `orderBy()` (ascending/descending)
- ✅ Result limiting for pagination
- ✅ Complex multi-condition queries
- ✅ Real-time filtered streams
- ✅ Search and pattern matching
- ✅ Date range queries
- ✅ Batch operations
- ✅ Performance optimized with proper indexing

---

## Why Firestore Queries Matter

### Performance Benefits

| Without Queries | With Queries |
|---|---|
| Fetch 1000+ documents | Fetch only 20 needed |
| Filter in app code | Filter on server |
| High bandwidth | Low bandwidth |
| Slow UI | Fast UI |
| More battery drain | Less battery drain |

### Real-World Impact

- **Chat App:** Query only unread messages → 100x faster
- **Dashboard:** Query today's data → Metrics load instantly
- **Task App:** Query pending tasks → Show next steps immediately
- **E-commerce:** Query by price range → Instant product filtering

---

## Implementation Details

### 1. Query Methods in FirestoreService

#### A. Simple Filtering Methods

```dart
/// Get tasks by status
Future<List<TaskModel>> queryTasksByStatusFuture(
  String userId,
  String status,
) async {
  return await _firestore
      .collection('tasks')
      .where('userId', isEqualTo: userId)
      .where('status', isEqualTo: status)
      .orderBy('dueDate', descending: false)
      .get();
}

// Usage:
final pendingTasks = await firestoreService
    .queryTasksByStatusFuture(userId, 'pending');
```

#### B. Comparison Operators

```dart
/// Get high priority tasks (urgent or high)
Future<List<TaskModel>> queryHighPriorityTasks(
  String userId,
) async {
  return await _firestore
      .collection('tasks')
      .where('userId', isEqualTo: userId)
      .where('priority', whereIn: ['urgent', 'high'])
      .orderBy('priority', descending: true)
      .orderBy('dueDate', descending: false)
      .get();
}
```

#### C. Date Range Queries

```dart
/// Get tasks due within date range
Future<List<TaskModel>> queryTasksByDateRange(
  String userId,
  DateTime startDate,
  DateTime endDate,
) async {
  return await _firestore
      .collection('tasks')
      .where('userId', isEqualTo: userId)
      .where('dueDate', 
          isGreaterThanOrEqualTo: startDate.toIso8601String())
      .where('dueDate', 
          isLessThanOrEqualTo: endDate.toIso8601String())
      .orderBy('dueDate', descending: false)
      .get();
}

// Usage:
final tomorrow = DateTime.now().add(Duration(days: 1));
final nextWeek = DateTime.now().add(Duration(days: 7));
final weekTasks = await firestoreService
    .queryTasksByDateRange(userId, tomorrow, nextWeek);
```

#### D. Advanced Multi-Filter Queries

```dart
/// Complex query with multiple optional filters
Future<List<TaskModel>> queryTasksAdvanced(
  String userId, {
  String? status,
  String? priority,
  DateTime? dueAfter,
  int? limitCount = 25,
}) async {
  Query query = _firestore.collection('tasks');

  // Apply filters dynamically
  query = query.where('userId', isEqualTo: userId);
  if (status != null) {
    query = query.where('status', isEqualTo: status);
  }
  if (priority != null) {
    query = query.where('priority', isEqualTo: priority);
  }
  if (dueAfter != null) {
    query = query.where('dueDate', 
        isGreaterThanOrEqualTo: dueAfter.toIso8601String());
  }

  // Apply sorting and limit
  query = query
      .orderBy('dueDate', descending: false)
      .limit(limitCount ?? 25);

  return (await query.get()).docs
      .map((doc) => TaskModel.fromFirestore(doc.data(), doc.id))
      .toList();
}

// Usage:
final results = await firestoreService.queryTasksAdvanced(
  userId,
  status: 'in_progress',
  priority: 'high',
  limitCount: 50,
);
```

#### E. Real-Time Filtered Streams

```dart
/// Stream filtered tasks with live updates
Stream<List<TaskModel>> streamFilteredTasks(
  String userId, {
  String? status,
  String? priority,
  int? limitCount,
}) {
  Query query = _firestore.collection('tasks');

  query = query.where('userId', isEqualTo: userId);
  if (status != null && status.isNotEmpty) {
    query = query.where('status', isEqualTo: status);
  }
  if (priority != null && priority.isNotEmpty) {
    query = query.where('priority', isEqualTo: priority);
  }

  query = query.orderBy('dueDate', descending: false);

  if (limitCount != null) {
    query = query.limit(limitCount);
  }

  return query
      .snapshots()
      .map((snapshot) {
        return snapshot.docs
            .map((doc) => TaskModel.fromFirestore(doc.data(), doc.id))
            .toList();
      })
      .handleError((error) {
        print('Error: $error');
        return <TaskModel>[];
      });
}

// Usage in UI:
StreamBuilder<List<TaskModel>>(
  stream: firestoreService.streamFilteredTasks(
    userId,
    status: 'pending',
    priority: 'urgent',
    limitCount: 10,
  ),
  builder: (context, snapshot) {
    if (snapshot.hasData) {
      return ListView.builder(
        itemCount: snapshot.data!.length,
        itemBuilder: (context, index) {
          return TaskTile(task: snapshot.data![index]);
        },
      );
    }
    return CircularProgressIndicator();
  },
)
```

#### F. Sorting and Ordering

```dart
/// Get completed tasks sorted by completion date
Future<List<TaskModel>> getCompletedTasks(
  String userId, {
  int limit = 50,
}) async {
  return await _firestore
      .collection('tasks')
      .where('userId', isEqualTo: userId)
      .where('status', isEqualTo: 'completed')
      .orderBy('updatedAt', descending: true)
      .limit(limit)
      .get();
}

/// Stream incomplete tasks sorted by priority then due date
Stream<List<TaskModel>> streamIncompleteTasks(String userId) {
  return _firestore
      .collection('tasks')
      .where('userId', isEqualTo: userId)
      .where('status', whereIn: ['pending', 'in_progress', 'on_hold'])
      .orderBy('priority', descending: true)
      .orderBy('dueDate', descending: false)
      .snapshots()
      .map((snapshot) {
        return snapshot.docs
            .map((doc) => TaskModel.fromFirestore(doc.data(), doc.id))
            .toList();
      });
}
```

#### G. Pagination Support

```dart
/// Get tasks in batches for pagination
Future<List<TaskModel>> getTasksBatch(
  String userId, {
  DocumentSnapshot? startAfter,
  int batchSize = 20,
}) async {
  Query query = _firestore
      .collection('tasks')
      .where('userId', isEqualTo: userId)
      .orderBy('dueDate', descending: false);

  if (startAfter != null) {
    query = query.startAfter([startAfter]);
  }

  return (await query.limit(batchSize).get()).docs
      .map((doc) => TaskModel.fromFirestore(doc.data(), doc.id))
      .toList();
}

// Usage:
// Load first page
List<TaskModel> page1 = await getTasksBatch(userId);

// Load next page
List<TaskModel> page2 = await getTasksBatch(
  userId,
  startAfter: page1.last,
);
```

#### H. Search/Pattern Matching

```dart
/// Search clients by name (case-insensitive)
Future<List<ClientModel>> searchClientsByName(
  String userId,
  String searchQuery,
) async {
  // Get clients (Firestore doesn't support native case-insensitive search)
  final snapshot = await _firestore
      .collection('clients')
      .where('userId', isEqualTo: userId)
      .where('isActive', isEqualTo: true)
      .limit(100)
      .get();

  final allClients = snapshot.docs
      .map((doc) => ClientModel.fromFirestore(doc.data(), doc.id))
      .toList();

  // Filter on client side for case-insensitive search
  final query = searchQuery.toLowerCase();
  return allClients
      .where((client) => client.name.toLowerCase().contains(query))
      .toList();
}
```

---

## Query Syntax Reference

### Basic Filtering

```dart
// Equality
.where('status', isEqualTo: 'pending')

// Comparison
.where('priority', isGreaterThan: 3)
.where('price', isLessThanOrEqualTo: 100)

// Array operations
.where('tags', arrayContains: 'featured')

// In list
.where('status', whereIn: ['pending', 'active'])

// Not equals
.where('status', isNotEqualTo: 'completed')
```

### Ordering

```dart
// Ascending (default)
.orderBy('dueDate')

// Descending
.orderBy('priority', descending: true)

// Multiple order criteria
.orderBy('priority', descending: true)
.orderBy('dueDate')  // Secondary sort
```

### Limiting

```dart
// Get first N documents
.limit(10)

// Get after a document (pagination)
.startAfter([lastDocumentSnapshot])
.limit(20)

// Get up to N documents
.limit(100)
```

### Date Queries

```dart
// Range
.where('dueDate', isGreaterThanOrEqualTo: startDate)
.where('dueDate', isLessThanOrEqualTo: endDate)

// Before/after
.where('createdAt', isGreaterThan: DateTime.now())
```

---

## UI Integration with StreamBuilder

### Simple Filtered List

```dart
StreamBuilder<List<TaskModel>>(
  stream: _firestoreService.streamFilteredTasks(
    userId,
    status: 'pending',
  ),
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return CircularProgressIndicator();
    }

    if (snapshot.hasError) {
      return ErrorWidget(error: snapshot.error);
    }

    if (!snapshot.hasData || snapshot.data!.isEmpty) {
      return Text('No pending tasks');
    }

    return ListView.builder(
      itemCount: snapshot.data!.length,
      itemBuilder: (context, index) {
        return TaskCard(task: snapshot.data![index]);
      },
    );
  },
)
```

### Dynamic Filter Selection

```dart
class TaskListScreen extends StatefulWidget {
  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  String _selectedStatus = 'pending';
  String _selectedPriority = '';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Filter UI
        Row(
          children: [
            DropdownButton(
              value: _selectedStatus,
              items: ['pending', 'in_progress', 'completed']
                  .map((s) => DropdownMenuItem(
                    value: s,
                    child: Text(s),
                  ))
                  .toList(),
              onChanged: (value) {
                setState(() => _selectedStatus = value!);
              },
            ),
          ],
        ),
        // Filtered results
        Expanded(
          child: StreamBuilder<List<TaskModel>>(
            stream: _firestoreService.streamFilteredTasks(
              userId,
              status: _selectedStatus,
              priority: _selectedPriority.isEmpty 
                  ? null 
                  : _selectedPriority,
            ),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return LoadingWidget();
              return TaskList(tasks: snapshot.data!);
            },
          ),
        ),
      ],
    );
  }
}
```

### Pagination

```dart
class PaginatedTaskList extends StatefulWidget {
  @override
  State<PaginatedTaskList> createState() => _PaginatedTaskListState();
}

class _PaginatedTaskListState extends State<PaginatedTaskList> {
  List<TaskModel> _allTasks = [];
  bool _isLoadingMore = false;
  
  @override
  void initState() {
    super.initState();
    _loadFirstPage();
  }

  Future<void> _loadFirstPage() async {
    final tasks = await _firestoreService.getTasksBatch(userId);
    setState(() => _allTasks = tasks);
  }

  Future<void> _loadMoreTasks() async {
    if (_allTasks.isEmpty) return;
    
    setState(() => _isLoadingMore = true);
    final moreTasks = await _firestoreService.getTasksBatch(
      userId,
      startAfter: _allTasks.last,
    );
    
    if (mounted) {
      setState(() {
        _allTasks.addAll(moreTasks);
        _isLoadingMore = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _allTasks.length + 1,
      itemBuilder: (context, index) {
        if (index == _allTasks.length) {
          return Padding(
            padding: EdgeInsets.all(16),
            child: _isLoadingMore
                ? CircularProgressIndicator()
                : ElevatedButton(
                  onPressed: _loadMoreTasks,
                  child: Text('Load More'),
                ),
          );
        }
        return TaskCard(task: _allTasks[index]);
      },
    );
  }
}
```

---

## Performance Optimization

### 1. Query Best Practices

✅ **DO:**
```dart
// Filter by userId first (narrows data)
.where('userId', isEqualTo: userId)
.where('status', isEqualTo: 'pending')
.orderBy('dueDate')
.limit(50)
```

❌ **DON'T:**
```dart
// Get entire collection, filter in code
.collection('tasks')  // Downloads everything!
.get()
```

### 2. Firestore Indexes

For complex queries, Firestore requires composite indexes:

**When Firestore asks for an index:**
1. Check the error message - copy the suggested index URL
2. Click the link to create the index automatically
3. Wait ~5 minutes for indexing to complete
4. Re-run your query

**Example index for:**
```dart
.where('userId', isEqualTo: userId)
.where('status', isEqualTo: 'pending')
.orderBy('priority', descending: true)
.orderBy('dueDate')
```

Index fields needed:
- `userId` (Ascending)
- `status` (Ascending)
- `priority` (Descending)
- `dueDate` (Ascending)

### 3. Cost Optimization

```dart
// Cheap - Filters reduce documents read
.where('userId', isEqualTo: userId)  // ~1% of collection
.limit(50)

// Expensive - Gets entire collection
.collection('tasks').get()  // Reads 100,000 docs!
```

Each document read costs money. Filter aggressively!

### 4. Caching Strategy

```dart
// Cache query results
StreamBuilder<List<TaskModel>>(
  stream: _firestoreService.streamFilteredTasks(userId),
  builder: (context, snapshot) {
    // Results auto-cache with offline persistence
    // Firestore handles caching automatically
  },
)
```

---

## Demo Screens

### 1. Firestore Query Demo Screen
**Path:** `lib/screens/firestore_query_demo_screen.dart`

Interactive tabs demonstrating:
- **Filtering:** By status, priority, multiple conditions
- **Sorting:** Ascending, descending, multiple criteria
- **Complex Queries:** Advanced multi-condition queries
- **Recent:** Getting recently updated items
- **Completed:** Querying completed items with limits

**Features:**
- Live query builder with code preview
- Dynamic filter selection
- Real-time result updates
- Visual indicators for priority/status

### 2. Firestore Query Documentation Screen
**Path:** `lib/screens/firestore_query_documentation_screen.dart`

Comprehensive guide covering:
- Why queries matter (performance, cost)
- Filtering operators and patterns
- Ordering and sorting
- Limiting and pagination
- Index requirements
- Common patterns and mistakes
- Real-world examples

---

## Code Examples

### Example 1: Dashboard with Multiple Filters

```dart
// Show high-priority tasks due soon
final urgentTasks = await firestoreService.queryTasksAdvanced(
  userId,
  status: 'pending',
  priority: 'urgent',
  dueAfter: DateTime.now(),
  limitCount: 10,
);

// Display in dashboard
return ListView.builder(
  itemCount: urgentTasks.length,
  itemBuilder: (context, index) {
    return UrgentTaskCard(task: urgentTasks[index]);
  },
);
```

### Example 2: Activity Feed with Pagination

```dart
// Load recent activities in batches
List<Activity> _activities = [];

@override
void initState() {
  _loadFirstPage();
}

Future<void> _loadFirstPage() async {
  final snap = await _firestore
      .collection('activities')
      .where('userId', isEqualTo: userId)
      .orderBy('createdAt', descending: true)
      .limit(20)
      .get();
      
  setState(() => _activities = snap.docs
      .map((d) => Activity.fromFirestore(d))
      .toList());
}

Future<void> loadMore() async {
  final snap = await _firestore
      .collection('activities')
      .where('userId', isEqualTo: userId)
      .orderBy('createdAt', descending: true)
      .startAfter([_activities.last])
      .limit(20)
      .get();
      
  setState(() => _activities.addAll(
      snap.docs.map((d) => Activity.fromFirestore(d))));
}
```

### Example 3:  Real-Time Search Results

```dart
String _searchQuery = '';

@override
Widget build(BuildContext context) {
  return Column(
    children: [
      TextField(
        onChanged: (query) {
          setState(() => _searchQuery = query);
        },
        decoration: InputDecoration(hintText: 'Search tasks...'),
      ),
      Expanded(
        child: StreamBuilder<List<TaskModel>>(
          stream: _firestoreService.streamFilteredTasks(
            userId,
            status: 'pending',  // Filter active tasks only
          ),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return LoadingWidget();
            
            // Client-side search filter
            final results = snapshot.data!
                .where((task) => task.title
                    .toLowerCase()
                    .contains(_searchQuery.toLowerCase()))
                .toList();
                
            return ListView.builder(
              itemCount: results.length,
              itemBuilder: (context, index) {
                return TaskCard(task: results[index]);
              },
            );
          },
        ),
      ),
    ],
  );
}
```

---

## Testing Queries

### Manual Testing Steps

1. **Start the app** and navigate to `/firestore-query-demo`

2. **Test Filtering:**
   - Select different status values
   - Verify only matching tasks appear
   - Try multiple filters together

3. **Test Sorting:**
   - Switch between ascending/descending
   - Verify order changes correctly
   - Observe multi-field sorting

4. **Test Pagination:**
   - Load first batch (20 items)
   - Click "Load More"
   - Verify next batch loads without duplicates

5. **Test Search:**
   - Type in search box
   - Verify results update in real-time
   - Try special characters and case variations

6. **Firestore Console Testing:**
   - Open Firestore Console
   - Change task status/priority
   - Watch app UI update instantly

### Expected Results

| Action | Result |
|--------|--------|
| Filter by status='pending' | Shows only pending tasks |
| Sort by priority descending | Urgent tasks appear first |
| Limit to 10 | Shows maximum 10 results |
| Set date range | Shows only tasks in range |
| Pagination | Loads 20, then 20 more |

---

## Reflection

### Why Query Performance Matters

1. **User Experience** - Apps feel faster when data loads instantly
2. **Battery Life** - Fewer document reads = less CPU = longer battery
3. **Cost** - Queries cost money; filtering on server is cheaper
4. **Scalability** - Queries scale better as data grows
5. **Responsiveness** - Filtered real-time data feels modern

### Query Selection Process

1. **Identify the data** you need to display
2. **Add filters** to narrow results (userId always first)
3. **Add sorting** for proper order
4. **Add limits** for pagination
5. **Test with Firestore** console before shipping
6. **Create indexes** if Firestore suggests them

### Challenges Encountered

1. **Composite Indexes** - Had to create indexes for complex queries
2. **Case-Sensitive Search** - Firestore doesn't have native case-insensitive search (solution: client-side filter)
3. **Multiple Conditions** - Firestore has limits on AND conditions
4. **Pagination** - Required using startAfter() with last document
5. **Real-Time + Filters** - Had to use streams properly to avoid memory leaks

### Key Learnings

1. **Filter early** - Always filter by userId or user-specific field first
2. **Indexes are essential** - Don't skip index creation for complex queries
3. **Limits are important** - Always limit large collections
4. **Server-side better** - Filter on Firestore, not in app code
5. **Monitor costs** - Each read counts toward quota/billing

---

## API Reference

### Query Methods Added

#### Filtering
- `queryTasksByStatusFuture(userId, status)` - Get tasks by status
- `queryHighPriorityTasks(userId)` - Get urgent/high priority
- `queryTasksByDateRange(userId, start, end)` - Date range queries
- `queryTasksAdvanced()` - Multiple optional filters
- `searchClientsByName(userId, query)` - Client-side search

#### Sorting/Ordering
- `getRecentlyUpdatedTasks(userId, limit)` - Most recent first
- `getCompletedTasks(userId, limit)` - Completed tasks sorted
- `streamTasksSorted()` - Real-time sorted stream

#### Streams (Real-Time)
- `streamFilteredTasks()` - Live filtered results
- `streamProjectsOrderedByStatus()` - Sorted projects stream
- `streamIncompleteTasks()` - Incomplete tasks with multi-sort

#### Pagination
- `getTasksBatch(userId, startAfter, batchSize)` - Paginated results

---

## Files Modified/Created

### New Files
```
lib/screens/firestore_query_demo_screen.dart (500+ lines)
lib/screens/firestore_query_documentation_screen.dart (450+ lines)
README_FIRESTORE_QUERYING.md (this file)
```

### Modified Files
```
lib/services/firestore_service.dart (+300 lines of query methods)
lib/main.dart (+3 route additions)
```

---

## Next Steps & Enhancements

1. **Advanced Search** - Implement full-text search with Algolia
2. **Saved Filters** - Remember user's favorite queries
3. **Query Analytics** - Track most-run queries
4. **Custom Indexes** - Guide users to create optimal indexes
5. **Offline Search** - Search cached data when offline

---

**Author:** TaskPilot Development Team  
**Date:** March 6, 2026  
**Version:** 1.0.0
