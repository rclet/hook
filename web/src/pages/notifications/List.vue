<template>
  <div class="notifications">
    <div class="notifications-header">
      <h1>Notifications</h1>
      <button @click="markAllAsReadConfirm" class="btn-mark-all">Mark All as Read</button>
    </div>
    <div v-if="loading" class="loading">Loading...</div>
    <div v-else-if="error" class="error">{{ error }}</div>
    <div v-else class="notifications-list">
      <div
        v-for="notification in notifications"
        :key="notification.id"
        class="notification-item"
        :class="{ unread: !notification.read }"
      >
        <div class="notification-content">
          <h3>{{ notification.title }}</h3>
          <p>{{ notification.message }}</p>
          <span class="time">{{ notification.created_at }}</span>
        </div>
        <div class="notification-actions">
          <button
            v-if="!notification.read"
            @click="markAsRead(notification.id)"
            class="btn-small"
          >
            Mark as Read
          </button>
          <button
            @click="deleteNotificationConfirm(notification.id)"
            class="btn-small btn-danger"
          >
            Delete
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import notificationsService from '@/services/notifications'

const loading = ref(true)
const error = ref('')
const notifications = ref([])

const fetchNotifications = async () => {
  try {
    const response = await notificationsService.getNotifications()
    notifications.value = response.data.data || response.data
  } catch (err) {
    error.value = err.response?.data?.message || 'Failed to load notifications'
  } finally {
    loading.value = false
  }
}

const markAsRead = async (notificationId) => {
  try {
    await notificationsService.markAsRead(notificationId)
    await fetchNotifications()
  } catch (err) {
    alert(err.response?.data?.message || 'Failed to mark as read')
  }
}

const markAllAsReadConfirm = async () => {
  if (confirm('Mark all notifications as read?')) {
    try {
      await notificationsService.markAllAsRead()
      await fetchNotifications()
    } catch (err) {
      alert(err.response?.data?.message || 'Failed to mark all as read')
    }
  }
}

const deleteNotificationConfirm = async (notificationId) => {
  if (confirm('Are you sure you want to delete this notification?')) {
    try {
      await notificationsService.deleteNotification(notificationId)
      await fetchNotifications()
    } catch (err) {
      alert(err.response?.data?.message || 'Failed to delete notification')
    }
  }
}

onMounted(() => {
  fetchNotifications()
})
</script>

<style scoped>
.notifications {
  padding: 2rem;
}

.notifications-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 1.5rem;
}

h1 {
  margin: 0;
}

.btn-mark-all {
  padding: 0.75rem 1.5rem;
  background: #2E7D8F;
  color: white;
  border: none;
  border-radius: 4px;
  cursor: pointer;
}

.loading, .error {
  text-align: center;
  padding: 2rem;
}

.notifications-list {
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
}

.notification-item {
  background: white;
  padding: 1.5rem;
  border-radius: 8px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
}

.notification-item.unread {
  border-left: 4px solid #2E7D8F;
  background: #f8f9fa;
}

.notification-content {
  flex: 1;
}

.notification-content h3 {
  margin: 0 0 0.5rem 0;
}

.notification-content p {
  margin: 0 0 0.5rem 0;
  color: #666;
}

.time {
  font-size: 0.75rem;
  color: #999;
}

.notification-actions {
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
  white-space: nowrap;
}

.btn-danger {
  background: #dc3545;
}
</style>
