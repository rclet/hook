<template>
  <div class="user-dashboard">
    <h1>Dashboard</h1>
    <div v-if="loading" class="loading">Loading...</div>
    <div v-else-if="error" class="error">{{ error }}</div>
    <div v-else class="dashboard-content">
      <div class="stats-grid">
        <div class="stat-card">
          <h3>Active Jobs</h3>
          <p class="stat-value">{{ dashboardData?.active_jobs || 0 }}</p>
        </div>
        <div class="stat-card">
          <h3>Proposals Sent</h3>
          <p class="stat-value">{{ dashboardData?.proposals_sent || 0 }}</p>
        </div>
        <div class="stat-card">
          <h3>Active Projects</h3>
          <p class="stat-value">{{ dashboardData?.active_projects || 0 }}</p>
        </div>
        <div class="stat-card">
          <h3>Total Earnings</h3>
          <p class="stat-value">${{ dashboardData?.total_earnings || 0 }}</p>
        </div>
      </div>
      <div class="quick-actions">
        <h2>Quick Actions</h2>
        <div class="actions-grid">
          <router-link to="/jobs/search" class="action-card">Search Jobs</router-link>
          <router-link to="/jobs/my-jobs" class="action-card">My Jobs</router-link>
          <router-link to="/proposals/my-proposals" class="action-card">My Proposals</router-link>
          <router-link to="/chat/inbox" class="action-card">Messages</router-link>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import usersService from '@/services/users'

const loading = ref(true)
const error = ref('')
const dashboardData = ref(null)

const fetchDashboard = async () => {
  try {
    const response = await usersService.getDashboard()
    dashboardData.value = response.data
  } catch (err) {
    error.value = err.response?.data?.message || 'Failed to load dashboard'
  } finally {
    loading.value = false
  }
}

onMounted(() => {
  fetchDashboard()
})
</script>

<style scoped>
.user-dashboard {
  padding: 2rem;
}

h1 {
  margin-bottom: 2rem;
}

.loading, .error {
  text-align: center;
  padding: 2rem;
}

.stats-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
  gap: 1rem;
  margin-bottom: 2rem;
}

.stat-card {
  background: white;
  padding: 1.5rem;
  border-radius: 8px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.stat-card h3 {
  margin: 0 0 0.5rem 0;
  font-size: 0.875rem;
  color: #666;
}

.stat-value {
  margin: 0;
  font-size: 2rem;
  font-weight: bold;
  color: #2E7D8F;
}

.quick-actions {
  background: white;
  padding: 2rem;
  border-radius: 8px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.quick-actions h2 {
  margin: 0 0 1.5rem 0;
}

.actions-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
  gap: 1rem;
}

.action-card {
  background: #2E7D8F;
  color: white;
  padding: 1.5rem;
  border-radius: 8px;
  text-align: center;
  text-decoration: none;
  transition: background 0.3s;
}

.action-card:hover {
  background: #5FB3C6;
}
</style>
