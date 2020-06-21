<template>
  <section class="section">
    <tree-view
      v-if="entry !== null"
      v-model="entry"
      disable-name-edit>
    </tree-view>
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
          @click="save">
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
  entry: null | any = null;

  async created() {
    const response = await this.$axios.get(
      `http://localhost:3001/entries/${this.$route.params.name}`,
    );
    this.entry = response.data;
  }
  cancel() {
    this.$router.push({ name: 'user-forest' });
  }

  save() {
    if(this.entry) {
      this.$axios.put(`http://localhost:3001/entries/${this.entry.name}`,
        this.entry);
      this.$router.push({ name: 'user-forest' });
    }
  } 
}
</script>
