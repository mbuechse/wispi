<template>
  <div :class="{ loading: loading !== 0 }">
    <b-form-group horizontal label="Namensfilter/Neu anlegen" class="mb-0">
      <b-input-group>
        <b-form-input v-model="query" placeholder="Suchbegriff" />
        <b-input-group-button>
          <b-btn :disabled="!query" @click="query = ''">X</b-btn>
          <b-dropdown :disabled="!query" id="ddown1" right text="anlegen">
            <b-dropdown-item v-for="d in neuDiscriminators" :key="d">
              <router-link :to="'/neu/' + d + '/' + query">{{d | capitalize}} "{{query}}" neu anlegen...</router-link>
            </b-dropdown-item>
          </b-dropdown>
        </b-input-group-button>
      </b-input-group>
    </b-form-group>
    <b-form-group horizontal label="Filter nach Art" class="mb-0">
      <b-button-group>
        <b-button :pressed="discriminator === 'base'" :to="computeUrl({discriminator: 'base'})">(keiner)</b-button>
        <b-button :pressed="discriminator === 'organisation'" :to="computeUrl({discriminator: 'organisation'})">Organisation</b-button>
        <b-button :pressed="discriminator === 'person'" :to="computeUrl({discriminator: 'person'})">Person</b-button>
        <b-button :pressed="discriminator === 'referentin'" :to="computeUrl({discriminator: 'referentin'})">Referent*in</b-button>
        <b-button :pressed="discriminator === 'raum'" :to="computeUrl({discriminator: 'raum'})">Raum</b-button>
        <b-button :pressed="discriminator === 'inventar'" :to="computeUrl({discriminator: 'inventar'})">Inventar</b-button>
        <b-button :pressed="discriminator === 'ressource'" :to="computeUrl({discriminator: 'ressource'})">Ressource</b-button>
        <b-button :pressed="discriminator === 'aktion'" :to="computeUrl({discriminator: 'aktion'})">Aktion</b-button>
      </b-button-group>
    </b-form-group>
    <div class="m-1">
      <b-table striped outlined hover :items="rows" :fields="fields" :sort-by="'sortname'" :per-page="perPage" :current-page="currentPage">
        <template slot="discriminator" slot-scope="data">{{data.item.discriminator | capitalize}}</template>
        <template slot="sortname" slot-scope="data">
          <router-link :to="'/detail/' + data.item.discriminator + '/' + data.item.id">{{data.item.sortname}}</router-link>
        </template>
        <template slot="friendly" slot-scope="data">
          <router-link :to="'/detail/' + data.item.discriminator + '/' + data.item.id">{{data.item.friendly}}</router-link>
        </template>
        <template slot="remove" slot-scope="data">
          <b-btn size="sm" variant="danger" @click="remove(data.item)">&#128465;</b-btn>
        </template>
      </b-table>
      <b-pagination :per-page="perPage" v-model="currentPage" :total-rows="totalRows" />
    </div>
    <br>
    <p class="debug">
      <template v-if="loading">Lade...<br></template>
      <template v-if="find">query: {{ find }}</template> <!--page: {{ page }}-->
      {{ rows }}
    </p>
  </div>
</template>

