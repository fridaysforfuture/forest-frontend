<template>
  <section v-if="!$auth.loggedIn" class="section">
    <Logo class="main-logo" />
    <h1 class="title">
      Hallo und Herzlich Willkommen bei Forest
    </h1>
    <p>
      Hallo lieber Aktivisti. Das hier ist Forest, unser Linktree-Service. Um
      den zu benutzen brauchst du einen Cloud-Account. Logge dich ein und dann
      kannst du dir selber Linktrees erstellen.
    </p>
    <div style="margin-top: 20px">
      <b-button v-if="!$auth.loggedIn" @click="login">
        Login
      </b-button>
    </div>
  </section>
  <section v-else class="section">
    <h1 class="title">
      Meine Linktrees:
    </h1>
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
        @click="editCard(entry.name)"
      >
        <div class="card-header-title">
          {{ entry.friendlyName }}
          <a
            :href="'https://ffftre.es/' + entry.name"
            class="tree-link"
            target="_blank"
          >
            {{ ' ffftre.es/' + entry.name }}
          </a>
        </div>
      </div>
    </b-collapse>
    <b-button>
      <nuxt-link to="/create" icon-left="login" style="margin-top: 15px">
        Neuen Baum pflanzen
      </nuxt-link>
    </b-button>
  </section>
</template>

<style>
.tree-link {
  margin-left: 0.7em;
}
.main-logo {
  height: 25vh;
  width: auto;
  margin-left: auto;
  margin-right: auto;
  display: block;
}
</style>

<script lang="ts">
import { Vue, Component } from 'vue-property-decorator';
import Logo from '@/components/Logo.vue';

@Component({
  components: {
    Logo,
  },
})
export default class IndexView extends Vue {
  entries = [];
  loading = true;

  async created() {
    if (this.$auth.loggedIn) {
      const response = await this.$axios.get(`user/${this.$auth.user.sub}`);
      this.loading = false;
      this.entries = response.data.ownEntries.concat(
        response.data.sharedEntries,
      );
    }
  }

  editCard(name: string) {
    this.$router.push({ name: 'edit-name', params: { name } });
  }

  login() {
    this.$auth.loginWith('oauth2');
  }

  logout() {
    this.$auth.logout();
  }
}
</script>
