# Cloud Firestore Database Schema Design for TaskPilot

## Overview

This document defines the complete Cloud Firestore database schema for the TaskPilot freelancer task management application. The schema is designed for scalability, clarity, and minimal read/write costs.

---

## Part 1: Data Requirements Analysis

### TaskPilot Core Entities

TaskPilot is a freelancer task management application that requires the following data entities:

#### 1. **Users**
- User authentication profile
- Basic information (name, email, phone)
- Business/freelancer details
- Profile settings and preferences

#### 2. **Clients**
- Client contact information
- Company details
- Billing addresses
- Contact history
- Per-user isolation (each freelancer has their own client list)

#### 3. **Tasks/Projects**
- Task creation and organization
- Status tracking (todo, in-progress, completed)
- Priority levels (low, medium, high)
- Deadline management
- Client association
- Task relationships

#### 4. **Invoices/Payments**
- Invoice creation and tracking
- Invoice items (line items)
- Payment status (draft, sent, paid, overdue)
- Payment history
- Client association

#### 5. **Time Tracking** (optional future feature)
- Time logs per task
- Duration tracking
- Billing calculations

#### 6. **Analytics/Reports** (optional future feature)
- User statistics
- Revenue tracking
- Task completion metrics
- Client insights

#### 7. **User Settings & Preferences**
- Theme and UI preferences
- Currency and timezone
- Notification settings
- Business settings

---

## Part 2: Complete Firestore Schema

### Visual Schema Overview

```
firestore/
├── users/
│   └── {userId}
│       ├── name: string
│       ├── email: string
│       ├── phone: string
│       ├── profilePicture: string (URL)
│       ├── businessName: string
│       ├── businessDescription: string
│       ├── location: string
│       ├── timezone: string
│       ├── currency: string
│       ├── createdAt: timestamp
│       ├── updatedAt: timestamp
│       └── isActive: boolean
│
├── clients/
│   └── {clientId}
│       ├── userId: string (reference)
│       ├── name: string
│       ├── email: string
│       ├── phone: string
│       ├── company: string
│       ├── address: string
│       ├── city: string
│       ├── state: string
│       ├── zipCode: string
│       ├── country: string
│       ├── taxId: string (optional)
│       ├── notes: string
│       ├── createdAt: timestamp
│       ├── updatedAt: timestamp
│       └── isActive: boolean
│
├── projects/
│   └── {projectId}
│       ├── userId: string (reference)
│       ├── name: string
│       ├── description: string
│       ├── clientId: string (reference, optional)
│       ├── budget: number (optional)
│       ├── status: string (active, completed, archived)
│       ├── startDate: timestamp
│       ├── dueDate: timestamp (optional)
│       ├── createdAt: timestamp
│       └── updatedAt: timestamp
│
├── tasks/
│   └── {taskId}
│       ├── userId: string (reference)
│       ├── projectId: string (reference, optional)
│       ├── clientId: string (reference, optional)
│       ├── title: string
│       ├── description: string
│       ├── status: string (todo, in-progress, completed, cancelled)
│       ├── priority: string (low, medium, high)
│       ├── dueDate: timestamp
│       ├── createdAt: timestamp
│       ├── updatedAt: timestamp
│       ├── completedAt: timestamp (set when status = completed)
│       ├── estimatedHours: number (optional)
│       ├── attachments: array (optional)
│       └── tags: array (optional)
│
├── invoices/
│   └── {invoiceId}
│       ├── userId: string (reference)
│       ├── clientId: string (reference)
│       ├── projectId: string (reference, optional)
│       ├── invoiceNumber: string (unique per user)
│       ├── items: array
│       │   └── {index}
│       │       ├── description: string
│       │       ├── quantity: number
│       │       ├── rate: number
│       │       └── amount: number
│       ├── subtotal: number
│       ├── tax: number (optional)
│       ├── taxRate: number (optional)
│       ├── total: number
│       ├── currency: string
│       ├── status: string (draft, sent, paid, overdue, cancelled)
│       ├── issuedDate: timestamp
│       ├── dueDate: timestamp
│       ├── paidDate: timestamp (optional)
│       ├── notes: string (optional)
│       ├── createdAt: timestamp
│       └── updatedAt: timestamp
│
├── payments/
│   └── {paymentId}
│       ├── userId: string (reference)
│       ├── invoiceId: string (reference)
│       ├── clientId: string (reference)
│       ├── amount: number
│       ├── currency: string
│       ├── paymentMethod: string (cash, check, bank_transfer, credit_card, paypal, other)
│       ├── transactionId: string (optional - from payment processor)
│       ├── paymentDate: timestamp
│       ├── notes: string (optional)
│       ├── createdAt: timestamp
│       └── updatedAt: timestamp
│
├── timeLogs/ (Optional)
│   └── {timeLogId}
│       ├── userId: string (reference)
│       ├── taskId: string (reference)
│       ├── projectId: string (reference)
│       ├── startTime: timestamp
│       ├── endTime: timestamp
│       ├── duration: number (in minutes)
│       ├── notes: string (optional)
│       ├── createdAt: timestamp
│       └── updatedAt: timestamp
│
├── userSettings/
│   └── {userId}
│       ├── currency: string (default: USD)
│       ├── timezone: string (default: UTC)
│       ├── theme: string (light, dark, auto)
│       ├── language: string (default: en)
│       ├── notificationsEnabled: boolean
│       ├── emailNotifications: boolean
│       ├── pushNotifications: boolean
│       ├── dailyReminders: boolean
│       ├── weeklyReports: boolean
│       ├── createdAt: timestamp
│       └── updatedAt: timestamp
│
└── analytics/ (Optional - for aggregated stats)
    └── {userId}
        ├── totalTasksCompleted: number
        ├── totalRevenue: number
        ├── totalClients: number
        ├── totalProjects: number
        ├── activeProjects: number
        ├── completedProjects: number
        ├── averageTaskDuration: number
        ├── monthlyRevenue: map (month -> amount)
        ├── lastUpdated: timestamp
        └── updatedAt: timestamp
```

