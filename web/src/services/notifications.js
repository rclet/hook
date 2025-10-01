import apiClient from './api'

export default {
  // GET /api/notifications
  getNotifications(params) {
    return apiClient.get('/notifications', { params })
  },

  // POST /api/notifications/mark-all-read
  markAllAsRead() {
    return apiClient.post('/notifications/mark-all-read')
  },

  // PUT /api/notifications/{notification}/read
  markAsRead(notificationId) {
    return apiClient.put(`/notifications/${notificationId}/read`)
  },

  // DELETE /api/notifications/{notification}
  deleteNotification(notificationId) {
    return apiClient.delete(`/notifications/${notificationId}`)
  }
}
