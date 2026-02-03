<template>
  <div>
    <button @click="goBack" class="goBack_btn">Go Back</button>

    <div class="c">
      <h1>Forward message to a new chat:</h1>
      <div class="bc">
        <button @click="openNewChatModal" class="btn">New chat</button>
      </div>
    </div>

    <div class="c">
      <div class="chats-list">
        <h2>Forward message to an existing chat:</h2>
        <ul v-if="chats.length > 0">
          <li
            v-for="chat in chats"
            :key="chat.chat_id"
            @click="forwardToChat(chat)"
          >
            <div class="chat-item">
              <img
                v-if="chat.photo"
                :src="chat.photo"
                class="chat-photo"
                @error="handleImageError"
              />
              <div v-else class="chat-photo-placeholder">👤</div>
              <div class="chat-info">
                <p class="chat-name">{{ chat.name }}</p>
                <p v-if="chat.lastsnip" class="chat-last-message">
                  {{ chat.lastsnip }}
                </p>
                <p v-if="chat.lastphoto" class="chat-last-message">[img]</p>
                <p v-if="chat.time" class="chat-time">
                  {{ formatTime(chat.time) }}
                </p>
              </div>
            </div>
          </li>
        </ul>
        <p v-else class="no-chats">No conversations yet</p>
      </div>
    </div>

    <div v-if="showAddMemberModal" class="modal">
      <div class="modal-content">
        <h3>Search a user</h3>
        <input
          v-model="newMemberName"
          type="text"
          placeholder="Insert the name of the user:"
          class="modal-input"
          required
          @keyup.enter="forwardToNewUser"
          :disabled="addingMember"
        />
        <div class="modal-btn">
          <button @click="forwardToNewUser" class="btn">Forward</button>
          <button @click="closeNewChatModal" class="btn_gray">Go Back</button>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  data() {
    return {
      chats: [],
      loading: false,
      messageToForward: null,
      showAddMemberModal: false,
      newMemberName: "",
      addingMember: false,
      error: null,
      currentNickname : this.$route.params.nickname,
      currentChatId : this.$route.params.chat,
      currentMessageId : this.$route.params.message,
    };
  },
  async created() {
    await this.loadChats();
    if (this.currentMessageId) {
      this.messageToForward = this.currentMessageId;
    }
  },

  methods: {
  async loadChats() {
    try {
      this.loading = true;
      const response = await this.$axios.get(`/wasachat/${this.currentNickname}/chats`, 
      {headers: {
          Authorization: localStorage.getItem("token")
         }
      });
    
      this.chats = [];
      for (let i = 0; i < response.data.length; i++) {
        const chat = response.data[i];
        
        if (chat.photo && !chat.photo.startsWith('data:image')) {
          chat.photo = 'data:image/jpeg;base64,' + chat.photo;
        }
        
        this.chats.push(chat);
      }
      
    } catch (e) {
      if (e.response && e.response.data) {
        const message = e.response.data.error;
        const errorCode = parseInt(e.response.data.errorCode);
        this.error = message + ' (code ' + errorCode + ')';
      } else {
        this.error = 'Error: Network error.';
      }
    } finally {
      this.loading = false;
    }
  },

    openNewChatModal() {
      this.showAddMemberModal = true;
      this.newMemberName = "";
      this.addingMember = false;
      this.error = null;
    },

    closeNewChatModal() {
      this.showAddMemberModal = false;
      this.newMemberName = "";
      this.addingMember = false;
      this.error = null;
    },

    formatTime(time) {
      const date = new Date(time);
      return date.toLocaleString();
    },

    handleImageError(event) {
      event.target.src = "https://via.placeholder.com/50";
    },

    async forwardToChat(chat) {
      const destinationChatId = chat.chat_id;

      if (this.currentMessageId) {
        try {
          const response = await this.$axios.post(
  `/wasachat/${this.currentNickname}/forw/${destinationChatId}/messages/${this.currentMessageId}`,
            {},
            {
              headers: {
                Authorization: localStorage.getItem("token")
              }
            }
          );
          const message = response.data.response;
          const code = parseInt(response.data.code);

          if (code >= 200 && code < 300) {
            alert(message);
            this.goBack();
          } else {
            alert(message);
          }
        } catch (e) {
          if (e.response) {
            const message = e.response.data.error;
            const errorCode = parseInt(e.response.data.errorCode);
            alert(message + ` (code ${errorCode})`);
          } else {
            alert("Error: Network error.");
          }
        }
      } else {
        this.$router.push(`/wasachat/${this.currentNickname}/chats/${destinationChatId}`);
      }
    },

  async forwardToNewUser() {
    this.addingMember = true;
    this.error = null;

    try {
      const response = await this.$axios.post(
  `/wasachat/${this.currentNickname}/forwnew/${this.newMemberName}/messages/${this.currentMessageId}`,
          {},
          {
            headers: {
              Authorization: localStorage.getItem("token")
            }
          }
        );

      const message = response.data.response;
      const code = parseInt(response.data.code);

      if (code >= 200 && code < 300) {
        alert(message);
        this.closeNewChatModal();
        this.goBack();
      } else {
        this.error = message;
      }
    } catch (e) {
      if (e.response) {
        const message = e.response.data.error;
        const errorCode = parseInt(e.response.data.errorCode);
        alert(message + ` (code ${errorCode})`);
      } else {
        alert("Error: Network error.");
      }
    } finally {
      this.addingMember = false;
    }
  },

    goBack() {
      this.$router.push(`/wasachat/${this.currentNickname}/chats/${this.currentChatId}`);
    }
  }
};
</script>

