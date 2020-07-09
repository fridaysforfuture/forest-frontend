<template>
  <section class="section">
    <tree-view v-model="tree" @submit="submit" />
    <b-field grouped>
      <div class="control is-expanded">
        <b-button @click="cancel">
          Abbrechen
        </b-button>
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
      },
    ],
    socialLinks: {
      instagram: '',
      facebook: '',
      twitter: '',
      youtube: '',
      website: '',
    },
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
      })
      .then(() => {
        this.$router.push({ name: 'user-forest' });
      })
      .catch((e) => {
        alert(e);
      });
  }
}
</script>
