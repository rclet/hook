# Backend Integration Guide - Admin Panel

## Quick Reference

This guide is for backend developers integrating with the Pipit admin panel feature.

## Required Changes

### 1. Add Role Field to User Model

Add `role` field to your User model/table:

```sql
ALTER TABLE users ADD COLUMN role VARCHAR(50) DEFAULT 'user';
```

### 2. Update Authentication Responses

#### Login/Register Response

Include `role` field in authentication responses:

```json
{
  "success": true,
  "message": "Login successful",
  "user": {
    "id": 1,
    "name": "User Name",
    "email": "user@example.com",
    "role": "admin",  // <-- Add this field
    "email_verified_at": "2024-01-01T00:00:00.000Z",
    "phone": "+1234567890",
    "avatar": "https://example.com/avatar.jpg",
    "created_at": "2024-01-01T00:00:00.000Z",
    "updated_at": "2024-01-01T00:00:00.000Z"
  },
  "token": "jwt-token-here",
  "token_type": "Bearer",
  "expires_in": 3600
}
```

### 3. Implement /api/auth/me Endpoint

Create new endpoint to verify current user:

**Route:** `GET /api/auth/me`

**Authentication:** Required (Bearer token)

**Response:**
```json
{
  "success": true,
  "user": {
    "id": 1,
    "name": "Admin User",
    "email": "sayma@gopipit.com",
    "role": "admin",
    "email_verified_at": "2024-01-01T00:00:00.000Z",
    "phone": "+1234567890",
    "avatar": "https://example.com/avatar.jpg",
    "created_at": "2024-01-01T00:00:00.000Z",
    "updated_at": "2024-01-01T00:00:00.000Z"
  }
}
```

**Error Response (401):**
```json
{
  "success": false,
  "message": "Unauthenticated"
}
```

### 4. Create Admin User Account

Create the admin account for Gopipit:

```sql
INSERT INTO users (name, email, password, role, email_verified_at)
VALUES (
  'Sayma',
  'sayma@gopipit.com',
  -- Hash of 'asdf1234' using your password hashing
  '$2y$10$...',
  'admin',
  NOW()
);
```

Or via your seeder/migration system.

## Implementation Examples

### Laravel Example

#### Migration
```php
Schema::table('users', function (Blueprint $table) {
    $table->string('role')->default('user');
});
```

#### User Model
```php
class User extends Authenticatable
{
    protected $fillable = [
        'name',
        'email',
        'password',
        'role',
        // ... other fields
    ];

    public function isAdmin()
    {
        return $this->role === 'admin';
    }
}
```

#### AuthController - Login
```php
public function login(Request $request)
{
    $credentials = $request->only('email', 'password');
    
    if (!Auth::attempt($credentials)) {
        return response()->json([
            'success' => false,
            'message' => 'Invalid credentials'
        ], 401);
    }

    $user = Auth::user();
    $token = $user->createToken('auth_token')->plainTextToken;

    return response()->json([
        'success' => true,
        'message' => 'Login successful',
        'user' => $user,  // Includes role field
        'token' => $token,
        'token_type' => 'Bearer'
    ]);
}
```

#### AuthController - Me Endpoint
```php
public function me(Request $request)
{
    return response()->json([
        'success' => true,
        'user' => $request->user()  // Returns authenticated user with role
    ]);
}
```

#### Routes
```php
Route::middleware('auth:sanctum')->group(function () {
    Route::get('/auth/me', [AuthController::class, 'me']);
});
```

### Node.js/Express Example

#### User Schema (Mongoose)
```javascript
const userSchema = new mongoose.Schema({
  name: String,
  email: { type: String, unique: true },
  password: String,
  role: { type: String, default: 'user' },
  emailVerifiedAt: Date,
  phone: String,
  avatar: String,
}, { timestamps: true });

userSchema.methods.isAdmin = function() {
  return this.role === 'admin';
};
```

#### Auth Routes
```javascript
router.get('/auth/me', authenticateToken, async (req, res) => {
  try {
    const user = await User.findById(req.userId).select('-password');
    res.json({
      success: true,
      user: user
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Server error'
    });
  }
});
```

## Testing

### Test /api/auth/me Endpoint

```bash
# Login first to get token
curl -X POST https://gig.com.bd/gig-main/backend/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "sayma@gopipit.com",
    "password": "asdf1234"
  }'

# Use returned token to test /auth/me
curl -X GET https://gig.com.bd/gig-main/backend/api/auth/me \
  -H "Authorization: Bearer YOUR_TOKEN_HERE"
```

### Expected Behavior

1. **Admin User Login**
   - Response includes `role: "admin"`
   - Token allows access to admin endpoints

2. **/auth/me Endpoint**
   - Returns current user data
   - Includes role field
   - Returns 401 if token invalid/expired

3. **Regular User Login**
   - Response includes `role: "user"`
   - Cannot access admin-only endpoints

## Security Considerations

### 1. Role Assignment
- Only allow admin users to change roles
- Validate role values (e.g., 'admin', 'user')
- Don't allow users to set their own role

### 2. Admin Endpoints
- Protect with middleware checking `role === 'admin'`
- Example middleware:

```php
public function handle($request, Closure $next)
{
    if (!$request->user() || $request->user()->role !== 'admin') {
        return response()->json([
            'success' => false,
            'message' => 'Unauthorized. Admin access required.'
        ], 403);
    }
    return $next($request);
}
```

### 3. Token Security
- Use short-lived tokens
- Implement token refresh mechanism
- Revoke tokens on logout

## Admin API Endpoints (Future)

These endpoints will be called by the admin panel:

```
GET    /api/admin/users          - List all users
GET    /api/admin/users/:id      - Get user details
PUT    /api/admin/users/:id      - Update user
DELETE /api/admin/users/:id      - Delete user

GET    /api/admin/gigs           - List all gigs
PUT    /api/admin/gigs/:id       - Update gig
DELETE /api/admin/gigs/:id       - Delete gig

GET    /api/admin/orders         - List all orders
GET    /api/admin/orders/:id     - Get order details

GET    /api/admin/stats          - Platform statistics
```

All admin endpoints should:
1. Require authentication
2. Verify admin role
3. Return proper error responses

## Questions?

Contact the frontend team or check the full documentation:
- Frontend: `docs/admin-panel-guide.md`
- GitHub: https://github.com/rclet/hook
