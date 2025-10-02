import apiClient from './api'

export default {
  // GET /api/users/dashboard
  getDashboard() {
    return apiClient.get('/users/dashboard')
  },

  // GET /api/users/profile
  getProfile() {
    return apiClient.get('/users/profile')
  },

  // PUT /api/users/profile
  updateProfile(profileData) {
    return apiClient.put('/users/profile', profileData)
  },

  // POST /api/users/avatar
  uploadAvatar(formData) {
    return apiClient.post('/users/avatar', formData, {
      headers: {
        'Content-Type': 'multipart/form-data'
      }
    })
  },

  // GET /api/users/analytics
  getAnalytics() {
    return apiClient.get('/users/analytics')
  }
}
