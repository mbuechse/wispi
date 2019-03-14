<template>
  <div>
    <b-form @submit="$emit('submit')">
      <b-form-group id="gart" label="Art der Adresse" label-for="art" label-cols="2">
        <b-input title="art" name="art" placeholder="Art der Adresse" v-model="value.art" />
      </b-form-group>
      <b-form-group id="gname" label="Empfänger*in" label-for="name" label-cols="2">
        <b-input title="name" name="name" placeholder="Empfänger*in" v-model="value.empfaenger" :state="Boolean(value.empfaenger)" />
      </b-form-group>
      <b-form-group id="gstrasse" label="Zeile 1" label-for="strasse1" label-cols="2">
        <b-input title="zeile1" name="strasse1" placeholder="Zeile 1" v-model="value.zeile1" />
      </b-form-group>
      <b-form-group id="gstrasse" label="Zeile 2" label-for="strasse2" label-cols="2">
        <b-input title="zeile2" name="strasse2" placeholder="Zeile 2" v-model="value.zeile2" />
      </b-form-group>
      <b-form-group id="gort" label="Ort" label-for="ort" label-cols="2">
        <b-input title="ort" name="ort" placeholder="Ort" v-model="value.ort" />
      </b-form-group>
      <b-form-group id="gplz" label="PLZ" label-for="plz" label-cols="2">
        <b-input title="plz" name="plz" placeholder="PLZ" v-model="value.plz" />
      </b-form-group>
      <b-form-group id="gtel1" label="Tel. 1" label-for="tel1" label-cols="2">
        <b-input title="tel1" name="tel1" placeholder="Tel 1" v-model="value.tel1" />
      </b-form-group>
      <b-form-group id="gtel2" label="Tel. 2" label-for="tel2" label-cols="2">
        <b-input title="tel2" name="tel2" placeholder="Tel 2" v-model="value.tel2" />
      </b-form-group>
      <b-form-group id="gemail" label="E-Mail" label-for="email" label-cols="2">
        <b-input title="email" name="email" placeholder="E-Mail" v-model="value.email" />
      </b-form-group>
      <b-form-group id="gnotiz" label="Kommentar" label-for="notiz" label-cols="2">
        <b-textarea title="notiz" name="notiz" placeholder="Kommentar" v-model="value.kommentar"
              :rows="3" :max-rows="6">
        </b-textarea>
      </b-form-group>
    </b-form>
    <p class="debug">
      row: {{ value }}
    </p>
  </div>
</template>

<script>
  export default {
    props: ['value']
  }
</script>
