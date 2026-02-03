<template>
  <div class="login-view">
    <button class="exit_btn" @click="exit">Go Home</button>

    <div class="lc">
      <h1 class="t">Login/Register into WasaText</h1>
      
      <form @submit.prevent="login">
        <input
          class="input"
          v-model="nickname"
          placeholder="Insert your nickname:"
          required
        />
        <button class="btn">Login/Register</button>
      </form>
    </div>
  </div>
</template>

<script>
export default {
  data() {
    return {
      nickname: ''
    };
  },
  methods: {
  async exit() {
    this.$router.push("/");
  },

  async login() {
      try {
        const response = await this.$axios.post("/wasachat", { 
          nickname: this.nickname 
        });
        
        const message = response.data.response;
        const code = parseInt(response.data.code);
        
        if (code === 200) {
          localStorage.setItem('token', response.data.userid);
          
          this.$router.push(`/wasachat/${this.nickname}/chats`);
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
        console.error(e);
      }
    }
  }
}
</script>

<style scoped>
  .login-view {
  background-color: #ffffff;
  display: flex;
  justify-content: center;
  align-items: center;
  height: 100vh;
  font-family: 'Roboto', sans-serif;
  }
  
  .lc {
  text-align: center;
  background-color: rgb(209, 188, 230);
  padding: 40px;
  border-radius: 12px;
  box-shadow: 0 6px 15px rgba(0, 0, 0, 0.1);
  }

  .t {
  font-size: 70px;
  color: #333;
  margin-bottom: 20px;
  padding: 10px;
  -webkit-text-stroke: 2px white;
  }

  .input {
  display: block;
  width: 100%;
  padding: 20px;
  margin: 10px 0;
  border: 1px solid #ccc;
  border-radius: 5px;
  }

  .btn {
  background-color: rgb(125, 3, 240);
  color: rgb(255, 255, 255);
  padding: 20px 40px;
  margin: 40px ;
  border-radius: 90px;
  font-size: 30px;
  }

  .exit_btn {
  background-color: rgb(161, 63, 84);
  color: rgb(221, 219, 219);
  padding: 20px 40px;
  margin: 40px;
  border-radius: 90px;
  font-size: 15px;
  
  position: fixed;
  top: 10px;    
  left: 10px;      
}

</style>
