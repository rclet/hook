<template>
  <div class="forgot-password-page">
    <div class="forgot-password-container">
      <h1>Forgot Password</h1>
      <form @submit.prevent="handleForgotPassword">
        <div class="form-group">
          <label for="email">Email</label>
          <input
            id="email"
            v-model="email"
            type="email"
            required
            placeholder="Enter your email"
          />
        </div>
        <div v-if="error" class="error-message">{{ error }}</div>
        <div v-if="success" class="success-message">{{ success }}</div>
        <button type="submit" :disabled="loading">
          {{ loading ? 'Sending...' : 'Send Reset Link' }}
        </button>
      </form>
      <div class="links">
        <router-link to="/auth/login">Back to Login</router-link>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import authService from '@/services/auth'

const email = ref('')
const loading = ref(false)
const error = ref('')
const success = ref('')

const handleForgotPassword = async () => {
  loading.value = true
  error.value = ''
  success.value = ''
  
  try {
    await authService.forgotPassword(email.value)
    success.value = 'Password reset link sent to your email!'
  } catch (err) {
    error.value = err.response?.data?.message || 'Failed to send reset link'
  } finally {
    loading.value = false
  }
}
</script>

<style scoped>
.forgot-password-page {
  display: flex;
  justify-content: center;
  align-items: center;
  min-height: 100vh;
  background: #f5f5f5;
}

.forgot-password-container {
  background: white;
  padding: 2rem;
  border-radius: 8px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
  width: 100%;
  max-width: 400px;
}

h1 {
  margin-bottom: 1.5rem;
  text-align: center;
}

.form-group {
  margin-bottom: 1rem;
}

label {
  display: block;
  margin-bottom: 0.5rem;
  font-weight: 500;
}

input {
  width: 100%;
  padding: 0.75rem;
  border: 1px solid #ddd;
  border-radius: 4px;
  font-size: 1rem;
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
  margin-top: 1rem;
}

button:disabled {
  opacity: 0.6;
  cursor: not-allowed;
}

.error-message {
  color: red;
  margin-top: 0.5rem;
}

.success-message {
  color: green;
  margin-top: 0.5rem;
}

.links {
  margin-top: 1rem;
  text-align: center;
}

.links a {
  color: #2E7D8F;
  text-decoration: none;
}
</style>
