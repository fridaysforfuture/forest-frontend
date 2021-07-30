<template>
  <section v-if="!$auth.loggedIn" class="section">
    <Logo class="main-logo" />
    <h1 class="title">Hallo und Herzlich Willkommen bei Forest</h1>
    <p>
      Hallo lieber Aktivisti. Das hier ist Forest, unser Linktree-Service. Um
      den zu benutzen brauchst du einen Cloud-Account. Logge dich ein und dann
      kannst du dir selber Linktrees erstellen.
    </p>
    <div style="margin-top: 20px">
      <b-button v-if="!$auth.loggedIn" @click="login"> Login </b-button>
    </div>
  </section>
  <section v-else class="section">
    <h1 class="title">Meine Linktrees:</h1>
    <div
      v-for="entry of entries"
      :key="entry.name"
      class="columns is-vcentered is-centered box"
      role="button"
      @click="editCard(entry.name)"
    >
      <div class="column has-text-centered is-hidden-mobile">
        {{ entry.friendlyName }}
      </div>
      <div class="column has-text-centered is-hidden-mobile">
        <a :href="'https://ffftre.es/' + entry.name" target="_blank">
          {{ ' ffftre.es/' + entry.name }}
        </a>
      </div>
      <div class="column has-text-centered is-hidden-tablet">
        <div>
          {{ entry.friendlyName }} <span> | </span>
          <a :href="'https://ffftre.es/' + entry.name" target="_blank">
            {{ ' ffftre.es/' + entry.name }}
          </a>
        </div>
      </div>
      <div v-if="entry.owner === $auth.user.sub" class="column">
        <b-button
          icon-right="delete"
          size="is-medium"
          type="is-danger"
          class="delete-button"
          @click.stop="deleteTreeDialog(entry.name)"
        >
        </b-button>
      </div>
      <div v-else class="column is-hidden-mobile"></div>
    </div>
    <b-button>
      <nuxt-link to="/create" icon-left="login" style="margin-top: 15px">
        Neuen Baum pflanzen
      </nuxt-link>
    </b-button>
  </section>
</template>

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

  deleteTreeDialog(name: string) {
    const typeless = this as any;
    const escape = function escape(html: string) {
      const text = document.createTextNode(html);
      const p = document.createElement('p');
      p.appendChild(text);
      return p.innerHTML;
    };
    typeless.$buefy.dialog.prompt({
      message: `Willst du '${escape(name)}' wirklich löschen? <br/>
      Bitte gib zur Bestätigung den Namen des Linktrees ein:`,
      inputAttrs: {
        type: 'text',
      },
      cancelText: 'Nicht löschen',
      confirmText: 'Löschen',
      hasIcon: true,
      type: 'is-danger',
      closeOnConfirm: false,
      onConfirm: (value: string, dialog: any) => {
        if (value === name) {
          this.deleteTree(name);
          dialog.close();
        } else {
          dialog.validationMessage =
            'Schreibe den richtigen Name mit Groß-und Kleinschreibung';
        }
      },
    });
  }

  deleteTree(name: string) {
    this.entries.splice(
      this.entries.findIndex((entry: any) => entry.name === name),
      1,
    );
    this.$axios.delete(`entries/${name}`);
  }
}
</script>

<style scoped lang="scss">
@media screen and (max-width: 768px) {
  .delete-button {
    width: 40%;
    margin: auto;
    display: block;
  }
}
@media screen and (min-width: 769px) {
  .delete-button {
    float: right;
  }
}
.main-logo {
  height: 25vh;
  width: auto;
  margin-left: auto;
  margin-right: auto;
  display: block;
}
</style>
