<template>
  <div>
    <b-form-group id="gname" label="Name" label-for="name" label-cols="2">
      <b-input title="name" name="name" placeholder="Name" v-model="value.name" />
    </b-form-group>
    <b-form-group id="glage" label="Lage (grob)" label-for="lage" label-cols="2">
      <b-input title="lage" name="lage" placeholder="Lage (grob)" v-model="value.lage"/>
    </b-form-group>
    <b-form-group id="ggroesze" label="Größe (qm)" label-for="groesze" label-cols="2">
      <b-input title="groesze" name="groesze" placeholder="Größe (qm)" v-model="value.groesse_qm"/>
    </b-form-group>
    <b-form-group id="gpersonenzahl" label="Personenzahl" label-for="personenzahl" label-cols="2">
      <b-input title="personenzahl" name="personenzahl" placeholder="Personenzahl" v-model="value.personenzahl" />
    </b-form-group>
    <b-form-group id="gverwaltung" label="Verwaltung" label-for="verwaltung" label-cols="2">
      <b-input title="verwaltung" name="verwaltung" placeholder="Verwaltung" v-model="value.verwaltung" />
    </b-form-group>
    <b-form-group id="gkosten" label="Kosten" label-for="kosten" label-cols="2">
      <b-input title="kosten" name="kosten" placeholder="Kosten" v-model="value.kosten"/>
    </b-form-group>
  </div>
</template>

<script>
  export default {
    props: ['value']
  }
</script>
