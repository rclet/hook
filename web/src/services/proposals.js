import apiClient from './api'

export default {
  // POST /api/proposals
  createProposal(proposalData) {
    return apiClient.post('/proposals', proposalData)
  },

  // GET /api/proposals/my-proposals
  getMyProposals(params) {
    return apiClient.get('/proposals/my-proposals', { params })
  },

  // GET /api/proposals/job/{job}
  getJobProposals(jobId) {
    return apiClient.get(`/proposals/job/${jobId}`)
  },

  // GET /api/proposals/{proposal}
  getProposal(proposalId) {
    return apiClient.get(`/proposals/${proposalId}`)
  },

  // PUT /api/proposals/{proposal}
  updateProposal(proposalId, proposalData) {
    return apiClient.put(`/proposals/${proposalId}`, proposalData)
  },

  // DELETE /api/proposals/{proposal}
  deleteProposal(proposalId) {
    return apiClient.delete(`/proposals/${proposalId}`)
  },

  // POST /api/proposals/{proposal}/accept
  acceptProposal(proposalId) {
    return apiClient.post(`/proposals/${proposalId}/accept`)
  },

  // POST /api/proposals/{proposal}/reject
  rejectProposal(proposalId) {
    return apiClient.post(`/proposals/${proposalId}/reject`)
  }
}