---

## Part 3: Collection Specifications

### 1. **users** Collection

**Purpose**: Store authenticated user profiles and business information

**Document ID**: Firebase Authentication UID (automatically generated)

**Fields**:
```
{
  "name": string,                    // User's full name (from auth + profile update)
  "email": string,                   // Email address (from auth)
  "phone": string,                   // Contact phone number
  "profilePicture": string,          // URL to profile image in Cloud Storage
  "businessName": string,            // Freelancer/business name
  "businessDescription": string,     // Brief description of business
  "location": string,                // City, State or general location
  "timezone": string,                // e.g., "America/New_York"
  "currency": string,                // Default currency code (USD, EUR, etc)
  "createdAt": timestamp,            // Account creation time
  "updatedAt": timestamp,            // Last profile update
  "isActive": boolean,               // Account status
  "lastLoginAt": timestamp           // Last login time
}
```

**Sample Document**:
```json
{
  "name": "Ravi Kumar",
  "email": "ravi@freela.com",
  "phone": "+1-555-0123",
  "profilePicture": "gs://taskpilot-bucket/users/abc123/profile.jpg",
  "businessName": "RK Solutions",
  "businessDescription": "Web development and UI/UX design specialist",
  "location": "San Francisco, CA",
  "timezone": "America/Los_Angeles",
  "currency": "USD",
  "createdAt": { "_seconds": 1735689600 },
  "updatedAt": { "_seconds": 1735689600 },
  "isActive": true,
  "lastLoginAt": { "_seconds": 1741000000 }
}
```

**Security Rules**: Users can only read/write their own document

---

### 2. **clients** Collection

**Purpose**: Store client information for each freelancer

**Document ID**: Auto-generated by Firestore

**Fields**:
```
{
  "userId": string,                  // Reference to user who owns this client
  "name": string,                    // Client's name or company name
  "email": string,                   // Primary contact email
  "phone": string,                   // Primary contact phone
  "company": string,                 // Company name (if different from contact)
  "address": string,                 // Street address
  "city": string,                    // City
  "state": string,                   // State/Province
  "zipCode": string,                 // Postal code
  "country": string,                 // Country
  "taxId": string,                   // Tax ID or VAT number (optional)
  "notes": string,                   // Internal notes about client
  "totalSpent": number,              // Cached total spent (for analytics)
  "createdAt": timestamp,            // When client was added
  "updatedAt": timestamp,            // Last update
  "isActive": boolean                // Whether actively working with client
}
```

**Sample Document**:
```json
{
  "userId": "user123abc",
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
  "notes": "Prefers email communication. Payment net-30.",
  "totalSpent": 15000,
  "createdAt": { "_seconds": 1735689600 },
  "updatedAt": { "_seconds": 1735689600 },
  "isActive": true
}
```

