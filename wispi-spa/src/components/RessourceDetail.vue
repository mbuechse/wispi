<template>
  <div>
    <b-form-group id="gtitel" label="Titel" label-for="titel" label-cols="2">
      <b-input title="titel" name="titel" placeholder="Titel" v-model="value.titel" :state="Boolean(value.titel)" />
    </b-form-group>
    <b-form-group id="gzielgruppe" label="Zielgruppe" label-for="zielgruppe" label-cols="2">
      <b-input title="zielgruppe" name="zielgruppe" placeholder="Zielgruppe" v-model="value.zielgruppe"/>
    </b-form-group>
    <b-form-group id="gerstellungsdatum" label="Erstellungsdatum" label-for="erstellungsdatum" label-cols="2">
      <b-input title="erstellungsdatum" name="erstellungsdatum" placeholder="Erstellungsdatum" v-model="value.erstellungsdatum"/>
    </b-form-group>
  </div>
</template>

<script>
  export default {
    props: ['value']
  }
</script>
