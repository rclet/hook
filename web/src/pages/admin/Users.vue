<template>
  <div class="admin-users">
    <h1>Manage Users</h1>
    <div class="actions">
      <button @click="showCreateModal = true" class="btn-primary">Create User</button>
    </div>
    <div v-if="loading" class="loading">Loading...</div>
    <div v-else-if="error" class="error">{{ error }}</div>
    <div v-else class="users-table">
      <table>
        <thead>
          <tr>
            <th>ID</th>
            <th>Name</th>
            <th>Email</th>
            <th>Role</th>
            <th>Actions</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="user in users" :key="user.id">
            <td>{{ user.id }}</td>
            <td>{{ user.name }}</td>
            <td>{{ user.email }}</td>
            <td>{{ user.role }}</td>
            <td>
              <button @click="editUser(user)" class="btn-small">Edit</button>
              <button @click="deleteUserConfirm(user.id)" class="btn-small btn-danger">Delete</button>
            </td>
          </tr>
        </tbody>
      </table>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import adminService from '@/services/admin'

const loading = ref(true)
const error = ref('')
const users = ref([])
const showCreateModal = ref(false)

const fetchUsers = async () => {
  try {
    const response = await adminService.getUsers()
    users.value = response.data.data || response.data
  } catch (err) {
    error.value = err.response?.data?.message || 'Failed to load users'
  } finally {
    loading.value = false
  }
}

const editUser = (user) => {
  // Navigate to edit page or show edit modal
  console.log('Edit user:', user)
}

const deleteUserConfirm = async (userId) => {
  if (confirm('Are you sure you want to delete this user?')) {
    try {
      await adminService.deleteUser(userId)
      await fetchUsers()
    } catch (err) {
      alert(err.response?.data?.message || 'Failed to delete user')
    }
  }
}

onMounted(() => {
  fetchUsers()
})
</script>

<style scoped>
.admin-users {
  padding: 2rem;
}

h1 {
  margin-bottom: 1rem;
}

.actions {
  margin-bottom: 1.5rem;
}

.btn-primary {
  background: #2E7D8F;
  color: white;
  padding: 0.75rem 1.5rem;
  border: none;
  border-radius: 4px;
  cursor: pointer;
}

.loading, .error {
  text-align: center;
  padding: 2rem;
}

.users-table {
  background: white;
  border-radius: 8px;
  overflow: hidden;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

table {
  width: 100%;
  border-collapse: collapse;
}

th, td {
  padding: 1rem;
  text-align: left;
}

th {
  background: #f5f5f5;
  font-weight: 600;
}

tr:not(:last-child) {
  border-bottom: 1px solid #eee;
}

.btn-small {
  padding: 0.5rem 1rem;
  margin-right: 0.5rem;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  background: #2E7D8F;
  color: white;
}

.btn-danger {
  background: #dc3545;
}
</style>
