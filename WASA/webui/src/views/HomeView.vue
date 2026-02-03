<template>
  <div class="h">
    <div class="c">
      <h1 class="t">WasaText</h1>

      <button
        class="btn"
        @click="openLink('https://wasa-enroll.sapienzaapps.it/dashboard/#/')"
      >
        WASA Enroll
      </button>

      <button
        class="btn"
        @click="openLink('https://github.com/CarloDaRomadev')"
      >
        My GitHub
      </button>

      <button
        class="btn"
        @click="openLink('http://gamificationlab.uniroma1.it/en/wasa/')"
      >
        WASA Course
      </button>

      <button
        class="btn"
        @click="loginRegister"
      >
        Login/Register
      </button>
    </div>
  </div>
</template>


<script>
export default {
  name: 'Home',
  methods: {
    loginRegister() {
      this.$router.push('/login');
    },
    openLink(url) {
      window.open(url, '_blank');
    }
  },
};
</script>

<style>
.h {
  background-color: #ffffff;
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  height: 100vh;
  font-family: 'Roboto', sans-serif;
}

.c {
  text-align: center;
  background-color: rgb(209, 188, 230);
  padding: 40px;
  border-radius: 12px;
  width: 75%;
}

.t {
  font-size: 100px;
  color: #333;
  margin-bottom: 20px;
  border: 2px solid #333;
  border-radius: 8px;
  padding: 10px;
  -webkit-text-stroke: 2px white;
}

.btn {
  background-color: rgb(125, 3, 240);
  color: rgb(255, 255, 255);
  padding: 20px 40px;
  border-radius: 90px;
  font-size: 15px;
  margin-right: 30px;
  margin-left: 30px;
  box-shadow: 0 6px 15px rgba(0, 0, 0, 0.1);
  }

</style>
