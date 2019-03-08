<template>
  <div :class="{ loading: loading !== 0 }">
    <b-form @submit="onSubmit" @reset="onReset" class="m-3">
      <component v-if="detailView !== undefined" :is="detailView" v-model="person"></component>
      <BaseDetailView v-model="person"></BaseDetailView>

      <b-button-group>
        <b-button type="submit" variant="primary">Speichern</b-button>
        <b-button type="reset"><template v-if="id === null">Abbrechen</template><template v-else>Zurücksetzen</template></b-button>
      </b-button-group>
    </b-form>
    <p class="debug">
      <template v-if="loading">Lade...<br></template>
      id: {{ id }}; person: {{ person }}; discriminator: {{ discriminator }}
    </p>
  </div>
</template>

<script>
  import api from '../api.js'
  import PersonDetailView from './PersonDetail.vue'
  import OrganisationDetailView from './OrganisationDetail.vue'
  import ThemaDetailView from './ThemaDetail.vue'
  import RaumDetailView from './RaumDetail.vue'
  import BaseDetailView from './BaseDetail.vue'
  import AktionDetailView from './AktionDetail.vue'
  import InventarDetailView from './InventarDetail.vue'
  import RessourceDetailView from './RessourceDetail.vue'

  const DiscriminatorViewMap = {
    person: PersonDetailView,
    organisation: OrganisationDetailView,
    thema: ThemaDetailView,
    raum: RaumDetailView,
    aktion: AktionDetailView,
    inventar: InventarDetailView,
    ressource: RessourceDetailView
  }

  const PersonView = {
    components: {BaseDetailView},
    data () { return { person: {}, loading: 0 } },
    props: {id: {}, discriminator: {default: 'person'}, prefix: {}},
    watch: {
      'id': 'fetchData',
      'discriminator': 'fetchData'
    },
    computed: {
      detailView () {
        return DiscriminatorViewMap[this.discriminator]
      }
    },
    created () {
      // fetch the data when the view is created and the data is already being observed
      this.fetchData()
    },
    methods: {
      err (e) {
        this.loading -= 1
        alert('Fehler:\n' + String(e) + '\n\nBitte die Seite neu laden und die letzte Aktion erneut versuchen.')
        console.error(e)
        console.log(e.response.data.message)
      },
      onReset (evt) {
        evt.preventDefault()
        if (this.id === null) {
          this.$emit('reset')
        } else {
          this.refetchData()
        }
      },
      onSubmit (evt) {
        evt.preventDefault()
        this.loading += 1
        let promise = this.person.id === undefined ? api.insertGeneric(this.person) : api.updateGeneric(this.person)
        promise.then(value => {
          if (this.id === null) {
            this.$emit('input', this.person.id)
          } else {
            this.refetchData()
          }
          this.loading -= 1
        }).catch(this.err)
      },
      fetchData () {
        if (this.id === null) {
          this.person = api.makeGeneric(this.discriminator, this.prefix)
        } else {
          this.refetchData()
        }
      },
      refetchData () {
        this.loading += 1
        api.getGenericDetail(this.discriminator, this.id).then(data => {
          this.person = data
          this.$emit('friendly', this.person.friendly, this.person.url)
          this.loading -= 1
        }).catch(this.err)
      }
    }
  }
  export default PersonView
</script>
