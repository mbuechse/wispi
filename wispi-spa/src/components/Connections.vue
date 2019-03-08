<template>
  <div :class="{ loading: loading !== 0 }">
    <ul v-if="beteiligung" class="m-2">
      <li v-for="item in beteiligung" :key="item.id">
        <template v-if="item.subjekt_id === value">
          {{item.subjekt_friendly}} 
          &nbsp;<em><router-link :to="'/detail/' + item.discriminator + '/' + item.id">ist {{item.discriminator.slice(4) | capitalize}} von</router-link></em>&nbsp;
          <router-link :to="'/detail/' + item.objekt_discriminator + '/' + item.objekt_id">{{item.objekt_friendly}}</router-link>
        </template>
        <template v-else>
          {{item.objekt_friendly}}
          &nbsp;<em><router-link :to="'/detail/' + item.discriminator + '/' + item.id">hat {{item.discriminator.slice(4) | capitalize}}</router-link></em>&nbsp;
          <router-link :to="'/detail/' + item.subjekt_discriminator + '/' + item.subjekt_id">{{item.subjekt_friendly}}</router-link>
        </template>
        (<b-link href="#" @click="remove(item)">entfernen</b-link>)
      </li>
    </ul>
    <b-form-group id="gbeteiligung" label="Hinzufügen" label-cols="1">
      <b-form-select v-model="selectedDiscriminator" :options="discriminatorOptions" class="mb-3" size="sm" />
      <model-list-select
        :list="restBase" :value="{}" :isDisabled="selectDisabled" option-value="id" option-text="friendly"
        :placeholder="baseDiscriminatorsFriendly" ref="select" @input="add" @searchchange="onSearchChange"
        >
      </model-list-select>
      <div class="debug">{{ beteiligung }}</div>
    </b-form-group>
  </div>
</template>

<script>
  import api from '../api.js'
  import _ from 'lodash'
  import { ModelListSelect } from 'vue-search-select'

  const ConnectionView = {
    components: { ModelListSelect },
    data () {
      return {
        alleBase: [], beteiligung: [], query: '', selectedDiscriminator: null, loading: 0
      }
    },
    props: ['value', 'discriminator'],
    watch: {
      'value': 'fetchData',
      'baseDiscriminators': 'reloadBase',
      'query': 'reloadBase'
    },
    computed: {
      discriminatorOptions () {
        var istRelation = {}
        var hatRelation = {}
        var result = []
        api.DiscriminatorKombi.filter(p => p[2] === this.discriminator || p[2] === 'base').forEach(p => { istRelation[p[0]] = true })
        api.DiscriminatorKombi.filter(p => p[1] === this.discriminator || p[1] === 'base').forEach(p => { hatRelation[p[0]] = true })
        // hier Präfix 'ist_' mittels slice(4) entfernen
        result = Object.keys(istRelation).sort().map(x => ({value: {discriminator: x, ist: true}, text: 'ist ' + x.slice(4) + ' von'}))
        result = result.concat(Object.keys(hatRelation).sort().map(x => ({value: {discriminator: x, ist: false}, text: 'hat ' + x.slice(4)})))
        return result
      },
      baseDiscriminators () {
        var selected = this.selectedDiscriminator
        if (selected === null) {
          return []
        } else if (selected.ist) {
          return api.DiscriminatorKombi.filter(p => p[0] === selected.discriminator).map(p => p[1])
        } else {
          return api.DiscriminatorKombi.filter(p => p[0] === selected.discriminator).map(p => p[2])
        }
      },
      baseDiscriminatorsFriendly () {
        return [...this.baseDiscriminators].sort().join(', ')
      },
      restBase () {
        var baseDiscriminators = this.baseDiscriminators
        var selected = this.selectedDiscriminator
        var fn1, fn2
        if (selected === null) {
          return []
        } else if (selected.ist) {
          fn1 = p => (p.discriminator === selected.discriminator && p.subjekt_id === this.value)
          fn2 = p => p.objekt_id
        } else {
          fn1 = p => (p.discriminator === selected.discriminator && p.objekt_id === this.value)
          fn2 = p => p.subjekt_id
        }
        const ids = this.beteiligung.filter(fn1).map(fn2)
        return this.alleBase.filter(p => ids.indexOf(p.id) === -1 && baseDiscriminators.indexOf(p.discriminator) !== -1)
      },
      selectDisabled () {
        return this.selectedDiscriminator === null
      }
    },
    created () {
      // fetch the data when the view is created and the data is already being observed
      this.fetchData()
      if (this.discriminatorOptions) {
        this.selectedDiscriminator = this.discriminatorOptions[0].value
      }
    },
    methods: {
      err (e) {
        this.loading -= 1
        console.error(e)
      },
      fetchData () {
        this.loading += 1
        api.getBeteiligung(this.value)
          .then(data => {
            this.loading -= 1
            this.beteiligung = data
          })
          .catch(this.err)
      },
      reloadBase () {
        this.loading += 1
        var discriminators = this.baseDiscriminators
        var discriminator = discriminators.length === 1 ? discriminators[0] : 'base'
        api.getGeneric(discriminator, this.query, 20).then(data => {
          data.sort((a, b) => a.friendly.localeCompare(b.friendly))
          this.alleBase = data
          this.loading -= 1
        })
      },
      onSearchChange: _.debounce(function (query) { this.query = query }, 100),
      change (method, ...args) {
        this.loading += 1
        return method(...args)
          .then(value => {
            this.fetchData()
            this.loading -= 1
          })
          .catch(this.err)
      },
      add (item) {
        if (!item.id) {
          return
        }
        var selected = this.selectedDiscriminator
        var data
        if (selected.ist) {
          data = {subjekt_id: this.value, objekt_id: item.id}
        } else {
          data = {subjekt_id: item.id, objekt_id: this.value}
        }
        return this.change(api.insertIstRel, selected.discriminator, data.subjekt_id, data.objekt_id)
      },
      remove (item) {
        return this.change(api.removeGeneric, item.id)
      }
    }
  }
  export default ConnectionView
</script>
