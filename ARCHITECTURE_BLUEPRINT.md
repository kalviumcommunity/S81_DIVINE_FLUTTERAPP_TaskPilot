# TaskPilot - Production Architecture Blueprint
**Freelancer Task & Payment Management Mobile App**
**Built with Flutter + Firebase + n8n**

---

## 📋 TABLE OF CONTENTS
1. Product Architecture Overview
2. Core Features (MVP)
3. User Flow
4. Database Structure (Firestore)
5. Backend Logic Split (Flutter vs n8n)
6. System Architecture Diagram
7. Technology Stack Rationale

---

## 1️⃣ PRODUCT ARCHITECTURE OVERVIEW

### Core Problem
Freelancers lose track of:
- Multiple active tasks
- Client deadlines
- Payment status
- Follow-up deadlines

### Solution: TaskPilot
**All-in-one freelancer management**: Tasks → Deadlines → Payments → Automated Reminders

### Architecture Principles
- **Firebase**: Real-time sync, auth, Firestore DB, Cloud Functions
- **Flutter**: Native performance, retro UI, offline capability
- **n8n**: Automation engine (reminders, follow-ups, notifications)
- **Clean Architecture**: Separation of concerns, easy to scale

---

## 2️⃣ MVP CORE FEATURES (14-Day Sprint)

### Phase 1: Foundation (Days 1-4)
- [ ] Auth (Email/Password + Google Sign-in)
- [ ] Dashboard with retro UI
- [ ] Task Management (Create, Read, Update, Delete)
- [ ] Task Categories & Priority

### Phase 2: Business Logic (Days 5-8)
- [ ] Client Management
- [ ] Deadline Tracking
- [ ] Task Status Workflow (To-Do → In Progress → Done)
- [ ] Basic Payment Tracking

### Phase 3: Automation (Days 9-11)
- [ ] Firebase Cloud Functions for triggers
- [ ] n8n workflow setup
- [ ] Push notifications
- [ ] Email reminders

### Phase 4: Polish & Deploy (Days 12-14)
- [ ] Retro UI refinements + 3D card effects
- [ ] Testing & bug fixes
- [ ] Firebase deployment
- [ ] APK build for Play Store submission

---

## 3️⃣ USER FLOW

```
┌─────────────────────────────────────────────────────────────┐
│                      TASKPILOT USER FLOW                    │
└─────────────────────────────────────────────────────────────┘

START
  ↓
[Splash Screen - Retro Animation]
  ↓
[Login/Register via Email or Google]
  ↓
[Dashboard - Main Hub]
  ├─ View Active Tasks (retro card grid)
  ├─ View Upcoming Deadlines (timeline view)
  ├─ Check Payment Status
  └─ See Pending Reminders
  ↓
[Task Creation Flow]
  ├─ Select Client
  ├─ Add Task Title & Description
  ├─ Set Deadline
  ├─ Set Priority (Low/Medium/High)
  ├─ Add Payment Info (rate, status)
  └─ SAVE (triggers Firebase trigger → n8n workflow)
  ↓
[Automation Triggered]
  ├─ Calculate days until deadline
  ├─ Set 3-day & 1-day reminders
  ├─ Mark for payment follow-up (7 days post-completion)
  └─ Send push notifications
  ↓
[User Gets Notified]
  ├─ Task reminder (3 days before deadline)
  ├─ Urgent deadline (1 day)
  ├─ Payment follow-up (7 days after task done)
  └─ Updates in real-time on dashboard
  ↓
[Task Completion]
  ├─ Mark task as DONE
  ├─ Auto-trigger payment follow-up workflow in n8n
  └─ Generate quick receipt/invoice
  ↓
[Payment Tracking]
  ├─ View payment status per client
  ├─ Get payment reminders
  └─ Export payment records
  ↓
END
```

---

## 4️⃣ DATABASE STRUCTURE (FIRESTORE)

### Collections & Documents

