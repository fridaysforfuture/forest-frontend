<template>
  <section class="section">
    <b-collapse
      v-for="entry of entries"
      :key="entry.name"
      class="card"
      animation="slide"
      :open="true"
    >
      <div
        slot="trigger"
        class="card-header"
        role="button"
        @click="editCard(entry.name)">
        <div class="card-header-title">
          {{ entry.friendlyName }}
          {{ entry.friendlyName === entry.name ? '' : entry.name }}
        </div>
      </div>
    </b-collapse>
    <b-button>
      <nuxt-link to="/create">
        Plant new Tree
      </nuxt-link>
    </b-button>
  </section>
</template>

<script lang="ts">
import { Vue, Component } from 'vue-property-decorator';

@Component
export default class UserView extends Vue {
  entries = [];
  loading = true;

  async created() {
    const response = await this.$axios.get(
      `http://localhost:3001/user/${this.$auth.user.username}`,
    );
    this.loading = false;
    this.entries = response.data.ownEntries;
  }

  editCard(name: string) {
    this.$router.push({ name: 'edit-name', params: { name } });
  }
}
</script>
