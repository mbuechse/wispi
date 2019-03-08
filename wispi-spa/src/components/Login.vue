<template>
  <div>
    <h2>Login</h2>
    <b-form @submit="onSubmit" class="m-3">
      <b-form-group id="gusername" label="Nutzer*in" label-for="username" label-cols="2">
        <b-form-input title="username" name="username" placeholder="Nutzer*in" v-model="username"></b-form-input>
      </b-form-group>
      <b-form-group id="password" label="Passwort" label-for="password" label-cols="2">
        <b-form-input title="password" name="password" placeholder="Passwort" type="password" v-model="password"></b-form-input>
      </b-form-group>
      <b-button type="submit" variant="primary">Los</b-button>
    </b-form>

    <b-alert variant="danger" dismissible :show="loginError !== ''" @dismissed="loginError=''">
      Fehler beim Login: {{ loginError }}
    </b-alert>

    <p class="debug">
      username: {{ username }}; path: {{ path }}
    </p>
  </div>
</template>

<script>
  import api from '../api.js'
  export default {
    data () { return { username: '', password: '', loginError: '' } },
    props: ['path'],
    methods: {
      onSubmit (evt) {
        evt.preventDefault()
        api.login(this.username, this.password).then(value => {
          this.$router.replace(this.path || '/tabelle/base/1')
        }).catch(err => { this.loginError = err.message })
      }
    }
  }
</script>