**Indexes**: 
- Composite: (userId, isActive)
- Composite: (userId, createdAt)

---

### 3. **projects** Collection

**Purpose**: Group tasks into projects for better organization

**Document ID**: Auto-generated by Firestore

**Fields**:
```
{
  "userId": string,                  // Reference to project owner
  "clientId": string,                // Reference to associated client (optional)
  "name": string,                    // Project name
  "description": string,             // Project description
  "budget": number,                  // Optional project budget
  "status": string,                  // active | completed | archived
  "startDate": timestamp,            // When project started
  "dueDate": timestamp,              // Project deadline (optional)
  "createdAt": timestamp,            // When project was created
  "updatedAt": timestamp,            // Last update
  "taskCount": number,               // Cached count of tasks
  "completedCount": number           // Cached count of completed tasks
}
```

**Sample Document**:
```json
{
  "userId": "user123abc",
  "clientId": "client456def",
  "name": "Website Redesign - Phase 1",
  "description": "Complete redesign of company website with new branding",
  "budget": 5000,
  "status": "active",
  "startDate": { "_seconds": 1735689600 },
  "dueDate": { "_seconds": 1738368000 },
  "createdAt": { "_seconds": 1735689600 },
  "updatedAt": { "_seconds": 1735689600 },
  "taskCount": 8,
  "completedCount": 3
}
```

---

### 4. **tasks** Collection

**Purpose**: Store individual tasks/work items

**Document ID**: Auto-generated by Firestore

**Fields**:
```
{
  "userId": string,                  // Reference to task owner
  "projectId": string,               // Reference to project (optional)
  "clientId": string,                // Reference to client (optional)
  "title": string,                   // Task title
  "description": string,             // Detailed description
  "status": string,                  // todo | in-progress | completed | cancelled
  "priority": string,                // low | medium | high
  "dueDate": timestamp,              // When task is due
  "createdAt": timestamp,            // When task was created
  "updatedAt": timestamp,            // Last modification
  "completedAt": timestamp,          // When marked complete (null if not done)
  "estimatedHours": number,          // Estimated time to complete (optional)
  "attachments": array,              // File URLs (optional)
  "tags": array,                     // Labels/categories (optional)
  "subtasks": array                  // Quick subtasks (optional)
}
```

**Sample Document**:
```json
{
  "userId": "user123abc",
  "projectId": "project789ghi",
  "clientId": "client456def",
  "title": "Design homepage mockups",
  "description": "Create 3 different homepage layout options using Figma",
  "status": "in-progress",
  "priority": "high",
  "dueDate": { "_seconds": 1736294400 },
  "createdAt": { "_seconds": 1735689600 },
  "updatedAt": { "_seconds": 1735689600 },
  "completedAt": null,
  "estimatedHours": 8,
  "attachments": [
    "gs://taskpilot-bucket/attachments/task123/notes.pdf"
  ],
  "tags": ["design", "urgent"],
  "subtasks": [
    {
      "title": "Review client branding guidelines",
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
```

**Indexes**:
- Composite: (userId, status)
- Composite: (userId, dueDate)
- Composite: (userId, priority, status)
- Composite: (projectId, status)

---

### 5. **invoices** Collection

**Purpose**: Store invoice documents for billing clients

**Document ID**: Auto-generated by Firestore

**Fields**:
```
{
  "userId": string,                  // Reference to invoice creator
  "clientId": string,                // Reference to client being billed
  "projectId": string,               // Reference to associated project (optional)
  "invoiceNumber": string,           // Unique invoice number (INV-2025-001)
  "items": array,                    // Line items
    // Each item:
    // {
    //   "description": string,
    //   "quantity": number,
    //   "rate": number,
    //   "amount": number
    // }
  "subtotal": number,                // Sum of all items
  "tax": number,                     // Tax amount (optional)
  "taxRate": number,                 // Tax percentage (optional)
  "total": number,                   // subtotal + tax
  "currency": string,                // Currency code
  "status": string,                  // draft | sent | paid | overdue | cancelled
  "issuedDate": timestamp,           // When invoice was issued
  "dueDate": timestamp,              // Payment due date
  "paidDate": timestamp,             // When payment received (null if unpaid)
  "notes": string,                   // Terms, thank you note, etc
  "createdAt": timestamp,            // When created
  "updatedAt": timestamp             // Last modification
}
```

