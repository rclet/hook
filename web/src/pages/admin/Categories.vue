<template>
  <div class="admin-categories">
    <h1>Manage Categories</h1>
    <div class="actions">
      <button @click="showCreateModal = true" class="btn-primary">Create Category</button>
    </div>
    <div v-if="loading" class="loading">Loading...</div>
    <div v-else-if="error" class="error">{{ error }}</div>
    <div v-else class="categories-grid">
      <div v-for="category in categories" :key="category.id" class="category-card">
        <h3>{{ category.name }}</h3>
        <p>{{ category.description }}</p>
        <div class="card-actions">
          <button @click="editCategory(category)" class="btn-small">Edit</button>
          <button @click="deleteCategoryConfirm(category.id)" class="btn-small btn-danger">Delete</button>
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
const categories = ref([])
const showCreateModal = ref(false)

const fetchCategories = async () => {
  try {
    const response = await adminService.getCategories()
    categories.value = response.data.data || response.data
  } catch (err) {
    error.value = err.response?.data?.message || 'Failed to load categories'
  } finally {
    loading.value = false
  }
}

const editCategory = (category) => {
  console.log('Edit category:', category)
}

const deleteCategoryConfirm = async (categoryId) => {
  if (confirm('Are you sure you want to delete this category?')) {
    try {
      await adminService.deleteCategory(categoryId)
      await fetchCategories()
    } catch (err) {
      alert(err.response?.data?.message || 'Failed to delete category')
    }
  }
}

onMounted(() => {
  fetchCategories()
})
</script>

<style scoped>
.admin-categories {
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

.categories-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
  gap: 1rem;
}

.category-card {
  background: white;
  padding: 1.5rem;
  border-radius: 8px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.category-card h3 {
  margin: 0 0 0.5rem 0;
}

.category-card p {
  margin: 0 0 1rem 0;
  color: #666;
}

.card-actions {
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
}

.btn-danger {
  background: #dc3545;
}
</style>
