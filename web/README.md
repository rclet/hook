# Hook Web Frontend

Vue.js 3 frontend for the Hook freelance platform, aligned with the Gig backend API.

## Tech Stack

- **Vue 3** - Progressive JavaScript framework
- **Vue Router** - Official router for Vue.js
- **Pinia** - State management
- **Axios** - HTTP client
- **Vite** - Build tool

## Project Structure

```
web/
├── src/
│   ├── pages/          # Vue components organized by feature
│   │   ├── auth/       # Login, Register, ForgotPassword
│   │   ├── admin/      # Dashboard, Users, Categories, Reports
│   │   ├── jobs/       # Search, JobDetail, MyJobs
│   │   ├── chat/       # Inbox, Conversation
│   │   ├── projects/   # ProjectDetail, Messages
│   │   ├── proposals/  # NewProposal, MyProposals
│   │   ├── users/      # Profile, Dashboard
│   │   └── notifications/ # List
│   ├── services/       # API service wrappers
│   │   ├── api.js      # Base API client with interceptors
│   │   ├── auth.js     # Authentication endpoints
│   │   ├── admin.js    # Admin endpoints
│   │   ├── jobs.js     # Jobs endpoints
│   │   ├── chat.js     # Chat endpoints
│   │   ├── projects.js # Projects endpoints
│   │   ├── proposals.js # Proposals endpoints
│   │   ├── users.js    # Users endpoints
│   │   └── notifications.js # Notifications endpoints
│   ├── router/         # Vue Router configuration
│   ├── App.vue         # Root component
│   └── main.js         # Application entry point
├── .env                # Environment variables
├── .env.example        # Example environment configuration
├── package.json        # Dependencies and scripts
├── vite.config.js      # Vite configuration
└── index.html          # HTML template

## API Endpoints

All services call the exact backend routes from `rclet/gig`:

### Auth (`/api/auth/`)
- POST login, register, logout
- POST forgot-password, reset-password
- POST verify-email, resend-verification
- POST enable-2fa, disable-2fa
- POST social-login
- GET me
- POST refresh

### Admin (`/api/admin/`)
- GET dashboard, analytics, reports
- GET/POST/PUT/DELETE users, categories

### Jobs (`/api/jobs/`)
- GET/POST jobs
- GET search, my-jobs, bookmarked
- GET/PUT/DELETE jobs/{id}
- POST/DELETE jobs/{id}/bookmark

### Chat (`/api/chat/`)
- GET/POST conversations
- GET conversations/{id}
- POST conversations/{id}/messages
- PUT conversations/{id}/read

### Projects (`/api/projects/`)
- GET/PUT projects/{id}
- POST projects/{id}/cancel, complete, rate
- GET/POST projects/{id}/messages

### Proposals (`/api/proposals/`)
- POST proposals
- GET my-proposals, job/{id}
- GET/PUT/DELETE proposals/{id}
- POST proposals/{id}/accept, reject

### Users (`/api/users/`)
- GET dashboard, profile, analytics
- PUT profile
- POST avatar

### Notifications (`/api/notifications/`)
- GET notifications
- POST mark-all-read
- PUT notifications/{id}/read
- DELETE notifications/{id}

## Setup

### Prerequisites

- Node.js 16+ and npm

### Installation

```bash
cd web
npm install
```

### Configuration

Copy `.env.example` to `.env` and configure:

```env
VITE_API_BASE_URL=https://gig.com.bd/gig-main/backend/public/api
VITE_APP_NAME=Hook
VITE_APP_VERSION=1.0.0
```

## Development

```bash
# Start development server
npm run dev

# Build for production
npm run build

# Preview production build
npm run preview

# Lint code
npm run lint
```

The dev server runs at `http://localhost:3000`

## Building

```bash
npm run build
```

Output is in `dist/` directory.

## Deployment

The built files can be deployed to any static hosting service:

1. Build the project: `npm run build`
2. Deploy the `dist/` folder to your hosting provider

## Authentication

Authentication uses JWT tokens stored in localStorage:
- Login endpoint returns a token
- Token is automatically added to all API requests via axios interceptor
- Token is removed on 401 responses and user is redirected to login

## Features

- ✅ Complete authentication flow (login, register, password reset)
- ✅ Admin panel with user and category management
- ✅ Job search and management
- ✅ Real-time chat interface
- ✅ Project management and messaging
- ✅ Proposal submission and tracking
- ✅ User profile and dashboard
- ✅ Notifications center
- ✅ Responsive design
- ✅ Protected routes with navigation guards

## License

MIT
