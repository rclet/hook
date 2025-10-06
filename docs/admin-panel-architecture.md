# Admin Panel Architecture Diagram

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                          PIPIT ADMIN PANEL ARCHITECTURE                      │
└─────────────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────────┐
│ 1. AUTHENTICATION FLOW                                                      │
└─────────────────────────────────────────────────────────────────────────────┘

   User                    App                     Backend
     │                      │                         │
     │   Enter credentials  │                         │
     ├─────────────────────>│                         │
     │                      │   POST /api/auth/login  │
     │                      ├────────────────────────>│
     │                      │                         │
     │                      │   Response with role    │
     │                      │<────────────────────────┤
     │                      │   {                     │
     │                      │     user: {             │
     │                      │       role: "admin"     │
     │                      │     },                  │
     │                      │     token: "..."        │
     │                      │   }                     │
     │                      │                         │
     │   Login successful   │  Store in Secure        │
     │<─────────────────────┤  Storage                │
     │                      │  - token                │
     │                      │  - role                 │
     │                      │                         │

┌─────────────────────────────────────────────────────────────────────────────┐
│ 2. ADMIN ACCESS FLOW                                                        │
└─────────────────────────────────────────────────────────────────────────────┘

   User                    App                     Backend
     │                      │                         │
     │  Navigate to /admin  │                         │
     ├─────────────────────>│                         │
     │                      │                         │
     │                      │  Router Guard           │
     │                      │  ┌──────────────┐       │
     │                      │  │ Check Auth   │       │
     │                      │  └──────┬───────┘       │
     │                      │         │               │
     │                      │  GET /api/auth/me       │
     │                      ├────────────────────────>│
     │                      │                         │
     │                      │  Verify & return user   │
     │                      │<────────────────────────┤
     │                      │  {                      │
     │                      │    user: {              │
     │                      │      role: "admin"      │
     │                      │    }                    │
     │                      │  }                      │
     │                      │         │               │
     │                      │  ┌──────▼───────┐       │
     │                      │  │ Check Role   │       │
     │                      │  └──────┬───────┘       │
     │                      │         │               │
     │                      │    if admin             │
     │                      │  ┌──────▼───────┐       │
     │   Admin Dashboard    │  │ Allow Access │       │
     │<─────────────────────┤  └──────────────┘       │
     │                      │                         │
     │                      │    if not admin         │
     │   Redirect to /home  │  ┌──────────────┐       │
     │<─────────────────────┤  │ Redirect     │       │
     │                      │  └──────────────┘       │
     │                      │                         │

┌─────────────────────────────────────────────────────────────────────────────┐
│ 3. SYSTEM ARCHITECTURE                                                      │
└─────────────────────────────────────────────────────────────────────────────┘

┌────────────────────────────────────────────────────────────────────────────┐
│                              FRONTEND (Flutter)                             │
├────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  ┌──────────────────┐    ┌──────────────────┐    ┌──────────────────┐    │
│  │   UI Screens     │    │   Services       │    │   Models         │    │
│  ├──────────────────┤    ├──────────────────┤    ├──────────────────┤    │
│  │ HomeScreen       │    │ AuthService      │    │ AuthUser         │    │
│  │   └─ AdminBtn    │    │   └─ isAdmin()   │    │   └─ role        │    │
│  │                  │    │   └─ verifyAuth()│    │   └─ isAdmin     │    │
│  │ LoginScreen      │◄───┤                  │◄───┤                  │    │
│  │                  │    │ RouterService    │    │ AuthResponse     │    │
│  │ AdminDashboard   │◄───┤   └─ Guard       │    │                  │    │
│  │ AdminUsers       │    │                  │    │                  │    │
│  └──────────────────┘    └──────────────────┘    └──────────────────┘    │
│                                    │                                       │
└────────────────────────────────────┼───────────────────────────────────────┘
                                     │
                                     │ HTTPS / JWT Token
                                     │
