<template>
  <div>
    <b-form-group id="gname" label="Name" label-for="name" label-cols="2">
      <b-input title="name" name="name" placeholder="Name" v-model="value.name" :state="Boolean(value.name)" />
    </b-form-group>
  </div>
</template>

<script>
  export default {
    props: ['value']
  }
</script>