```
Firestore Structure:
├── users/
│   └── {userId}/
│       ├── profile
│       │   ├── name (string)
│       │   ├── email (string)
│       │   ├── profilePic (URL)
│       │   ├── billing.ratePerHour (number)
│       │   ├── createdAt (timestamp)
│       │   └── preferences (object)
│       ├── tasks/
│       │   └── {taskId}/
│       │       ├── title (string)
│       │       ├── description (string)
│       │       ├── clientId (reference)
│       │       ├── status (enum: "todo" | "inProgress" | "done")
│       │       ├── priority (enum: "low" | "medium" | "high")
│       │       ├── deadline (timestamp)
│       │       ├── startDate (timestamp)
│       │       ├── rate (number)
│       │       ├── estimatedHours (number)
│       │       ├── actualHours (number)
│       │       ├── tags (array)
│       │       ├── createdAt (timestamp)
│       │       ├── updatedAt (timestamp)
│       │       └── completedAt (timestamp)
│       ├── clients/
│       │   └── {clientId}/
│       │       ├── name (string)
│       │       ├── email (string)
│       │       ├── phone (string)
│       │       ├── company (string)
│       │       ├── paymentStatus (enum: "pending" | "partial" | "completed")
│       │       ├── totalSpent (number)
│       │       └── createdAt (timestamp)
│       ├── payments/
│       │   └── {paymentId}/
│       │       ├── clientId (reference)
│       │       ├── taskIds (array of references)
│       │       ├── amount (number)
│       │       ├── status (enum: "unpaid" | "partial" | "paid")
│       │       ├── dueDate (timestamp)
│       │       ├── paidDate (timestamp)
│       │       ├── invoiceUrl (string)
│       │       ├── notes (string)
│       │       └── createdAt (timestamp)
│       └── notifications/
│           └── {notificationId}/
│               ├── type (enum: "reminder" | "deadline" | "payment" | "update")
│               ├── title (string)
│               ├── message (string)
│               ├── taskId (reference, optional)
│               ├── read (boolean)
│               ├── actionUrl (string, optional)
│               └── createdAt (timestamp)

├── automationLogs/ (for n8n tracking)
│   └── {logId}/
│       ├── userId (reference)
│       ├── workflowName (string)
│       ├── trigger (string)
│       ├── status (enum: "success" | "failed")
│       ├── response (object)
│       └── timestamp (timestamp)
```

### Firestore Indexes
```
Composite Indexes:
1. users/{userId}/tasks: status, deadline
2. users/{userId}/tasks: priority, status
3. users/{userId}/payments: status, dueDate
4. users/{userId}/notifications: read, createdAt (descending)
```

---

## 5️⃣ BACKEND LOGIC SPLIT: FLUTTER vs n8n

### RUNS IN FLUTTER (Mobile App)
✅ **Immediate, synchronous operations:**
- User authentication (Firebase Auth)
- Task CRUD operations
- Local state management
- UI rendering & navigation
- Offline sync (local cache with Firestore)
- Form validation
- Payment input/updates
- Task status changes

### RUNS IN n8n (Automation Layer)
✅ **Asynchronous, scheduled, or event-triggered:**
- **Task Deadline Reminders**
  - Trigger: 3 days before deadline
  - Action: Send push notification + email
  
- **Urgent Deadline Alert**
  - Trigger: 1 day before deadline
  - Action: Send urgent push notification
  
- **Payment Follow-up**
  - Trigger: 7 days after task completion
  - Action: Send email reminder + push notification
  
- **Weekly Payment Summary**
  - Trigger: Every Monday 9 AM
  - Action: Send email with unpaid invoices
  
- **Client Inactivity Alert**
  - Trigger: No tasks from client for 30 days
  - Action: Send prompt to reach out
  
- **Invoice Generation**
  - Trigger: Task marked as DONE
  - Action: Generate PDF invoice, send to client email

### Communication Flow

```
┌─────────────┐          ┌─────────────┐         ┌──────────────┐
│   FLUTTER   │  CREATE  │  FIRESTORE  │ TRIGGER │   n8n CLOUD  │
│   (Mobile)  │─────────→│  (Database) │────────→│  (Automation)│
└─────────────┘          └─────────────┘         └──────────────┘
      ↑                         ↓                        │
      │                   REAL-TIME SYNC                 │
      │                      (Listeners)                 │
      └─────────────────────────────────────────────────┘
                    PUSH NOTIFICATIONS
                    (Firebase Cloud Messaging)
```

---

## 6️⃣ SYSTEM ARCHITECTURE DIAGRAM

