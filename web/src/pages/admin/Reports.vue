<template>
  <div class="admin-reports">
    <h1>Reports</h1>
    <div v-if="loading" class="loading">Loading...</div>
    <div v-else-if="error" class="error">{{ error }}</div>
    <div v-else class="reports-content">
      <div class="report-section">
        <h2>System Reports</h2>
        <p>View and download system reports</p>
        <div class="report-list">
          <div v-for="report in reports" :key="report.id" class="report-item">
            <span>{{ report.name }}</span>
            <button @click="downloadReport(report.id)">Download</button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import adminService from '@/services/admin'

const loading = ref(true)
const error = ref('')
const reports = ref([])

const fetchReports = async () => {
  try {
    const response = await adminService.getReports()
    reports.value = response.data.data || response.data
  } catch (err) {
    error.value = err.response?.data?.message || 'Failed to load reports'
  } finally {
    loading.value = false
  }
}

const downloadReport = (reportId) => {
  console.log('Download report:', reportId)
}

onMounted(() => {
  fetchReports()
})
</script>

<style scoped>
.admin-reports {
  padding: 2rem;
}

h1 {
  margin-bottom: 2rem;
}

.loading, .error {
  text-align: center;
  padding: 2rem;
}

.report-section {
  background: white;
  padding: 2rem;
  border-radius: 8px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.report-section h2 {
  margin: 0 0 0.5rem 0;
}

.report-list {
  margin-top: 1.5rem;
}

.report-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 1rem;
  border: 1px solid #eee;
  border-radius: 4px;
  margin-bottom: 0.5rem;
}

.report-item button {
  background: #2E7D8F;
  color: white;
  padding: 0.5rem 1rem;
  border: none;
  border-radius: 4px;
  cursor: pointer;
}
</style>
