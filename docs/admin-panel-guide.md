# Admin Panel Implementation Guide

## Overview

This document describes the implementation of role-based access control and admin panel functionality in the Pipit Flutter application.

## Architecture

### 1. Authentication & Authorization

#### Role Field
- Added `role` field to `AuthUser` model
- Role is returned from backend during login/registration
- Stored securely using Flutter Secure Storage
- Accessible via `user.role` and `user.isAdmin` getter

#### Admin Check Flow
```
User Login → Backend Returns Role → Store in Secure Storage → Check isAdmin
```

### 2. Router Guards

#### Implementation Location
`lib/services/router_service.dart` - `redirect()` callback

#### Guard Logic
```dart
if (location.startsWith('/admin')) {
  1. Check if user is authenticated
  2. Call GET /api/auth/me to verify role
  3. Check if user.isAdmin == true
  4. Redirect if unauthorized:
     - Not authenticated → /login
     - Not admin → /home
}
```

#### API Verification
- Endpoint: `GET /api/auth/me`
- Purpose: Verify current user's role from backend
- Called on every admin route navigation
- Updates local user data with fresh info from server

### 3. Admin Panel UI

#### Screen Structure
```
/admin
├── AdminDashboardScreen (Main dashboard)
├── /admin/users (User management)
├── /admin/gigs (Gig management)
├── /admin/orders (Order management)
└── /admin/settings (Platform settings)
```

#### Components

**AdminDashboardScreen**
- Welcome card
- Quick stats cards (Users, Gigs, Orders, Revenue)
- Admin action cards with navigation
- Logout button

**AdminUsersScreen**
- User search functionality
- User list with actions
- View/Edit/Disable user options

### 4. UI Integration

#### Home Screen Admin Button
- Location: App bar actions
- Visibility: Only shown to admin users
- Icon: `Icons.admin_panel_settings_rounded`
- Style: Amber background for distinction
- Action: Navigate to `/admin`

#### Code Example
```dart
if (isAdmin)
  IconButton(
    onPressed: () => context.go('/admin'),
    icon: Icon(Icons.admin_panel_settings_rounded),
  )
```

## Backend Requirements

### API Endpoints

#### 1. Login/Register Response
```json
{
  "success": true,
  "message": "Login successful",
  "user": {
    "id": 1,
    "name": "Admin User",
    "email": "sayma@gopipit.com",
    "role": "admin",
    "created_at": "2024-01-01T00:00:00.000Z",
    "updated_at": "2024-01-01T00:00:00.000Z"
  },
  "token": "jwt-token-here",
  "token_type": "Bearer",
  "expires_in": 3600
}
```

#### 2. Auth Verification Endpoint
**Request:**
```
GET /api/auth/me
Authorization: Bearer {token}
```

**Response:**
```json
{
  "success": true,
  "user": {
    "id": 1,
    "name": "Admin User",
    "email": "sayma@gopipit.com",
    "role": "admin",
    "created_at": "2024-01-01T00:00:00.000Z",
    "updated_at": "2024-01-01T00:00:00.000Z"
  }
}
```

## Admin Credentials

### Test Account
- **Email:** `sayma@gopipit.com`
- **Password:** `asdf1234`
- **Role:** `admin`

## Usage Guide

### For Developers

#### Adding New Admin Routes
```dart
GoRoute(
  path: '/admin/new-feature',
  name: 'admin_new_feature',
  builder: (context, state) => const NewFeatureScreen(),
),
```

The guard automatically protects all routes starting with `/admin`.

#### Checking Admin Status in Code
```dart
final authService = context.read<AuthService>();
final isAdmin = await authService.isAdmin();

if (isAdmin) {
  // Show admin-only features
}
```

#### Getting Current User with Role
```dart
final authService = context.read<AuthService>();
final user = await authService.getCurrentUser();

if (user?.isAdmin == true) {
  // User is admin
}
```

### For Users

#### Accessing Admin Panel
1. Log in with admin credentials
2. Look for admin icon in home screen app bar (amber icon)
3. Tap to navigate to admin dashboard
4. Access is verified on navigation

#### Admin Features
- View platform statistics
- Manage users
- Review gigs
- Monitor orders
- Configure settings

## Security Considerations

### 1. Role Verification
- Role is verified on every admin route navigation
- Calls backend API to ensure role hasn't changed
- Local storage is updated with fresh data

### 2. Token Management
- Token stored in Flutter Secure Storage
- Automatically included in API requests
- Cleared on logout or 401 errors

### 3. Redirect Protection
- Unauthenticated users → `/login`
- Non-admin users → `/home`
- Prevents direct URL access to admin routes

## Testing

### Unit Tests
Location: `test/auth_models_test.dart`

Tests cover:
- Role field parsing from JSON
- isAdmin getter logic
- Case-insensitive role checking
- Null role handling
- JSON serialization with role

### Manual Testing Steps
1. **Login as Admin**
   - Use admin credentials
   - Verify admin button appears in home screen
   
2. **Access Admin Panel**
   - Click admin button
   - Verify redirect to `/admin`
   - Check dashboard loads correctly
   
3. **Navigation**
   - Test all admin sub-routes
   - Verify back button works
   - Check logout functionality
   
4. **Authorization**
   - Login as regular user
   - Verify admin button NOT shown
   - Try direct URL access to `/admin`
   - Should redirect to `/home`
   
5. **Unauthenticated Access**
   - Log out
   - Try to access `/admin`
   - Should redirect to `/login`

## Code Files Changed

### Modified Files
1. `lib/models/auth_models.dart` - Added role field
2. `lib/models/auth_models.g.dart` - Generated code for role
3. `lib/services/auth_service.dart` - Added isAdmin() and verifyAuth()
4. `lib/services/router_service.dart` - Added admin routes and guard
5. `lib/screens/home_screen.dart` - Added admin button

### New Files
1. `lib/screens/admin/admin_dashboard_screen.dart` - Dashboard
2. `lib/screens/admin/admin_users_screen.dart` - User management
3. `test/auth_models_test.dart` - Unit tests

## Future Enhancements

### Potential Features
1. **Granular Permissions**
   - Role-based permissions beyond admin/user
   - Feature-specific access control
   
2. **Admin Activity Log**
   - Track admin actions
   - Audit trail for changes
   
3. **Advanced User Management**
   - Bulk operations
   - User analytics
   - Role assignment UI
   
4. **Real-time Stats**
   - WebSocket integration
   - Live dashboard updates
   
5. **Export Functionality**
   - Export user data
   - Generate reports

## Troubleshooting

### Admin Button Not Showing
- Check user is logged in
- Verify user has `role: 'admin'` in backend response
- Check `isAdmin` state in HomeScreen

### Access Denied to Admin Panel
- Verify backend returns `role: 'admin'`
- Check `/api/auth/me` endpoint is working
- Ensure token is valid and not expired

### Navigation Issues
- Check go_router version (requires ^14.0.0 for async redirect)
- Verify all admin screens are imported in router_service.dart
- Check console for navigation errors

## Support

For questions or issues:
- Check GitHub Issues: https://github.com/rclet/hook/issues
- Review this documentation
- Contact development team
