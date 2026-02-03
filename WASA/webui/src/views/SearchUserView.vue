<template>
  <button @click="goBack" class="exit_btn">Go Back</button>

  <div class="c">
    <h2>Search user</h2>
    <form @submit.prevent="searchUser">
      <input
        type="text"
        v-model="user"
        placeholder="Nickname"
        required
      />
      <button type="submit" class="btn">Search</button>
    </form>
  </div>
</template>


<script>
export default {
  data() {
    return {
      user: '',
      nickname : this.$route.params.nickname,
    };
  },
  methods: {
    async searchUser() {
      try {
        const response = await this.$axios.post(`/wasachat/${this.nickname}/privateconversation`, {
          user: this.user.trim(),
        }, 
        {
        headers: {
          Authorization: localStorage.getItem("token")
            }
          }
        );  
        if (response.status >= 200 && response.status < 300) {
          this.$router.push(`/wasachat/${this.nickname}/chats`);
        } else {
          const message = response.data.response;
          alert(message);
        }
      } catch (e) {
        if (e.response) {
          const message = e.response.data.error;
          const errorCode = e.response.data.errorCode;
          alert(`${message} (code ${errorCode})`);
        } else {
          alert("Error: Network error.");
        }
        console.error(e);
      }
    },
    
    goBack() {
      this.$router.push(`/wasachat/${this.nickname}/chats`);
    },
  },
};
</script>

<style scoped>

.c {
  text-align: center;
  background-color: rgb(209, 188, 230);
  padding: 40px;
  border-radius: 12px;
  width: 60%;
  margin: auto;
  border-radius: 5px;
  margin-top: 400px;
}

input {
  display: block;
  width: 100%;
  padding: 10px;
  margin: 10px 0;
  border: 1px solid #ccc;
  border-radius: 5px;
}

.btn {
  background-color: rgb(125, 3, 240);
  color: rgb(255, 255, 255);
  padding: 20px 40px;
  border-radius: 90px;
  font-size: 15px;
  margin-right: 30px;
  margin-left: 30px;
  border: none;
  cursor: pointer;
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
  border: none;
  cursor: pointer;
}

</style>