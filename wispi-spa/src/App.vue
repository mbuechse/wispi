<template>
  <main class="m-3">
    <header><h1 style="display:inline;"><router-link to="/">Wisπ</router-link></h1>
    <p style="display:inline;margin-left:3em;" v-if="api.getUsername()"
    title="zum Abmelden bitte Browsertab schließen">angemeldet als Nutzer*in <em>{{api.getUsername()}}</em> bis {{api.getExpires().toLocaleTimeString()}}</p>
    <hr>
    </header>
    <div id="app"><router-view></router-view></div>
  </main>
</template>

<script>
import 'bootstrap/dist/css/bootstrap.css'
import 'bootstrap-vue/dist/bootstrap-vue.css'
import api from './api.js'
export default {
  computed: {
    api () { return api },
    username () {
      return api.getUsername()
    },
    expires () {
      return api.getExpires()
    }
  },
  name: 'app'
}
</script>

<style src="semantic-ui-css/semantic.css"></style>
<style>
/*
#app {
  font-family: 'Avenir', Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
  margin-top: 60px;
}
*/
</style>
