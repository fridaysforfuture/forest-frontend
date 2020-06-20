<template>
  <section class="section">
    <form class="container is-mobile" @submit.prevent="submit">
      <tree-view v-model="tree"> </tree-view>
      <b-button native-type="submit">
        Eintrag erstellen
      </b-button>
    </form>
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
  };

  submit() {
    this.$axios.put(`http://localhost:3001/entries/${this.tree.name}`, {
      friendlyName: this.tree.friendlyName,
      links: this.tree.links,
    });
  }
}
</script>
