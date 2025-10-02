<template>
  <div class="jobs-search">
    <h1>Search Jobs</h1>
    <div class="search-bar">
      <input
        v-model="searchQuery"
        type="text"
        placeholder="Search for jobs..."
        @keyup.enter="handleSearch"
      />
      <button @click="handleSearch">Search</button>
    </div>
    <div v-if="loading" class="loading">Loading...</div>
    <div v-else-if="error" class="error">{{ error }}</div>
    <div v-else class="jobs-grid">
      <div v-for="job in jobs" :key="job.id" class="job-card">
        <h3>{{ job.title }}</h3>
        <p>{{ job.description }}</p>
        <div class="job-meta">
          <span class="budget">${{ job.budget }}</span>
          <span class="category">{{ job.category }}</span>
        </div>
        <router-link :to="`/jobs/${job.id}`" class="btn-view">View Details</router-link>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import jobsService from '@/services/jobs'

const searchQuery = ref('')
const loading = ref(false)
const error = ref('')
const jobs = ref([])

const handleSearch = async () => {
  loading.value = true
  error.value = ''
  
  try {
    const response = await jobsService.searchJobs({ q: searchQuery.value })
    jobs.value = response.data.data || response.data
  } catch (err) {
    error.value = err.response?.data?.message || 'Failed to search jobs'
  } finally {
    loading.value = false
  }
}
</script>

<style scoped>
.jobs-search {
  padding: 2rem;
}

h1 {
  margin-bottom: 1.5rem;
}

.search-bar {
  display: flex;
  gap: 1rem;
  margin-bottom: 2rem;
}

.search-bar input {
  flex: 1;
  padding: 0.75rem;
  border: 1px solid #ddd;
  border-radius: 4px;
  font-size: 1rem;
}

.search-bar button {
  padding: 0.75rem 2rem;
  background: #2E7D8F;
  color: white;
  border: none;
  border-radius: 4px;
  cursor: pointer;
}

.loading, .error {
  text-align: center;
  padding: 2rem;
}

.jobs-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
  gap: 1rem;
}

.job-card {
  background: white;
  padding: 1.5rem;
  border-radius: 8px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.job-card h3 {
  margin: 0 0 0.5rem 0;
}

.job-card p {
  margin: 0 0 1rem 0;
  color: #666;
}

.job-meta {
  display: flex;
  justify-content: space-between;
  margin-bottom: 1rem;
}

.budget {
  font-weight: bold;
  color: #2E7D8F;
}

.category {
  background: #f0f0f0;
  padding: 0.25rem 0.5rem;
  border-radius: 4px;
  font-size: 0.875rem;
}

.btn-view {
  display: inline-block;
  background: #2E7D8F;
  color: white;
  padding: 0.5rem 1rem;
  border-radius: 4px;
  text-decoration: none;
}
</style>
