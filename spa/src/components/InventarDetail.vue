<template>
  <div>
    <b-form-group id="gbezeichnung" label="Bezeichnung" label-for="bezeichnung" horizontal :label-cols="2">
      <b-input title="bezeichnung" name="bezeichnung" placeholder="Bezeichnung" v-model="value.bezeichnung" />
    </b-form-group>
    <b-form-group id="glagerung" label="Lagerung" label-for="lagerung" horizontal :label-cols="2">
      <b-input title="lagerung" name="lagerung" placeholder="Lagerung" v-model="value.lagerung"/>
    </b-form-group>
    <b-form-group id="ganschaffung" label="Anschaffung" label-for="anschaffung" horizontal :label-cols="2">
      <b-input title="anschaffung" name="anschaffung" placeholder="Anschaffung" v-model="value.anschaffung"/>
    </b-form-group>
    <b-form-group id="gzustaendig" label="Zuständig" label-for="zustaendig" horizontal :label-cols="2">
      <b-input title="zustaendig" name="zustaendig" placeholder="Zuständig" v-model="value.zustaendig" />
    </b-form-group>
  </div>
</template>

<script>
  export default {
    props: ['value']
  }
</script>
