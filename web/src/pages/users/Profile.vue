<template>
  <div class="user-profile">
    <h1>My Profile</h1>
    <div v-if="loading" class="loading">Loading...</div>
    <div v-else-if="error" class="error">{{ error }}</div>
    <div v-else class="profile-content">
      <div class="avatar-section">
        <div class="avatar">
          <img v-if="profile?.avatar" :src="profile.avatar" alt="Avatar" />
          <div v-else class="avatar-placeholder">{{ profile?.name?.charAt(0) }}</div>
        </div>
        <input
          type="file"
          ref="fileInput"
          @change="handleAvatarUpload"
          accept="image/*"
          style="display: none"
        />
        <button @click="$refs.fileInput.click()" class="btn-upload">Change Avatar</button>
      </div>
      <form @submit.prevent="handleUpdate" class="profile-form">
        <div class="form-group">
          <label for="name">Name</label>
          <input
            id="name"
            v-model="form.name"
            type="text"
            required
          />
        </div>
        <div class="form-group">
          <label for="email">Email</label>
          <input
            id="email"
            v-model="form.email"
            type="email"
            required
          />
        </div>
        <div class="form-group">
          <label for="bio">Bio</label>
          <textarea
            id="bio"
            v-model="form.bio"
            rows="4"
            placeholder="Tell us about yourself..."
          ></textarea>
        </div>
        <div v-if="updateError" class="error-message">{{ updateError }}</div>
        <div v-if="success" class="success-message">{{ success }}</div>
        <button type="submit" :disabled="updating">
          {{ updating ? 'Updating...' : 'Update Profile' }}
        </button>
      </form>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import usersService from '@/services/users'

const loading = ref(true)
const error = ref('')
const updateError = ref('')
const success = ref('')
const updating = ref(false)
const profile = ref(null)
const form = ref({
  name: '',
  email: '',
  bio: ''
})
const fileInput = ref(null)

const fetchProfile = async () => {
  try {
    const response = await usersService.getProfile()
    profile.value = response.data
    form.value = {
      name: profile.value.name || '',
      email: profile.value.email || '',
      bio: profile.value.bio || ''
    }
  } catch (err) {
    error.value = err.response?.data?.message || 'Failed to load profile'
  } finally {
    loading.value = false
  }
}

const handleUpdate = async () => {
  updating.value = true
  updateError.value = ''
  success.value = ''
  
  try {
    await usersService.updateProfile(form.value)
    success.value = 'Profile updated successfully!'
    await fetchProfile()
  } catch (err) {
    updateError.value = err.response?.data?.message || 'Failed to update profile'
  } finally {
    updating.value = false
  }
}

const handleAvatarUpload = async (event) => {
  const file = event.target.files[0]
  if (!file) return
  
  const formData = new FormData()
  formData.append('avatar', file)
  
  try {
    await usersService.uploadAvatar(formData)
    await fetchProfile()
    success.value = 'Avatar updated successfully!'
  } catch (err) {
    updateError.value = err.response?.data?.message || 'Failed to upload avatar'
  }
}

onMounted(() => {
  fetchProfile()
})
</script>

<style scoped>
.user-profile {
  padding: 2rem;
  max-width: 700px;
  margin: 0 auto;
}

h1 {
  margin-bottom: 1.5rem;
}

.loading, .error {
  text-align: center;
  padding: 2rem;
}

.profile-content {
  background: white;
  padding: 2rem;
  border-radius: 8px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.avatar-section {
  display: flex;
  flex-direction: column;
  align-items: center;
  margin-bottom: 2rem;
}

.avatar {
  width: 120px;
  height: 120px;
  border-radius: 50%;
  overflow: hidden;
  margin-bottom: 1rem;
}

.avatar img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.avatar-placeholder {
  width: 100%;
  height: 100%;
  background: #2E7D8F;
  color: white;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 3rem;
  font-weight: bold;
}

.btn-upload {
  padding: 0.5rem 1rem;
  background: #f0f0f0;
  border: none;
  border-radius: 4px;
  cursor: pointer;
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

button[type="submit"] {
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