<script>
  import api from '../api.js'
  import _ from 'lodash'
  
  const DefaultFields = [
    {key: 'id', label: 'id', sortable: true, 'class': 'id-column'},
    {key: 'sortname', label: 'Name', sortable: true, 'class': 'sortname-column'},
    {key: 'empty', label: '&nbsp;', sortable: false}
  ]
  
  const Config = {
    base: [
      {key: 'id', label: 'id', sortable: true, 'class': 'id-column'},
      {key: 'sortname', label: 'Name', sortable: true, 'class': 'sortname-column'},
      {key: 'discriminator', label: 'Art', sortable: true, 'class': 'discriminator-column'},
      {key: 'empty', label: '&nbsp;', sortable: false}
    ],
    person: [
      {key: 'id', label: 'id', sortable: true, 'class': 'id-column'},
      {key: 'sortname', label: 'Name', sortable: true, 'class': 'sortname-column'},
      {key: 'orga', label: 'Organisationen', sortable: false},
      {key: 'remove', label: 'Aktionen', sortable: false, 'class': 'action-column'}
    ],
    referentin: [
      {key: 'id', label: 'id', sortable: true, 'class': 'id-column'},
      {key: 'sortname', label: 'Name', sortable: true, 'class': 'sortname-column'},
      {key: 'orga', label: 'Organisationen', sortable: false},
      {key: 'honorar', sortable: false}
    ],
    organisation: DefaultFields,
    thema: DefaultFields,
    aktion: DefaultFields,
    ressource: [
      {key: 'id', label: 'id', sortable: true, 'class': 'id-column'},
      {key: 'sortname', label: 'Titel', sortable: true, 'class': 'sortname-column'},
      {key: 'zielgruppe', label: 'Zielgruppe', sortable: false},
      {key: 'autorinnen', label: 'Autor*innen', sortable: false}
    ],
    inventar: [
      {key: 'id', label: 'id', sortable: true, 'class': 'id-column'},
      {key: 'sortname', label: 'Bezeichnung', sortable: true, 'class': 'sortname-column'},
      {key: 'lagerung', label: 'Lagerung', sortable: false},
      {key: 'zustaendig', label: 'Zuständig', sortable: false}
    ],
    raum: [
      {key: 'id', label: 'id', sortable: true, 'class': 'id-column'},
      {key: 'sortname', label: 'Name', sortable: true, 'class': 'sortname-column'},
      {key: 'groesse_qm', label: 'Größe (qm)', sortable: false},
      {key: 'personenzahl', sortable: false},
      {key: 'kosten', sortable: false}
    ]
  }
  
  const TableView = {
    data () {
      return {
        rows: [],
        currentPage: 1,
        perPage: 12,
        loading: 0,
        query: String(this.find)
      }
    },
    props: {
      find: {default: ''},
      page: {default: 1},
      discriminator: {default: 'base'}
    },
    watch: {
      'page': 'fetchData',
      'find': 'fetchData',
      'discriminator': 'fetchData',
      'query': 'submit'
    },
    created () {
      // fetch the data when the view is created and the data is already being observed
      this.fetchData()
    },
    computed: {
      fields () {
        return Config[this.discriminator]
      },
      totalRows () {
        return this.rows.length
      },
      neuDiscriminators () {
        if (this.discriminator === 'base') {
          return ['organisation', 'person', 'raum', 'inventar', 'ressource', 'aktion']
        } else if (this.discriminator === 'referentin') {
          return ['person']
        } else {
          return [this.discriminator]
        }
      }
    },
    methods: {
      err (e) {
        this.loading -= 1
        alert('Fehler:\n' + String(e) + '\n\nBitte die Seite neu laden und die letzte Aktion erneut versuchen.')
        console.error(e)
        console.log(e.response.data.message)
      },
      computeUrl (o) {
        var discriminator = o.discriminator || this.discriminator
        var query = o.query || this.query
        var page = o.page || this.page
        return '/tabelle/' + discriminator + '/' + (query ? query + '/' : '') + page
      },
      submit: _.debounce(function () {
        if (this.query === this.find) {
          return
        }
        this.$router.replace(this.computeUrl({page: 1}))
      }, 300),
      fetchData: function () {
        this.loading += 1
        api.getGeneric(this.discriminator, this.find).then(data => {
          this.loading -= 1
          this.rows = data
          // this.query = this.find  // annoying if you want to continue typing
        }).catch(this.err)
      },
      remove (item) {
        if (confirm('Eintrag "' + item.friendly + '" wirklich löschen?\n\nDabei werden auch alle Kommentare, Verknüpfungen und Adressen dieses Eintrags entfernt!')) {
          this.loading += 1
          api.removeGeneric(item.id).then(x => {
            this.fetchData()
            this.loading -= 1
          }).catch(this.err)
        }
      }
    }
  }
  export default TableView
</script>

<style>
.id-column {
  width:4em;
}
.action-column {
  width:6em;
}
.discriminator-column {
  width:25%;
}
.sortname-column {
  width:33%;
}
</style>
