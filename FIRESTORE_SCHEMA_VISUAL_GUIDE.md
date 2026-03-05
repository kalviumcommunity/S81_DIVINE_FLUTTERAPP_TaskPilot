# TaskPilot Firestore Schema - Visual & Implementation Guide

## Quick Schema Reference

### Collections at a Glance

```
┌─────────────────────────────────────────────────────────────────┐
│                    FIRESTORE DATABASE                            │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  📦 COLLECTIONS:                                                │
│  ├── users/              (User profiles)                        │
│  ├── userSettings/       (User preferences)                     │
│  ├── clients/            (Client contacts)                      │
│  ├── projects/           (Project groupings)                    │
│  ├── tasks/              (Individual work items)                │
│  ├── invoices/           (Billing documents)                    │
│  ├── payments/           (Payment records)                      │
│  ├── timeLogs/           (Time tracking - optional)             │
│  └── analytics/          (Aggregated stats - optional)          │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

## Data Flow Diagram

```
┌──────────┐
│  User    │
│ (Auth)   │
└────┬─────┘
     │ Creates
     ▼
┌──────────────────────────────────────────────┐
│         👤 users {userId}                    │
│  ├─ name                                    │
│  ├─ email                                   │
│  ├─ profilePicture                          │
│  ├─ businessName                            │
│  ├─ timezone                                │
│  ├─ currency                                │
│  └─ timestamps                              │
└──────────┬───────────────────┬──────────────┘
           │                   │
           │ Owns              │ Has Settings
           ▼                   ▼
      ┌─────────┐         ┌──────────────┐
      │ clients │         │ userSettings │
      │ (many)  │         │ (1 per user) │
      └────┬────┘         └──────────────┘
           │
           │ Associated with
           ▼
     ┌──────────────────┐
     │  📋 projects     │
     │  (optional)      │
     └────┬─────────────┘
          │
          │ Contains
          ▼
     ┌──────────────────┐
     │  ✅ tasks        │
     │  (many)          │
     └──────────────────┘


     ┌──────────────────────────────────────┐
     │  👔 clients (from above)              │
     └────┬─────────────────────────────────┘
          │
          │ Billed via
          ▼
     ┌──────────────────┐
     │  💰 invoices     │
     │  (many)          │
     └────┬─────────────┘
          │
          │ Paid by
          ▼
     ┌──────────────────┐
     │  💳 payments     │
     │  (many)          │
     └──────────────────┘
```

## Collection Reference Matrix

```
┌──────────┬────────────────────────────────────────────────────────┐
│ Collection │ References                                            │
├──────────┼────────────────────────────────────────────────────────┤
│ users    │ (none) - Root entity                                   │
│ clients  │ → userId (who owns)                                    │
│ projects │ → userId (who owns), clientId (optional)               │
│ tasks    │ → userId (who owns), projectId (opt), clientId (opt)   │
│ invoices │ → userId (who created), clientId (who billed),         │
│          │   projectId (optional)                                 │
│ payments │ → userId (who received), invoiceId, clientId           │
│ settings │ → userId (implicit - same as doc ID)                  │
│ analytics│ → userId (implicit - same as doc ID)                  │
└──────────┴────────────────────────────────────────────────────────┘
```

## Document Structure Examples

### 1. User Document

```
COLLECTION: users
DOCUMENT ID: JdkLp3sBwkQc7e1FgH2s (Firebase UID)

{
  "name": "Ravi Kumar",
  "email": "ravi@freela.com",
  "phone": "+1-555-0123",
  "profilePicture": "gs://bucket/user-profile.jpg",
  "businessName": "RK Solutions",
  "businessDescription": "Web & UI/UX specialist",
  "location": "San Francisco, CA",
  "timezone": "America/Los_Angeles",
  "currency": "USD",
  "createdAt": 2025-02-01T10:00:00Z,
  "updatedAt": 2025-02-01T10:00:00Z,
  "isActive": true,
  "lastLoginAt": 2025-02-15T15:30:00Z
}

