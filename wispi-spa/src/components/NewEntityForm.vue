<template>
  <div>
    <h2>Neuen Eintrag anlegen ({{discriminator | capitalize}})</h2>
    <EntityView :id="id" :discriminator="discriminator" :prefix="prefix" @input="onIdChange" @reset="onReset"></EntityView>
    <p class="debug">
      id: {{ id }}; discriminator: {{ discriminator }}
    </p>
  </div>
</template>

<script>
  import EntityView from './Entity.vue'
  
  export default {
    components: { EntityView },
    props: {id: {}, discriminator: {default: 'person'}, prefix: {}},
    methods: {
      onIdChange (id) {
        this.$router.replace('/detail/' + this.discriminator + '/' + id)
      },
      onReset () {
        this.$router.go(-1)
      }
    }
  }
</script>
