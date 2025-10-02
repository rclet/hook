<template>
  <div class="project-messages">
    <h1>Project Messages</h1>
    <div v-if="loading" class="loading">Loading...</div>
    <div v-else-if="error" class="error">{{ error }}</div>
    <div v-else class="messages-container">
      <div class="messages-list" ref="messagesList">
        <div
          v-for="message in messages"
          :key="message.id"
          class="message"
          :class="{ 'own-message': message.is_own }"
        >
          <div class="message-author">{{ message.author }}</div>
          <div class="message-content">{{ message.content }}</div>
          <div class="message-time">{{ message.created_at }}</div>
        </div>
      </div>
      <div class="message-input">
        <textarea
          v-model="newMessage"
          placeholder="Type your message..."
          @keydown.enter.prevent="sendMessage"
        ></textarea>
        <button @click="sendMessage" :disabled="!newMessage.trim()">Send</button>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, nextTick } from 'vue'
import { useRoute } from 'vue-router'
import projectsService from '@/services/projects'

const route = useRoute()
const loading = ref(true)
const error = ref('')
const messages = ref([])
const newMessage = ref('')
const messagesList = ref(null)

const fetchMessages = async () => {
  try {
    const response = await projectsService.getProjectMessages(route.params.id)
    messages.value = response.data.data || response.data
    scrollToBottom()
  } catch (err) {
    error.value = err.response?.data?.message || 'Failed to load messages'
  } finally {
    loading.value = false
  }
}

const sendMessage = async () => {
  if (!newMessage.value.trim()) return
  
  try {
    const response = await projectsService.sendProjectMessage(route.params.id, {
      content: newMessage.value
    })
    messages.value.push(response.data)
    newMessage.value = ''
    await nextTick()
    scrollToBottom()
  } catch (err) {
    alert(err.response?.data?.message || 'Failed to send message')
  }
}

const scrollToBottom = () => {
  if (messagesList.value) {
    messagesList.value.scrollTop = messagesList.value.scrollHeight
  }
}

onMounted(() => {
  fetchMessages()
})
</script>

<style scoped>
.project-messages {
  padding: 2rem;
  height: calc(100vh - 4rem);
}

h1 {
  margin-bottom: 1rem;
}

.loading, .error {
  text-align: center;
  padding: 2rem;
}

.messages-container {
  background: white;
  border-radius: 8px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
  height: calc(100% - 3rem);
  display: flex;
  flex-direction: column;
}

.messages-list {
  flex: 1;
  overflow-y: auto;
  padding: 1.5rem;
  display: flex;
  flex-direction: column;
  gap: 1rem;
}

.message {
  max-width: 70%;
  align-self: flex-start;
}

.own-message {
  align-self: flex-end;
}

.message-author {
  font-size: 0.875rem;
  font-weight: 500;
  margin-bottom: 0.25rem;
}

.message-content {
  background: #f0f0f0;
  padding: 0.75rem 1rem;
  border-radius: 8px;
}

.own-message .message-content {
  background: #2E7D8F;
  color: white;
}

.message-time {
  font-size: 0.75rem;
  color: #999;
  margin-top: 0.25rem;
}

.message-input {
  padding: 1.5rem;
  border-top: 1px solid #eee;
  display: flex;
  gap: 1rem;
}

.message-input textarea {
  flex: 1;
  padding: 0.75rem;
  border: 1px solid #ddd;
  border-radius: 4px;
  resize: none;
  font-family: inherit;
}

.message-input button {
  padding: 0.75rem 1.5rem;
  background: #2E7D8F;
  color: white;
  border: none;
  border-radius: 4px;
  cursor: pointer;
}

.message-input button:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}
</style>