```
┌──────────────────────────────────────────────────────────────────┐
│                        USER DEVICE (iOS/Android)                 │
│                                                                   │
│  ┌─────────────────────────────────────────────────────────────┐ │
│  │                     FLUTTER APP                             │ │
│  │  ┌──────────────────────────────────────────────────────┐  │ │
│  │  │ UI Layer (Retro Dashboard, Cards, 3D Effects)       │  │ │
│  │  ├──────────────────────────────────────────────────────┤  │ │
│  │  │ BLoC/Provider State Management                       │  │ │
│  │  ├──────────────────────────────────────────────────────┤  │ │
│  │  │ Repository Pattern (Data Abstraction)               │  │ │
│  │  ├──────────────────────────────────────────────────────┤  │ │
│  │  │ Firebase SDK (Auth, Firestore Real-time sync)       │  │ │
│  │  └──────────────────────────────────────────────────────┘  │ │
│  └─────────────────────────────────────────────────────────────┘ │
└──────────────────────────────────────────────────────────────────┘
                              │
                              │ HTTPS
                              ↓
┌──────────────────────────────────────────────────────────────────┐
│                    GOOGLE FIREBASE CLOUD                         │
│                                                                   │
│  ┌──────────────────────────────┐  ┌──────────────────────────┐ │
│  │   Firestore (NoSQL DB)       │  │   Firebase Auth          │ │
│  │  - Collections               │  │  - Email/Password        │ │
│  │  - Real-time listeners       │  │  - Google/Social Login   │ │
│  │  - Security Rules            │  │                          │ │
│  └──────────────────────────────┘  └──────────────────────────┘ │
│                                                                   │
│  ┌──────────────────────────────┐  ┌──────────────────────────┐ │
│  │   Cloud Functions            │  │   Cloud Messaging (FCM)  │ │
│  │  - Task triggers             │  │  - Push notifications    │ │
│  │  - Webhooks from n8n         │  │  - Real-time alerts      │ │
│  │  - Data transformations      │  │                          │ │
│  └──────────────────────────────┘  └──────────────────────────┘ │
│                                                                   │
│  ┌──────────────────────────────┐  ┌──────────────────────────┐ │
│  │   Cloud Storage              │  │   Analytics              │ │
│  │  - Invoice PDFs              │  │  - Usage tracking        │ │
│  │  - User data backups         │  │                          │ │
│  └──────────────────────────────┘  └──────────────────────────┘ │
└──────────────────────────────────────────────────────────────────┘
                              │
                              │ HTTP Webhooks
                              ↓
┌──────────────────────────────────────────────────────────────────┐
│                    n8n AUTOMATION PLATFORM                       │
│  (Self-hosted or Cloud)                                          │
│                                                                   │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │  Workflows:                                              │  │
│  │  ✓ Task Deadline Reminder (3 days before)               │  │
│  │  ✓ Urgent Alert (1 day before)                          │  │
│  │  ✓ Payment Follow-up (7 days post-completion)           │  │
│  │  ✓ Weekly Payment Summary Report                        │  │
│  │  ✓ Invoice Generator (HTML → PDF)                       │  │
│  │  ✓ Client Re-engagement Alert (30 days inactive)        │  │
│  └──────────────────────────────────────────────────────────┘  │
│                                                                   │
│  Integrations:                                                   │
│  ├─ Firebase Firestore (Read/Write)                             │
│  ├─ SendGrid / Gmail (Email)                                    │
│  ├─ Twilio (SMS/WhatsApp)                                       │
│  ├─ Firebase Cloud Messaging (Push notifications)               │
│  ├─ Google Drive (Invoice storage)                              │
│  └─ Webhook endpoints                                           │
└──────────────────────────────────────────────────────────────────┘
```

---

## 7️⃣ TECHNOLOGY STACK RATIONALE

| Layer | Technology | Why |
|-------|-----------|-----|
| **Mobile Frontend** | Flutter + Dart | Fast dev, retro UI easy, iOS + Android in one codebase, excellent performance |
| **State Management** | BLoC (Provider alternative) | Scalable, testable, clean separation of concerns |
| **UI/UX** | Custom widgets + Neumorphism | Retro aesthetic without skeuomorphism, modern depth effects |
| **Backend Auth** | Firebase Auth | Serverless, supports email/Google/social, free tier generous |
| **Database** | Firestore (NoSQL) | Real-time sync, offline support, scales automatically, free tier sufficient |
| **Push Notifications** | Firebase Cloud Messaging (FCM) | Native integration with Firebase, free, reliable |
| **Automation** | n8n (self-hosted or cloud) | Visual workflow builder, 500+ integrations, easy maintenance, open-source alternative to Zapier |
| **Invoice Generation** | pdf library + n8n | Serverless invoice generation triggered from n8n |
| **Email** | SendGrid + Firebase Functions | Reliable delivery, templates, tracking |
| **Hosting (n8n)** | Railway / Render / Digital Ocean | $12-25/month, easy deployment, Docker support |

---

## KEY ARCHITECTURE DECISIONS

### 1. Why Firestore over Realtime Database?
- Firestore: Better querying, offline support, scales better, data validation rules
- RTD: Simpler for some, but limited query flexibility

### 2. Why n8n over Cloud Functions only?
- n8n: Visual workflows, easy to modify without code, built-in integrations (email, SMS, etc.)
- Cloud Functions: More powerful but requires coding for each automation

### 3. Why BLoC over GetX or Provider?
- BLoC: Enterprise-grade, testable, clear separation, scales well
- Alternative: Provider for simpler implementation (if you prefer faster setup)

### 4. Offline-First Approach
- Flutter caches data locally
- Firestore syncs when online
- No lost data, better UX

---

## NEXT STEPS
→ Jump to **SPRINT_PLAN.md** for day-by-day tasks
→ Jump to **FLUTTER_BUILD_GUIDE.md** for coding details
→ Jump to **N8N_WORKFLOWS.md** for automation setup
