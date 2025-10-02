<template>
  <div class="chat-inbox">
    <h1>Conversations</h1>
    <div v-if="loading" class="loading">Loading...</div>
    <div v-else-if="error" class="error">{{ error }}</div>
    <div v-else class="conversations-list">
      <div
        v-for="conversation in conversations"
        :key="conversation.id"
        class="conversation-item"
        @click="openConversation(conversation.id)"
      >
        <div class="conversation-info">
          <h3>{{ conversation.title }}</h3>
          <p>{{ conversation.last_message }}</p>
        </div>
        <div class="conversation-meta">
          <span class="time">{{ conversation.updated_at }}</span>
          <span v-if="conversation.unread_count" class="unread-badge">
            {{ conversation.unread_count }}
          </span>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import chatService from '@/services/chat'

const router = useRouter()
const loading = ref(true)
const error = ref('')
const conversations = ref([])

const fetchConversations = async () => {
  try {
    const response = await chatService.getConversations()
    conversations.value = response.data.data || response.data
  } catch (err) {
    error.value = err.response?.data?.message || 'Failed to load conversations'
  } finally {
    loading.value = false
  }
}

const openConversation = (conversationId) => {
  router.push(`/chat/${conversationId}`)
}

onMounted(() => {
  fetchConversations()
})
</script>

<style scoped>
.chat-inbox {
  padding: 2rem;
}

h1 {
  margin-bottom: 1.5rem;
}

.loading, .error {
  text-align: center;
  padding: 2rem;
}

.conversations-list {
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
}

.conversation-item {
  background: white;
  padding: 1.5rem;
  border-radius: 8px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
  cursor: pointer;
  display: flex;
  justify-content: space-between;
  transition: background 0.2s;
}

.conversation-item:hover {
  background: #f8f8f8;
}

.conversation-info h3 {
  margin: 0 0 0.5rem 0;
}

.conversation-info p {
  margin: 0;
  color: #666;
  font-size: 0.875rem;
}

.conversation-meta {
  display: flex;
  flex-direction: column;
  align-items: flex-end;
  gap: 0.5rem;
}

.time {
  font-size: 0.75rem;
  color: #999;
}

.unread-badge {
  background: #2E7D8F;
  color: white;
  padding: 0.25rem 0.5rem;
  border-radius: 12px;
  font-size: 0.75rem;
}
</style>