**Sample Document**:
```json
{
  "userId": "user123abc",
  "clientId": "client456def",
  "projectId": "project789ghi",
  "invoiceNumber": "INV-2025-001",
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
  "tax": 288,
  "taxRate": 8,
  "total": 3888,
  "currency": "USD",
  "status": "sent",
  "issuedDate": { "_seconds": 1735689600 },
  "dueDate": { "_seconds": 1738368000 },
  "paidDate": null,
  "notes": "Payment due within 30 days. Thank you for your business!",
  "createdAt": { "_seconds": 1735689600 },
  "updatedAt": { "_seconds": 1735689600 }
}
```

**Indexes**:
- Composite: (userId, status)
- Composite: (userId, dueDate)
- Composite: (clientId, status)

---

### 6. **payments** Collection

**Purpose**: Record payment receipts for invoices

**Document ID**: Auto-generated by Firestore

**Fields**:
```
{
  "userId": string,                  // Reference to user receiving payment
  "invoiceId": string,               // Reference to invoice being paid
  "clientId": string,                // Reference to paying client
  "amount": number,                  // Payment amount
  "currency": string,                // Currency code
  "paymentMethod": string,           // cash | check | bank_transfer | credit_card | paypal | other
  "transactionId": string,           // ID from payment processor (optional)
  "paymentDate": timestamp,          // When payment was received
  "notes": string,                   // Notes about payment (optional)
  "createdAt": timestamp,            // When recorded
  "updatedAt": timestamp             // Last modification
}
```

**Sample Document**:
```json
{
  "userId": "user123abc",
  "invoiceId": "invoice001xyz",
  "clientId": "client456def",
  "amount": 3888,
  "currency": "USD",
  "paymentMethod": "bank_transfer",
  "transactionId": "TXN-202502-12345",
  "paymentDate": { "_seconds": 1736899200 },
  "notes": "Received via wire transfer",
  "createdAt": { "_seconds": 1736899200 },
  "updatedAt": { "_seconds": 1736899200 }
}
```

---

### 7. **userSettings** Collection

**Purpose**: Store user preferences and settings

**Document ID**: Firebase UID (same as user)

**Fields**:
```
{
  "currency": string,                // Default currency (USD, EUR, etc)
  "timezone": string,                // Default timezone
  "theme": string,                   // light | dark | auto
  "language": string,                // Language code (en, es, fr, etc)
  "notificationsEnabled": boolean,   // Master notification toggle
  "emailNotifications": boolean,     // Email notifications
  "pushNotifications": boolean,      // Push notifications
  "dailyReminders": boolean,         // Daily task reminders
  "weeklyReports": boolean,          // Weekly summary reports
  "createdAt": timestamp,            // When settings created
  "updatedAt": timestamp             // Last modification
}
```

**Sample Document**:
```json
{
  "currency": "USD",
  "timezone": "America/Los_Angeles",
  "theme": "dark",
  "language": "en",
  "notificationsEnabled": true,
  "emailNotifications": true,
  "pushNotifications": true,
  "dailyReminders": true,
  "weeklyReports": true,
  "createdAt": { "_seconds": 1735689600 },
  "updatedAt": { "_seconds": 1735689600 }
}
```

---

## Part 4: Firestore Schema Diagram (Mermaid)

```
graph TD
    A["users<br/>{userId}"] -->|owns| B["clients<br/>{clientId}"]
    A -->|creates| C["projects<br/>{projectId}"]
    A -->|manages| D["tasks<br/>{taskId}"]
    A -->|issues| E["invoices<br/>{invoiceId}"]
    A -->|records| F["payments<br/>{paymentId}"]
    A -->|has| G["userSettings<br/>{userId}"]
    A -->|tracks| H["analytics<br/>{userId}"]
    
    B -->|appears in| C
    B -->|associated with| D
    B -->|billed via| E
    B -->|pays| F
    
    C -->|contains| D
    C -->|linked to| E
    
    E -->|paid by| F
    
    D -->|logged in| I["timeLogs<br/>{timeLogId}"]
    
    style A fill:#4a90e2
    style B fill:#50e3c2
    style C fill:#f5a623
    style D fill:#f8e71c
    style E fill:#bd10e0
    style F fill:#7ed321
    style G fill:#b8e986
    style H fill:#417505
    style I fill:#50e3c2
```

