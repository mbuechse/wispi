<template>
  <div>
    <b-form-group id="gname" label="Name" label-for="name" label-cols="2">
      <b-input title="name" name="name" placeholder="Name" v-model="value.name" :state="Boolean(value.name)" />
    </b-form-group>
    <b-form-group id="grahmenveranstaltung" label="Rahmenveranstaltung" label-for="rahmenveranstaltung" label-cols="2">
      <b-input title="rahmenveranstaltung" name="rahmenveranstaltung" placeholder="Rahmenveranstaltung" v-model="value.rahmenveranstaltung" />
    </b-form-group>
    <b-form-group id="gzeitraum" label="Zeitraum" label-for="zeitraum" label-cols="2">
      <b-input title="zeitraum" name="zeitraum" placeholder="Zeitraum" v-model="value.zeitraum" />
    </b-form-group>
    <b-form-group id="gturnus" label="Turnus" label-for="turnus" label-cols="2">
      <b-input title="turnus" name="turnus" placeholder="Turnus" v-model="value.turnus" />
    </b-form-group>
    <b-form-group id="gfristen" label="Fristen" label-for="fristen" label-cols="2">
      <b-textarea title="fristen" name="fristen" placeholder="Fristen" v-model="value.fristen"
            :rows="3" :max-rows="6">
      </b-textarea>
    </b-form-group>
  </div>
</template>

<script>
  export default {
    props: ['value']
  }
</script>
