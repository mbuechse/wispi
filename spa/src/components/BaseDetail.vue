<template>
  <div>
    <b-form-group id="gurl" label="WWW" label-for="url" horizontal :label-cols="2">
      <b-input title="url" name="url" placeholder="WWW" v-model="value.url"/>
    </b-form-group>
    <b-form-group id="gbemerkungen" label="Bemerkungen" label-for="bemerkungen" horizontal :label-cols="2">
      <b-textarea title="bemerkungen" name="bemerkungen" placeholder="bemerkungen" v-model="value.bemerkungen"
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
