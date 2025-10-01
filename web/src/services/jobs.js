import apiClient from './api'

export default {
  // GET /api/jobs
  getJobs(params) {
    return apiClient.get('/jobs', { params })
  },

  // POST /api/jobs
  createJob(jobData) {
    return apiClient.post('/jobs', jobData)
  },

  // GET /api/jobs/search
  searchJobs(params) {
    return apiClient.get('/jobs/search', { params })
  },

  // GET /api/jobs/my-jobs
  getMyJobs(params) {
    return apiClient.get('/jobs/my-jobs', { params })
  },

  // GET /api/jobs/bookmarked
  getBookmarkedJobs(params) {
    return apiClient.get('/jobs/bookmarked', { params })
  },

  // GET /api/jobs/{job}
  getJob(jobId) {
    return apiClient.get(`/jobs/${jobId}`)
  },

  // PUT /api/jobs/{job}
  updateJob(jobId, jobData) {
    return apiClient.put(`/jobs/${jobId}`, jobData)
  },

  // DELETE /api/jobs/{job}
  deleteJob(jobId) {
    return apiClient.delete(`/jobs/${jobId}`)
  },

  // POST /api/jobs/{job}/bookmark
  bookmarkJob(jobId) {
    return apiClient.post(`/jobs/${jobId}/bookmark`)
  },

  // DELETE /api/jobs/{job}/bookmark
  unbookmarkJob(jobId) {
    return apiClient.delete(`/jobs/${jobId}/bookmark`)
  }
}
