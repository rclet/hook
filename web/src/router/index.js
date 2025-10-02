import { createRouter, createWebHistory } from 'vue-router'

// Auth
import Login from '@/pages/auth/Login.vue'
import Register from '@/pages/auth/Register.vue'
import ForgotPassword from '@/pages/auth/ForgotPassword.vue'

// Admin
import AdminDashboard from '@/pages/admin/Dashboard.vue'
import AdminUsers from '@/pages/admin/Users.vue'
import AdminCategories from '@/pages/admin/Categories.vue'
import AdminReports from '@/pages/admin/Reports.vue'

// Jobs
import JobsSearch from '@/pages/jobs/Search.vue'
import JobDetail from '@/pages/jobs/JobDetail.vue'
import MyJobs from '@/pages/jobs/MyJobs.vue'

// Chat
import ChatInbox from '@/pages/chat/Inbox.vue'
import Conversation from '@/pages/chat/Conversation.vue'

// Projects
import ProjectDetail from '@/pages/projects/ProjectDetail.vue'
import ProjectMessages from '@/pages/projects/Messages.vue'

// Proposals
import NewProposal from '@/pages/proposals/NewProposal.vue'
import MyProposals from '@/pages/proposals/MyProposals.vue'

// Users
import UserProfile from '@/pages/users/Profile.vue'
import UserDashboard from '@/pages/users/Dashboard.vue'

// Notifications
import NotificationsList from '@/pages/notifications/List.vue'

const router = createRouter({
  history: createWebHistory(),
  routes: [
    {
      path: '/',
      redirect: '/auth/login'
    },
    // Auth routes
    {
      path: '/auth/login',
      name: 'Login',
      component: Login
    },
    {
      path: '/auth/register',
      name: 'Register',
      component: Register
    },
    {
      path: '/auth/forgot-password',
      name: 'ForgotPassword',
      component: ForgotPassword
    },
    // Admin routes
    {
      path: '/admin/dashboard',
      name: 'AdminDashboard',
      component: AdminDashboard,
      meta: { requiresAuth: true, requiresAdmin: true }
    },
    {
      path: '/admin/users',
      name: 'AdminUsers',
      component: AdminUsers,
      meta: { requiresAuth: true, requiresAdmin: true }
    },
    {
      path: '/admin/categories',
      name: 'AdminCategories',
      component: AdminCategories,
      meta: { requiresAuth: true, requiresAdmin: true }
    },
    {
      path: '/admin/reports',
      name: 'AdminReports',
      component: AdminReports,
      meta: { requiresAuth: true, requiresAdmin: true }
    },
    // Jobs routes
    {
      path: '/jobs/search',
      name: 'JobsSearch',
      component: JobsSearch
    },
    {
      path: '/jobs/:id',
      name: 'JobDetail',
      component: JobDetail
    },
    {
      path: '/jobs/my-jobs',
      name: 'MyJobs',
      component: MyJobs,
      meta: { requiresAuth: true }
    },
    // Chat routes
    {
      path: '/chat/inbox',
      name: 'ChatInbox',
      component: ChatInbox,
      meta: { requiresAuth: true }
    },
    {
      path: '/chat/:id',
      name: 'Conversation',
      component: Conversation,
      meta: { requiresAuth: true }
    },
    // Projects routes
    {
      path: '/projects/:id',
      name: 'ProjectDetail',
      component: ProjectDetail,
      meta: { requiresAuth: true }
    },
    {
      path: '/projects/:id/messages',
      name: 'ProjectMessages',
      component: ProjectMessages,
      meta: { requiresAuth: true }
    },
    // Proposals routes
    {
      path: '/proposals/new',
      name: 'NewProposal',
      component: NewProposal,
      meta: { requiresAuth: true }
    },
    {
      path: '/proposals/my-proposals',
      name: 'MyProposals',
      component: MyProposals,
      meta: { requiresAuth: true }
    },
    // Users routes
    {
      path: '/users/profile',
      name: 'UserProfile',
      component: UserProfile,
      meta: { requiresAuth: true }
    },
    {
      path: '/users/dashboard',
      name: 'UserDashboard',
      component: UserDashboard,
      meta: { requiresAuth: true }
    },
    // Notifications routes
    {
      path: '/notifications',
      name: 'Notifications',
      component: NotificationsList,
      meta: { requiresAuth: true }
    }
  ]
})

// Navigation guard
router.beforeEach((to, from, next) => {
  const token = localStorage.getItem('auth_token')
  
  if (to.meta.requiresAuth && !token) {
    next('/auth/login')
  } else {
    next()
  }
})

export default router