<style scoped>
.goBack_btn {
  background-color: rgb(161, 63, 84);
  color: rgb(221, 219, 219);
  padding: 20px 40px;
  margin: 40px;
  border-radius: 90px;
  font-size: 15px;
  position: fixed;
  top: 0px;
  right: 40px;
  border: none;
  cursor: pointer;
}

.c {
  text-align: center;
  background-color: rgb(209, 188, 230);
  padding: 40px;
  border-radius: 12px;
  width: 60%;
  margin: auto;
  margin-top: 100px;
  margin-bottom: 100px;
}

.bc {
  display: flex;
  flex-direction: column;
  gap: 15px;
  padding: 20px;
}

.btn {
  background-color: rgb(125, 3, 240);
  color: rgb(255, 255, 255);
  padding: 20px 40px;
  border-radius: 90px;
  font-size: 15px;
  border: none;
  cursor: pointer;
  margin: 15px auto;
  width: 80%;
}

.chats-list {
  text-align: left;
  margin-top: 20px;
}

.chats-list h2 {
  color: #333;
  margin-bottom: 15px;
}

ul {
  list-style-type: none;
  padding: 0;
  margin: 0;
}

li {
  padding: 15px;
  cursor: pointer;
  transition: background-color 0.3s;
}

.chat-item {
  display: flex;
  align-items: center;
}

.chat-photo {
  width: 50px;
  height: 50px;
  border-radius: 50%;
  margin-right: 15px;
  object-fit: cover;
}

.chat-photo-placeholder {
  display: flex;
  align-items: center;
  justify-content: center;
  margin-right: 15px;
  color: white;
  font-size: 30px;
  width: 50px;
  height: 50px;
  border-radius: 50%;
  background-color: rgb(172, 159, 184);
}

.chat-info {
  flex-grow: 1;
}

.chat-name {
  font-weight: bold;
  margin: 0;
  color: #333;
}

.chat-last-message {
  margin: 5px 0 0;
  color: #666;
  font-size: 0.9em;
}

.chat-time {
  margin: 5px 0 0;
  font-size: 0.8em;
  color: #999;
}

.no-chats {
  text-align: center;
  margin-top: 20px;
  color: #666;
}

.modal {
  position: fixed;
  display: flex;
  justify-content: center;
  align-items: center;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  z-index: 1000;
  background-color: rgba(0, 0, 0, 0.5);
}

.modal-content {
  background-color: rgb(255, 255, 255);
  padding: 25px;
  border-radius: 8px;
  width: 90%;
  max-width: 800px;
}

.modal-input {
  width: 100%;
  padding: 15px;
  margin: 15px 0;
  border: 1px solid #ddd;
  border-radius: 4px;
  font-size: 16px;
}

.modal-btn {
  display: flex;
  justify-content: flex-end;
  padding: 15px;
  border-radius: 60px;
  font-size: 15px;
  border: none;
  cursor: pointer;
}

.btn_gray {
  background-color: rgb(172, 159, 184);
  color: rgb(255, 255, 255);
  padding: 20px 40px;
  border-radius: 90px;
  font-size: 15px;
  margin-right: 30px;
  margin-left: 30px;
  border: none;
  cursor: pointer;
}
</style>