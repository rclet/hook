<template>
  <div class="conversation">
    <div v-if="loading" class="loading">Loading...</div>
    <div v-else-if="error" class="error">{{ error }}</div>
    <div v-else class="conversation-container">
      <div class="conversation-header">
        <h2>{{ conversation?.title }}</h2>
      </div>
      <div class="messages-list" ref="messagesList">
        <div
          v-for="message in messages"
          :key="message.id"
          class="message"
          :class="{ 'own-message': message.is_own }"
        >
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
import chatService from '@/services/chat'

const route = useRoute()
const loading = ref(true)
const error = ref('')
const conversation = ref(null)
const messages = ref([])
const newMessage = ref('')
const messagesList = ref(null)

const fetchConversation = async () => {
  try {
    const response = await chatService.getConversation(route.params.id)
    conversation.value = response.data
    messages.value = response.data.messages || []
    await chatService.markAsRead(route.params.id)
    scrollToBottom()
  } catch (err) {
    error.value = err.response?.data?.message || 'Failed to load conversation'
  } finally {
    loading.value = false
  }
}

const sendMessage = async () => {
  if (!newMessage.value.trim()) return
  
  try {
    const response = await chatService.sendMessage(route.params.id, {
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
  fetchConversation()
})
</script>

<style scoped>
.conversation {
  padding: 2rem;
  height: calc(100vh - 4rem);
}

.loading, .error {
  text-align: center;
  padding: 2rem;
}

.conversation-container {
  background: white;
  border-radius: 8px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
  height: 100%;
  display: flex;
  flex-direction: column;
}

.conversation-header {
  padding: 1.5rem;
  border-bottom: 1px solid #eee;
}

.conversation-header h2 {
  margin: 0;
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
