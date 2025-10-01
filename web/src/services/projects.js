import apiClient from './api'

export default {
  // GET /api/projects
  getProjects(params) {
    return apiClient.get('/projects', { params })
  },

  // GET /api/projects/{project}
  getProject(projectId) {
    return apiClient.get(`/projects/${projectId}`)
  },

  // PUT /api/projects/{project}
  updateProject(projectId, projectData) {
    return apiClient.put(`/projects/${projectId}`, projectData)
  },

  // POST /api/projects/{project}/cancel
  cancelProject(projectId) {
    return apiClient.post(`/projects/${projectId}/cancel`)
  },

  // POST /api/projects/{project}/complete
  completeProject(projectId) {
    return apiClient.post(`/projects/${projectId}/complete`)
  },

  // GET /api/projects/{project}/messages
  getProjectMessages(projectId) {
    return apiClient.get(`/projects/${projectId}/messages`)
  },

  // POST /api/projects/{project}/messages
  sendProjectMessage(projectId, messageData) {
    return apiClient.post(`/projects/${projectId}/messages`, messageData)
  },

  // POST /api/projects/{project}/rate
  rateProject(projectId, ratingData) {
    return apiClient.post(`/projects/${projectId}/rate`, ratingData)
  }
}
