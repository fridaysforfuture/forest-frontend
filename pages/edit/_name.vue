<template>
  <section class="section">
    <tree-view v-model="entry" disable-name-edit @submit="save"> </tree-view>
    <b-field grouped>
      <div class="control is-expanded">
        <b-button @click="cancel">
          Abbrechen
        </b-button>
      </div>
      <div class="control">
        <b-button
          tag="input"
          native-type="submit"
          type="is-success"
          value="Speichern"
          form="tree-view"
        >
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
export default class EditView extends Vue {
  entry: null | any = null;

  async created() {
    this.entry = await this.$axios.$get(`entries/${this.$route.params.name}`);
  }

  cancel() {
    this.$router.push({ name: 'index' });
  }

  save() {
    if (this.entry) {
      const formData = new FormData();
      Object.keys(this.entry).forEach((key) => {
        const value = this.entry[key];
        if (value instanceof Blob) {
          formData.append(key, value);
        } else {
          formData.append(key, JSON.stringify(value));
        }
      });
      this.$axios.$put(`entries/${this.entry.name}`, formData, {
        headers: {
          'Content-Type': 'multipart/form-data',
        },
      });
      this.$router.push({ name: 'index' });
    }
  }
}
</script>
