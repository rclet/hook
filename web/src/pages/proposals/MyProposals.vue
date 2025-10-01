<template>
  <div class="my-proposals">
    <h1>My Proposals</h1>
    <div v-if="loading" class="loading">Loading...</div>
    <div v-else-if="error" class="error">{{ error }}</div>
    <div v-else class="proposals-list">
      <div v-for="proposal in proposals" :key="proposal.id" class="proposal-item">
        <div class="proposal-header">
          <h3>{{ proposal.job_title }}</h3>
          <span class="status" :class="proposal.status">{{ proposal.status }}</span>
        </div>
        <p class="cover-letter">{{ proposal.cover_letter }}</p>
        <div class="proposal-footer">
          <div class="proposal-details">
            <span class="budget">Budget: ${{ proposal.budget }}</span>
            <span class="delivery">Delivery: {{ proposal.delivery_time }} days</span>
          </div>
          <div class="actions">
            <router-link :to="`/proposals/${proposal.id}`" class="btn-small">View</router-link>
            <button
              v-if="proposal.status === 'pending'"
              @click="deleteProposalConfirm(proposal.id)"
              class="btn-small btn-danger"
            >
              Delete
            </button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import proposalsService from '@/services/proposals'

const loading = ref(true)
const error = ref('')
const proposals = ref([])

const fetchProposals = async () => {
  try {
    const response = await proposalsService.getMyProposals()
    proposals.value = response.data.data || response.data
  } catch (err) {
    error.value = err.response?.data?.message || 'Failed to load proposals'
  } finally {
    loading.value = false
  }
}

const deleteProposalConfirm = async (proposalId) => {
  if (confirm('Are you sure you want to delete this proposal?')) {
    try {
      await proposalsService.deleteProposal(proposalId)
      await fetchProposals()
    } catch (err) {
      alert(err.response?.data?.message || 'Failed to delete proposal')
    }
  }
}

onMounted(() => {
  fetchProposals()
})
</script>

<style scoped>
.my-proposals {
  padding: 2rem;
}

h1 {
  margin-bottom: 1.5rem;
}

.loading, .error {
  text-align: center;
  padding: 2rem;
}

.proposals-list {
  display: flex;
  flex-direction: column;
  gap: 1rem;
}

.proposal-item {
  background: white;
  padding: 1.5rem;
  border-radius: 8px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.proposal-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 1rem;
}

.proposal-header h3 {
  margin: 0;
}

.status {
  padding: 0.25rem 0.75rem;
  border-radius: 4px;
  font-size: 0.875rem;
  font-weight: 500;
}

.status.pending {
  background: #fff3cd;
  color: #856404;
}

.status.accepted {
  background: #d4edda;
  color: #155724;
}

.status.rejected {
  background: #f8d7da;
  color: #721c24;
}

.cover-letter {
  margin: 0 0 1rem 0;
  color: #666;
}

.proposal-footer {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.proposal-details {
  display: flex;
  gap: 1.5rem;
  font-size: 0.875rem;
}

.budget {
  font-weight: bold;
  color: #2E7D8F;
}

.actions {
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