📊 SIZE: ~2 KB
📈 SCALE: 100K users = 200 MB
```

### 2. Client Document

```
COLLECTION: clients
DOCUMENT ID: client123abc (Auto-generated)

{
  "userId": "JdkLp3sBwkQc7e1FgH2s",  ← Creator reference
  "name": "Acme Corporation",
  "email": "contact@acme.com",
  "phone": "+1-555-9999",
  "company": "Acme Corp",
  "address": "123 Business Ave",
  "city": "New York",
  "state": "NY",
  "zipCode": "10001",
  "country": "United States",
  "taxId": "12-3456789",
  "notes": "Prefers email. Payment net-30.",
  "totalSpent": 15000,
  "createdAt": 2025-02-01T10:00:00Z,
  "updatedAt": 2025-02-01T10:00:00Z,
  "isActive": true
}

📊 SIZE: ~500 B
📈 SCALE: 100K users × 20 clients = 1 GB
⚡ QUERY: Get all clients for user → (userId, isActive)
```

### 3. Project Document

```
COLLECTION: projects
DOCUMENT ID: proj456def (Auto-generated)

{
  "userId": "JdkLp3sBwkQc7e1FgH2s",  ← Creator reference
  "clientId": "client123abc",         ← Associated with (optional)
  "name": "Website Redesign - Phase 1",
  "description": "Complete redesign with new branding",
  "budget": 5000,
  "status": "active",                 ← active | completed | archived
  "startDate": 2025-02-01T00:00:00Z,
  "dueDate": 2025-03-01T00:00:00Z,
  "createdAt": 2025-02-01T10:00:00Z,
  "updatedAt": 2025-02-01T10:00:00Z,
  "taskCount": 8,                     ← Cached count
  "completedCount": 3                 ← Cached count
}

📊 SIZE: ~1 KB
📈 SCALE: 100K users × 5 projects = 5 GB
⚡ QUERY: Get all active projects → (userId, status)
```

### 4. Task Document

```
COLLECTION: tasks
DOCUMENT ID: task789ghi (Auto-generated)

{
  "userId": "JdkLp3sBwkQc7e1FgH2s",  ← Creator reference
  "projectId": "proj456def",          ← Optional parent project
  "clientId": "client123abc",         ← Optional associated client
  "title": "Design homepage mockups",
  "description": "Create 3 layout options in Figma",
  "status": "in-progress",            ← todo | in-progress | completed | cancelled
  "priority": "high",                 ← low | medium | high
  "dueDate": 2025-02-15T00:00:00Z,
  "createdAt": 2025-02-01T10:00:00Z,
  "updatedAt": 2025-02-05T14:30:00Z,
  "completedAt": null,                ← Set when completed
  "estimatedHours": 8,                ← Optional estimate
  "attachments": [
    "gs://bucket/task123/notes.pdf"   ← File URLs
  ],
  "tags": ["design", "urgent"],       ← Labels
  "subtasks": [
    {
      "title": "Review branding guidelines",
      "completed": true
    },
    {
      "title": "Create option A layout",
      "completed": true
    },
    {
      "title": "Create option B layout",
      "completed": false
    }
  ]
}

📊 SIZE: ~1 KB
📈 SCALE: 100K users × 50 tasks = 5 GB
⚡ QUERY: Get tasks by status → (userId, status)
⚡ QUERY: Get overdue tasks → (userId, dueDate)
⚡ QUERY: Get high priority → (userId, priority, status)
```

### 5. Invoice Document

```
COLLECTION: invoices
DOCUMENT ID: inv001xyz (Auto-generated)

