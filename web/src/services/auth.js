import apiClient from './api'

export default {
  // POST /api/auth/login
  login(credentials) {
    return apiClient.post('/auth/login', credentials)
  },

  // POST /api/auth/register
  register(userData) {
    return apiClient.post('/auth/register', userData)
  },

  // POST /api/auth/forgot-password
  forgotPassword(email) {
    return apiClient.post('/auth/forgot-password', { email })
  },

  // POST /api/auth/reset-password
  resetPassword(data) {
    return apiClient.post('/auth/reset-password', data)
  },

  // POST /api/auth/logout
  logout() {
    return apiClient.post('/auth/logout')
  },

  // GET /api/auth/me
  getMe() {
    return apiClient.get('/auth/me')
  },

  // POST /api/auth/refresh
  refresh() {
    return apiClient.post('/auth/refresh')
  },

  // POST /api/auth/verify-email
  verifyEmail(token) {
    return apiClient.post('/auth/verify-email', { token })
  },

  // POST /api/auth/resend-verification
  resendVerification() {
    return apiClient.post('/auth/resend-verification')
  },

  // POST /api/auth/enable-2fa
  enable2FA() {
    return apiClient.post('/auth/enable-2fa')
  },

  // POST /api/auth/disable-2fa
  disable2FA() {
    return apiClient.post('/auth/disable-2fa')
  },

  // POST /api/auth/social-login
  socialLogin(provider, data) {
    return apiClient.post('/auth/social-login', { provider, ...data })
  }
}
