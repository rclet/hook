<template>
  <div class="my-jobs">
    <h1>My Jobs</h1>
    <div class="actions">
      <router-link to="/jobs/create" class="btn-primary">Post New Job</router-link>
    </div>
    <div v-if="loading" class="loading">Loading...</div>
    <div v-else-if="error" class="error">{{ error }}</div>
    <div v-else class="jobs-list">
      <div v-for="job in jobs" :key="job.id" class="job-item">
        <div class="job-header">
          <h3>{{ job.title }}</h3>
          <span class="status" :class="job.status">{{ job.status }}</span>
        </div>
        <p>{{ job.description }}</p>
        <div class="job-footer">
          <span class="budget">${{ job.budget }}</span>
          <div class="actions">
            <router-link :to="`/jobs/${job.id}`" class="btn-small">View</router-link>
            <button @click="editJob(job.id)" class="btn-small">Edit</button>
            <button @click="deleteJobConfirm(job.id)" class="btn-small btn-danger">Delete</button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import jobsService from '@/services/jobs'

const loading = ref(true)
const error = ref('')
const jobs = ref([])

const fetchMyJobs = async () => {
  try {
    const response = await jobsService.getMyJobs()
    jobs.value = response.data.data || response.data
  } catch (err) {
    error.value = err.response?.data?.message || 'Failed to load jobs'
  } finally {
    loading.value = false
  }
}

const editJob = (jobId) => {
  console.log('Edit job:', jobId)
}

const deleteJobConfirm = async (jobId) => {
  if (confirm('Are you sure you want to delete this job?')) {
    try {
      await jobsService.deleteJob(jobId)
      await fetchMyJobs()
    } catch (err) {
      alert(err.response?.data?.message || 'Failed to delete job')
    }
  }
}

onMounted(() => {
  fetchMyJobs()
})
</script>

<style scoped>
.my-jobs {
  padding: 2rem;
}

h1 {
  margin-bottom: 1rem;
}

.actions {
  margin-bottom: 1.5rem;
}

.btn-primary {
  display: inline-block;
  background: #2E7D8F;
  color: white;
  padding: 0.75rem 1.5rem;
  border-radius: 4px;
  text-decoration: none;
}

.loading, .error {
  text-align: center;
  padding: 2rem;
}

.jobs-list {
  display: flex;
  flex-direction: column;
  gap: 1rem;
}

.job-item {
  background: white;
  padding: 1.5rem;
  border-radius: 8px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.job-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 0.5rem;
}

.job-header h3 {
  margin: 0;
}

.status {
  padding: 0.25rem 0.75rem;
  border-radius: 4px;
  font-size: 0.875rem;
  font-weight: 500;
}

.status.open {
  background: #d4edda;
  color: #155724;
}

.status.closed {
  background: #f8d7da;
  color: #721c24;
}

.job-item p {
  margin: 0 0 1rem 0;
  color: #666;
}

.job-footer {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.budget {
  font-weight: bold;
  color: #2E7D8F;
}

.job-footer .actions {
  display: flex;
  gap: 0.5rem;
}

.btn-small {
  padding: 0.5rem 1rem;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  background: #2E7D8F;
  color: white;
  text-decoration: none;
  display: inline-block;
}

.btn-danger {
  background: #dc3545;
}
</style>
