<template>
  <div class="new-proposal">
    <h1>Submit Proposal</h1>
    <form @submit.prevent="handleSubmit">
      <div class="form-group">
        <label for="job">Job</label>
        <input
          id="job"
          v-model="form.job_id"
          type="text"
          required
          readonly
        />
      </div>
      <div class="form-group">
        <label for="cover_letter">Cover Letter</label>
        <textarea
          id="cover_letter"
          v-model="form.cover_letter"
          required
          rows="6"
          placeholder="Explain why you're the best fit for this job..."
        ></textarea>
      </div>
      <div class="form-group">
        <label for="budget">Your Budget ($)</label>
        <input
          id="budget"
          v-model="form.budget"
          type="number"
          required
          min="0"
          step="0.01"
        />
      </div>
      <div class="form-group">
        <label for="delivery_time">Delivery Time (days)</label>
        <input
          id="delivery_time"
          v-model="form.delivery_time"
          type="number"
          required
          min="1"
        />
      </div>
      <div v-if="error" class="error-message">{{ error }}</div>
      <div v-if="success" class="success-message">{{ success }}</div>
      <button type="submit" :disabled="loading">
        {{ loading ? 'Submitting...' : 'Submit Proposal' }}
      </button>
    </form>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import proposalsService from '@/services/proposals'

const route = useRoute()
const router = useRouter()
const form = ref({
  job_id: route.query.job || '',
  cover_letter: '',
  budget: '',
  delivery_time: ''
})
const loading = ref(false)
const error = ref('')
const success = ref('')

const handleSubmit = async () => {
  loading.value = true
  error.value = ''
  success.value = ''
  
  try {
    await proposalsService.createProposal(form.value)
    success.value = 'Proposal submitted successfully!'
    setTimeout(() => {
      router.push('/proposals/my-proposals')
    }, 2000)
  } catch (err) {
    error.value = err.response?.data?.message || 'Failed to submit proposal'
  } finally {
    loading.value = false
  }
}
</script>

<style scoped>
.new-proposal {
  padding: 2rem;
  max-width: 700px;
  margin: 0 auto;
}

h1 {
  margin-bottom: 1.5rem;
}

form {
  background: white;
  padding: 2rem;
  border-radius: 8px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.form-group {
  margin-bottom: 1.5rem;
}

label {
  display: block;
  margin-bottom: 0.5rem;
  font-weight: 500;
}

input, textarea {
  width: 100%;
  padding: 0.75rem;
  border: 1px solid #ddd;
  border-radius: 4px;
  font-size: 1rem;
  font-family: inherit;
}

button {
  width: 100%;
  padding: 0.75rem;
  background: #2E7D8F;
  color: white;
  border: none;
  border-radius: 4px;
  font-size: 1rem;
  cursor: pointer;
}

button:disabled {
  opacity: 0.6;
  cursor: not-allowed;
}

.error-message {
  color: red;
  margin-bottom: 1rem;
}

.success-message {
  color: green;
  margin-bottom: 1rem;
}
</style>
