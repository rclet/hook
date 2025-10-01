import apiClient from './api'

export default {
  // GET /api/admin/dashboard
  getDashboard() {
    return apiClient.get('/admin/dashboard')
  },

  // GET /api/admin/analytics
  getAnalytics() {
    return apiClient.get('/admin/analytics')
  },

  // GET /api/admin/reports
  getReports() {
    return apiClient.get('/admin/reports')
  },

  // GET /api/admin/users
  getUsers(params) {
    return apiClient.get('/admin/users', { params })
  },

  // POST /api/admin/users
  createUser(userData) {
    return apiClient.post('/admin/users', userData)
  },

  // GET /api/admin/users/{user}
  getUser(userId) {
    return apiClient.get(`/admin/users/${userId}`)
  },

  // PUT /api/admin/users/{user}
  updateUser(userId, userData) {
    return apiClient.put(`/admin/users/${userId}`, userData)
  },

  // DELETE /api/admin/users/{user}
  deleteUser(userId) {
    return apiClient.delete(`/admin/users/${userId}`)
  },

  // GET /api/admin/categories
  getCategories(params) {
    return apiClient.get('/admin/categories', { params })
  },

  // POST /api/admin/categories
  createCategory(categoryData) {
    return apiClient.post('/admin/categories', categoryData)
  },

  // GET /api/admin/categories/{category}
  getCategory(categoryId) {
    return apiClient.get(`/admin/categories/${categoryId}`)
  },

  // PUT /api/admin/categories/{category}
  updateCategory(categoryId, categoryData) {
    return apiClient.put(`/admin/categories/${categoryId}`, categoryData)
  },

  // DELETE /api/admin/categories/{category}
  deleteCategory(categoryId) {
    return apiClient.delete(`/admin/categories/${categoryId}`)
  }
}
