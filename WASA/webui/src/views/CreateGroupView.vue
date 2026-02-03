<template>
  <button @click="goBack" class="goBack_btn">Go Back</button>

  <div class="cc">
    <h2>Create your group</h2>
    <form @submit.prevent="createGroup">
      <input
        type="text"
        v-model="name"
        placeholder="Group Name"
        required
      />
      <input
        type="file"
        @change="handleFileUpload"
        accept="image/jpeg"
        required
      />
      <button type="submit" class="btn">Create group</button>
    </form>
  </div>
</template>


<script>
export default {
  data() {
    return {
      name: '',
      photo: '', 
      error: null, 
      currentUser: this.$route.params.nickname
    };
  },
  methods: {
    handleFileUpload(event) {
      const file = event.target.files[0];
      if (file) {
        if (!file.type.match(/image\/jpeg/)) {
          this.error = "Select a valid file";
          this.photo = '';
          return;
        }
        this.convertToBase64(file); 
      } else {
        this.error = "Select a valid image";
      }
    },

    convertToBase64(file) {
      const reader = new FileReader();
      reader.onload = () => {
        this.photo = reader.result; 
        this.error = null;
      };
      reader.onerror = (error) => {
        console.error("Error:", error);
        this.error = "Errore during the upload of the image.";
      };
      reader.readAsDataURL(file);
    },

    async createGroup() {
      this.error = null;
      try {
        const response = await this.$axios.post(`/wasachat/${this.currentUser}/groups`, {
          name: this.name,
          photo: this.photo,
        },{
      headers: {
          Authorization: localStorage.getItem("token")
       }
      });
        const message = response.data.response;
        const code = parseInt(response.data.code);
        if (response.code >= 200 && response.code < 300) {
          this.$router.push(`/wasachat/${this.currentUser}/chats`);
          alert(message);
        } else {
          this.$router.push(`/wasachat/${this.currentUser}/chats`);
          alert(message)
        }
      } catch (e) {
        if (e.response) {
          const message = e.response.data.error;
          const errorCode = parseInt(e.response.data.errorCode);
          alert(message + ` (code ${errorCode})`);
        } else {
          alert("Error: Network error.");
        }
      }finally {
        console.error(e);
      }
    },

    goBack() {
      this.$router.push(`/wasachat/${this.currentUser}/chats`);
    },

  },
};
</script>

<style scoped>
.cc {
  text-align: center;
  background-color: rgb(209, 188, 230);
  padding: 40px;
  border-radius: 12px;
  width: 60%;
  margin: auto;
  border-radius: 5px;
  margin-top: 300px;
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
  
</style>