---

## Part 5: Naming & Structuring Conventions

### Field Naming Rules

1. **Use lowerCamelCase**
   ✅ Good: `createdAt`, `invoiceNumber`, `isActive`
   ❌ Bad: `created_at`, `invoice_number`, `IsActive`

2. **Boolean Fields Start with `is` or `has`**
   ✅ Good: `isActive`, `hasAttachments`, `isPaid`
   ❌ Bad: `active`, `attachments`, `paid`

3. **Timestamp Fields Use `At` Suffix**
   ✅ Good: `createdAt`, `updatedAt`, `completedAt`
   ❌ Bad: `created`, `updated`, `completed_date`

4. **References Use Clear Naming**
   ✅ Good: `userId`, `clientId`, `invoiceId`
   ❌ Bad: `user`, `client`, `invoice`

5. **Keep Field Structure Simple**
   ✅ Good: Separate collections for related data
   ❌ Bad: Deeply nested maps (2+ levels)

### ID Generation Strategy

| Collection | ID Type | Example |
|-----------|---------|---------|
| users | Firebase UID | `JdkLp3sBwkQc7e1FgH2s` |
| clients | Auto-generated | `abc123def456ghi789` |
| projects | Auto-generated | `project001abc` |
| tasks | Auto-generated | `task001xyz` |
| invoices | Auto-generated | `invoice001` |
| payments | Auto-generated | `payment001` |
| userSettings | Firebase UID | `JdkLp3sBwkQc7e1FgH2s` |

---

## Part 6: Data Relationships & Rules

### User Isolation
✅ All user data is isolated by userId  
✅ Clients belong to one user  
✅ Tasks belong to one user  
✅ Invoices belong to one user  

### Data Consistency

**Invoice-Payment Relationship**:
- When payment recorded: check that amount ≤ invoice.total
- When invoice status changes: update related records

**Task-Project Relationship**:
- When task created: optional projectId reference
- When project deleted: tasks should be orphaned (not deleted)

**Client-Dependent Collections**:
- When client deleted: manually orphan related tasks/invoices
- Or use soft delete (set `isActive: false`)

### Indexing Strategy

**Critical Indexes** (must create manually):
```
1. tasks: (userId, status)
2. tasks: (userId, dueDate)
3. tasks: (userId, priority, status)
4. invoices: (userId, status)
5. invoices: (userId, dueDate)
6. clients: (userId, isActive)
7. projects: (userId, status)
```

---

## Part 7: Scalability Analysis

### Current Schema Scalability

#### Users
- **Per user**: ~2 KB
- **100K users**: ~200 MB
- **Status**: ✅ Highly scalable

#### Clients
- **Per client**: ~500 B
- **Per user avg**: ~20 clients = 10 KB
- **100K users × 20 clients**: ~200 MB
- **Status**: ✅ Highly scalable

#### Tasks
- **Per task**: ~800 B
- **Per user avg**: ~50 tasks = 40 KB
- **100K users × 50 tasks**: ~4 GB
- **Status**: ✅ Scalable with proper indexes

#### Invoices
- **Per invoice**: ~1.5 KB
- **Per user avg**: ~30 invoices = 45 KB
- **100K users × 30 invoices**: ~4.5 GB
- **Status**: ✅ Scalable

#### Payments
- **Per payment**: ~400 B
- **Per user avg**: ~30 payments = 12 KB
- **100K users × 30 payments**: ~1.2 GB
- **Status**: ✅ Highly scalable

### Read/Write Cost Analysis

**Typical Daily Operations per User**:
- View tasks: 1 document read
- Create task: 1 write
- Update task: 1 write
- View invoice: 1 document read
- Create invoice: 1 write
- Total: ~5 operations/day

**100K users × 5 ops × 30 days = 15 million operations/month**
- Cost: ~$0.50-1.00/month (Firestore free tier covers 50K reads/day)
- **Status**: ✅ Cost-effective at scale

---

## Part 8: Validation Checklist

✅ **Logical Grouping**: Each collection serves a single purpose  
✅ **Scalable Structure**: No arrays with 10K+ items  
✅ **Minimal Reads/Writes**: Use references, not denormalization  
✅ **No Unnecessary Nesting**: Max 3 levels (collection → doc → field)  
✅ **Consistent Naming**: lowerCamelCase throughout  
✅ **Clear References**: Foreign keys use `*Id` naming  
✅ **Timestamp Completeness**: createdAt/updatedAt on all docs  
✅ **User Isolation**: All queries include userId filter  
✅ **Future-Proof**: Room for growth without restructuring  
✅ **Team-Understandable**: Clear field names and structure  