┌────────────────────────────────────▼───────────────────────────────────────┐
│                              BACKEND (API)                                  │
├────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  ┌──────────────────┐    ┌──────────────────┐    ┌──────────────────┐    │
│  │   Endpoints      │    │   Middleware     │    │   Database       │    │
│  ├──────────────────┤    ├──────────────────┤    ├──────────────────┤    │
│  │ POST /auth/login │───►│ Auth Check       │───►│ users table      │    │
│  │ GET /auth/me     │    │ Role Check       │    │   ├─ id          │    │
│  │                  │    │                  │    │   ├─ email       │    │
│  │ Admin Endpoints: │    │ AdminMiddleware  │    │   ├─ role ◄──────┼─┐  │
│  │ /admin/users     │───►│   └─ Verify      │    │   └─ ...        │ │  │
│  │ /admin/gigs      │    │      role="admin"│    │                  │ │  │
│  │ /admin/orders    │    │                  │    └──────────────────┘ │  │
│  └──────────────────┘    └──────────────────┘                         │  │
│                                                                        │  │
│  New field added ──────────────────────────────────────────────────────┘  │
└────────────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────────┐
│ 4. SECURITY LAYERS                                                          │
└─────────────────────────────────────────────────────────────────────────────┘

Layer 1: Authentication (Token)
┌────────────────────────────────────────────────────────┐
│ ✓ User must be logged in                              │
│ ✓ Valid JWT token required                            │
│ ✓ Token stored in Flutter Secure Storage              │
└────────────────────────────────────────────────────────┘
                        │
                        ▼
Layer 2: Frontend Route Guard
┌────────────────────────────────────────────────────────┐
│ ✓ Router checks role before navigation                │
│ ✓ Calls GET /api/auth/me to verify                    │
│ ✓ Redirects if unauthorized                           │
└────────────────────────────────────────────────────────┘
                        │
                        ▼
Layer 3: Backend Authorization
┌────────────────────────────────────────────────────────┐
│ ✓ Middleware checks role="admin"                      │
│ ✓ Returns 403 if not admin                            │
│ ✓ Role stored in database                             │
└────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────────┐
│ 5. DATA FLOW                                                                │
└─────────────────────────────────────────────────────────────────────────────┘

Storage Locations:

Flutter Secure Storage                Database (Backend)
┌──────────────────────┐             ┌──────────────────────┐
│ auth_token           │◄────────────┤ users.id             │
│ token_type           │             │ users.email          │
│ user_data            │             │ users.role ◄── NEW   │
│   ├─ id              │             │ users.password       │
│   ├─ email           │             │ users.created_at     │
│   ├─ role ◄── NEW    │             │ users.updated_at     │
│   └─ ...             │             └──────────────────────┘
└──────────────────────┘

┌─────────────────────────────────────────────────────────────────────────────┐
│ 6. ROUTE STRUCTURE                                                          │
└─────────────────────────────────────────────────────────────────────────────┘

Public Routes (No Auth Required)
├── /                     Splash Screen
├── /login               Login Screen
└── /register            Register Screen

Protected Routes (Auth Required)
├── /home                Home Screen
│   └── [Admin Button]   ◄── Shows only if role="admin"
├── /profile             Profile Screen
└── /settings            Settings Screen

Admin Routes (Auth + Admin Role Required)
└── /admin               ◄── Guard checks here
    ├── /                Dashboard Screen
    ├── /users          User Management
    ├── /gigs           Gig Management
    ├── /orders         Order Management
    └── /settings       Platform Settings

┌─────────────────────────────────────────────────────────────────────────────┐
│ 7. ERROR HANDLING                                                           │
└─────────────────────────────────────────────────────────────────────────────┘

Scenario                          Action
─────────────────────────────────────────────────────────────────────────
Token expired (401)           →   Clear storage + Redirect to /login
Not authenticated             →   Redirect to /login
Non-admin user                →   Redirect to /home
API call fails                →   Show error + Redirect to /login
Backend returns wrong role    →   Redirect to /home

┌─────────────────────────────────────────────────────────────────────────────┐
│ 8. TESTING FLOW                                                             │
└─────────────────────────────────────────────────────────────────────────────┘

1. Unit Tests (Automated)
   ├── AuthUser.fromJson() with role
   ├── AuthUser.isAdmin getter
   ├── Role serialization
   └── Edge cases (null, case sensitivity)

2. Manual Tests (Required)
   ├── Login as admin (sayma@gopipit.com)
   ├── Verify admin button visible
   ├── Navigate to admin panel
   ├── Test all admin routes
   ├── Logout and login as regular user
   ├── Verify admin button NOT visible
   ├── Try direct URL to /admin
   └── Verify redirect to /home

┌─────────────────────────────────────────────────────────────────────────────┐
│ LEGEND                                                                      │
└─────────────────────────────────────────────────────────────────────────────┘
  ──►  Data flow direction
  ◄──  NEW field added
  ✓    Security check
  │    Component connection
  └──  Sub-component
```
