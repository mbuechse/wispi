<template>
  <div>
    <h2>
      <template v-if="discriminator.startsWith('ist_')">Verknüpfung:</template>
      <template v-else>{{discriminator | capitalize}}:</template>
      {{friendly}} (id {{ id }})</h2>
    <p v-if="url">
      <a :href="url" target="_blank">{{url}}</a>
    </p>
    <b-tabs no-fade v-model="activeTabIdx">
      <b-tab title="Allgemein">
        <EntityView :id="id" :discriminator="discriminator" @friendly="onFriendlyChange"></EntityView>
      </b-tab>
      <b-tab title="Kommentare">
        <HistorienView v-model="id"></HistorienView>
      </b-tab>
      <b-tab v-if="!discriminator.startsWith('ist_')" title="Verknüpfungen">
        <ConnectionView v-model="id" :discriminator="discriminator"></ConnectionView>
      </b-tab>
      <b-tab v-if="hatAdresse" title="Adressen">
        <AdressenView v-model="id"></AdressenView>
      </b-tab>
    </b-tabs>
    <p class="debug">
      id: {{ id }}; discriminator: {{ discriminator }}
    </p>
  </div>
</template>

<script>
  import ConnectionView from './Connections.vue'
  import EntityView from './Entity.vue'
  import AdressenView from './AdressenView'
  import HistorienView from './HistorienView'
  
  export default {
    components: { ConnectionView, AdressenView, HistorienView, EntityView },
    data () { return { friendly: '', url: '', activeTabIdx: 0 } },
    props: { id: {}, discriminator: {default: 'person'} },
    watch: {
      '$route' (to, from) {
        // Es ist echt zum Heulen. Ich kriege es dank der variablen Tabs (manche werden ausgeblendet)
        // nicht hin, dass das richtige Tab angezeigt wird (beispielsweise über die Route). Also immer 0
        this.activeTabIdx = 0
      }
    },
    computed: {
      hatAdresse () {
        return this.discriminator !== 'thema' && !this.discriminator.startsWith('ist_')
      }
    },
    methods: {
      onFriendlyChange (friendly, url) {
        this.friendly = friendly
        this.url = url
      }
    }
  }
</script>
