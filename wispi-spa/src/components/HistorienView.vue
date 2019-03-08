<template>
  <div :class="{ loading: loading !== 0 }">
    <b-card v-for="row in rows" :key="row.id" header-tag="header" class="m-3">
      <template slot="header">
        <span v-if="row.datum">Hinzugefügt am {{row.datum | friendlyDate}} um {{row.datum | friendlyTime}} von Nutzer*in <em v-if="row.username">{{ row.username }}</em></span>
        <span v-else>Neuen Kommentar hinzufügen</span>
      </template>
      <b-form @submit="evt => evt.preventDefault()" @reset="evt => evt.preventDefault()">
        <b-form-row>
          <b-col cols="10"><b-form-textarea v-model="row.notiz" :plaintext="!row.checked" :ref="'input' + row.id" placeholder="Neuer Kommentar" rows="1"></b-form-textarea></b-col>
          <b-col>
            <b-button-group v-if="row.checked">
              <b-btn :disabled="!row.notiz" size="lg" type="submit" variant="outline-primary" @click="save(row)" title="Speichern">&#128427;</b-btn>
              <b-btn size="lg" variant="outline-secondary" type="reset" @click="reset(row)" title="Zurücksetzen">&cross;</b-btn>
            </b-button-group>
            <b-button-group v-else>
              <b-btn size="lg" variant="outline-primary" @click="edit(row)" title="Bearbeiten">&#128393;</b-btn>
              <b-btn size="lg" variant="outline-danger" @click="remove(row)" title="Löschen">&#128465;</b-btn>
            </b-button-group>
          </b-col>
        </b-form-row>
      </b-form>
    </b-card>
    <p class="debug">
      <template v-if="loading">Lade...<br></template>
      id: {{ value }}; rows: {{ rows }}
    </p>
  </div>
</template>

<script>
  import api from '../api.js'

  const HistorienView = {
    data () { return { rows: [], notiz: '', loading: 0, kommentar: { base_id: this.value, checked: true, id: undefined, notiz: '' } } },
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
        alert('Es ist ein Fehler aufgetreten:\n ' + String(e) + '\n\nBitte die Seite neu laden und die letzte Aktion erneut versuchen.')
        console.error(e)
        console.log(e.response.data.message)
      },
      edit (row) {
        row.checked = true
        this.$refs['input' + row.id][0].$el.focus()
      },
      save (row) {
        if (!row.checked) {
          return  // sicher ist sicher
        }
        let data = {...row}
        delete data.checked
        this.loading += 1
        let promise = row.id === undefined ? api.postExtra('historie', data) : api.patchExtra('historie', data)
        return promise.then(x => {
          row.id = data.id
          return this.reset(row)
        })
        .then(x => { this.loading -= 1 }).catch(this.err)
      },
      reset (row) {
        if (row.id === undefined) {
          row.notiz = ''
          return
        }
        this.loading += 1
        return api.getExtra('historie', row.id).then(data => {
          data.checked = false
          Object.keys(data).forEach(x => { row[x] = data[x] })
          if (this.rows.length === 0 || this.rows[this.rows.length - 1].id !== undefined) {
            this.rows.push({...this.kommentar})
          }
          this.loading -= 1
        }).catch(this.err)
      },
      remove (item) {
        if (!confirm(`Folgender Kommentar soll gelöscht werden: ${item.notiz}\n\nWirklich fortfahren?`)) {
          return
        }
        this.loading += 1
        return api.removeExtra('historie', item.id).then(value => {
          // this.fetchData()  -- nicht machen, weil vielleicht noch Editoren offen sind
          let idx = this.rows.findIndex(i => i.id === item.id)
          this.rows.splice(idx, 1)
          this.loading -= 1
        }).catch(this.err)
      },
      fetchData () {
        this.loading += 1
        return api.getExtraFor('historie', this.value).then(data => {
          this.loading -= 1
          data.forEach(row => { row.checked = false })
          data.push({...this.kommentar})
          this.rows = data
        }).catch(this.err)
      }
    }
  }
  export default HistorienView
</script>
