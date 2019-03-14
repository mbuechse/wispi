<template>
  <div>
    <b-form-group id="ganrede" label="Anrede" label-for="anrede" label-cols="2">
      <b-input title="anrede" name="anrede" placeholder="Anrede" v-model="value.anrede"/>
    </b-form-group>
    <b-form-group id="gtitel" label="Titel" label-for="titel" label-cols="2">
      <b-input title="titel" name="titel" placeholder="Titel" v-model="value.titel" />
    </b-form-group>
    <b-form-group id="gvorname" label="Vorname" label-for="vorname" label-cols="2">
      <b-input title="vorname" name="vorname" placeholder="Vorname" v-model="value.vorname" />
    </b-form-group>
    <b-form-group id="gname" label="Name" label-for="name" label-cols="2">
      <b-input title="name" name="name" placeholder="Name" v-model="value.name" :state="Boolean(value.name)" />
    </b-form-group>
    <b-form-group id="gfunction" label="Funktion" label-for="funktion" label-cols="2">
      <b-input title="funktion" name="funktion" placeholder="Funktion" v-model="value.funktion"/>
    </b-form-group>
    <b-form-group id="gkontaktaufnahme" label="Modus der Kontaktaufnahme" label-for="kontaktaufnahme" label-cols="2">
      <b-input title="kontaktaufnahme" name="kontaktaufnahme" placeholder="Modus der Kontaktaufnahme" v-model="value.kontaktaufnahme"/>
    </b-form-group>
    <b-form-group id="gansprache" label="Ansprache" label-for="ansprache" label-cols="2">
      <b-input title="ansprache" name="ansprache" placeholder="Ansprache" v-model="value.ansprache" />
    </b-form-group>
    <template v-if="value.referentin">
      <b-form-checkbox v-model="value.referentin.checked">Referent*innen-Daten zu <template v-if="value.name">{{value.titel}} {{value.vorname}} {{value.name}}</template><template v-else>dieser Person</template> hinterlegen</b-form-checkbox>
      <template v-if="value.referentin.checked">
        <b-form-group id="ghonorar" label="Honorar" label-for="honorar" label-cols="2">
          <b-input title="honorar" name="honorar" placeholder="Honorar" v-model="value.referentin.honorar" />
        </b-form-group>
      </template>
    </template>
  </div>
</template>

<script>
  export default {
    props: ['value']
  }
</script>
