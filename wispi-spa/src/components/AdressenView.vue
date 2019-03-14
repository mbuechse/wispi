<template>
  <div :class="{ loading: loading !== 0 }">
    <ol v-if="adressen" class="m-0">
      <li v-for="item in adressen" :key="item.id">
        <b-card class="m-2">
          <template v-if="item.checked">
            <AdresseView :value="item"></AdresseView>
            <b-button-group>
              <b-button :disabled="!item.empfaenger" type="submit" variant="primary" @click="save(item)">Speichern</b-button>
              <b-button @click="reset(item)"><template v-if="item.id !== undefined">Zücksetzen</template><template v-else>Abbrechen</template></b-button>
            </b-button-group>
          </template>
          <template v-else>
            <p>
              <template v-if="item.art">{{item.art}}<br></template>
              {{item.empfaenger}}<template v-if="item.zeile1">, 
              {{item.zeile1}}</template><template v-if="item.zeile2">, 
              {{item.zeile2}}</template><template v-if="item.ort || item.plz">, 
              {{item.plz}} {{item.ort}}</template>
              <br v-if="item.tel1 || item.tel2 || item.email">
              <template v-if="item.tel1">Tel. 1: {{item.tel1}}</template>
              <template v-if="item.tel2"><template v-if="item.tel1">&bull;</template> Tel. 2: {{item.tel2}}</template>
              <template v-if="item.email"><template v-if="item.tel1 || item.tel2">&bull;</template> E-Mail: <a :href="'mailto:' + item.email">{{item.email}}</a></template>

              <template v-if="item.kommentar"><br>Kommentar: {{item.kommentar}}</template>
            </p>
            <b-button-group>
              <b-btn variant="primary" @click="item.checked = true">Bearbeiten</b-btn>
              <b-btn variant="danger" @click="remove(item)">Löschen</b-btn>
            </b-button-group>
          </template>
        </b-card>
      </li>
    </ol>
    <b-btn v-if="adressen.length < 1 || adressen[adressen.length - 1].id" variant="primary" @click="add" class="m-3">neue Adresse anlegen</b-btn>
    <div class="debug">{{adressen}}</div>
  </div>
</template>

<script>
  import api from '../api.js'
  import AdresseView from './AdresseView.vue'

  const AdressenView = {
    components: { AdresseView },
    data () {
      return {
        adressen: [],
        adresse: { checked: true, base_id: this.value, id: undefined },
        loading: 0
      }
    },
    props: ['value'],
    watch: {
      'value': 'fetchData'
    },
    created () {
      // fetch the data when the view is created and the data is already being observed
      this.fetchData()
    },
    methods: {
      err (e) {
        this.loading -= 1
        alert('Es ist ein Fehler aufgetreten:\n ' + e + '\n\nBitte die Seite neu laden und die letzte Aktion erneut versuchen.')
        console.log(e.response.data.message)
      },
      fetchData () {
        this.loading += 1
        api.getExtraFor('adresse', this.value).then(data => {
          this.loading -= 1
          data.forEach(item => { item.checked = false })
          this.adressen = data
        }).catch(this.err)
      },
      reset (item) {
        if (item.id === undefined) {
          this.adressen.splice(this.adressen.length - 1, 1)
          return
        }
        this.loading += 1
        return api.getExtra('adresse', item.id).then(data => {
          data.checked = false
          Object.keys(data).forEach(x => { item[x] = data[x] })
          this.loading -= 1
        }).catch(this.err)
      },
      save (item) {
        this.loading += 1
        let data = {...item}
        delete data.checked
        let promise = item.id === undefined ? api.postExtra('adresse', data) : api.patchExtra('adresse', data)
        promise.then(value => {
          // this.fetchData()  -- nicht machen, weil vielleicht noch Editoren offen sind
          item.id = data.id
          return this.reset(item)
        })
        .then(x => { this.loading -= 1 }).catch(this.err)
      },
      add (evt) {
        this.adressen.push({...this.adresse})
      },
      remove (item) {
        if (!confirm(`Folgende Adresse soll gelöscht werden: ${item.art} ${item.empfaenger}\n\nWirklich fortfahren?`)) {
          return
        }
        this.loading += 1
        api.removeExtra('adresse', item.id).then(value => {
          // this.fetchData()  -- nicht machen, weil vielleicht noch Editoren offen sind
          let idx = this.adressen.findIndex(i => i.id === item.id)
          this.adressen.splice(idx, 1)
          this.loading -= 1
        }).catch(this.err)
      }
    }
  }
  export default AdressenView
</script>