{
  "userId": "JdkLp3sBwkQc7e1FgH2s",  ← Issued by
  "clientId": "client123abc",         ← Billed to
  "projectId": "proj456def",          ← Associated with (optional)
  "invoiceNumber": "INV-2025-001",    ← Unique per user
  "items": [
    {
      "description": "Website Design - 40 hours @ $75/hr",
      "quantity": 40,
      "rate": 75,
      "amount": 3000
    },
    {
      "description": "Revision Round 1 - 8 hours @ $75/hr",
      "quantity": 8,
      "rate": 75,
      "amount": 600
    }
  ],
  "subtotal": 3600,
  "tax": 288,                         ← Optional tax amount
  "taxRate": 8,                       ← Optional tax %
  "total": 3888,
  "currency": "USD",
  "status": "sent",                   ← draft | sent | paid | overdue | cancelled
  "issuedDate": 2025-02-01T00:00:00Z,
  "dueDate": 2025-03-01T00:00:00Z,
  "paidDate": null,                   ← Set when paid
  "notes": "Payment due within 30 days. Thank you!",
  "createdAt": 2025-02-01T10:00:00Z,
  "updatedAt": 2025-02-01T10:00:00Z
}

📊 SIZE: ~1.5 KB
📈 SCALE: 100K users × 30 invoices = 4.5 GB
⚡ QUERY: Get unpaid invoices → (userId, status)
⚡ QUERY: Get overdue invoices → (userId, dueDate) + filter
```

### 6. Payment Document

```
COLLECTION: payments
DOCUMENT ID: pay001qrs (Auto-generated)

{
  "userId": "JdkLp3sBwkQc7e1FgH2s",  ← Recipient
  "invoiceId": "inv001xyz",           ← For which invoice
  "clientId": "client123abc",         ← From which client
  "amount": 3888,
  "currency": "USD",
  "paymentMethod": "bank_transfer",   ← cash | check | bank_transfer
                                       ← credit_card | paypal | other
  "transactionId": "TXN-202502-99999",← Payment processor ID (optional)
  "paymentDate": 2025-02-20T00:00:00Z,
  "notes": "Received via wire transfer",
  "createdAt": 2025-02-20T10:00:00Z,
  "updatedAt": 2025-02-20T10:00:00Z
}

📊 SIZE: ~400 B
📈 SCALE: 100K users × 30 payments = 1.2 GB
⚡ QUERY: Get payments for user → (userId)
⚡ QUERY: Get payments by date → (userId, paymentDate)
```

### 7. User Settings Document

```
COLLECTION: userSettings
DOCUMENT ID: JdkLp3sBwkQc7e1FgH2s (Same as user)

{
  "currency": "USD",
  "timezone": "America/Los_Angeles",
  "theme": "dark",                    ← light | dark | auto
  "language": "en",
  "notificationsEnabled": true,
  "emailNotifications": true,
  "pushNotifications": true,
  "dailyReminders": true,
  "weeklyReports": true,
  "createdAt": 2025-02-01T10:00:00Z,
  "updatedAt": 2025-02-01T10:00:00Z
}

📊 SIZE: ~300 B
📈 SCALE: 100K users = 30 MB
```

## Query Patterns & Required Indexes

### Frequently Used Queries

```
1️⃣  Get all tasks for user
    db.collection('tasks')
       .where('userId', '==', uid)
       .get()
    ✅ Indexed: NO (userId only)

2️⃣  Get tasks by status
    db.collection('tasks')
       .where('userId', '==', uid)
       .where('status', '==', 'in-progress')
       .get()
    ⚡ Indexed: YES (userId, status)

3️⃣  Get overdue tasks
    db.collection('tasks')
       .where('userId', '==', uid)
       .where('dueDate', '<', now)
       .get()
    ⚡ Indexed: YES (userId, dueDate)

4️⃣  Get high priority active tasks
    db.collection('tasks')
       .where('userId', '==', uid)
       .where('priority', '==', 'high')
       .where('status', '!=', 'completed')
       .get()
    ⚡ Indexed: YES (userId, priority, status)

5️⃣  Get unpaid invoices
    db.collection('invoices')
       .where('userId', '==', uid)
       .where('status', 'in', ['draft', 'sent', 'overdue'])
       .get()
    ⚡ Indexed: YES (userId, status)

