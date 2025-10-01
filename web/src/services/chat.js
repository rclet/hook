import apiClient from './api'

export default {
  // GET /api/chat/conversations
  getConversations(params) {
    return apiClient.get('/chat/conversations', { params })
  },

  // POST /api/chat/conversations
  createConversation(data) {
    return apiClient.post('/chat/conversations', data)
  },

  // GET /api/chat/conversations/{conversation}
  getConversation(conversationId) {
    return apiClient.get(`/chat/conversations/${conversationId}`)
  },

  // POST /api/chat/conversations/{conversation}/messages
  sendMessage(conversationId, messageData) {
    return apiClient.post(`/chat/conversations/${conversationId}/messages`, messageData)
  },

  // PUT /api/chat/conversations/{conversation}/read
  markAsRead(conversationId) {
    return apiClient.put(`/chat/conversations/${conversationId}/read`)
  }
}
