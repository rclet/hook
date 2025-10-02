<template>
  <div class="job-detail">
    <div v-if="loading" class="loading">Loading...</div>
    <div v-else-if="error" class="error">{{ error }}</div>
    <div v-else-if="job" class="job-content">
      <h1>{{ job.title }}</h1>
      <div class="job-info">
        <div class="info-item">
          <strong>Budget:</strong> ${{ job.budget }}
        </div>
        <div class="info-item">
          <strong>Category:</strong> {{ job.category }}
        </div>
        <div class="info-item">
          <strong>Posted:</strong> {{ job.created_at }}
        </div>
      </div>
      <div class="job-description">
        <h2>Description</h2>
        <p>{{ job.description }}</p>
      </div>
      <div class="actions">
        <button @click="toggleBookmark" class="btn-bookmark">
          {{ job.is_bookmarked ? 'Remove Bookmark' : 'Bookmark' }}
        </button>
        <router-link :to="`/proposals/new?job=${job.id}`" class="btn-proposal">
          Submit Proposal
        </router-link>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRoute } from 'vue-router'
import jobsService from '@/services/jobs'

const route = useRoute()
const loading = ref(true)
const error = ref('')
const job = ref(null)

const fetchJob = async () => {
  try {
    const response = await jobsService.getJob(route.params.id)
    job.value = response.data
  } catch (err) {
    error.value = err.response?.data?.message || 'Failed to load job'
  } finally {
    loading.value = false
  }
}

const toggleBookmark = async () => {
  try {
    if (job.value.is_bookmarked) {
      await jobsService.unbookmarkJob(job.value.id)
      job.value.is_bookmarked = false
    } else {
      await jobsService.bookmarkJob(job.value.id)
      job.value.is_bookmarked = true
    }
  } catch (err) {
    alert(err.response?.data?.message || 'Failed to update bookmark')
  }
}

onMounted(() => {
  fetchJob()
})
</script>

<style scoped>
.job-detail {
  padding: 2rem;
  max-width: 900px;
  margin: 0 auto;
}

.loading, .error {
  text-align: center;
  padding: 2rem;
}

.job-content {
  background: white;
  padding: 2rem;
  border-radius: 8px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

h1 {
  margin: 0 0 1.5rem 0;
}

.job-info {
  display: flex;
  gap: 2rem;
  margin-bottom: 2rem;
  padding-bottom: 1.5rem;
  border-bottom: 1px solid #eee;
}

.info-item {
  display: flex;
  flex-direction: column;
  gap: 0.25rem;
}

.job-description {
  margin-bottom: 2rem;
}

.job-description h2 {
  margin: 0 0 1rem 0;
}

.actions {
  display: flex;
  gap: 1rem;
}

.btn-bookmark, .btn-proposal {
  padding: 0.75rem 1.5rem;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  text-decoration: none;
  display: inline-block;
}

.btn-bookmark {
  background: #f0f0f0;
  color: #333;
}

.btn-proposal {
  background: #2E7D8F;
  color: white;
}
</style>