6️⃣  Get client's invoices
    db.collection('invoices')
       .where('clientId', '==', clientId)
       .get()
    ⚡ Indexed: YES (clientId, status) - Optional

7️⃣  Get tasks for project
    db.collection('tasks')
       .where('projectId', '==', projectId)
       .where('status', '!=', 'cancelled')
       .get()
    ⚡ Indexed: YES (projectId, status)

8️⃣  Get user settings
    db.collection('userSettings')
       .doc(uid)
       .get()
    ✅ Indexed: NO (single doc by ID)
```

## Firestore Rules Preview

```javascript
// Firestore Security Rules (Pseudo-code)

rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    
    // Verify user is authenticated
    function isAuth() {
      return request.auth != null;
    }
    
    // Verify user owns document
    function isOwner(userId) {
      return request.auth.uid == userId;
    }
    
    // USERS Collection
    match /users/{userId} {
      allow read, write: if isAuth() && isOwner(userId);
    }
    
    // USER SETTINGS Collection
    match /userSettings/{userId} {
      allow read, write: if isAuth() && isOwner(userId);
    }
    
    // CLIENTS Collection (owned by user)
    match /clients/{clientId} {
      allow read, write: if isAuth() && 
        isOwner(resource.data.userId);
    }
    
    // PROJECTS Collection (owned by user)
    match /projects/{projectId} {
      allow read, write: if isAuth() && 
        isOwner(resource.data.userId);
    }
    
    // TASKS Collection (owned by user)
    match /tasks/{taskId} {
      allow read, write: if isAuth() && 
        isOwner(resource.data.userId);
    }
    
    // INVOICES Collection (owned by user)
    match /invoices/{invoiceId} {
      allow read, write: if isAuth() && 
        isOwner(resource.data.userId);
    }
    
    // PAYMENTS Collection (owned by user)
    match /payments/{paymentId} {
      allow read, write: if isAuth() && 
        isOwner(resource.data.userId);
    }
  }
}
```

## Size & Cost Estimation

### Document Sizes
| Collection | Per Doc | Example |
|-----------|---------|---------|
| users | 2 KB | 1 user |
| clients | 500 B | 1 client |
| projects | 1 KB | 1 project |
| tasks | 1 KB | 1 task |
| invoices | 1.5 KB | 1 invoice |
| payments | 400 B | 1 payment |
| userSettings | 300 B | 1 settings |

### Storage at Scale
```
100,000 users scenario:
├─ users: 100K × 2 KB = 200 MB
├─ clients: 100K × 20 × 500 B = 1 GB
├─ projects: 100K × 5 × 1 KB = 500 MB
├─ tasks: 100K × 50 × 1 KB = 5 GB
├─ invoices: 100K × 30 × 1.5 KB = 4.5 GB
├─ payments: 100K × 30 × 400 B = 1.2 GB
└─ Total: ~12.4 GB
```

### Monthly Costs (100K users)
```
Assuming average usage:
- 15 million document reads: $0.50
- 5 million document writes: $1.50
- Storage: $3.72 (12.4 GB × $0.3/GB)

Total: ~$5.72/month (very affordable!)
```

## Implementation Checklist

### Phase 1: Core Setup
- [ ] Create Firestore database
- [ ] Set security rules
- [ ] Create collections:
  - [ ] users
  - [ ] userSettings
  - [ ] clients
  - [ ] projects
  - [ ] tasks

### Phase 2: Billing
- [ ] Create invoices collection
- [ ] Create payments collection
- [ ] Create composite indexes

### Phase 3: Analytics
- [ ] Create analytics collection
- [ ] Set up scheduled functions

### Phase 4: Polish
- [ ] Add validation rules
- [ ] Backup configuration
- [ ] Monitoring setup

---

**Schema Version**: 1.0  
**Last Updated**: March 5, 2026  
**Status**: ✅ Ready for Implementation
