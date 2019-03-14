<template>
  <div>
    <b-form-group id="gbezeichnung" label="Bezeichnung" label-for="bezeichnung" label-cols="2">
      <b-input title="bezeichnung" name="bezeichnung" placeholder="Bezeichnung" v-model="value.bezeichnung" :state="Boolean(value.bezeichnung)" />
    </b-form-group>
    <b-form-group id="glagerung" label="Lagerung" label-for="lagerung" label-cols="2">
      <b-input title="lagerung" name="lagerung" placeholder="Lagerung" v-model="value.lagerung"/>
    </b-form-group>
    <b-form-group id="ganschaffung" label="Anschaffung" label-for="anschaffung" label-cols="2">
      <b-input title="anschaffung" name="anschaffung" placeholder="Anschaffung" v-model="value.anschaffung"/>
    </b-form-group>
    <b-form-group id="gzustaendig" label="Zuständig" label-for="zustaendig" label-cols="2">
      <b-input title="zustaendig" name="zustaendig" placeholder="Zuständig" v-model="value.zustaendig" />
    </b-form-group>
  </div>
</template>

<script>
  export default {
    props: ['value']
  }
</script>
