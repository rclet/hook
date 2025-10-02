<template>
  <div class="project-detail">
    <div v-if="loading" class="loading">Loading...</div>
    <div v-else-if="error" class="error">{{ error }}</div>
    <div v-else-if="project" class="project-content">
      <h1>{{ project.title }}</h1>
      <div class="project-info">
        <div class="info-item">
          <strong>Status:</strong>
          <span class="status" :class="project.status">{{ project.status }}</span>
        </div>
        <div class="info-item">
          <strong>Budget:</strong> ${{ project.budget }}
        </div>
        <div class="info-item">
          <strong>Deadline:</strong> {{ project.deadline }}
        </div>
      </div>
      <div class="project-description">
        <h2>Description</h2>
        <p>{{ project.description }}</p>
      </div>
      <div class="actions">
        <button
          v-if="project.status === 'in_progress'"
          @click="completeProjectConfirm"
          class="btn-complete"
        >
          Mark as Complete
        </button>
        <button
          v-if="project.status === 'in_progress'"
          @click="cancelProjectConfirm"
          class="btn-cancel"
        >
          Cancel Project
        </button>
        <router-link :to="`/projects/${project.id}/messages`" class="btn-messages">
          View Messages
        </router-link>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRoute } from 'vue-router'
import projectsService from '@/services/projects'

const route = useRoute()
const loading = ref(true)
const error = ref('')
const project = ref(null)

const fetchProject = async () => {
  try {
    const response = await projectsService.getProject(route.params.id)
    project.value = response.data
  } catch (err) {
    error.value = err.response?.data?.message || 'Failed to load project'
  } finally {
    loading.value = false
  }
}

const completeProjectConfirm = async () => {
  if (confirm('Are you sure you want to mark this project as complete?')) {
    try {
      await projectsService.completeProject(project.value.id)
      await fetchProject()
    } catch (err) {
      alert(err.response?.data?.message || 'Failed to complete project')
    }
  }
}

const cancelProjectConfirm = async () => {
  if (confirm('Are you sure you want to cancel this project?')) {
    try {
      await projectsService.cancelProject(project.value.id)
      await fetchProject()
    } catch (err) {
      alert(err.response?.data?.message || 'Failed to cancel project')
    }
  }
}

onMounted(() => {
  fetchProject()
})
</script>

<style scoped>
.project-detail {
  padding: 2rem;
  max-width: 900px;
  margin: 0 auto;
}

.loading, .error {
  text-align: center;
  padding: 2rem;
}

.project-content {
  background: white;
  padding: 2rem;
  border-radius: 8px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

h1 {
  margin: 0 0 1.5rem 0;
}

.project-info {
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

.status {
  padding: 0.25rem 0.75rem;
  border-radius: 4px;
  font-size: 0.875rem;
}

.status.in_progress {
  background: #fff3cd;
  color: #856404;
}

.status.completed {
  background: #d4edda;
  color: #155724;
}

.status.cancelled {
  background: #f8d7da;
  color: #721c24;
}

.project-description {
  margin-bottom: 2rem;
}

.project-description h2 {
  margin: 0 0 1rem 0;
}

.actions {
  display: flex;
  gap: 1rem;
}

.actions button,
.actions a {
  padding: 0.75rem 1.5rem;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  text-decoration: none;
  display: inline-block;
}

.btn-complete {
  background: #28a745;
  color: white;
}

.btn-cancel {
  background: #dc3545;
  color: white;
}

.btn-messages {
  background: #2E7D8F;
  color: white;
}
</style>