---

## Part 9: Security Rules Preview

```javascript
// Preview of Firestore Security Rules (to be implemented)
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    
    // User can only access their own data
    match /users/{userId} {
      allow read, write: if request.auth.uid == userId;
    }
    
    // User can only access their own clients
    match /clients/{document=**} {
      allow read, write: if request.auth.uid == resource.data.userId;
    }
    
    // User can only access their own tasks
    match /tasks/{document=**} {
      allow read, write: if request.auth.uid == resource.data.userId;
    }
    
    // User can only access their own invoices
    match /invoices/{document=**} {
      allow read, write: if request.auth.uid == resource.data.userId;
    }
    
    // ... (similar rules for other collections)
  }
}
```

---

## Part 10: Implementation Roadmap

### Phase 1: Core Collections (MVP)
1. ✅ users (created via Firebase Auth)
2. ✅ userSettings
3. ⏳ clients
4. ⏳ tasks
5. ⏳ projects

### Phase 2: Billing
6. ⏳ invoices
7. ⏳ payments

### Phase 3: Analytics & Enhancements
8. ⏳ analytics
9. ⏳ timeLogs (optional)

### Phase 4: Advanced Features
10. ⏳ Notifications collection
11. ⏳ ActivityLogs collection (audit trail)

---

## Part 11: Design Decisions & Rationale

### Why Separate Collections for Invoices & Payments?
**Decision**: Create separate `invoices` & `payments` collections instead of embedding payments in invoices

**Rationale**:
- ✅ Payments can be recorded repeatedly for single invoice
- ✅ Payment history can be queried independently
- ✅ Avoid document size limits (Firestore max 1 MB)
- ✅ Better scalability for high-volume payment apps

### Why No Subcollections?
**Decision**: Use reference fields (userId, clientId) instead of subcollections

**Rationale**:
- ✅ Simpler queries (no need to traverse subcollections)
- ✅ Easier access control with security rules
- ✅ Collections can be queried globally
- ✅ Easier data migration and management

**When to Use Subcollections** (Future):
- Chat messages under conversations
- Comments under posts
- Revisions under documents
- (Only for truly nested, large content)

### Why Arrays for Items in Invoices?
**Decision**: Use array for invoice items instead of subcollection

**Rationale**:
- ✅ Invoice is always read as single unit
- ✅ Items are short (~100 B each)
- ✅ Typically <= 50 items per invoice
- ✅ Denormalization justified here

### Why Duplicate Currency in Payments?
**Decision**: Store currency in both invoices and payments

**Rationale**:
- ✅ Payment valid even if user deletes invoice
- ✅ Audit trail includes currency info
- ✅ Payment can be recorded independently

---

## Part 12: Future Enhancements

### Collections to Add Later

#### notifications
```
{
  "userId": string,
  "type": string,           // task_due, invoice_paid, etc
  "title": string,
  "message": string,
  "read": boolean,
  "createdAt": timestamp
}
```

#### activityLog
```
{
  "userId": string,
  "action": string,         // created_task, sent_invoice, etc
  "entityType": string,     // task, invoice, client
  "entityId": string,
  "details": object,
  "timestamp": timestamp
}
```

#### teamMembers (for future team collaboration)
```
{
  "userId": string,
  "teamId": string,
  "role": string,          // admin, editor, viewer
  "joinedAt": timestamp
}
```

#### templates (for recurring invoices, tasks)
```
{
  "userId": string,
  "type": string,          // invoice, task
  "name": string,
  "content": object,
  "createdAt": timestamp
}
```

---

## Conclusion

This Firestore schema provides:

✅ **Clarity**: Well-organized, easy to understand  
✅ **Scalability**: Handles 100K+ users efficiently  
✅ **Security**: User isolation built-in  
✅ **Flexibility**: Room for future features  
✅ **Performance**: Optimized read/write patterns  
✅ **Cost-Efficiency**: Minimal document operations  

**Ready for implementation!**

---

**Last Updated**: March 5, 2026
**Version**: 1.0
**Status**: ✅ Design Complete - Ready for Implementation
