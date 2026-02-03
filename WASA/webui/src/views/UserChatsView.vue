<template>
  <div>
    <div class="btn-c">
      <button class="btn" @click="createGroup">Create group</button>
      <button class="btn" @click="searchUser">Search user</button>
      <button class="btn" @click="profileSettings">Modify profile</button>
      <button class="exit_btn" @click="logout">Logout</button>
    </div>

    <div class="cc">
      <h1 class="t">Your conversations:</h1>
      <ul v-if="chats.length > 0">
        <li v-for="chat in chats" :key="chat.chat_id" @click="viewChat(chat)">
          <div class="chat-item">
            <img
              v-if="chat.photo"
              :src="chat.photo"
              class="chat-photo"
              @error="handleImageError"
            />
            <div v-else class="cpp">👤</div>
            <div class="chat-info">
              <p class="chat-name">{{ chat.name }}</p>
              <p v-if="chat.lastsnip" class="chat-last-message">{{ chat.lastsnip }}</p>
              <img
                v-if="chat.lastphoto"
                :src="chat.lastphoto"
                class="photo-message"
                @error="handleImageError"
              />
              <p v-if="chat.time" class="chat-time">{{ formatTime(chat.time) }}</p>
            </div>
          </div>
        </li>
      </ul>
      <p v-else class="no_conversations">No conversations yet.</p>
    </div>
  </div>
</template>

<script>
export default {
  data() {
    return {
      chats: [],
      error: null, 
      pollingInterval: null,
      nickname : this.$route.params.nickname,
      isLoading: false,
    };
  },
  async created() {
    await this.loadChats();
    this.startPolling();
  },

  beforeUnmount() {
  this.stopPolling();
  },

  methods: {

    startPolling() {
    this.pollingInterval = setInterval(() => {
      this.loadChats();
    }, 10000); 
  },


  stopPolling() {
    if (this.pollingInterval) {
      clearInterval(this.pollingInterval);
      this.pollingInterval = null;
    }
  },

  async loadChats() {
    if (this.isLoading) return;
    this.isLoading = true;
    let error = null;

    try {
      const response = await this.$axios.get(`/wasachat/${this.nickname}/chats`,
      {
      headers: {
          Authorization: localStorage.getItem("token")
       }
      });
      if (Array.isArray(response.data)) {
        this.chats = response.data;
      } else {
        console.warn("Unexpected response format", response.data);
        this.chats = [];
      }
    } catch (e) {
      error = e;
      if (e.response && e.response.data) {
        const message = e.response.data.error;
        const errorCode = parseInt(e.response.data.errorCode);
        alert(`${message} (code ${errorCode})`);
      } else {
        alert('Error: Network error');
      }
    } finally {
      if (error) console.error(error);
      this.isLoading = false;
    }
  },

    formatTime(time) {
      const date = new Date(time);
      return date.toLocaleString();
    },

    handleImageError(event) {
      console.error("Error during the upload:", event);
      event.target.src = "https://via.placeholder.com/50";
    },

    profileSettings() {
      this.stopPolling()
      this.$router.push(`/wasachat/${this.nickname}/settings`);
    },

    createGroup() {
      this.stopPolling()
      this.$router.push(`/wasachat/${this.nickname}/chats/creategroup`);
    },

    searchUser() {
      this.stopPolling()
      this.$router.push(`/wasachat/${this.nickname}/chats/searchuser`);
    },

    viewChat(chat) {
        this.$router.push(`/wasachat/${this.nickname}/chats/${chat.chat_id}`);
    },

    logout(){
      this.stopPolling()
      this.$router.push(`/`)
    }
  },
};

</script>

<style scoped>

.t {
  font-size: 45px;
  color: #666;
  margin-bottom: 5px;
  padding: 7px;
  border: 1px solid #666;
  border-radius: 90px;
}

.btn-c{
  text-align: center;
  background-color: rgb(209, 188, 230);
  padding: 40px;
  border-bottom-right-radius: 90px;
  text-align: left;
  width: 70%;
  position: fixed;
}
.cc {
  padding: 20px;
  padding-top: 180px; 
  width: 100%;
  text-align: left;
}

ul {
  list-style-type: none;
  padding: 0;
}

li {
  padding: 10px;
  border-bottom: 1px solid #ccc;
  cursor: pointer; 
}

li:hover {
  background-color: #f5f5f5;
}

.chat-item {
  display: flex;
  align-items: center;
}

.chat-photo {
  width: 100px;
  height: 100px;
  border-radius: 50%;
  margin-right: 20px;
}

.photo-message{
  width: 5%;
  height: 5%;
  max-width: 100;
  max-height: 100s;
}

.cpp {
  width: 100px;
  height: 100px;
  border-radius: 50%;
  background-color: #b5afb6;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 50px;
  padding: 50px;
  margin-right: 20px;
}

.chat-info {
  flex-grow: 1;
}

.chat-name {
  font-weight: bold;
  margin: 0;
}

.chat-last-message {
  margin: 5px 0;
  color: #666;
}

.chat-time {
  margin: 0;
  font-size: 0.9em;
  color: #999;
}

.btn {
  background-color: rgb(125, 3, 240);
  color: rgb(255, 255, 255);
  padding: 20px 40px;
  border-radius: 90px;
  font-size: 15px;
  margin-right: 30px;
  margin-left: 30px;
}

.no_conversations {
  max-width: 900px;
  background-color: rgb(209, 188, 230);
  margin: 180px auto;
  font-size: 60px;
  padding: 80px;
  border-radius: 20px
}

  .exit_btn {
  background-color: rgb(161, 63, 84);
  color: rgb(221, 219, 219);
  padding: 20px 40px;
  margin: 40px;
  border-radius: 90px;
  font-size: 15px;
  position: fixed;
  top: 0px;    
  right: 40px;      
}

</style>