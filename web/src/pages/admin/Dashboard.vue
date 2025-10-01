<template>
  <div class="admin-dashboard">
    <h1>Admin Dashboard</h1>
    <div v-if="loading" class="loading">Loading...</div>
    <div v-else-if="error" class="error">{{ error }}</div>
    <div v-else class="dashboard-content">
      <div class="stats-grid">
        <div class="stat-card">
          <h3>Total Users</h3>
          <p class="stat-value">{{ dashboardData?.total_users || 0 }}</p>
        </div>
        <div class="stat-card">
          <h3>Total Jobs</h3>
          <p class="stat-value">{{ dashboardData?.total_jobs || 0 }}</p>
        </div>
        <div class="stat-card">
          <h3>Active Projects</h3>
          <p class="stat-value">{{ dashboardData?.active_projects || 0 }}</p>
        </div>
        <div class="stat-card">
          <h3>Revenue</h3>
          <p class="stat-value">${{ dashboardData?.revenue || 0 }}</p>
        </div>
      </div>
      <div class="navigation-cards">
        <router-link to="/admin/users" class="nav-card">Manage Users</router-link>
        <router-link to="/admin/categories" class="nav-card">Manage Categories</router-link>
        <router-link to="/admin/reports" class="nav-card">View Reports</router-link>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import adminService from '@/services/admin'

const loading = ref(true)
const error = ref('')
const dashboardData = ref(null)

const fetchDashboard = async () => {
  try {
    const response = await adminService.getDashboard()
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
.admin-dashboard {
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

.navigation-cards {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
  gap: 1rem;
}

.nav-card {
  background: #2E7D8F;
  color: white;
  padding: 1.5rem;
  border-radius: 8px;
  text-align: center;
  text-decoration: none;
  transition: background 0.3s;
}

.nav-card:hover {
  background: #5FB3C6;
}
</style>
