<template>
  <section class="section">
    <tree-view v-model="tree" @submit="submit" />
    <b-field grouped style="margin-top: 15px">
      <div class="control is-expanded">
        <b-button @click="cancel"> Abbrechen </b-button>
      </div>
      <div class="control is-success">
        <b-button native-type="submit" class="is-success" form="tree-view">
          Eintrag erstellen
        </b-button>
      </div>
    </b-field>
  </section>
</template>

<script lang="ts">
import { Vue, Component } from 'vue-property-decorator';
import TreeView from '@/components/treeView.vue';

@Component({
  components: {
    TreeView,
  },
})
export default class CreateView extends Vue {
  tree = {
    name: '',
    friendlyName: '',
    links: [
      {
        text: '',
        url: '',
        id: -1,
      },
    ],
    socialLinks: {
      telegram: '',
      whatsapp: '',
      instagram: '',
      facebook: '',
      twitter: '',
      youtube: '',
      website: '',
    },
    sharedTo: [],
    owner: this.$auth.user.sub,
  };

  cancel() {
    this.$router.back();
  }

  submit() {
    this.$axios
      .$put(`entries/${this.tree.name}`, {
        friendlyName: this.tree.friendlyName,
        links: this.tree.links,
        socialLinks: this.tree.socialLinks,
        sharedTo: this.tree.sharedTo,
      })
      .then(() => {
        this.$router.push({ name: 'index' });
      })
      .catch((e) => {
        if (e.response?.status === 401) {
          this.$buefy.dialog.alert({
            title: 'Erstellen fehlgeschlagen',
            message:
              'Den Eintrag den du erstellen wolltest scheint es schon zu geben',
            type: 'is-danger',
            hasIcon: true,
          });
        }
      });
  }
}
</script>
