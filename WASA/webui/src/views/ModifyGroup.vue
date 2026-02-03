<template>
  <button @click="goBack" class="goBack_btn">Go Back</button>

  <div class="c">
    <h1>Modify group</h1>
    <div class="bc">
      <button
        @click="openModifyNameModal"
        class="btn"
        title="Modify name"
      >
        Modify name
      </button>
      <button
        @click="openModifyPhotoModal"
        class="btn"
        title="Modify photo"
      >
        Modify photo
      </button>
    </div>

    <div v-if="showModifyNameModal" class="modal">
      <div class="modal-content">
        <h3>Modify group name</h3>
        <form @submit.prevent="modifyGroupName">
          <input
            v-model="newGroupName"
            type="text"
            placeholder="Insert the new group name:"
            class="modal-input"
            required
          />
          <div class="modal-btn">
            <button type="submit" class="btn">Save</button>
            <button
              type="button"
              @click="closeModifyNameModal"
              class="btn_gray"
            >
              Go Back
            </button>
          </div>
        </form>
      </div>
    </div>

    <div v-if="showModifyPhotoModal" class="modal">
      <div class="modal-content">
        <h3>Modify group photo</h3>
        <form @submit.prevent="modifyGroupPhoto">
          <input
            type="file"
            accept="image/jpeg"
            class="modal-input"
            @change="handleFileUpload"
            required
          />
          <div v-if="errorMsg" class="error-message">
            {{ errorMsg }}
          </div>
          <div class="modal-btn">
            <button type="submit" class="btn">Save</button>
            <button
              type="button"
              @click="closeModifyPhotoModal"
              class="btn_gray"
            >
              Go Back
            </button>
          </div>
        </form>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  data() {
    return {
      showModifyNameModal: false,
      showModifyPhotoModal: false,
      newGroupName: "",
      newGroupPhoto: "",
      errorMsg: null,
      currentUser: this.$route.params.nickname,
      chatId: this.$route.params.chat
    };
  },
  methods: {

    handleFileUpload(event) {
      const file = event.target.files[0];
      this.errorMsg = null;
      
      if (!file) return;
      
      if (!file.type.match(/image\/jpeg/)) {
        this.errorMsg = "Select a valid file";
        this.newGroupPhoto = '';
        return;
      }

      this.convertToBase64(file);
    },

    convertToBase64(file) {
      const reader = new FileReader();
      reader.onload = () => {
        this.newGroupPhoto = reader.result;
      };
      reader.onerror = (error) => {
        console.error("Error:", error);
        alert("Error: Error during the upload of the image");
      };
      reader.readAsDataURL(file);
    },

    openModifyNameModal() {
      this.showModifyNameModal = true;
      this.newGroupName = "";
      this.errorMsg = null;
    },

    closeModifyNameModal() {
      this.showModifyNameModal = false;
      this.newGroupName = "";
      this.errorMsg = null;
    },


    openModifyPhotoModal() {
      this.showModifyPhotoModal = true;
      this.newGroupPhoto = "";
      this.errorMsg = null;
    },

    closeModifyPhotoModal() {
      this.showModifyPhotoModal = false;
      this.newGroupPhoto = "";
      this.errorMsg = null;
    },

    async modifyGroupName() {
      try {
        const response = await this.$axios.put(
          `/wasachat/${this.currentUser}/groups/${this.chatId}/name`,
          { name: this.newGroupName.trim() }, 
          {
         headers: {
           Authorization: localStorage.getItem("token")
            }
          }
        );
        
        const message = response.data.response;
        const code = parseInt(response.data.code);

        alert(message);
        this.closeModifyNameModal();
        
      } catch (e) {
        if (e.response) {
          const message = e.response.data.error;
          const errorCode = parseInt(e.response.data.errorCode);
          alert(message + ` (code ${errorCode})`);
        } else {
          alert("Error: Network error.");
        }
      } finally {
        console.error(e);
      }
    },

    async modifyGroupPhoto() {  
      try {
        const response = await this.$axios.put(
          `/wasachat/${this.currentUser}/groups/${this.chatId}/photo`,
          { photo: this.newGroupPhoto }, 
          {
          headers: {
            Authorization: localStorage.getItem("token")
            }
          }
        );

        const message = response.data.response;
        const code = parseInt(response.data.code);

        alert(message);
        this.closeModifyPhotoModal();
        
      } catch (e) {
        if (e.response) {
          const message = e.response.data.error;
          const errorCode = parseInt(e.response.data.errorCode);
          alert(message + ` (code ${errorCode})`);
        } else {
          alert("Error: Network error.");
        }
      } finally {
        console.error(e);
      }
    },

    goBack() {
      this.$router.push(`/wasachat/${this.currentUser}/chats/${this.chatId}`);
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
  border-radius: 5px;
  margin-top: 300px;
}

.bc {
  display: flex;
  flex-direction: column;
  gap: 15px;
  padding: 40px;
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

.modal {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  display: flex;
  justify-content: center;
  align-items: center;
  z-index: 1000;
  background-color: rgba(0, 0, 0, 0.5);
}

.modal-content {
  background-color: white;
  padding: 25px;
  border-radius: 8px;
  width: 90%;
  max-width: 700px;
}

.modal-input {
  width: 100%;
  padding: 10px;
  margin: 15px 0;
  border: 1px solid #ddd;
  border-radius: 4px;
}

.modal-btn {
  margin-top: 20px;
}

.btn_gray {
  background-color: rgb(172, 159, 184);
  color: rgb(255, 255, 255);
  padding: 20px 40px;
  border-radius: 90px;
  font-size: 15px;
  border: none;
  cursor: pointer;
}
</style>