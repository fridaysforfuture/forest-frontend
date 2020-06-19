<template>
  <section class="section">
    <form
      @submit.prevent="submit"
      class="container is-mobile">
      <tree-view v-model="tree">
      </tree-view>
      <b-button native-type="submit">
        Eintrag erstellen
      </b-button>
    </form>
  </section>
</template>

<script lang="ts">
import { Vue, Component } from 'vue-property-decorator';
import axios from 'axios';
import TreeView from '@/components/treeView.vue';

@Component({
  components: {
    TreeView
  }
})
export default class CreateView extends Vue {
  tree = {
    name: '',
    friendlyName: '',
    links: [{
      text: '',
      url: ''
    }]
  };

  submit() {
    this.$axios.put(`http://localhost:3001/entries/${this.tree.name}`,
      {
        friendlyName: this.tree.friendlyName,
        links: this.tree.links
      });
  }
}
</script>
