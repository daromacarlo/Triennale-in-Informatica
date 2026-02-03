<template>
  <div class="container">
    <button @click="goBack" class="goBack_btn">Go Back</button>

    <h2 class="title">Participants</h2>

    <div class="participants-box">
      <ul v-if="chats.length > 0">
        <li
          v-for="chat in chats"
          :key="chat.chat_id"
          class="participant-card"
        >
          <div class="participant-info">
            <p class="participant-name">{{ chat.Nickname }}</p>
          </div>
        </li>
      </ul>
      <p v-else class="no-participants">No participants.</p>
    </div>
  </div>
</template>

<script>
export default {
  data() {
    return {
      chats: [],
      error: null,
      currentUser: this.$route.params.nickname,
      chat: this.$route.params.chat
    };
  },
  async created() {
    await this.loadChats();
    if (this.$route.params.message) {
      this.messageToForward = this.$route.params.message;
    }
  },

  methods: {
    async loadChats() {
      try {
        const response = await this.$axios.get(`/wasachat/${this.currentUser}/usercheck/groups/${this.chat}`, 
        {
        headers: {
          Authorization: localStorage.getItem("token")
          }
        });
        this.chats = response.data;
        const message = response.data.response;
        if (message) {
          alert(message);
        }
      } catch (e) {
        if (e.response) {
          const message = e.response.data.error;
          const errorCode = parseInt(e.response.data.errorCode);
          alert(message + ` (code ${errorCode})`);
        } else {
          alert("Error. Network error.");
        }
        console.error(e);
      }
    },
    goBack() {
      this.$router.push(`/wasachat/${this.currentUser}/chats/${this.chat}`);
    },
  },
};
</script>

<style scoped>
.container {
  max-width: 700px;
  margin: 60px auto 30px;
  padding: 20px;
}

.title {
  text-align: center;
  font-size: 2rem;
  margin-bottom: 20px;
}

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

.participants-box {
  background-color: rgb(209, 188, 230);
  padding: 30px;
  border-radius: 16px;
}

ul {
  list-style-type: none;
  padding: 0;
  margin: 0;
}

.participant-card {
  background: white;
  border-radius: 12px;
  padding: 16px 20px;
  margin-bottom: 12px;
  display: flex;
  align-items: center;
}

.participant-info {
  flex-grow: 1;
}
.participant-name {
  font-weight: 600;
  font-size: 1.1rem;
  color: #333;
  margin: 0;
}

</style>
