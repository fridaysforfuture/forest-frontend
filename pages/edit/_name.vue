<template>
  <section class="section">
    <tree-view v-if="entry !== null" v-model="entry"> </tree-view>
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
  entry = null;

  async created() {
    const response = await this.$axios.get(
      `http://localhost:3001/entries/${this.$route.params.name}`,
    );
    this.entry = response.data;
  }
}
</script>
