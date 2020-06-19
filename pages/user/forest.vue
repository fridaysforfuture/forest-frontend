<template>
  <section class="section">
    <b-collapse
      class="card"
      animation="slide"
      v-for="entry of entries"
      :key="entry.name"
      :open="true">
      <div
        slot="trigger"
        slot-scope="props"
        class="card-header"
        role="button"
        @click="editCard">
        <div class="card-header-title">
          {{ entry.friendlyName }}
          {{ entry.friendlyName === entry.name ? '' : entry.name }}
        </div>
      </div>
    </b-collapse>
  </section>
</template>

<script lang="ts">
import { Vue, Component } from 'vue-property-decorator';
import axios from 'axios';


@Component 
export default class UserView extends Vue {
  entries = [];
  loading = true;

  async created() {
    const response = await
      this.$axios.get(`http://localhost:3001/user/${this.$auth.user.username}`)
    this.loading = false;
    this.entries = response.data;
  }
}
</script>
