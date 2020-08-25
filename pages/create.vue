<template>
  <section class="section">
    <tree-view v-model="tree" @submit="submit" />
    <b-field grouped style="margin-top: 15px">
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
    const formData = new FormData();
    Object.keys(this.tree).forEach((key) => {
      const value = (this.tree as any)[key];
      if (value instanceof Blob) {
        formData.append(key, value);
      } else {
        formData.append(key, JSON.stringify(value));
      }
    });
    this.$axios
      .$put(`entries/${this.tree.name}`, formData, {
        headers: {
          'Content-Type': 'multipart/form-data',
        },
      })
      .then(() => {
        this.$router.push({ name: 'index' });
      })
      .catch((e) => {
        alert(e);
      });
  }
}
</script>
